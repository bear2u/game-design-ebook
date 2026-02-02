# GitHub Pages 배포 가이드

## 🚀 자동 배포 설정

이 프로젝트는 GitHub Actions를 통해 자동으로 GitHub Pages에 배포됩니다.

### 배포 프로세스

1. **코드 푸시**: `main` 또는 `master` 브랜치에 푸시하면 자동으로 배포가 시작됩니다.
2. **빌드**: GitHub Actions가 프로젝트 파일을 빌드합니다.
3. **배포**: 빌드된 파일이 GitHub Pages에 자동으로 배포됩니다.

### GitHub Pages 설정 확인

배포가 완료되면 다음 단계를 확인하세요:

1. 저장소의 **Settings** 탭으로 이동
2. 왼쪽 메뉴에서 **Pages** 선택
3. **Source**가 **GitHub Actions**로 설정되어 있는지 확인
4. 배포 상태가 **Active**로 표시되는지 확인

### 사이트 주소

배포가 완료되면 다음 주소로 접속할 수 있습니다:

```
https://[your-username].github.io/game-design-translate/
```

또는

```
https://[your-org-name].github.io/game-design-translate/
```

### 수동 배포

필요한 경우 GitHub Actions 탭에서 워크플로우를 수동으로 실행할 수 있습니다:

1. 저장소의 **Actions** 탭으로 이동
2. 왼쪽에서 **Deploy to GitHub Pages** 워크플로우 선택
3. **Run workflow** 버튼 클릭

### 배포 확인

배포가 완료되면:
- GitHub Actions 탭에서 빌드 로그 확인
- Pages 설정에서 배포 상태 확인
- 실제 사이트 URL로 접속하여 확인

### 문제 해결

배포가 실패하는 경우:
1. GitHub Actions 탭에서 에러 로그 확인
2. Pages 설정에서 Source가 올바르게 설정되었는지 확인
3. 저장소가 Public이거나 GitHub Pro/Team 계정인지 확인 (무료 계정은 Public 저장소만 Pages 지원)
