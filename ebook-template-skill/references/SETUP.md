# Setup Guide

## Installation Steps

### Step 1: Copy Template Files

Copy the template files to your project:

```bash
# Option 1: Copy entire assets folder
cp -r ebook-template-skill/assets/* your-project/

# Option 2: Copy specific files
cp ebook-template-skill/assets/index.html your-project/
cp -r ebook-template-skill/assets/.github your-project/
cp ebook-template-skill/assets/.gitignore your-project/
```

### Step 2: Create Directory Structure

```
your-project/
├── index.html              # Main ebook page (from template)
├── translate/              # Your chapter markdown files
│   ├── chapter1.md
│   ├── chapter2.md
│   └── ...
├── imgs/                   # Images (optional)
│   └── ...
├── .github/
│   └── workflows/
│       └── deploy-pages.yml
└── .gitignore
```

### Step 3: Update Chapter List

Edit `index.html` and find the chapter list section:

```html
<ul class="chapter-list" id="chapterList">
    <li><a href="#" data-chapter="1">Chapter 1: Your Title</a></li>
    <li><a href="#" data-chapter="2">Chapter 2: Your Title</a></li>
    <!-- Add all your chapters -->
</ul>
```

**Important**: The `data-chapter` attribute must match your file names:
- `data-chapter="1"` → `translate/chapter1.md`
- `data-chapter="2"` → `translate/chapter2.md`
- etc.

### Step 4: Update Header

Modify the header section in `index.html`:

```html
<header>
    <h1>Your Book Title</h1>
    <p>Subtitle or Description</p>
    <p style="font-size: 0.9em; margin-top: 10px; opacity: 0.8;">Author Name</p>
</header>
```

### Step 5: Update Page Title

Change the `<title>` tag:

```html
<title>Your Book Title - Ebook</title>
```

### Step 6: Prepare Chapter Files

Create your chapter markdown files in `translate/` folder:

**translate/chapter1.md**:
```markdown
# 챕터 1: 제목

본문 내용...

## Page 1

페이지 내용...

## Page 2

다음 페이지 내용...
```

**Naming Convention**:
- Files must be named: `chapter{N}.md` where N is the chapter number
- Example: `chapter1.md`, `chapter2.md`, `chapter3.md`

### Step 7: Test Locally

```bash
# Using Python
python3 -m http.server 8000

# Or using Node.js
npx serve

# Or use the provided serve.sh
chmod +x serve.sh
./serve.sh
```

Visit `http://localhost:8000` to test.

### Step 8: Deploy to GitHub

1. Initialize git repository:
```bash
git init
git add .
git commit -m "Initial commit"
```

2. Create GitHub repository and push:
```bash
git remote add origin https://github.com/username/repo-name.git
git push -u origin main
```

3. Configure GitHub Pages:
   - Go to repository Settings > Pages
   - Source: Select **GitHub Actions**
   - Save

4. Wait for deployment (check Actions tab)

## File Requirements

### Required Files

- `index.html` - Main ebook page
- `translate/chapter{N}.md` - At least one chapter file
- `.github/workflows/deploy-pages.yml` - GitHub Actions workflow

### Optional Files

- `imgs/` - Image folder
- `.gitignore` - Git ignore rules
- `README.md` - Project documentation

## Chapter File Format

### Basic Structure

```markdown
# 챕터 제목

챕터 소개 내용...

## Page 1

페이지 내용...

## Page 2

다음 페이지 내용...
```

### Supported Markdown

- Headers (`#`, `##`, `###`)
- Paragraphs
- Lists (ordered, unordered)
- Links `[text](url)`
- Images `![alt](path)` (hidden by default)
- Code blocks ` ```code``` `
- Blockquotes `> quote`
- Bold `**text**`, Italic `*text*`

### Page Numbers

Use `## Page N` format for page breaks:

```markdown
## Page 1
Content for page 1...

## Page 2
Content for page 2...
```

These will be automatically converted to page number indicators.

## Troubleshooting

### Chapters Not Loading

1. Check file names match: `chapter{N}.md`
2. Verify `data-chapter` attributes match file numbers
3. Check browser console for errors
4. Ensure files are in `translate/` folder

### Images Not Showing

Images are hidden by default. To show images:

1. Remove or comment out this CSS:
```css
.chapter-content img {
    display: none;
}
```

2. Use correct image paths:
```markdown
![Alt text](../imgs/image.jpg)
```

### Mobile Layout Issues

1. Clear browser cache
2. Check viewport meta tag is present
3. Test on actual device, not just browser dev tools
4. Verify safe area CSS is included

### GitHub Pages Not Deploying

1. Check Actions tab for errors
2. Verify `.github/workflows/deploy-pages.yml` exists
3. Ensure repository is public (or you have GitHub Pro)
4. Check Settings > Pages > Source is set to "GitHub Actions"
