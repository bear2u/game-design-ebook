#!/bin/bash
# Interactive Ebook Template Setup Script
# 자동으로 이북 프로젝트 구조를 생성합니다

set -e

PROJECT_NAME="${1:-my-ebook}"
PROJECT_DIR="${2:-./${PROJECT_NAME}}"

echo "📚 Interactive Ebook Template Setup"
echo "===================================="
echo ""
echo "프로젝트 이름: ${PROJECT_NAME}"
echo "프로젝트 경로: ${PROJECT_DIR}"
echo ""

# 프로젝트 디렉토리 생성
mkdir -p "${PROJECT_DIR}"
cd "${PROJECT_DIR}"

# 기본 디렉토리 구조 생성
echo "📁 디렉토리 구조 생성 중..."
mkdir -p translate
mkdir -p imgs
mkdir -p .github/workflows

# index.html 생성 (템플릿)
echo "📄 index.html 생성 중..."
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>이북 - Ebook</title>
    <style>
        :root {
            --bg-primary: #f5f5f5;
            --bg-secondary: #ffffff;
            --text-primary: #333;
            --text-secondary: #555;
            --accent-color: #667eea;
            --accent-color-dark: #764ba2;
            --border-color: #e0e0e0;
            --shadow: rgba(0,0,0,0.1);
            --header-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        [data-theme="dark"] {
            --bg-primary: #1a1a1a;
            --bg-secondary: #2d2d2d;
            --text-primary: #e0e0e0;
            --text-secondary: #b0b0b0;
            --accent-color: #8b9aff;
            --accent-color-dark: #a78bfa;
            --border-color: #404040;
            --shadow: rgba(0,0,0,0.3);
            --header-gradient: linear-gradient(135deg, #4c5fd5 0%, #6d5dfa 100%);
        }
        
        [data-theme="warm"] {
            --bg-primary: #faf8f3;
            --bg-secondary: #fffef9;
            --text-primary: #3d3d3d;
            --text-secondary: #5a5a5a;
            --accent-color: #d4a574;
            --accent-color-dark: #c49564;
            --border-color: #e8e0d4;
            --shadow: rgba(212, 165, 116, 0.15);
            --header-gradient: linear-gradient(135deg, #d4a574 0%, #c49564 100%);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Noto Sans KR', sans-serif;
            line-height: var(--line-height, 1.8);
            color: var(--text-primary);
            background: var(--bg-primary);
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
            transition: background-color 0.3s ease, color 0.3s ease;
        }
        
        * {
            -webkit-tap-highlight-color: transparent;
        }
        
        a, button {
            touch-action: manipulation;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        header {
            background: var(--header-gradient);
            color: white;
            padding: 40px 20px;
            padding-top: max(40px, env(safe-area-inset-top, 0px) + 20px);
            text-align: center;
            margin-bottom: 30px;
            box-shadow: 0 4px 6px var(--shadow);
            position: relative;
            transition: background 0.3s ease;
        }
        
        .header-toc-toggle {
            display: none;
            position: absolute;
            top: max(15px, env(safe-area-inset-top, 0px) + 10px);
            left: 15px;
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            color: white;
            border: 1.5px solid rgba(255, 255, 255, 0.4);
            border-radius: 12px;
            padding: 10px 16px;
            font-size: 0.9em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 100;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
            display: flex;
            align-items: center;
            gap: 6px;
        }
        
        .header-toc-toggle:hover {
            background: rgba(255, 255, 255, 0.35);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        
        /* 설정 패널 */
        .settings-panel {
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 1000;
            background: var(--bg-secondary);
            border-radius: 16px;
            box-shadow: 0 8px 32px var(--shadow);
            padding: 22px;
            min-width: 280px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            max-width: 320px;
            border: 1px solid var(--border-color);
        }
        
        .settings-toggle {
            position: fixed;
            bottom: max(20px, env(safe-area-inset-bottom, 0px) + 10px);
            right: max(20px, env(safe-area-inset-right, 0px) + 10px);
            z-index: 1001;
            width: 56px;
            height: 56px;
            border-radius: 50%;
            background: var(--accent-color);
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.2);
            font-size: 1.5em;
            cursor: pointer;
            box-shadow: 0 4px 16px var(--shadow);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        /* 데스크톱에서는 설정 버튼 하단 우측 */
        @media (min-width: 769px) {
            .settings-toggle {
                bottom: 20px;
                right: 20px;
                top: auto;
            }
        }
        
        .settings-toggle:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 16px var(--shadow);
        }
        
        .settings-panel.hidden {
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            pointer-events: none;
        }
        
        .settings-panel:not(.hidden) {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
            pointer-events: auto;
        }
        
        .settings-panel h3 {
            margin-bottom: 15px;
            color: var(--text-primary);
            font-size: 1.1em;
        }
        
        .theme-selector {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .theme-btn {
            flex: 1;
            padding: 12px 10px;
            border: 2px solid var(--border-color);
            border-radius: 10px;
            background: var(--bg-primary);
            color: var(--text-primary);
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-size: 0.88em;
            font-weight: 600;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }
        
        .theme-btn:hover {
            border-color: var(--accent-color);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        
        .theme-btn.active {
            border-color: var(--accent-color);
            background: var(--accent-color);
            color: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        .theme-btn:active {
            transform: translateY(0);
        }
        
        .font-control {
            margin-top: 20px;
        }
        
        .font-control label {
            display: block;
            margin-bottom: 10px;
            color: var(--text-primary);
            font-size: 0.95em;
        }
        
        .font-slider {
            width: 100%;
            height: 6px;
            border-radius: 3px;
            background: var(--bg-primary);
            outline: none;
            -webkit-appearance: none;
            cursor: pointer;
        }
        
        .font-slider::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 22px;
            height: 22px;
            border-radius: 50%;
            background: var(--accent-color);
            cursor: pointer;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
            transition: all 0.2s ease;
        }
        
        .font-slider::-webkit-slider-thumb:hover {
            transform: scale(1.1);
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.3);
        }
        
        .font-slider::-moz-range-thumb {
            width: 22px;
            height: 22px;
            border-radius: 50%;
            background: var(--accent-color);
            cursor: pointer;
            border: none;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
            transition: all 0.2s ease;
        }
        
        .font-slider::-moz-range-thumb:hover {
            transform: scale(1.1);
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.3);
        }
        
        .font-size-display {
            text-align: center;
            margin-top: 8px;
            color: var(--text-secondary);
            font-size: 0.9em;
        }

        header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0,0,0,0.2);
            letter-spacing: -0.02em;
        }

        header p {
            font-size: 1.1em;
            margin-bottom: 5px;
            opacity: 0.95;
            letter-spacing: 0.01em;
        }

        .main-content {
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 30px;
        }

        .sidebar {
            background: var(--bg-secondary);
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px var(--shadow);
            height: calc(100vh - 200px);
            position: sticky;
            top: 20px;
            overflow-y: auto;
            overflow-x: hidden;
            transition: background-color 0.3s ease;
        }
        
        .sidebar::-webkit-scrollbar {
            width: 6px;
        }
        
        .sidebar::-webkit-scrollbar-track {
            background: var(--bg-primary);
            border-radius: 10px;
        }
        
        .sidebar::-webkit-scrollbar-thumb {
            background: var(--accent-color);
            border-radius: 10px;
        }
        
        .sidebar::-webkit-scrollbar-thumb:hover {
            background: var(--accent-color-dark);
        }

        .sidebar h2 {
            font-size: 1.3em;
            margin-bottom: 20px;
            color: var(--accent-color);
            border-bottom: 2px solid var(--accent-color);
            padding-bottom: 10px;
            transition: color 0.3s ease, border-color 0.3s ease;
        }

        .chapter-list {
            list-style: none;
        }

        .chapter-list li {
            margin-bottom: 8px;
        }

        .chapter-list a {
            display: block;
            padding: 14px 15px;
            color: var(--text-secondary);
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.3s;
            border-left: 3px solid transparent;
            min-height: 44px;
            display: flex;
            align-items: center;
        }

        .chapter-list a:hover {
            background: var(--bg-primary);
            border-left-color: var(--accent-color);
            transform: translateX(5px);
        }
        
        .chapter-list a:active {
            background: var(--border-color);
            transform: translateX(3px);
        }

        .chapter-list a.active {
            background: var(--accent-color);
            color: white;
            border-left-color: var(--accent-color-dark);
            font-weight: 600;
        }

        .content-area {
            background: var(--bg-secondary);
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px var(--shadow);
            min-height: calc(100vh - 200px);
            max-height: calc(100vh - 200px);
            overflow-y: auto;
            overflow-x: hidden;
            transition: background-color 0.3s ease;
        }
        
        .content-area::-webkit-scrollbar {
            width: 8px;
        }
        
        .content-area::-webkit-scrollbar-track {
            background: var(--bg-primary);
            border-radius: 10px;
        }
        
        .content-area::-webkit-scrollbar-thumb {
            background: var(--accent-color);
            border-radius: 10px;
        }
        
        .content-area::-webkit-scrollbar-thumb:hover {
            background: var(--accent-color-dark);
        }

        /* 챕터 네비게이션 버튼 */
        .chapter-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding: 15px 0;
            border-bottom: 2px solid var(--border-color);
            gap: 15px;
        }
        
        .nav-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 12px 20px;
            background: var(--bg-primary);
            color: var(--text-primary);
            border: 2px solid var(--border-color);
            border-radius: 10px;
            text-decoration: none;
            font-size: 0.95em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            flex: 1;
            justify-content: center;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }
        
        .nav-btn:hover:not(.disabled) {
            background: var(--accent-color);
            color: white;
            border-color: var(--accent-color);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        .nav-btn:active:not(.disabled) {
            transform: translateY(0);
        }
        
        .nav-btn.disabled {
            opacity: 0.4;
            cursor: not-allowed;
            pointer-events: none;
        }
        
        .nav-btn.prev {
            text-align: left;
        }
        
        .nav-btn.next {
            text-align: right;
            flex-direction: row-reverse;
        }
        
        .nav-btn-icon {
            font-size: 1.1em;
        }
        
        .chapter-content {
            font-size: var(--font-size, 1em);
        }
        
        .chapter-content ul,
        .chapter-content ol {
            margin-bottom: 20px;
            padding-left: 30px;
            color: var(--text-primary);
        }
        
        .chapter-content li {
            margin-bottom: 10px;
            color: var(--text-primary);
        }
        
        .chapter-content strong {
            color: var(--text-primary);
            font-weight: 600;
        }
        
        .chapter-content em {
            color: var(--text-secondary);
        }
        
        .chapter-content h1 {
            font-size: calc(var(--font-size, 1em) * 2.5);
            margin-bottom: 30px;
            color: var(--text-primary);
            border-bottom: 3px solid var(--accent-color);
            padding-bottom: 15px;
            transition: color 0.3s ease, border-color 0.3s ease;
        }

        .chapter-content h2 {
            font-size: calc(var(--font-size, 1em) * 1.8);
            margin-top: 40px;
            margin-bottom: 20px;
            color: var(--accent-color);
            transition: color 0.3s ease;
        }

        .chapter-content h3 {
            font-size: calc(var(--font-size, 1em) * 1.4);
            margin-top: 30px;
            margin-bottom: 15px;
            color: var(--text-secondary);
            transition: color 0.3s ease;
        }

        .chapter-content p {
            margin-bottom: 20px;
            text-align: justify;
            color: var(--text-primary);
            transition: color 0.3s ease;
        }

        .chapter-content img {
            display: none; /* 이미지 숨김 */
        }

        .page-number {
            text-align: center;
            color: var(--text-secondary);
            font-size: calc(var(--font-size, 1em) * 0.9);
            margin: 30px 0;
            padding: 10px;
            background: var(--bg-primary);
            border-radius: 5px;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .loading {
            text-align: center;
            padding: 60px;
            color: var(--text-secondary);
        }

        .error {
            text-align: center;
            padding: 60px;
            color: #e74c3c;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--text-secondary);
        }

        .empty-state h2 {
            font-size: 2em;
            margin-bottom: 15px;
            color: var(--accent-color);
        }

        @media (max-width: 768px) {
            .header-toc-toggle {
                display: flex;
                position: absolute;
                top: max(12px, env(safe-area-inset-top, 0px) + 8px);
                left: 12px;
                right: auto;
                background: rgba(255, 255, 255, 0.25);
                backdrop-filter: blur(12px);
                -webkit-backdrop-filter: blur(12px);
                color: white;
                border: 1.5px solid rgba(255, 255, 255, 0.4);
                border-radius: 12px;
                padding: 10px 14px;
                font-size: 0.85em;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                z-index: 100;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
                align-items: center;
                gap: 6px;
            }
            
            .header-toc-toggle:active {
                background: rgba(255, 255, 255, 0.35);
                transform: scale(0.96);
            }
            
            .settings-toggle {
                position: fixed;
                top: max(12px, env(safe-area-inset-top, 0px) + 8px);
                right: max(12px, env(safe-area-inset-right, 0px) + 8px);
                bottom: auto;
                width: 48px;
                height: 48px;
                font-size: 1.25em;
                z-index: 1001;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
                border: 1.5px solid rgba(255, 255, 255, 0.3);
            }
            
            .settings-toggle:active {
                transform: scale(0.95);
            }
            
            .settings-panel {
                position: fixed;
                top: max(68px, env(safe-area-inset-top, 0px) + 64px);
                right: max(12px, env(safe-area-inset-right, 0px) + 8px);
                bottom: auto;
                left: auto;
                min-width: 280px;
                max-width: calc(100vw - 24px);
                z-index: 1000;
                border-radius: 16px;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            }
            
            header {
                padding: 18px 15px;
                padding-top: max(16px, env(safe-area-inset-top, 0px) + 12px);
                padding-bottom: 16px;
                margin-bottom: 0;
                position: sticky;
                top: 0;
                z-index: 1000;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }
            
            header h1 {
                font-size: 1.4em;
                margin-bottom: 4px;
                margin-top: 0;
                line-height: 1.2;
                padding: 0 50px;
            }
            
            header p {
                font-size: 0.85em;
                margin-bottom: 2px;
                padding: 0 50px;
                line-height: 1.3;
            }
            
            header p:last-of-type {
                font-size: 0.75em;
                margin-top: 4px;
            }
            
            .container {
                padding: 12px;
                margin-top: 0;
            }
            
            .main-content {
                grid-template-columns: 1fr;
                gap: 0;
            }
            
            .sidebar {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                width: 100%;
                max-height: 0;
                overflow: hidden;
                z-index: 999;
                transition: max-height 0.4s cubic-bezier(0.4, 0, 0.2, 1), padding 0.4s ease, box-shadow 0.4s ease;
                border-radius: 0 0 24px 24px;
                box-shadow: 0 0 0 rgba(0,0,0,0);
                overflow-y: auto;
                padding: 0 18px;
                padding-top: 0;
                margin-top: 0;
                background: var(--bg-secondary);
                border-top: none;
                scroll-behavior: smooth;
            }
            
            .sidebar.active {
                max-height: calc(100vh - env(safe-area-inset-top, 0px) - env(safe-area-inset-bottom, 0px));
                padding: 20px 18px;
                padding-top: calc(env(safe-area-inset-top, 0px) + 90px);
                box-shadow: 0 8px 32px rgba(0,0,0,0.15);
            }
            
            .sidebar h2 {
                font-size: 1.2em;
                margin-bottom: 15px;
                margin-top: 0;
                padding-top: 0;
            }
            
            .chapter-list a {
                padding: 14px 12px;
                font-size: 0.95em;
            }

            .content-area {
                padding: 20px 16px;
                min-height: auto;
                max-height: none;
                overflow-y: visible;
                border-radius: 0;
                margin-top: 0;
            }

            .chapter-nav {
                margin-bottom: 20px;
                padding: 12px 0;
                gap: 10px;
            }
            
            .nav-btn {
                padding: 10px 16px;
                font-size: 0.9em;
            }
            
            .nav-btn span:not(.nav-btn-icon) {
                display: none;
            }
            
            .nav-btn.prev {
                flex: 0 0 auto;
                padding-left: 12px;
                padding-right: 12px;
            }
            
            .nav-btn.next {
                flex: 0 0 auto;
                padding-left: 12px;
                padding-right: 12px;
            }
            
            .chapter-content h1 {
                font-size: 1.75em;
                margin-bottom: 18px;
                line-height: 1.3;
            }
            
            .chapter-content h2 {
                font-size: 1.35em;
                margin-top: 32px;
                line-height: 1.4;
            }
            
            .chapter-content h3 {
                font-size: 1.15em;
                margin-top: 24px;
                line-height: 1.4;
            }
            
            .chapter-content p {
                font-size: 1em;
                line-height: 1.85;
                margin-bottom: 18px;
            }
            
            .empty-state {
                padding: 40px 20px;
            }
            
            .empty-state h2 {
                font-size: 1.3em;
            }
        }
        
        @media (max-width: 480px) {
            header h1 {
                font-size: 1.3em;
            }
            
            .sidebar {
                width: 100%;
            }
            
            .content-area {
                padding: 15px 12px;
            }
            
            .chapter-nav {
                margin-bottom: 15px;
                padding: 10px 0;
            }
            
            .nav-btn {
                padding: 10px 14px;
                font-size: 0.85em;
            }
            
            .chapter-content h1 {
                font-size: 1.6em;
            }
        }
    </style>
</head>
<body>
    <header>
        <h1>이북 제목</h1>
        <p>부제목 또는 설명</p>
        <p style="font-size: 0.9em; margin-top: 10px; opacity: 0.8;">저자 이름</p>
        <button class="header-toc-toggle" id="headerTocToggle" aria-label="목차 열기">
            <span style="font-size: 1.2em; margin-right: 6px;">☰</span>목차
        </button>
    </header>
    
    <!-- 설정 패널 -->
    <button class="settings-toggle" id="settingsToggle" aria-label="설정 열기">
        ⚙️
    </button>
    
    <div class="settings-panel hidden" id="settingsPanel">
        <h3>설정</h3>
        
        <div class="theme-selector">
            <button class="theme-btn active" data-theme="light" id="themeLight">
                ☀️ 라이트
            </button>
            <button class="theme-btn" data-theme="dark" id="themeDark">
                🌙 다크
            </button>
            <button class="theme-btn" data-theme="warm" id="themeWarm">
                🔥 따뜻한
            </button>
        </div>
        
        <div class="font-control">
            <label for="fontSizeSlider">폰트 크기</label>
            <input type="range" id="fontSizeSlider" class="font-slider" min="0.8" max="1.4" step="0.05" value="1">
            <div class="font-size-display" id="fontSizeDisplay">100%</div>
        </div>
    </div>
    
    <div class="container">
        <div class="main-content">
            <aside class="sidebar" id="sidebar">
                <h2>목차</h2>
                <ul class="chapter-list" id="chapterList">
                    <!-- 챕터 목록은 자동으로 생성됩니다 -->
                </ul>
            </aside>
            
            <main class="content-area" id="contentContainer">
                <div class="empty-state">
                    <h2>📖 이북</h2>
                    <p>왼쪽 목차에서 챕터를 선택하세요.</p>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
    <script>
        // 커스텀 렌더러로 HTML 이미지 태그 보존
        const renderer = new marked.Renderer();
        const originalParagraph = renderer.paragraph;
        renderer.paragraph = function(text) {
            if (typeof text !== 'string') {
                return originalParagraph.call(this, text);
            }
            if (text.includes('<img') || text.includes('<div')) {
                return text + '\n';
            }
            return originalParagraph.call(this, text);
        };
        
        renderer.code = function(code, language) {
            return `<pre><code class="language-${language}">${code}</code></pre>`;
        };
        
        marked.setOptions({ 
            renderer: renderer,
            breaks: true,
            gfm: true
        });
        
        function parseMarkdown(markdown) {
            markdown = markdown.replace(/^## Page (\d+)$/gim, '\n<div class="page-number">Page $1</div>\n');
            let html = marked.parse(markdown);
            return html;
        }

        let currentChapter = null;
        
        async function loadChapter(chapterNum) {
            const contentContainer = document.getElementById('contentContainer');
            contentContainer.innerHTML = '<div class="loading">챕터를 불러오는 중...</div>';
            currentChapter = chapterNum;
            
            try {
                const translatePath = 'translate';
                const response = await fetch(`${translatePath}/chapter${chapterNum}.md`);
                
                if (!response.ok) {
                    throw new Error('챕터를 찾을 수 없습니다.');
                }
                
                const markdown = await response.text();
                let html = parseMarkdown(markdown);
                
                html = html.replace(/<div[^>]*>[\s\S]*?<img[^>]*>[\s\S]*?<\/div>/gi, '');
                html = html.replace(/<img[^>]*>/gi, '');
                
                const chapterNumInt = parseInt(chapterNum);
                const chapters = getChapterList();
                const prevDisabled = chapterNumInt <= 1 ? 'disabled' : '';
                const nextDisabled = chapterNumInt >= chapters.length ? 'disabled' : '';
                
                const navHTML = `
                    <div class="chapter-nav">
                        <a href="#" class="nav-btn prev ${prevDisabled}" id="prevChapter">
                            <span class="nav-btn-icon">←</span>
                            <span>이전 챕터</span>
                        </a>
                        <a href="#" class="nav-btn next ${nextDisabled}" id="nextChapter">
                            <span class="nav-btn-icon">→</span>
                            <span>다음 챕터</span>
                        </a>
                    </div>
                `;
                
                contentContainer.innerHTML = `${navHTML}<div class="chapter-content active">${html}</div>`;
                
                const prevBtn = document.getElementById('prevChapter');
                const nextBtn = document.getElementById('nextChapter');
                
                if (prevBtn && !prevDisabled) {
                    prevBtn.addEventListener('click', (e) => {
                        e.preventDefault();
                        loadChapter(chapterNumInt - 1);
                    });
                }
                
                if (nextBtn && !nextDisabled) {
                    nextBtn.addEventListener('click', (e) => {
                        e.preventDefault();
                        loadChapter(chapterNumInt + 1);
                    });
                }
                
                document.querySelectorAll('.chapter-list a').forEach(link => {
                    link.classList.remove('active');
                });
                const activeLink = document.querySelector(`[data-chapter="${chapterNum}"]`);
                if (activeLink) {
                    activeLink.classList.add('active');
                }
                
                window.scrollTo({ top: 0, behavior: 'smooth' });
                
            } catch (error) {
                contentContainer.innerHTML = `<div class="error">오류: ${error.message}</div>`;
            }
        }

        function getChapterList() {
            const links = document.querySelectorAll('.chapter-list a');
            return Array.from(links).map(link => parseInt(link.getAttribute('data-chapter')));
        }

        function autoDetectChapters() {
            const chapterList = document.getElementById('chapterList');
            const chapters = [];
            
            // translate 폴더에서 챕터 파일 자동 감지
            // 실제로는 서버에서 파일 목록을 가져와야 하지만,
            // 여기서는 사용자가 제공한 챕터 목록을 사용합니다
            
            // 기본 예제 챕터 추가
            if (chapterList.children.length === 0) {
                chapters.push({ num: 1, title: '챕터 1: 시작' });
            }
            
            return chapters;
        }

        // 모바일 헤더 목차 토글
        const headerTocToggle = document.getElementById('headerTocToggle');
        const sidebar = document.getElementById('sidebar');
        
        function toggleHeaderToc() {
            sidebar.classList.toggle('active');
            const isOpen = sidebar.classList.contains('active');
            if (isOpen) {
                headerTocToggle.innerHTML = '<span style="font-size: 1.2em; margin-right: 6px;">✕</span>닫기';
                setTimeout(() => {
                    sidebar.scrollTop = 0;
                    const firstChapter = document.querySelector('.chapter-list li:first-child a');
                    if (firstChapter) {
                        firstChapter.scrollIntoView({ behavior: 'auto', block: 'nearest' });
                        setTimeout(() => {
                            sidebar.scrollTop = Math.max(0, sidebar.scrollTop - 10);
                        }, 50);
                    }
                }, 450);
            } else {
                headerTocToggle.innerHTML = '<span style="font-size: 1.2em; margin-right: 6px;">☰</span>목차';
            }
        }
        
        function closeHeaderToc() {
            sidebar.classList.remove('active');
            if (headerTocToggle) {
                headerTocToggle.innerHTML = '<span style="font-size: 1.2em; margin-right: 6px;">☰</span>목차';
            }
        }
        
        if (headerTocToggle) {
            headerTocToggle.addEventListener('click', toggleHeaderToc);
        }
        
        document.addEventListener('click', (e) => {
            if (window.innerWidth <= 768) {
                if (sidebar && sidebar.classList.contains('active')) {
                    if (!sidebar.contains(e.target) && (!headerTocToggle || !headerTocToggle.contains(e.target))) {
                        closeHeaderToc();
                    }
                }
            }
        });
        
        // 챕터 목록 클릭 이벤트
        document.querySelectorAll('.chapter-list a').forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const chapterNum = link.getAttribute('data-chapter');
                loadChapter(chapterNum);
                
                if (window.innerWidth <= 768 && sidebar && sidebar.classList.contains('active')) {
                    closeHeaderToc();
                }
                
                history.pushState({ chapter: chapterNum }, '', `?chapter=${chapterNum}`);
            });
        });

        // 설정 관리
        const settingsToggle = document.getElementById('settingsToggle');
        const settingsPanel = document.getElementById('settingsPanel');
        const themeButtons = document.querySelectorAll('.theme-btn');
        const fontSizeSlider = document.getElementById('fontSizeSlider');
        const fontSizeDisplay = document.getElementById('fontSizeDisplay');
        
        function loadSettings() {
            const savedTheme = localStorage.getItem('theme') || 'light';
            const savedFontSize = localStorage.getItem('fontSize') || '1';
            
            document.documentElement.setAttribute('data-theme', savedTheme);
            document.documentElement.style.setProperty('--font-size', savedFontSize + 'em');
            fontSizeSlider.value = savedFontSize;
            fontSizeDisplay.textContent = Math.round(savedFontSize * 100) + '%';
            
            themeButtons.forEach(btn => {
                btn.classList.remove('active');
                if (btn.dataset.theme === savedTheme) {
                    btn.classList.add('active');
                }
            });
        }
        
        themeButtons.forEach(btn => {
            btn.addEventListener('click', () => {
                const theme = btn.dataset.theme;
                document.documentElement.setAttribute('data-theme', theme);
                localStorage.setItem('theme', theme);
                
                themeButtons.forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
            });
        });
        
        fontSizeSlider.addEventListener('input', (e) => {
            const fontSize = e.target.value;
            document.documentElement.style.setProperty('--font-size', fontSize + 'em');
            fontSizeDisplay.textContent = Math.round(fontSize * 100) + '%';
            localStorage.setItem('fontSize', fontSize);
        });
        
        if (settingsToggle && settingsPanel) {
            settingsToggle.addEventListener('click', () => {
                settingsPanel.classList.toggle('hidden');
            });
            
            document.addEventListener('click', (e) => {
                if (!settingsPanel.contains(e.target) && !settingsToggle.contains(e.target)) {
                    settingsPanel.classList.add('hidden');
                }
            });
        }
        
        loadSettings();
        
        // 키보드 네비게이션
        document.addEventListener('keydown', (e) => {
            if (currentChapter) {
                const chapterNum = parseInt(currentChapter);
                const chapters = getChapterList();
                if (e.key === 'ArrowLeft' && chapterNum > 1) {
                    e.preventDefault();
                    loadChapter(chapterNum - 1);
                } else if (e.key === 'ArrowRight' && chapterNum < chapters.length) {
                    e.preventDefault();
                    loadChapter(chapterNum + 1);
                }
            }
        });
        
        // URL에서 챕터 로드
        window.addEventListener('DOMContentLoaded', () => {
            const urlParams = new URLSearchParams(window.location.search);
            const chapter = urlParams.get('chapter');
            if (chapter) {
                loadChapter(chapter);
            }
        });
    </script>
</body>
</html>
EOF

# GitHub Actions 워크플로우 생성
echo "🔧 GitHub Actions 워크플로우 생성 중..."
cat > .github/workflows/deploy-pages.yml << 'WORKFLOW_EOF'
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - main
      - master
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v4
      
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: '.'
          exclude: |
            .git
            .github
            node_modules
            _site
            .sass-cache
            .jekyll-cache
            .jekyll-metadata
            vendor
            .bundle
            *.backup
            scripts
            src
            docs

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
WORKFLOW_EOF

# .gitignore 생성
echo "📝 .gitignore 생성 중..."
cat > .gitignore << 'GITIGNORE_EOF'
# OS files
.DS_Store
Thumbs.db

# IDE
.idea/
.vscode/
*.swp
*.swo

# Temporary files
*.tmp
*.temp
*.backup

# Build artifacts
_site/
.sass-cache/
.jekyll-cache/
.jekyll-metadata
vendor/
.bundle/
Gemfile.lock

# Environment
.env
.env.local
GITIGNORE_EOF

# README 생성
echo "📖 README.md 생성 중..."
cat > README.md << README_EOF
# ${PROJECT_NAME}

이북 프로젝트입니다.

## 로컬에서 실행하기

\`\`\`bash
python3 -m http.server 8000
\`\`\`

브라우저에서 \`http://localhost:8000\`으로 접속하세요.

## 배포하기

1. GitHub 저장소에 푸시
2. Settings > Pages에서 Source를 "GitHub Actions"로 설정
3. 자동으로 배포됩니다

## 챕터 추가하기

\`translate/\` 폴더에 \`chapter{N}.md\` 형식으로 파일을 추가하고,
\`index.html\`의 챕터 목록을 업데이트하세요.
README_EOF

# 샘플 챕터 생성
echo "📚 샘플 챕터 생성 중..."
cat > translate/chapter1.md << 'CHAPTER_EOF'
# 챕터 1: 시작

이것은 첫 번째 챕터입니다.

## Page 1

첫 페이지 내용을 여기에 작성하세요.

## Page 2

두 번째 페이지 내용을 여기에 작성하세요.
CHAPTER_EOF

echo ""
echo "✅ 프로젝트 생성 완료!"
echo ""
echo "다음 단계:"
echo "1. translate/ 폴더에 챕터 마크다운 파일 추가 (chapter1.md, chapter2.md, ...)"
echo "2. index.html의 챕터 목록 업데이트"
echo "3. index.html의 헤더 정보 수정 (제목, 저자 등)"
echo "4. git init && git add . && git commit -m 'Initial commit'"
echo "5. GitHub에 푸시하고 Pages 설정"
echo ""
echo "프로젝트 경로: $(pwd)"
echo "로컬 테스트: python3 -m http.server 8000"
