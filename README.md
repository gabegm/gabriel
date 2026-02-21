# Gabriel's Personal Blog

A personal tech blog built with [Hugo](https://gohugo.io/) using a heavily customized version of the [Hyde theme](https://github.com/spf13/hyde).

## Prerequisites

- [Hugo](https://gohugo.io/installation/) v0.138.0 or later
- Git (for theme submodule)

## Local Development

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd gabriel
   ```

2. **Initialize theme submodule**
   ```bash
   git submodule update --init --recursive
   ```

3. **Run local development server**
   ```bash
   hugo server -D
   ```
   
   The site will be available at `http://localhost:1313/`

## Building for Production

```bash
hugo --gc --minify
```

Output will be in the `public/` directory.

## Deployment

This site is automatically deployed via:
- **Netlify**: On push to main branch (production)
- **GitHub Pages**: Via GitHub Actions workflow

## Theme Customizations

The Hyde theme has been heavily modified with:
- Custom sidebar layout with avatar and navigation
- Accessibility improvements (ARIA labels, alt text)
- RSS feed with custom XML styling
- OpenGraph metadata for social sharing
- Responsive image handling

## Content Structure

```
content/
└── posts/          # Blog posts
    └── *.md        # Individual posts in Markdown

static/
└── images/         # Static images referenced in posts

themes/
└── hyde/           # Customized Hyde theme (git submodule)
```

## Writing a New Post

```bash
hugo new posts/my-new-post.md
```

Edit the frontmatter and content in `content/posts/my-new-post.md`.

## Configuration

Main configuration is in `config.toml`. Key settings:
- Site title, description, author
- Navigation menu items
- Theme parameters (colors, layout)

## License

Content is © Gabriel Gauci Maistre. All rights reserved.