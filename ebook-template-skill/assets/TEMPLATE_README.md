# Template Files

This folder contains the template files for the Interactive Ebook Template.

## Files Included

- `index.html` - Main ebook template (copy from parent project)
- `.github/workflows/deploy-pages.yml` - GitHub Actions deployment workflow
- `.gitignore` - Git ignore rules

## How to Use

1. Copy `index.html` from the parent project root directory
2. Copy `.github/workflows/deploy-pages.yml` to your project
3. Copy `.gitignore` to your project root
4. Follow the setup guide in `references/SETUP.md`

## Note

The `index.html` file is large (~1150 lines). You should copy it directly from the working project rather than recreating it.

## Quick Copy Command

From the parent project directory:

```bash
# Copy template files
cp index.html ebook-template-skill/assets/
cp .gitignore ebook-template-skill/assets/
cp -r .github ebook-template-skill/assets/
```
