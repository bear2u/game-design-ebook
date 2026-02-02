#!/usr/bin/env python3
"""
번역된 book_ko.md를 챕터별로 분할하여 mdBook 구조로 변환
"""

import re
from pathlib import Path
from typing import Dict, List, Tuple


# 챕터 정보 (챕터 번호, 시작 텍스트, 한글 제목)
CHAPTERS = [
    (1, "In the Beginning, There Is the Designer", "시작에는 디자이너가 있다"),
    (2, "The Designer Creates an Experience", "디자이너는 경험을 창조한다"),
    (3, "The Experience Rises Out of a Game", "경험은 게임에서 비롯된다"),
    (4, "The Game Consists of Elements", "게임은 요소들로 구성된다"),
    (5, "The Elements Support a Theme", "요소들은 테마를 지탱한다"),
    (6, "The Game Begins with an Idea", "게임은 아이디어에서 시작된다"),
    (7, "The Game Improves Through Iteration", "게임은 반복을 통해 개선된다"),
    (8, "The Game is Made for a Player", "게임은 플레이어를 위해 만들어진다"),
    (9, "The Experience is in the Player's Mind", "경험은 플레이어의 마음속에 있다"),
    (10, "Some Elements are Game Mechanics", "일부 요소는 게임 메커닉이다"),
    (11, "Game Mechanics Must be in Balance", "게임 메커닉은 균형을 이루어야 한다"),
    (12, "Game Mechanics Support Puzzles", "게임 메커닉은 퍼즐을 지원한다"),
    (13, "Players Play Games Through an Interface", "플레이어는 인터페이스를 통해 게임을 한다"),
    (14, "Experiences Can be Judged by Their Interest Curves", "경험은 흥미 곡선으로 평가할 수 있다"),
    (15, "One Kind of Experience Is the Story", "경험의 한 종류는 스토리다"),
    (16, "Story and Game Structures can be Artfully Merged with Indirect Control", "스토리와 게임 구조는 간접 제어로 예술적으로 융합될 수 있다"),
    (17, "Stories and Games Take Place in Worlds", "스토리와 게임은 세계 속에서 펼쳐진다"),
    (18, "Worlds Contain Characters", "세계에는 캐릭터가 있다"),
    (19, "Worlds Contain Spaces", "세계에는 공간이 있다"),
    (20, "The Look and Feel of a World Is Defined by Its Aesthetics", "세계의 외관과 느낌은 미학으로 정의된다"),
    (21, "Some Games are Played with Other Players", "일부 게임은 다른 플레이어와 함께 한다"),
    (22, "Other Players Sometimes Form Communities", "다른 플레이어들은 때때로 커뮤니티를 형성한다"),
    (23, "The Designer Usually Works with a Team", "디자이너는 보통 팀과 함께 일한다"),
    (24, "The Team Sometimes Communicates Through Documents", "팀은 때때로 문서를 통해 소통한다"),
    (25, "Good Games are Created Through Playtesting", "좋은 게임은 플레이테스트를 통해 만들어진다"),
]


def find_chapter_positions(text: str) -> List[Tuple[int, int, str]]:
    """챕터 시작 위치 찾기"""
    positions = []

    for chapter_num, eng_title, ko_title in CHAPTERS:
        # 다양한 챕터 헤딩 패턴 검색
        patterns = [
            rf"# CHAPTER {chapter_num}",
            rf"# CHAPTER.*?{chapter_num}",
            rf"# {eng_title}",
            rf"#{1,2}\s*{eng_title}",
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                positions.append((match.start(), chapter_num, ko_title))
                break

    return sorted(positions, key=lambda x: x[0])


def split_into_chapters(text: str) -> Dict[int, Tuple[str, str]]:
    """텍스트를 챕터별로 분할"""
    positions = find_chapter_positions(text)
    chapters = {}

    for i, (pos, chapter_num, ko_title) in enumerate(positions):
        # 다음 챕터 시작 위치 또는 끝
        end_pos = positions[i + 1][0] if i + 1 < len(positions) else len(text)

        content = text[pos:end_pos].strip()
        chapters[chapter_num] = (ko_title, content)

    return chapters


def create_summary(chapters: Dict[int, Tuple[str, str]]) -> str:
    """SUMMARY.md 생성"""
    lines = [
        "# Summary",
        "",
        "[소개](./introduction.md)",
        "",
    ]

    for chapter_num in sorted(chapters.keys()):
        ko_title, _ = chapters[chapter_num]
        lines.append(f"- [Chapter {chapter_num}: {ko_title}](./chapters/chapter{chapter_num:02d}.md)")

    return "\n".join(lines)


def create_introduction(text: str) -> str:
    """소개 페이지 생성 (챕터 1 이전 내용)"""
    positions = find_chapter_positions(text)

    if positions:
        first_chapter_pos = positions[0][0]
        intro_content = text[:first_chapter_pos].strip()
    else:
        intro_content = "# 게임 디자인의 예술\n\nJesse Schell 저"

    return f"""# 게임 디자인의 예술

## A Book of Lenses

**저자**: Jesse Schell (Carnegie Mellon University)

---

이 책은 게임 디자이너가 자신의 작업을 다양한 관점(렌즈)으로 바라볼 수 있도록 돕는 가이드입니다.

---

{intro_content}
"""


def main():
    base_dir = Path(__file__).parent.parent
    input_file = base_dir / "book_ko.md"
    src_dir = base_dir / "src"
    chapters_dir = src_dir / "chapters"

    # 디렉토리 생성
    chapters_dir.mkdir(parents=True, exist_ok=True)

    # 번역 파일 읽기
    if not input_file.exists():
        print(f"오류: {input_file} 파일이 없습니다.")
        print("먼저 translator.py를 실행하여 번역을 완료하세요.")
        return

    print(f"파일 읽기: {input_file}")
    with open(input_file, 'r', encoding='utf-8') as f:
        text = f.read()

    # 챕터 분할
    print("챕터 분할 중...")
    chapters = split_into_chapters(text)
    print(f"{len(chapters)}개 챕터 발견")

    # 소개 페이지 생성
    intro_content = create_introduction(text)
    intro_file = src_dir / "introduction.md"
    with open(intro_file, 'w', encoding='utf-8') as f:
        f.write(intro_content)
    print(f"생성: {intro_file}")

    # 챕터 파일 생성
    for chapter_num, (ko_title, content) in chapters.items():
        chapter_file = chapters_dir / f"chapter{chapter_num:02d}.md"

        # 챕터 제목 추가
        chapter_content = f"# Chapter {chapter_num}: {ko_title}\n\n{content}"

        with open(chapter_file, 'w', encoding='utf-8') as f:
            f.write(chapter_content)

        print(f"생성: {chapter_file}")

    # SUMMARY.md 생성
    summary_content = create_summary(chapters)
    summary_file = src_dir / "SUMMARY.md"
    with open(summary_file, 'w', encoding='utf-8') as f:
        f.write(summary_content)
    print(f"생성: {summary_file}")

    print("\n완료! mdbook build 명령으로 빌드할 수 있습니다.")


if __name__ == "__main__":
    main()
