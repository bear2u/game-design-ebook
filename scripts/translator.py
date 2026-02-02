#!/usr/bin/env python3
"""
Ollama 기반 마크다운 번역기
book.md를 페이지 단위로 분할하여 한국어로 번역
"""

import re
import json
import time
import argparse
from pathlib import Path
from datetime import datetime
from dataclasses import dataclass, asdict
from typing import List, Dict, Optional
from enum import Enum

try:
    import ollama
except ImportError:
    print("ollama 패키지가 필요합니다. 설치: pip install ollama")
    exit(1)

try:
    from tqdm import tqdm
except ImportError:
    print("tqdm 패키지가 필요합니다. 설치: pip install tqdm")
    exit(1)


class TranslationStatus(Enum):
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    FAILED = "failed"


@dataclass
class PageData:
    """페이지 데이터"""
    page_num: int
    content: str
    translated: Optional[str] = None
    status: str = "pending"
    error: Optional[str] = None
    timestamp: Optional[str] = None


class MarkdownPreserver:
    """마크다운 요소 보존"""

    # 보존할 패턴 (번역하지 않을 요소)
    PRESERVE_PATTERNS = [
        (r'<div[^>]*>.*?</div>', 'DIV'),           # div 태그
        (r'<img[^>]*/?>', 'IMG'),                   # img 태그
        (r'<table[^>]*>.*?</table>', 'TABLE'),     # table 태그
        (r'!\[([^\]]*)\]\(([^)]+)\)', 'IMAGE'),    # 마크다운 이미지
        (r'\[([^\]]+)\]\(([^)]+)\)', 'LINK'),      # 마크다운 링크
        (r'```[\s\S]*?```', 'CODEBLOCK'),          # 코드 블록
        (r'`[^`]+`', 'CODE'),                       # 인라인 코드
        (r'^\|.+\|$', 'TABLEROW'),                 # 테이블 행
        (r'^---+$', 'HR'),                          # 구분선
        (r'^#+\s*$', 'EMPTYHEADER'),               # 빈 헤더
    ]

    def __init__(self):
        self.preserved = {}
        self.counter = 0

    def protect(self, text: str) -> str:
        """번역하지 않을 요소 보호"""
        self.preserved = {}
        self.counter = 0
        result = text

        for pattern, tag in self.PRESERVE_PATTERNS:
            flags = re.MULTILINE | re.DOTALL if 'table' in pattern.lower() else re.MULTILINE

            def replace_match(match):
                placeholder = f"__PRESERVED_{self.counter}_{tag}__"
                self.preserved[placeholder] = match.group(0)
                self.counter += 1
                return placeholder

            result = re.sub(pattern, replace_match, result, flags=flags)

        return result

    def restore(self, text: str) -> str:
        """보호된 요소 복원"""
        result = text
        for placeholder, original in self.preserved.items():
            result = result.replace(placeholder, original)
        return result


class TranslationState:
    """번역 진행 상태 관리"""

    def __init__(self, state_file: str):
        self.state_file = Path(state_file)
        self.pages: Dict[int, PageData] = {}
        self.metadata = {
            "source_file": "",
            "total_pages": 0,
            "model": "",
            "started_at": "",
            "last_updated": ""
        }
        self._load()

    def _load(self):
        """상태 파일 로드"""
        if self.state_file.exists():
            with open(self.state_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
                self.metadata = data.get("metadata", self.metadata)
                for page_num, page_data in data.get("pages", {}).items():
                    self.pages[int(page_num)] = PageData(**page_data)

    def save(self):
        """상태 파일 저장"""
        self.metadata["last_updated"] = datetime.now().isoformat()
        data = {
            "metadata": self.metadata,
            "pages": {str(k): asdict(v) for k, v in self.pages.items()}
        }
        with open(self.state_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

    def add_page(self, page_num: int, content: str):
        """페이지 추가"""
        if page_num not in self.pages:
            self.pages[page_num] = PageData(
                page_num=page_num,
                content=content,
                status=TranslationStatus.PENDING.value
            )

    def update_page(self, page_num: int, translated: str = None,
                    status: TranslationStatus = None, error: str = None):
        """페이지 상태 업데이트"""
        if page_num in self.pages:
            page = self.pages[page_num]
            if translated:
                page.translated = translated
            if status:
                page.status = status.value
            if error:
                page.error = error
            page.timestamp = datetime.now().isoformat()
            self.save()

    def get_pending_pages(self) -> List[int]:
        """대기 중인 페이지 목록"""
        return [
            num for num, page in self.pages.items()
            if page.status in [TranslationStatus.PENDING.value, TranslationStatus.FAILED.value]
        ]

    def get_completion_rate(self) -> float:
        """완료율"""
        if not self.pages:
            return 0.0
        completed = sum(1 for p in self.pages.values() if p.status == TranslationStatus.COMPLETED.value)
        return (completed / len(self.pages)) * 100


class PageSplitter:
    """페이지 단위 분할"""

    @staticmethod
    def split(text: str) -> Dict[int, str]:
        """## Page N 기준으로 분할"""
        pages = {}
        # ## Page N 패턴으로 분할
        pattern = r'^## Page (\d+)\s*$'

        lines = text.split('\n')
        current_page = None
        current_content = []

        for line in lines:
            match = re.match(pattern, line)
            if match:
                # 이전 페이지 저장
                if current_page is not None:
                    pages[current_page] = '\n'.join(current_content).strip()

                current_page = int(match.group(1))
                current_content = [line]  # 페이지 헤더 포함
            elif current_page is not None:
                current_content.append(line)

        # 마지막 페이지 저장
        if current_page is not None:
            pages[current_page] = '\n'.join(current_content).strip()

        return pages


class OllamaTranslator:
    """Ollama 번역기"""

    SYSTEM_PROMPT = """당신은 전문 게임 디자인 서적 번역가입니다.

## 번역 지침:
1. 영어를 자연스럽고 정확한 한국어로 번역하세요
2. 게임 디자인 전문 용어는 적절하게 번역하되, 널리 알려진 용어는 영문 병기 가능
3. 고유명사(인명, 게임명, 회사명)는 원문 그대로 유지
4. 마크다운 문법(헤더, 리스트 등)은 그대로 유지
5. __PRESERVED_로 시작하는 플레이스홀더는 절대 번역하지 말고 그대로 유지
6. 문장 구조를 한국어에 맞게 자연스럽게 조정

## 주의사항:
- 원문의 의미를 정확하게 전달
- 불필요한 설명 추가 금지
- 번역 결과만 출력 (부가 설명 없이)"""

    def __init__(self, model: str = "translategemma", host: str = "http://localhost:11434"):
        self.model = model
        self.client = ollama.Client(host=host)
        self.preservor = MarkdownPreserver()

    def translate(self, text: str, max_retries: int = 3) -> str:
        """텍스트 번역"""
        # 마크다운 요소 보호
        protected_text = self.preservor.protect(text)

        # 번역 프롬프트
        user_prompt = f"""다음 영어 텍스트를 한국어로 번역하세요:

{protected_text}

번역 결과:"""

        for attempt in range(max_retries):
            try:
                response = self.client.generate(
                    model=self.model,
                    prompt=user_prompt,
                    system=self.SYSTEM_PROMPT,
                    stream=False,
                    options={
                        "temperature": 0.3,
                        "top_p": 0.9,
                        "num_predict": 4096,
                    }
                )

                translated = response.get("response", "").strip()

                # 마크다운 요소 복원
                restored = self.preservor.restore(translated)

                return restored

            except Exception as e:
                if attempt < max_retries - 1:
                    wait_time = 2 ** attempt
                    print(f"\n재시도 {attempt + 1}/{max_retries} ({wait_time}초 대기)...")
                    time.sleep(wait_time)
                else:
                    raise e

        return ""


class BookTranslator:
    """책 번역 메인 클래스"""

    def __init__(self,
                 input_file: str,
                 output_file: str,
                 state_file: str = "translation_state.json",
                 model: str = "translategemma"):
        self.input_file = Path(input_file)
        self.output_file = Path(output_file)
        self.state = TranslationState(state_file)
        self.translator = OllamaTranslator(model=model)
        self.model = model

    def initialize(self):
        """번역 초기화 - 페이지 분할"""
        print(f"파일 읽기: {self.input_file}")
        with open(self.input_file, 'r', encoding='utf-8') as f:
            text = f.read()

        print("페이지 분할 중...")
        pages = PageSplitter.split(text)

        print(f"총 {len(pages)}개 페이지 발견")

        # 상태 초기화
        self.state.metadata["source_file"] = str(self.input_file)
        self.state.metadata["total_pages"] = len(pages)
        self.state.metadata["model"] = self.model
        self.state.metadata["started_at"] = datetime.now().isoformat()

        for page_num, content in pages.items():
            self.state.add_page(page_num, content)

        self.state.save()
        return len(pages)

    def translate(self, resume: bool = True, limit: int = None, start_page: int = None):
        """번역 실행

        Args:
            resume: True면 이전 상태에서 계속
            limit: 번역할 최대 페이지 수 (None이면 전체)
            start_page: 시작 페이지 번호 (None이면 처음부터)
        """
        # 재개 모드가 아니거나 상태가 없으면 초기화
        if not resume or not self.state.pages:
            self.initialize()

        pending = self.state.get_pending_pages()

        if not pending:
            print("모든 페이지가 이미 번역되었습니다!")
            return

        # 시작 페이지 필터링
        if start_page:
            pending = [p for p in pending if p >= start_page]

        # 제한이 있으면 적용
        if limit:
            pending = pending[:limit]

        print(f"\n번역 시작: {len(pending)}개 페이지 대기 중")
        print(f"모델: {self.model}")
        print(f"현재 완료율: {self.state.get_completion_rate():.1f}%\n")

        # 페이지 번호 순으로 정렬
        pending.sort()

        with tqdm(total=len(pending), desc="번역 진행") as pbar:
            for page_num in pending:
                page = self.state.pages[page_num]

                try:
                    self.state.update_page(page_num, status=TranslationStatus.IN_PROGRESS)

                    # 번역 수행
                    translated = self.translator.translate(page.content)

                    self.state.update_page(
                        page_num,
                        translated=translated,
                        status=TranslationStatus.COMPLETED
                    )

                except KeyboardInterrupt:
                    print("\n\n사용자에 의해 중단됨. 진행 상태가 저장되었습니다.")
                    self.state.update_page(page_num, status=TranslationStatus.PENDING)
                    break

                except Exception as e:
                    print(f"\n페이지 {page_num} 번역 실패: {e}")
                    self.state.update_page(
                        page_num,
                        status=TranslationStatus.FAILED,
                        error=str(e)
                    )

                pbar.update(1)
                pbar.set_postfix({"완료율": f"{self.state.get_completion_rate():.1f}%"})

                # API 과부하 방지
                time.sleep(0.5)

        print(f"\n번역 완료율: {self.state.get_completion_rate():.1f}%")

    def export(self, translated_only: bool = False):
        """번역 결과 내보내기

        Args:
            translated_only: True면 번역된 페이지만 내보내기
        """
        print(f"\n결과 내보내기: {self.output_file}")

        # 페이지 번호 순으로 정렬하여 병합
        sorted_pages = sorted(self.state.pages.items())

        result_parts = []
        for page_num, page in sorted_pages:
            if page.status == TranslationStatus.COMPLETED.value and page.translated:
                result_parts.append(page.translated)
            elif not translated_only:
                # 번역 안 된 페이지는 원문 유지 (translated_only가 False일 때만)
                result_parts.append(page.content)

        result = '\n\n---\n\n'.join(result_parts)

        with open(self.output_file, 'w', encoding='utf-8') as f:
            f.write(result)

        print(f"저장 완료: {self.output_file}")
        return self.output_file


def run_sample_test(model: str = "translategemma", pages: int = 3, start_page: int = None):
    """샘플 테스트 실행 - 특정 페이지 범위만 번역"""
    print("=" * 60)
    print("샘플 번역 테스트")
    print("=" * 60)

    base_dir = Path(__file__).parent.parent
    input_file = base_dir / "book.md"
    output_file = base_dir / "sample_ko.md"
    state_file = base_dir / "sample_state.json"

    # 기존 샘플 상태 파일 삭제 (항상 새로 시작)
    if state_file.exists():
        state_file.unlink()

    print(f"\n입력 파일: {input_file}")
    print(f"출력 파일: {output_file}")
    print(f"모델: {model}")
    if start_page:
        print(f"테스트 페이지: {start_page} ~ {start_page + pages - 1}")
    else:
        print(f"테스트 페이지 수: {pages}")

    translator = BookTranslator(
        input_file=str(input_file),
        output_file=str(output_file),
        state_file=str(state_file),
        model=model
    )

    # 페이지 수 제한하여 번역
    translator.translate(resume=False, limit=pages, start_page=start_page)
    translator.export(translated_only=True)  # 샘플 테스트에서는 번역된 것만 출력

    # 결과 미리보기
    print("\n" + "=" * 60)
    print("번역 결과 미리보기")
    print("=" * 60)

    if output_file.exists():
        with open(output_file, 'r', encoding='utf-8') as f:
            content = f.read()

        # 처음 2000자만 표시
        preview = content[:2000]
        if len(content) > 2000:
            preview += "\n\n... (이하 생략) ..."

        print(preview)

    print("\n" + "=" * 60)
    print(f"샘플 테스트 완료! 결과 파일: {output_file}")
    print("=" * 60)


def main():
    parser = argparse.ArgumentParser(description="Ollama 기반 마크다운 번역기")
    parser.add_argument("--input", "-i", default="book.md", help="입력 파일")
    parser.add_argument("--output", "-o", default="book_ko.md", help="출력 파일")
    parser.add_argument("--state", "-s", default="translation_state.json", help="상태 파일")
    parser.add_argument("--model", "-m", default="translategemma", help="Ollama 모델")
    parser.add_argument("--no-resume", action="store_true", help="처음부터 다시 번역")
    parser.add_argument("--export-only", action="store_true", help="번역 결과만 내보내기")
    parser.add_argument("--sample", type=int, metavar="N", help="샘플 테스트 모드: N페이지만 번역")
    parser.add_argument("--start", type=int, metavar="N", help="시작 페이지 번호 (--sample과 함께 사용)")
    parser.add_argument("--limit", type=int, metavar="N", help="번역할 최대 페이지 수")

    args = parser.parse_args()

    # 샘플 테스트 모드
    if args.sample:
        run_sample_test(model=args.model, pages=args.sample, start_page=args.start)
        return

    # 경로 설정
    base_dir = Path(__file__).parent.parent
    input_file = base_dir / args.input
    output_file = base_dir / args.output
    state_file = base_dir / args.state

    translator = BookTranslator(
        input_file=str(input_file),
        output_file=str(output_file),
        state_file=str(state_file),
        model=args.model
    )

    if args.export_only:
        translator.export()
    else:
        translator.translate(resume=not args.no_resume, limit=args.limit)
        translator.export()


if __name__ == "__main__":
    main()
