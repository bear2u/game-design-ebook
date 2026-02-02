---
name: interactive-ebook-template
description: Automatically create a beautiful, mobile-optimized interactive ebook website from markdown files. Includes setup script to generate complete project structure, chapter list auto-updater, theme switching (light/dark/warm), font controls, navigation, and GitHub Pages deployment. Use when users want to create an ebook reader, documentation site, or convert markdown chapters into a web-based reading experience. Simply run setup script, add markdown files to translate/ folder, run updater script, and deploy.
license: MIT
compatibility: Requires GitHub account for Pages deployment. Works with any static file hosting. Setup script requires Bash, updater script requires Node.js.
metadata:
  author: game-design-translate
  version: "1.0.0"
  category: web-template
  automation: true
---

# Interactive Ebook Template

A production-ready, mobile-first ebook template with advanced features for creating beautiful reading experiences.

## Features

### 🎨 Theme System
- **3 Built-in Themes**: Light, Dark, and Warm (reading-optimized)
- Smooth theme transitions
- Theme preference saved in localStorage

### 📱 Mobile Optimization
- Responsive design for all screen sizes
- Header-fixed dropdown table of contents
- Touch-friendly controls
- Safe area support (notch/status bar)
- Independent scrolling for sidebar and content

### 🔤 Typography Controls
- Font size slider (80% - 140%)
- Real-time preview
- Preference persistence

### 📖 Navigation
- Previous/Next chapter buttons
- Keyboard shortcuts (← → arrow keys)
- Chapter list with active state
- Smooth scrolling

### 🚀 Deployment
- GitHub Pages ready
- GitHub Actions workflow included
- No build step required (pure HTML/JS)

## Quick Start

### Automated Workflow (For AI Agents)

**Step 1: Create Project Structure**

```bash
# Run setup script to create complete project
chmod +x ebook-template-skill/scripts/setup-ebook.sh
./ebook-template-skill/scripts/setup-ebook.sh my-ebook
```

This automatically creates:
- ✅ Complete project directory structure
- ✅ Full `index.html` template (1150+ lines)
- ✅ GitHub Actions workflow (`.github/workflows/deploy-pages.yml`)
- ✅ `.gitignore` file
- ✅ Sample chapter (`translate/chapter1.md`)
- ✅ README.md

**Step 2: Add Your Markdown Chapters**

Simply add your markdown files to `translate/` folder:

```bash
translate/
├── chapter1.md
├── chapter2.md
├── chapter3.md
└── ...
```

**Step 3: Auto-Update Chapter List**

Run the chapter list updater to automatically update `index.html`:

```bash
chmod +x scripts/update-chapters.js
node scripts/update-chapters.js
```

This script:
- ✅ Scans `translate/` folder for `chapter{N}.md` files
- ✅ Extracts chapter titles from markdown headers
- ✅ Automatically updates the chapter list in `index.html`

**Step 4: Customize Header (Optional)**

Edit `index.html` header section:

```html
<header>
    <h1>Your Book Title</h1>
    <p>Subtitle</p>
    <p style="font-size: 0.9em; margin-top: 10px; opacity: 0.8;">Author Name</p>
</header>
```

**Step 5: Deploy**

```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/username/repo.git
git push -u origin main
```

Then configure GitHub Pages (Settings > Pages > Source: GitHub Actions)

**That's it!** Your ebook is ready. 🎉

### Manual Setup

```bash
# Create your ebook directory
mkdir my-ebook
cd my-ebook

# Copy template files
cp -r ebook-template-skill/assets/* .
cp -r ebook-template-skill/scripts/* .  # Optional
```

### 2. Prepare Your Content

Create a `translate/` directory and add your chapter markdown files:

```
translate/
├── chapter1.md
├── chapter2.md
├── chapter3.md
└── ...
```

### 3. Update Chapter List

**Option A: Automatic (Recommended)**

Use the chapter list updater script:

```bash
# Make script executable
chmod +x scripts/update-chapters.js

# Run updater (reads translate/ folder and updates index.html)
node scripts/update-chapters.js
```

**Option B: Manual**

Edit `index.html` and update the chapter list in the sidebar:

```html
<ul class="chapter-list" id="chapterList">
    <li><a href="#" data-chapter="1">Chapter 1: Title</a></li>
    <li><a href="#" data-chapter="2">Chapter 2: Title</a></li>
    <!-- Add more chapters -->
</ul>
```

### 4. Customize Header

Update the header section in `index.html`:

```html
<header>
    <h1>Your Book Title</h1>
    <p>Subtitle or Description</p>
    <p style="font-size: 0.9em; margin-top: 10px; opacity: 0.8;">Author Name</p>
</header>
```

### 5. Deploy to GitHub Pages

1. Push to GitHub repository
2. Go to Settings > Pages
3. Set Source to **GitHub Actions**
4. The site will auto-deploy

## File Structure

```
your-ebook/
├── index.html              # Main ebook page
├── translate/              # Chapter markdown files
│   ├── chapter1.md
│   ├── chapter2.md
│   └── ...
├── imgs/                   # Images (optional)
├── .github/
│   └── workflows/
│       └── deploy-pages.yml  # GitHub Actions workflow
├── .gitignore
└── README.md
```

## Customization

### Theme Colors

Edit CSS variables in `index.html`:

```css
:root {
    --bg-primary: #f5f5f5;
    --bg-secondary: #ffffff;
    --text-primary: #333;
    --accent-color: #667eea;
    /* ... */
}
```

### Chapter Loading

The template uses `marked.js` for Markdown parsing. Chapters are loaded from:

```
translate/chapter{N}.md
```

Where `{N}` is the chapter number.

### Image Paths

Images should be placed in `imgs/` directory and referenced in markdown:

```markdown
![Alt text](../imgs/image.jpg)
```

Or use HTML:

```html
<div style="text-align: center;">
    <img src="../imgs/image.jpg" alt="Description" width="60%"/>
</div>
```

## Advanced Features

### Keyboard Navigation

- `←` (Left Arrow): Previous chapter
- `→` (Right Arrow): Next chapter

### Mobile TOC

On mobile devices:
- Tap top-left button to open table of contents
- TOC slides down from header
- Automatically closes when chapter is selected

### Settings Panel

- Tap gear icon (⚙️) in top-right (mobile) or bottom-right (desktop)
- Change theme: Light / Dark / Warm
- Adjust font size with slider

## Browser Support

- Chrome/Edge (latest)
- Firefox (latest)
- Safari (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## Dependencies

- **marked.js**: CDN loaded for Markdown parsing
- No build tools required
- No Node.js required

## Troubleshooting

### Images Not Loading

1. Check image paths are relative to `index.html`
2. Ensure `imgs/` folder exists
3. Check browser console for 404 errors

### Chapters Not Loading

1. Verify chapter files exist in `translate/` folder
2. Check file naming: `chapter{N}.md` (N = chapter number)
3. Ensure chapter list in HTML matches file names

### GitHub Pages Not Deploying

1. Check GitHub Actions tab for errors
2. Verify `.github/workflows/deploy-pages.yml` exists
3. Ensure repository Settings > Pages > Source is set to "GitHub Actions"

## Examples

See `references/EXAMPLES.md` for complete examples and use cases.

## License

MIT License - Feel free to use in your projects.
