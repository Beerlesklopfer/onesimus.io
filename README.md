# onesimus.io

The website for [Onesimus](https://github.com/Beerlesklopfer/Onesimus) — a modern Qt6 management interface for Bacula & Bareos backup systems.

## Quick Start

```bash
# Install Hugo (https://gohugo.io/installation/)
# macOS
brew install hugo

# Linux (snap)
snap install hugo

# Verify
hugo version  # needs v0.120.0+

# Run locally
hugo server -D
# → http://localhost:1313/
```

## Structure

```
onesimus-site/
├── content/
│   ├── _index.md              # Homepage
│   ├── blog/                  # Blog posts (Markdown)
│   ├── docs/                  # Documentation
│   └── pricing/               # Pricing page
├── themes/onesimus-theme/     # Custom theme
│   ├── assets/css/main.css    # All styles
│   ├── layouts/               # HTML templates
│   └── static/                # Images, icons
├── static/                    # Site-wide static files
├── hugo.toml                  # Site configuration
└── .github/workflows/hugo.yml # Auto-deploy to GitHub Pages
```

## Writing Blog Posts

```bash
hugo new blog/my-new-post.md
```

Edit `content/blog/my-new-post.md`, set `draft: false` when ready.

## Deployment

Push to `main` branch → GitHub Actions builds and deploys to GitHub Pages automatically.

### Custom Domain Setup

1. In your domain registrar, add these DNS records:
   - `A` record: `185.199.108.153` (and .109, .110, .111)
   - `CNAME` record: `www` → `beerlesklopfer.github.io`
2. In GitHub repo Settings → Pages → Custom domain: `onesimus.io`
3. Enable "Enforce HTTPS"

## Customization

- **Colors/Fonts**: Edit `themes/onesimus-theme/assets/css/main.css` (CSS variables at top)
- **Navigation**: Edit `hugo.toml` → `[menu]` section
- **Pricing**: Edit `content/pricing/_index.md` and `themes/onesimus-theme/layouts/pricing/list.html`
- **Homepage**: Edit `themes/onesimus-theme/layouts/index.html`

## Adding Screenshots

Place images in `static/img/` and reference them in templates:

```html
<img src="/img/screenshot-jobs.png" alt="Job Management">
```

## License

Website content: CC BY 4.0
Theme code: MIT
