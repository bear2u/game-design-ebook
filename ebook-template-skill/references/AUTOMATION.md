# Automation Guide

## For AI Agents: Complete Automation Workflow

This guide explains how AI agents can use this skill to automatically create ebook projects.

## Workflow Overview

```
1. Run setup script → Creates project structure
2. Add markdown files → User/Agent adds chapters
3. Run updater script → Auto-updates chapter list
4. Customize header → Optional metadata update
5. Deploy → Push to GitHub
```

## Step-by-Step Automation

### 1. Initialize Project

```bash
# From skill directory
./scripts/setup-ebook.sh project-name [output-dir]
```

**What it does:**
- Creates project directory
- Generates complete `index.html` (all 1150+ lines)
- Creates GitHub Actions workflow
- Creates `.gitignore`
- Creates sample chapter
- Creates README

**Output:**
```
project-name/
├── index.html          # Complete template
├── translate/
│   └── chapter1.md     # Sample
├── .github/
│   └── workflows/
│       └── deploy-pages.yml
├── .gitignore
└── README.md
```

### 2. Add Chapter Files

User or agent adds markdown files:

```bash
# Example: Adding chapters
echo "# Chapter 2: Title" > project-name/translate/chapter2.md
echo "# Chapter 3: Title" > project-name/translate/chapter3.md
```

**File naming convention:**
- Must be: `chapter{N}.md` where N is number
- Example: `chapter1.md`, `chapter2.md`, `chapter10.md`
- Files are automatically sorted by number

### 3. Auto-Update Chapter List

```bash
cd project-name
node scripts/update-chapters.js
```

**What it does:**
- Scans `translate/` folder
- Finds all `chapter{N}.md` files
- Extracts titles from first `#` header in each file
- Updates `<ul class="chapter-list">` in `index.html`
- Preserves existing HTML structure

**Before:**
```html
<ul class="chapter-list" id="chapterList">
    <!-- Empty or old list -->
</ul>
```

**After:**
```html
<ul class="chapter-list" id="chapterList">
    <li><a href="#" data-chapter="1">Chapter 1: Title</a></li>
    <li><a href="#" data-chapter="2">Chapter 2: Title</a></li>
    <li><a href="#" data-chapter="3">Chapter 3: Title</a></li>
</ul>
```

### 4. Customize Metadata (Optional)

Update header in `index.html`:

```javascript
// Example: Programmatic update
const fs = require('fs');
let html = fs.readFileSync('index.html', 'utf-8');

html = html.replace(
    /<h1>이북 제목<\/h1>/,
    '<h1>Your Book Title</h1>'
);

html = html.replace(
    /<p>부제목 또는 설명<\/p>/,
    '<p>Your Subtitle</p>'
);

fs.writeFileSync('index.html', html, 'utf-8');
```

### 5. Deploy

```bash
git init
git add .
git commit -m "Initial ebook"
git remote add origin https://github.com/user/repo.git
git push -u origin main
```

GitHub Pages will auto-deploy via Actions.

## Complete Agent Workflow Example

```javascript
// Pseudo-code for AI agent
async function createEbook(bookTitle, chapters) {
    // 1. Setup project
    execSync('./scripts/setup-ebook.sh my-book');
    
    // 2. Create chapter files
    chapters.forEach((ch, idx) => {
        fs.writeFileSync(
            `my-book/translate/chapter${idx + 1}.md`,
            ch.content
        );
    });
    
    // 3. Update chapter list
    execSync('cd my-book && node scripts/update-chapters.js');
    
    // 4. Update header
    updateHeader('my-book/index.html', {
        title: bookTitle,
        subtitle: 'Generated Ebook',
        author: 'AI Agent'
    });
    
    // 5. Initialize git (optional)
    execSync('cd my-book && git init && git add . && git commit -m "Initial"');
    
    return 'my-book';
}
```

## Chapter File Format

Each `chapter{N}.md` file should start with a header:

```markdown
# 챕터 N: 제목

본문 내용...

## Page 1

페이지 내용...

## Page 2

다음 페이지...
```

The updater script extracts the first `#` header as the chapter title.

## Error Handling

### No Chapters Found

If `update-chapters.js` finds no chapters:
- Prints warning message
- Exits with code 1
- Does not modify `index.html`

### Invalid File Names

Files not matching `chapter{N}.md` pattern are ignored:
- `chapter1.md` ✅
- `Chapter1.md` ❌ (case sensitive)
- `ch1.md` ❌
- `chapter-1.md` ❌

### Missing index.html

If `index.html` not found:
- Prints error message
- Exits with code 1

## Integration Tips

### For AI Agents

1. **Always run setup script first** - Creates complete structure
2. **Use update script after adding chapters** - Keeps HTML in sync
3. **Check script exit codes** - Handle errors appropriately
4. **Validate chapter files** - Ensure proper naming before update

### For Users

1. Run setup once per project
2. Add chapters as needed
3. Run updater whenever chapters change
4. Customize header manually if needed

## Script Dependencies

- `setup-ebook.sh`: Bash, no dependencies
- `update-chapters.js`: Node.js (built-in `fs`, `path` modules)

No external npm packages required!
