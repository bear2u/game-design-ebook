# GitHub Actions 빌드 오류 해결

## 문제
Jekyll 빌드 시 `vendor/` 폴더의 템플릿 파일을 읽으려고 시도하여 오류 발생

## 해결 방법

### 방법 1: deploy-pages.yml 사용 (권장)
이 프로젝트는 순수 HTML/JS이므로 Jekyll 빌드가 필요 없습니다.

**사용할 워크플로우**: `.github/workflows/deploy-pages.yml`

이 워크플로우는:
- Jekyll 빌드 없이 정적 파일만 배포
- 더 빠르고 안정적
- `vendor/` 폴더 문제 없음

**설정 방법**:
1. GitHub 저장소 Settings > Pages
2. Source를 **GitHub Actions**로 설정
3. `deploy-pages.yml` 워크플로우가 자동으로 실행됩니다

### 방법 2: jekyll-gh-pages.yml 수정
Jekyll 빌드를 사용해야 한다면:

1. `_config.yml`에 `vendor/` 폴더가 exclude에 포함되어 있는지 확인 (이미 추가됨)
2. `.nojekyll` 파일이 루트에 있는지 확인 (이미 생성됨)
3. 워크플로우에서 `vendor/` 폴더를 임시로 이동하여 빌드 (워크플로우 수정됨)

## 현재 상태

✅ `_config.yml`에 `vendor/` exclude 추가됨
✅ `.nojekyll` 파일 생성됨
✅ `deploy-pages.yml` 워크플로우 준비됨 (Jekyll 없이 배포)
✅ `jekyll-gh-pages.yml` 워크플로우 수정됨 (vendor 폴더 처리)

## 권장 사항

**`deploy-pages.yml`을 사용하세요!**
- 더 간단하고 빠름
- Jekyll 의존성 없음
- 오류 가능성 낮음
