# GitHub Pages 배포 가이드

이 프로젝트는 Jekyll을 사용하여 GitHub Pages에 자동으로 배포됩니다.

## 설정 방법

### 1. GitHub 저장소 설정

1. GitHub 저장소로 이동
2. **Settings** > **Pages** 메뉴로 이동
3. **Source** 섹션에서:
   - **Deploy from a branch** 선택
   - **Branch**: `main` (또는 기본 브랜치)
   - **Folder**: `/ (root)` 선택
4. **Save** 클릭

### 2. GitHub Actions 권한 설정

1. **Settings** > **Actions** > **General** 메뉴로 이동
2. **Workflow permissions** 섹션에서:
   - **Read and write permissions** 선택
   - **Allow GitHub Actions to create and approve pull requests** 체크
3. **Save** 클릭

### 3. 첫 배포

1. 코드를 GitHub에 푸시:
   ```bash
   git add .
   git commit -m "Setup Jekyll for GitHub Pages"
   git push origin main
   ```

2. GitHub Actions 탭에서 배포 진행 상황 확인:
   - 저장소의 **Actions** 탭으로 이동
   - "Deploy Jekyll site to Pages" 워크플로우가 실행되는지 확인
   - 빌드가 완료되면 (약 1-2분 소요) 사이트가 배포됩니다

3. 사이트 확인:
   - **Settings** > **Pages**에서 사이트 URL 확인
   - 일반적으로 `https://[username].github.io/game-design-translate/` 형식입니다

## 문제 해결

### 빌드 실패 시

1. **Actions** 탭에서 실패한 워크플로우 확인
2. 로그를 확인하여 오류 원인 파악
3. 일반적인 문제:
   - Ruby 버전 불일치 → `Gemfile` 확인
   - Jekyll 플러그인 오류 → `_config.yml` 확인
   - 마크다운 문법 오류 → 챕터 파일 확인

### 사이트가 업데이트되지 않을 때

1. 브라우저 캐시 삭제 (Ctrl+Shift+R 또는 Cmd+Shift+R)
2. GitHub Actions에서 최신 배포 확인
3. 수동으로 워크플로우 재실행:
   - **Actions** 탭 > **Deploy Jekyll site to Pages** > **Run workflow**

## 로컬 테스트

배포 전에 로컬에서 테스트하려면:

```bash
# 의존성 설치
bundle install

# 로컬 서버 실행
bundle exec jekyll serve

# 브라우저에서 http://localhost:4000 접속
```

## 파일 구조

- `_config.yml`: Jekyll 설정 파일
- `_layouts/`: 레이아웃 템플릿
- `index.md`: 메인 페이지
- `translate/`: 번역된 챕터 마크다운 파일들
- `Gemfile`: Ruby 의존성 정의
- `.github/workflows/jekyll-gh-pages.yml`: GitHub Actions 워크플로우

## 참고사항

- Jekyll은 `_site/` 폴더에 빌드 산출물을 생성합니다 (이 폴더는 `.gitignore`에 포함되어 있습니다)
- `translate/` 폴더의 마크다운 파일들은 JavaScript로 동적으로 로드되므로 그대로 복사됩니다
- 이미지는 `imgs/` 폴더에 저장되어 있습니다
