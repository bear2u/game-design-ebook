# Ebook Template Examples

## Example 1: Technical Documentation

Convert technical documentation into an interactive ebook:

```html
<header>
    <h1>API Documentation</h1>
    <p>Complete Guide to Our API</p>
    <p style="font-size: 0.9em; margin-top: 10px; opacity: 0.8;">Development Team</p>
</header>
```

Chapters:
- `chapter1.md`: Getting Started
- `chapter2.md`: Authentication
- `chapter3.md`: Endpoints
- etc.

## Example 2: Course Material

Create an online course reader:

```html
<header>
    <h1>Web Development Course</h1>
    <p>Learn Modern Web Technologies</p>
    <p style="font-size: 0.9em; margin-top: 10px; opacity: 0.8;">Course Instructor</p>
</header>
```

Features:
- Each lesson as a chapter
- Code examples in markdown code blocks
- Progress tracking via localStorage

## Example 3: Novel/Story

Publish a novel or story collection:

```html
<header>
    <h1>The Adventure Begins</h1>
    <p>A Collection of Short Stories</p>
    <p style="font-size: 0.9em; margin-top: 10px; opacity: 0.8;">Author Name</p>
</header>
```

Customize:
- Use "Warm" theme for reading comfort
- Larger default font size
- Minimal navigation (hide prev/next on first/last chapter)

## Example 4: Research Paper

Convert academic papers into readable format:

```html
<header>
    <h1>Research Findings</h1>
    <p>Study on Machine Learning Applications</p>
    <p style="font-size: 0.9em; margin-top: 10px; opacity: 0.8;">Research Team</p>
</header>
```

Chapters:
- Abstract
- Introduction
- Methodology
- Results
- Conclusion
- References

## Customization Tips

### Hide Images

If you don't need images, the template already hides them by default. To show images, remove this CSS:

```css
.chapter-content img {
    display: none;
}
```

### Custom Chapter Numbering

If your chapters don't follow `chapter1.md`, `chapter2.md` pattern, modify the `loadChapter` function:

```javascript
// Instead of: translate/chapter${chapterNum}.md
// Use: translate/${chapterSlug}.md
const response = await fetch(`${translatePath}/${chapterSlug}.md`);
```

### Add Progress Indicator

Add a progress bar showing reading progress:

```html
<div class="reading-progress">
    <div class="progress-bar" id="progressBar"></div>
</div>
```

```javascript
function updateProgress() {
    const scrollTop = window.pageYOffset;
    const docHeight = document.documentElement.scrollHeight - window.innerHeight;
    const progress = (scrollTop / docHeight) * 100;
    document.getElementById('progressBar').style.width = progress + '%';
}
```

### Add Search Functionality

Implement chapter search:

```html
<input type="search" id="chapterSearch" placeholder="Search chapters...">
```

```javascript
document.getElementById('chapterSearch').addEventListener('input', (e) => {
    const query = e.target.value.toLowerCase();
    document.querySelectorAll('.chapter-list a').forEach(link => {
        const text = link.textContent.toLowerCase();
        link.style.display = text.includes(query) ? 'block' : 'none';
    });
});
```
