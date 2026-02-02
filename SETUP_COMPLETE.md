# ✅ Jekyll GitHub Pages 설정 완료

프로젝트가 Jekyll 기반 GitHub Pages로 배포되도록 설정되었습니다.

## 📦 생성된 파일

### Jekyll 설정 파일
- ✅ `_config.yml` - Jekyll 메인 설정 파일
- ✅ `_layouts/ebook.html` - 이북 레이아웃 템플릿
- ✅ `_layouts/default.html` - 기본 레이아웃
- ✅ `index.md` - 메인 페이지 (Jekyll 형식)
- ✅ `Gemfile` - Ruby 의존성 정의

### GitHub Actions
- ✅ `.github/workflows/jekyll-gh-pages.yml` - 자동 배포 워크플로우

### 문서
- ✅ `README.md` - 프로젝트 설명 업데이트
- ✅ `GITHUB_PAGES_SETUP.md` - 상세 설정 가이드
- ✅ `DEPLOYMENT.md` - 배포 가이드

## 🚀 다음 단계

### 1. GitHub 저장소 설정

1. GitHub 저장소로 이동
2. **Settings** > **Pages**:
   - Source: **Deploy from a branch**
   - Branch: **main** / **(root)**
   - Save

3. **Settings** > **Actions** > **General**:
   - Workflow permissions: **Read and write permissions** 체크
   - Save

### 2. 코드 푸시

```bash
git add .
git commit -m "Setup Jekyll for GitHub Pages deployment"
git push origin main
```

### 3. 배포 확인

1. **Actions** 탭에서 워크플로우 실행 확인
2. 빌드 완료 후 (약 1-2분) 사이트 접속
3. URL: `https://[username].github.io/game-design-translate/`

## 🔍 주요 기능

- ✅ Jekyll 기반 정적 사이트 생성
- ✅ GitHub Actions 자동 배포
- ✅ 32개 챕터 목차 및 동적 로딩
- ✅ 반응형 디자인 (모바일 지원)
- ✅ 마크다운 파일 동적 렌더링 (Marked.js)
- ✅ 이미지 경로 자동 처리

## 📁 프로젝트 구조

```
game-design-translate/
├── _config.yml              # Jekyll 설정
├── _layouts/                # 레이아웃 템플릿
│   ├── default.html
│   └── ebook.html
├── index.md                 # 메인 페이지
├── translate/               # 번역된 챕터들 (32개)
│   ├── chapter1.md
│   └── ...
├── imgs/                    # 이미지 파일들
├── Gemfile                  # Ruby 의존성
└── .github/
    └── workflows/
        └── jekyll-gh-pages.yml  # GitHub Actions
```

## 🛠️ 로컬 개발

```bash
# 의존성 설치
bundle install

# 로컬 서버 실행
bundle exec jekyll serve

# 브라우저에서 http://localhost:4000 접속
```

## ⚠️ 주의사항

1. **마크다운 파일**: `translate/` 폴더의 `.md` 파일들은 JavaScript로 동적 로드되므로 원본 그대로 유지됩니다.

2. **이미지 경로**: 이미지는 `imgs/` 폴더에 저장되어 있으며, 챕터 파일에서 `../imgs/` 또는 `imgs/`로 참조됩니다.

3. **빌드 산출물**: Jekyll은 `_site/` 폴더에 빌드 산출물을 생성합니다 (`.gitignore`에 포함됨).

4. **기존 파일**: `index.html`은 `index.html.backup`으로 백업되었습니다.

## 🎉 완료!

이제 GitHub에 푸시하면 자동으로 배포됩니다!
