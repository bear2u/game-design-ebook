#!/bin/bash

# 간단한 로컬 서버 실행 스크립트 (Jekyll 없이)
# Python의 http.server를 사용합니다

PORT=${1:-8000}

echo "🚀 이북 사이트를 로컬에서 실행합니다..."
echo "📍 주소: http://localhost:$PORT"
echo ""
echo "서버를 중지하려면 Ctrl+C를 누르세요."
echo ""

# Python 3가 있으면 사용, 없으면 Python 2
if command -v python3 &> /dev/null; then
    python3 -m http.server $PORT
elif command -v python &> /dev/null; then
    python -m SimpleHTTPServer $PORT
else
    echo "❌ Python이 설치되어 있지 않습니다."
    echo "Python을 설치하거나 Jekyll을 사용하세요."
    exit 1
fi
