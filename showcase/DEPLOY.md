# Deployment Plan -- Noisy Claude Showcase Site

## Recommendation: GitHub Pages

**Primary recommendation: GitHub Pages** with Vercel as backup option.

### Why GitHub Pages

| Factor | GitHub Pages | Vercel | Netlify |
|--------|-------------|--------|---------|
| Cost | Free | Free tier | Free tier |
| Custom domain | Yes (CNAME) | Yes | Yes |
| HTTPS | Automatic | Automatic | Automatic |
| Deploy from | git push to branch | git push / CLI | git push / CLI |
| Build step | Optional (Jekyll or none) | Required (framework detection) | Required (build command) |
| Complexity | Minimal | Medium | Medium |
| CDN | Fastly | Edge network | Cloudflare |
| Bandwidth | 100GB/month soft limit | 100GB/month free | 100GB/month free |
| Best for | Static HTML/CSS/JS | Framework-based apps | JAMstack sites |

**GitHub Pages wins because:**

1. **No build step** -- Noisy Claude's showcase is static HTML/CSS/JS, like the Control Panel itself. Push and done.
2. **Same platform** -- The Noisy Claude repo already lives on GitHub. One fewer account/service to manage.
3. **Simplicity** -- No config files, no build commands, no framework detection. Just HTML files served from a branch.
4. **Free forever** -- No usage-based pricing surprises. The showcase site will never exceed GitHub Pages limits.

### When to use Vercel instead

Choose Vercel if:
- We add a framework (Next.js, Astro) for the showcase site
- We need server-side rendering or API routes
- We want preview deployments on every PR
- We need edge functions for analytics or A/B testing

### When to use Netlify instead

Choose Netlify if:
- We need form handling (contact forms, feedback)
- We want Netlify CMS for content management
- We need split testing or branch deploys with UI

## GitHub Pages Setup

### Option A: Separate Repository (Recommended)

Create a new repo `noisy-claude-site` (or similar) with its own deployment:

```bash
# Create the showcase site repo
gh repo create noisy-claude-site --public --description "Noisy Claude showcase website"

# Push the site files
cd showcase/
git init
git add .
git commit -m "Initial showcase site"
git remote add origin git@github.com:USERNAME/noisy-claude-site.git
git push -u origin main

# Enable GitHub Pages
gh api repos/USERNAME/noisy-claude-site/pages \
  --method POST \
  --field source='{"branch":"main","path":"/"}'
```

**Pros**: Clean separation. Showcase site has its own commit history, issues, and deploy pipeline.
**Cons**: Two repos to manage.

### Option B: Subdirectory in Main Repo

Deploy from a `/docs` or `/showcase` directory in the noisy-claude repo:

```
Settings > Pages > Source: Deploy from a branch
Branch: main
Folder: /showcase (or /docs)
```

**Pros**: Single repo, everything together.
**Cons**: Showcase commits mixed with tool commits. Deploy triggers on any push to main.

### Recommendation: Option A (Separate Repo)

The showcase site is a different project with different concerns (marketing, design, copy). It should have its own lifecycle.

## Directory Structure

```
noisy-claude-site/
  index.html              # The entire showcase site (single file, < 50KB)
  favicon.ico
  CNAME                   # Custom domain (if applicable)
  README.md               # Repo README
```

The site is a single HTML file with all CSS and JS inline. No external stylesheets, scripts, or images. The only external dependency is Google Fonts (IBM Plex Mono). This makes deployment trivially simple.

## No Audio on the Showcase Site

The showcase site deliberately does not include sound playback. This is an intentional creative decision (see CREATIVE-BRIEF.md: "No sound on the website itself. The irony is intentional. Let them imagine the sounds."). No audio assets need to be managed, converted, or deployed.

## Custom Domain (Optional)

If a custom domain is desired:

1. Purchase domain (e.g., `noisyclaude.dev` or `noisy-claude.dev`)
2. Add CNAME file to repo root with domain name
3. Configure DNS:
   - A records pointing to GitHub Pages IPs (185.199.108-111.153)
   - Or CNAME record pointing to `USERNAME.github.io`
4. Enable HTTPS in repo Settings > Pages

## Deployment Checklist

### Pre-Deploy
- [ ] HTML validates (W3C validator)
- [ ] Total page weight under 50KB (excluding font files)
- [ ] All links work (no broken hrefs, GitHub URL correct)
- [ ] Favicon in place
- [ ] Meta tags set (title, description, og:title, og:description, twitter:card)
- [ ] Responsive design tested at 1200px, 768px, 375px
- [ ] Accessibility audit passes (contrast, keyboard nav, skip-to-content, reduced motion)
- [ ] No terminal green (#00FF41) outside MGS-themed areas
- [ ] Collection card contrast is visually obvious

### Deploy
- [ ] Push to main branch
- [ ] Verify GitHub Pages build succeeds (Actions tab)
- [ ] Test live URL in Chrome, Safari, Firefox
- [ ] Verify HTTPS works
- [ ] Copy buttons work on live site

### Post-Deploy
- [ ] Update main Noisy Claude repo README with link to showcase site
- [ ] Share URL for team review
- [ ] Check Google PageSpeed Insights score
- [ ] Set up basic analytics if desired (Plausible, Simple Analytics -- privacy-respecting)

## Performance Targets

| Metric | Target |
|--------|--------|
| First Contentful Paint | < 1.0s |
| Largest Contentful Paint | < 1.5s |
| Total page weight (excluding fonts) | < 50KB |
| Total page weight (including fonts) | < 200KB |
| Lighthouse Performance | > 95 |
| Lighthouse Accessibility | > 95 |

## Monitoring

GitHub Pages provides no built-in analytics. Options:

1. **None** -- Simplest. If we don't need metrics, skip it.
2. **Plausible Analytics** -- Privacy-respecting, lightweight (~1KB script). Paid service ($9/mo).
3. **Simple Analytics** -- Similar to Plausible. Paid.
4. **GoatCounter** -- Free and open source. Self-hosted or hosted tier.
5. **GitHub traffic** -- Repo Insights > Traffic shows visits (only for repo owners, 14-day window).

**Recommendation**: Start with no analytics. Add GoatCounter if we want to track visits later.
