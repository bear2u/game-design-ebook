# 로컬 테스트 가이드

## 🚀 방법 1: 간단한 HTTP 서버 (추천)

Jekyll 없이 바로 테스트할 수 있는 가장 간단한 방법입니다.

### 실행 방법

```bash
# 기본 포트(8000)로 실행
./serve.sh

# 또는 다른 포트 지정
./serve.sh 3000
```

브라우저에서 `http://localhost:8000` 접속하면 됩니다.

### 수동 실행

```bash
# Python 3 사용
python3 -m http.server 8000

# 또는 Python 2 사용
python -m SimpleHTTPServer 8000
```

## 🚀 방법 2: Jekyll 사용 (고급)

Jekyll의 모든 기능을 사용하려면 Ruby 환경이 필요합니다.

### Ruby 버전 확인

```bash
ruby --version
# Ruby 2.7 이상 권장
```

### Ruby 업그레이드 (macOS)

```bash
# Homebrew로 Ruby 설치
brew install ruby

# 또는 rbenv 사용 (권장)
brew install rbenv ruby-build
rbenv install 3.1.0
rbenv global 3.1.0
```

### 의존성 설치

```bash
# Bundler 설치
gem install bundler

# 프로젝트 의존성 설치
bundle install
```

### 서버 실행

```bash
# 기본 실행
bundle exec jekyll serve

# 자동 새로고침 포함
bundle exec jekyll serve --livereload

# 다른 포트 사용
bundle exec jekyll serve --port 4001
```

브라우저에서 `http://localhost:4000` 접속하면 됩니다.

## 🔧 문제 해결

### bundle install 실패 시

**시스템 Ruby 사용 중인 경우:**
```bash
# rbenv로 Ruby 설치 (권장)
brew install rbenv ruby-build
rbenv install 3.1.0
rbenv global 3.1.0

# 또는 사용자 디렉토리에 설치
bundle install --path ~/.gem
```

**ffi gem 오류:**
```bash
gem pristine ffi --version 1.16.3
bundle install
```

### 포트가 이미 사용 중일 때

```bash
# 다른 포트 사용
./serve.sh 3000
# 또는
bundle exec jekyll serve --port 4001
```

## 📝 빠른 시작 (간단한 방법)

```bash
# 1. 서버 실행
./serve.sh

# 2. 브라우저에서 http://localhost:8000 접속
```

## 💡 팁

- **간단한 테스트**: `./serve.sh` 사용 (Jekyll 불필요)
- **완전한 기능**: Jekyll 사용 (자동 빌드, 플러그인 등)
- 파일을 수정하면 브라우저에서 새로고침(F5)하면 됩니다
- `index.html.backup`은 백업 파일이므로 무시해도 됩니다

## 🎯 권장 방법

로컬에서 빠르게 확인하려면:
```bash
./serve.sh
```

GitHub Pages 배포 전에 Jekyll 빌드를 테스트하려면:
```bash
bundle exec jekyll build
bundle exec jekyll serve
```
