# 게임 디자인의 기술 - 번역 프로젝트

"The Art of Game Design: A Book of Lenses" by Jesse Schell의 한국어 번역 프로젝트입니다.

## 📚 이북 사이트

번역된 챕터들을 읽을 수 있는 웹 이북 사이트가 GitHub Pages에서 호스팅됩니다.

**사이트 주소**: `https://[your-username].github.io/game-design-translate/`

## 🚀 로컬에서 실행하기

### Jekyll 설치

```bash
# Ruby 설치 확인
ruby --version

# Bundler 설치
gem install bundler

# 의존성 설치
bundle install

# 로컬 서버 실행
bundle exec jekyll serve
```

브라우저에서 `http://localhost:4000`으로 접속하세요.

## 📁 프로젝트 구조

```
game-design-translate/
├── _config.yml          # Jekyll 설정
├── _layouts/            # Jekyll 레이아웃
│   ├── default.html
│   └── ebook.html
├── index.md             # 메인 페이지
├── translate/           # 번역된 챕터 파일들
│   ├── chapter1.md
│   ├── chapter2.md
│   └── ...
├── imgs/                # 이미지 파일들
├── Gemfile              # Ruby 의존성
└── .github/
    └── workflows/
        └── jekyll-gh-pages.yml  # GitHub Actions 워크플로우
```

## 🔧 GitHub Pages 배포

이 프로젝트는 GitHub Actions를 통해 자동으로 배포됩니다.

### 자동 배포 설정

1. **GitHub 저장소 생성** (아직 없다면)
2. **코드 푸시**: `main` 또는 `master` 브랜치에 푸시하면 자동으로 배포가 시작됩니다
3. **Pages 설정**: 저장소 Settings > Pages에서 Source를 **GitHub Actions**로 설정
4. **배포 완료**: 몇 분 후 사이트가 자동으로 배포됩니다

### 배포 확인

배포가 완료되면 다음 주소로 접속할 수 있습니다:
```
https://[your-username].github.io/game-design-translate/
```

### 수동 배포

GitHub Actions 탭에서 "Deploy to GitHub Pages" 워크플로우를 수동으로 실행할 수도 있습니다.

자세한 내용은 [DEPLOYMENT.md](./DEPLOYMENT.md)를 참조하세요.

## 📝 번역 진행 상황

- ✅ 챕터 1-32 번역 완료
- ✅ 이북 사이트 구축 완료
- ✅ GitHub Pages 배포 설정 완료

## 🛠️ 기술 스택

- **Jekyll**: 정적 사이트 생성기
- **GitHub Pages**: 호스팅
- **GitHub Actions**: CI/CD
- **Marked.js**: 마크다운 파싱
- **Vanilla JavaScript**: 인터랙티브 기능

## 📄 라이선스

원본 책의 저작권은 Jesse Schell에게 있습니다. 이 번역본은 교육 목적으로만 사용됩니다.
