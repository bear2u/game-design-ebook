#!/usr/bin/env node
/**
 * 챕터 목록 자동 업데이트 스크립트
 * translate/ 폴더의 마크다운 파일을 읽어서 index.html의 챕터 목록을 자동으로 업데이트합니다
 */

const fs = require('fs');
const path = require('path');

const TRANSLATE_DIR = path.join(__dirname, '..', '..', 'translate');
const INDEX_HTML = path.join(__dirname, '..', '..', 'index.html');

function extractChapterTitle(markdownContent) {
    // 첫 번째 # 헤더를 찾아서 제목 추출
    const lines = markdownContent.split('\n');
    for (const line of lines) {
        const match = line.match(/^#+\s*(.+)$/);
        if (match) {
            return match[1].trim();
        }
    }
    return null;
}

function getChapters() {
    const chapters = [];
    
    if (!fs.existsSync(TRANSLATE_DIR)) {
        console.error(`❌ translate/ 폴더를 찾을 수 없습니다: ${TRANSLATE_DIR}`);
        return chapters;
    }
    
    const files = fs.readdirSync(TRANSLATE_DIR)
        .filter(file => file.startsWith('chapter') && file.endsWith('.md'))
        .sort((a, b) => {
            const numA = parseInt(a.match(/chapter(\d+)/)?.[1] || '0');
            const numB = parseInt(b.match(/chapter(\d+)/)?.[1] || '0');
            return numA - numB;
        });
    
    for (const file of files) {
        const match = file.match(/chapter(\d+)\.md/);
        if (match) {
            const chapterNum = parseInt(match[1]);
            const filePath = path.join(TRANSLATE_DIR, file);
            const content = fs.readFileSync(filePath, 'utf-8');
            const title = extractChapterTitle(content) || `챕터 ${chapterNum}`;
            
            chapters.push({
                num: chapterNum,
                title: title,
                file: file
            });
        }
    }
    
    return chapters;
}

function updateIndexHtml(chapters) {
    if (!fs.existsSync(INDEX_HTML)) {
        console.error(`❌ index.html을 찾을 수 없습니다: ${INDEX_HTML}`);
        return false;
    }
    
    let html = fs.readFileSync(INDEX_HTML, 'utf-8');
    
    // 챕터 목록 HTML 생성
    const chapterListHtml = chapters.map(ch => 
        `                    <li><a href="#" data-chapter="${ch.num}">${ch.title}</a></li>`
    ).join('\n');
    
    // 기존 챕터 목록 찾아서 교체
    const chapterListPattern = /(<ul class="chapter-list" id="chapterList">)([\s\S]*?)(<\/ul>)/;
    const match = html.match(chapterListPattern);
    
    if (match) {
        html = html.replace(
            chapterListPattern,
            `$1\n${chapterListHtml}\n                $3`
        );
        fs.writeFileSync(INDEX_HTML, html, 'utf-8');
        return true;
    } else {
        console.error('❌ 챕터 목록을 찾을 수 없습니다. index.html 구조를 확인하세요.');
        return false;
    }
}

// 실행
console.log('📚 챕터 목록 자동 업데이트');
console.log('========================\n');

const chapters = getChapters();

if (chapters.length === 0) {
    console.log('⚠️  translate/ 폴더에 챕터 파일이 없습니다.');
    console.log('   chapter1.md, chapter2.md 형식으로 파일을 추가하세요.');
    process.exit(1);
}

console.log(`✅ ${chapters.length}개의 챕터를 찾았습니다:\n`);
chapters.forEach(ch => {
    console.log(`   ${ch.num}. ${ch.title} (${ch.file})`);
});

console.log('\n📝 index.html 업데이트 중...');

if (updateIndexHtml(chapters)) {
    console.log('✅ index.html이 성공적으로 업데이트되었습니다!');
} else {
    console.log('❌ index.html 업데이트 실패');
    process.exit(1);
}
