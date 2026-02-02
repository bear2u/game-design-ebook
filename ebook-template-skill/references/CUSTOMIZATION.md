# Customization Guide

## Theme Customization

### Create Custom Theme

Add a new theme in `index.html`:

```css
[data-theme="custom"] {
    --bg-primary: #your-color;
    --bg-secondary: #your-color;
    --text-primary: #your-color;
    --accent-color: #your-color;
    /* ... */
}
```

Add theme button:

```html
<button class="theme-btn" data-theme="custom" id="themeCustom">
    🎨 Custom
</button>
```

### Modify Existing Themes

Edit CSS variables in `:root`, `[data-theme="dark"]`, or `[data-theme="warm"]` sections.

## Layout Customization

### Change Sidebar Width

```css
.main-content {
    grid-template-columns: 350px 1fr; /* Increase sidebar width */
}
```

### Change Header Height

```css
header {
    padding: 50px 20px; /* Increase padding */
}
```

### Modify Content Padding

```css
.content-area {
    padding: 50px; /* Increase content padding */
}
```

## Typography Customization

### Change Default Font

```css
body {
    font-family: 'Your Font', -apple-system, BlinkMacSystemFont, sans-serif;
}
```

### Adjust Line Height

```css
body {
    line-height: 2; /* Increase line spacing */
}
```

### Modify Heading Sizes

```css
.chapter-content h1 {
    font-size: calc(var(--font-size, 1em) * 3); /* Larger h1 */
}
```

## Navigation Customization

### Change Button Styles

```css
.nav-btn {
    border-radius: 20px; /* More rounded */
    padding: 15px 25px; /* Larger buttons */
}
```

### Modify Keyboard Shortcuts

Edit the keyboard event listener:

```javascript
document.addEventListener('keydown', (e) => {
    if (currentChapter) {
        if (e.key === 'ArrowLeft' && chapterNum > 1) {
            // Previous chapter
        }
        // Add more shortcuts
        if (e.key === 'Home') {
            loadChapter(1); // Jump to first chapter
        }
    }
});
```

## Mobile Customization

### Adjust Mobile Breakpoint

```css
@media (max-width: 768px) { /* Change to 1024px for tablet */
    /* Mobile styles */
}
```

### Modify Mobile Header

```css
@media (max-width: 768px) {
    header h1 {
        font-size: 1.2em; /* Smaller title */
    }
}
```

### Change Mobile TOC Animation

```css
.sidebar {
    transition: max-height 0.5s ease; /* Slower animation */
}
```

## Feature Additions

### Add Table of Contents Generation

Automatically generate TOC from chapter headings:

```javascript
function generateTOC(chapterContent) {
    const headings = chapterContent.querySelectorAll('h2, h3');
    const toc = document.createElement('ul');
    headings.forEach(heading => {
        const li = document.createElement('li');
        const a = document.createElement('a');
        a.href = `#${heading.id}`;
        a.textContent = heading.textContent;
        li.appendChild(a);
        toc.appendChild(li);
    });
    return toc;
}
```

### Add Reading Time Estimate

```javascript
function estimateReadingTime(text) {
    const wordsPerMinute = 200;
    const words = text.split(/\s+/).length;
    const minutes = Math.ceil(words / wordsPerMinute);
    return `${minutes} min read`;
}
```

### Add Print Styles

```css
@media print {
    .sidebar, .settings-toggle, .settings-panel {
        display: none;
    }
    .content-area {
        max-width: 100%;
        padding: 0;
    }
}
```

## Performance Optimization

### Lazy Load Chapters

Load chapters only when needed:

```javascript
const chapterCache = new Map();

async function loadChapter(chapterNum) {
    if (chapterCache.has(chapterNum)) {
        return chapterCache.get(chapterNum);
    }
    // Load and cache
}
```

### Optimize Images

Add lazy loading:

```html
<img src="image.jpg" loading="lazy" alt="Description">
```

### Minimize Reflows

Use CSS transforms instead of position changes:

```css
.nav-btn:hover {
    transform: translateY(-2px); /* Instead of margin-top */
}
```

## Accessibility Improvements

### Add ARIA Labels

```html
<button aria-label="Previous chapter" id="prevChapter">
    ← 이전 챕터
</button>
```

### Keyboard Navigation

Ensure all interactive elements are keyboard accessible:

```css
.nav-btn:focus {
    outline: 2px solid var(--accent-color);
    outline-offset: 2px;
}
```

### Screen Reader Support

Add skip links:

```html
<a href="#main-content" class="skip-link">Skip to main content</a>
```
