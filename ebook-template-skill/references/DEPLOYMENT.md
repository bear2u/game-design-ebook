# Deployment Guide

## GitHub Pages Deployment

### Automatic Deployment (Recommended)

1. **Push to GitHub**
   ```bash
   git add .
   git commit -m "Add ebook template"
   git push origin main
   ```

2. **Configure GitHub Pages**
   - Go to repository Settings > Pages
   - Source: Select **GitHub Actions**
   - Save

3. **Verify Deployment**
   - Check Actions tab for deployment status
   - Site will be available at: `https://[username].github.io/[repo-name]/`

### Manual Deployment

If you prefer manual deployment:

1. **Build Locally** (optional, not required)
   ```bash
   # No build step needed - pure HTML/JS
   # Just ensure all files are committed
   ```

2. **Use GitHub Pages Branch**
   - Settings > Pages
   - Source: Select branch (usually `main` or `gh-pages`)
   - Folder: `/ (root)`

## Other Hosting Options

### Netlify

1. Drag and drop your project folder to Netlify
2. Or connect GitHub repository
3. Build command: (leave empty)
4. Publish directory: `/`

### Vercel

1. Import your GitHub repository
2. Framework Preset: Other
3. Build Command: (leave empty)
4. Output Directory: (leave empty)

### Cloudflare Pages

1. Connect GitHub repository
2. Build command: (leave empty)
3. Build output directory: `/`

## Custom Domain

### GitHub Pages Custom Domain

1. Add `CNAME` file to repository root:
   ```
   yourdomain.com
   ```

2. Configure DNS:
   - Type: CNAME
   - Name: @ or www
   - Value: [username].github.io

3. Enable HTTPS in GitHub Pages settings

## Environment Variables

This template doesn't require environment variables. All configuration is in `index.html`.

## Build Optimization

### Minify HTML/CSS/JS (Optional)

For production, you can minify:

```bash
# Using html-minifier
npm install -g html-minifier
html-minifier --collapse-whitespace --remove-comments index.html -o index.min.html
```

### Image Optimization

Optimize images before adding to `imgs/`:

```bash
# Using ImageMagick
convert image.jpg -quality 85 -resize 1200x image-optimized.jpg
```

## CDN Considerations

The template uses CDN for `marked.js`:

```html
<script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
```

For offline support or custom CDN, download and host locally:

```bash
wget https://cdn.jsdelivr.net/npm/marked/marked.min.js
# Place in assets/js/marked.min.js
```

Then update HTML:

```html
<script src="assets/js/marked.min.js"></script>
```

## Troubleshooting Deployment

### 404 Errors

- Check file paths are relative
- Ensure `index.html` is in root directory
- Verify GitHub Pages is serving from correct branch

### Assets Not Loading

- Use relative paths: `../imgs/image.jpg`
- Check browser console for 404 errors
- Verify file permissions in repository

### GitHub Actions Failing

- Check `.github/workflows/deploy-pages.yml` exists
- Verify workflow has correct permissions
- Check Actions tab for detailed error messages
