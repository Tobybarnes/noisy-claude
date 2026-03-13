# Development Guide -- Noisy Claude Showcase Site

Guide for building and maintaining the showcase site.

## Prerequisites

- A modern web browser (Chrome, Safari, or Firefox)
- A text editor
- `python3` (for local dev server) or any static file server
- `git` for version control

No npm, no node_modules, no build tools required.

## Local Development

### Quick Start

```bash
# Clone the showcase site repo
git clone git@github.com:USERNAME/noisy-claude-site.git
cd noisy-claude-site

# Start a local server (any of these work)
python3 -m http.server 8080
# or
npx serve .
# or just open index.html directly in a browser
```

Visit http://localhost:8080

### File Structure

```
noisy-claude-site/
  index.html              # The entire showcase site (single file)
  favicon.ico
  CNAME                   # Custom domain config (if applicable)
  README.md               # Repo README
```

The site is a **single HTML file** with all CSS inline in `<style>` and all JS inline at the bottom of `<body>`. No external CSS, JS, or image files. All visual elements are CSS-generated (LEDs, borders, grids, gradients). The only external dependency is Google Fonts (IBM Plex Mono).

The working prototype is at `showcase-site.html` in the main Noisy Claude repo.

### Key Conventions

- **Single HTML file**: Everything -- markup, styles, scripts -- lives in one file. No routing, no imports.
- **Vanilla JS only**: IntersectionObserver for scroll reveal + clipboard API for copy buttons. Under 50 lines total.
- **CSS custom properties**: All design tokens defined at `:root` in the inline `<style>` block.
- **No build step**: What you edit is what gets deployed.
- **No images**: All visual elements (LEDs, cards, grids, mockups) are pure CSS.
- **No sound on the website**: The showcase page deliberately has no audio playback.
- **No `border-radius`**: Sharp corners everywhere. Only exception: LED circles (`border-radius: 50%`).
- **Semantic HTML**: `<section>` with `aria-label`, one `<h1>`, proper heading hierarchy, `role="article"` for collection cards.

### Design System Reference

The showcase site uses a **neutral-framework** approach ("The Player"): the base site is clean and collection-agnostic, while each collection section gets its own distinct visual treatment.

**Full design specs**: See `showcase/DESIGN-SPECS.md` for the complete component library, section-by-section specs, responsive breakpoints, and accessibility requirements. This section summarizes the key tokens.

**Critical rule**: Terminal green (`#00FF41`) is NOT a framework color. It belongs exclusively to the MGS aesthetic. The neutral framework uses white (`#FFFFFF`).

#### Framework / Neutral Tokens (hero, event map, installation, CTA, footer)

| Token | Value | Usage |
|-------|-------|-------|
| `--bg-page` | `#0A0A0A` | Page background (not pure black) |
| `--bg-surface` | `#141414` | Cards, panels, content blocks |
| `--bg-elevated` | `#1A1A1A` | Hover states, elevated panels |
| `--bg-inset` | `#0D0D0D` | Code blocks, deepest recesses |
| `--accent` | `#FFFFFF` | Framework accent -- white, NOT green |
| `--text-primary` | `#FFFFFF` | Headlines, key values |
| `--text-secondary` | `rgba(255,255,255,0.65)` | Body text, descriptions |
| `--text-tertiary` | `rgba(255,255,255,0.40)` | Labels, captions, metadata |
| `--border-default` | `rgba(255,255,255,0.08)` | Panel edges, dividers |
| `--led-on` | `#FFFFFF` | Neutral white LED |
| Font | `IBM Plex Mono` (400, 500, 700) | One font, no secondary |
| Spacing | `4px` base grid | Use multiples: 8, 12, 16, 24, 32, 48, 64, 80, 96 |
| Border radius | `0` | Sharp corners everywhere. Only exception: LED circles. |

#### MGS Collection Tokens (MGS card, MGS deep-dive section)

| Token | Value | Usage |
|-------|-------|-------|
| `--mgs-primary` | `#FFB800` | Codec amber -- headings, borders, stats |
| `--mgs-secondary` | `#00FF41` | Terminal green -- code/event names within MGS |
| `--mgs-bg` | `#0D0D0A` | Slightly warm near-black |
| `--mgs-surface` | `#141410` | Slightly warm dark surface |
| `--mgs-border` | `rgba(255,184,0,0.15)` | Amber-tinted borders |
| `--mgs-glow` | `0 0 12px rgba(255,184,0,0.4)` | Amber LED glow |
| LED color | `#FFB800` (amber) | Not green -- amber is the MGS LED color |

#### Sims 2 Collection Tokens (Sims card, Sims deep-dive section)

| Token | Value | Usage |
|-------|-------|-------|
| `--sims-primary` | `#00D4AA` | Plumbob teal -- headings, borders, stats |
| `--sims-bg` | `#0F1413` | Slightly cool near-black (on showcase site) |
| `--sims-surface` | `#141A18` | Slightly cool dark surface |
| `--sims-border` | `rgba(0,212,170,0.15)` | Teal-tinted borders |
| `--sims-glow` | `0 0 12px rgba(0,212,170,0.4)` | Teal LED glow |
| LED color | `#00D4AA` (teal) | Plumbob teal |
| Sims bg (Control Panel light theme) | `#F4F1EC` | Warm off-white for the light UI theme |
| Sims text on light | `#1A1A1A` | Near-black text on light background |
| Sims teal on light | `#009B7D` | Darker teal for contrast on white |

#### Color Usage Quick Reference (from DESIGN-SPECS.md Appendix D)

| Section | Accent | LED | Button BG | Code Text | Borders |
|---------|--------|-----|-----------|-----------|---------|
| Hero | White | White | White | -- | `rgba(255,255,255,0.08)` |
| Collections intro | White | White | -- | -- | `rgba(255,255,255,0.08)` |
| MGS card | `#FFB800` | Amber | Amber | `#00FF41` | `rgba(255,184,0,0.12)` |
| Sims card | `#00D4AA` | Teal | Teal | `#00D4AA` | `rgba(0,212,170,0.12)` |
| Control Panel | White | White | White | `rgba(255,255,255,0.80)` | `rgba(255,255,255,0.08)` |
| Event Map | White | White | -- | `rgba(255,255,255,0.80)` | `rgba(255,255,255,0.08)` |
| CTA | White | -- | White | `rgba(255,255,255,0.80)` | `rgba(255,255,255,0.25)` |

#### Control Panel Theming (Product Feature -- Implemented)

The Control Panel (`control-panel.html`) supports adaptive themes via `body.theme-mgs` and `body.theme-sims` CSS classes.

**Trigger**: `applyCollectionTheme(collectionId)` function, called from both `switchCollection()` and `init()`.

**Theme class mapping** (JS):
```
collectionThemes = {
    'MGS': 'theme-mgs', 'mgs': 'theme-mgs',
    'Sims2': 'theme-sims', 'sims2': 'theme-sims', 'sims': 'theme-sims'
}
```

**Sims theme variables** (`body.theme-sims`):

| Variable | Value |
|----------|-------|
| `--color-bg-primary` | `#F4F1EC` |
| `--color-bg-panel` | `#FFFFFF` |
| `--color-bg-meter` | `#EAE6DF` |
| `--color-bg-category` | `#EDE9E3` |
| `--color-text-primary` | `#1A1A1A` |
| `--color-text-secondary` | `rgba(0, 0, 0, 0.55)` |
| `--color-accent` | `#009B7D` |
| `--color-border` | `rgba(0, 0, 0, 0.10)` |
| `--color-led-on` | `#00D4AA` |
| `--color-led-bezel` | `#C0C0C0` |

**MGS theme variables** (`body.theme-mgs`):

| Variable | Value |
|----------|-------|
| `--color-bg-primary` | `#0A0A0A` |
| `--color-bg-panel` | `#0E0E0E` |
| `--color-bg-category` | `#161310` |
| `--color-accent` | `#FFB800` |
| `--color-border` | `rgba(255, 184, 0, 0.08)` |
| `--color-led-on` | `#00FF00` |

Both themes include per-theme overrides for buttons, focus options, toasts, loading spinner, modals, and the master power switch.

The showcase site demonstrates both themes side-by-side in the `.cp-dual` grid section using CSS-only mini mockups (rendered live in HTML, no screenshots).

#### Master Power Switch (Product Feature -- Implemented)

**Config**: `master_enabled: true` at top level of config.json.

**UI** (`control-panel.html`): Skeuomorphic 72x36px rocker switch with sliding paddle and embossed ON/OFF labels. Sits as its own rack-unit strip between the title header and the controls nav (not inside the header). Includes:
- Power indicator LED (red glow default, teal for Sims theme, amber for MGS theme)
- "MASTER POWER" label with "Cmd+Shift+M" keyboard hint
- Status readout: "Active" / "Standby"

**Powered-off visual treatment** (`body.powered-off` class):
- Events grid: 25% opacity, desaturated (`filter: saturate(0)`), pointer-events disabled
- Header controls: 35% opacity, pointer-events disabled
- Search box: 35% opacity, disabled
- Collections section: 50% opacity
- Power switch itself stays fully interactive

**Theme-aware**: Full CSS overrides for `body.theme-sims` and `body.theme-mgs` -- housing color, paddle gradient, LED color, border accents all adapt.

**Shell script** (`noisy-claude.sh`): Master check at lines 139-146, runs before focus mode check. CLI commands: `--mute` / `--unmute`. `--status` shows master power state.

Independent of focus_mode. Master off = silence regardless of focus mode setting.

#### Sound Labels (Product Feature -- Implemented)

`sound_label` field on all 76 events in config.json. CSS class: `.sound-label` (styled in accent color at 70% opacity). Rendered inside `createEventCard()` between `.event-description` and `.event-controls`. When user changes the sound dropdown, the label is actively cleared (not left stale). Key examples:

| Event | MGS Sound | MGS Label | Sims Sound | Sims Label |
|-------|-----------|-----------|------------|------------|
| session_start | 0x1a.wav | Codec ring | mGREETING.wav | Cheerful greeting |
| context_90 | 0x01.wav | Alert (!) | fHUNGRY2.wav | Hungry complaint |
| git_commit | 0x67.wav | Item pickup | Good Shot M.wav | Enthusiastic approval |
| git_pr_create | 0x44.wav | Mission milestone | fCELEB0.wav | Celebration |
| plan_mode_enter | 0x40.wav | Cardboard box | mBENCH0.wav | Sitting down to think |

### JavaScript (Inline)

The site uses only two JS features, both inline at the bottom of `<body>`:

1. **Scroll reveal** -- IntersectionObserver adds `.visible` to `.reveal` elements as they enter the viewport. One-shot (unobserves after trigger).

2. **Code copy** -- Clipboard API writes the code block text, toggles `.copied` class for 1500ms visual feedback.

Total JS: under 50 lines. No frameworks, no libraries, no external scripts.

### Testing

No test framework. Manual testing checklist:

**Core:**
- [ ] Page loads without console errors
- [ ] All sections render correctly
- [ ] Copy buttons copy text to clipboard and show "Copied" feedback
- [ ] Scroll reveal animations trigger once per section
- [ ] All links work (GitHub, anchor scrolls)

**Design:**
- [ ] MGS and Sims cards have visibly different color temperatures side-by-side
- [ ] LED colors match context: white (neutral), amber (MGS), teal (Sims)
- [ ] No terminal green (`#00FF41`) appears outside MGS-themed areas
- [ ] Control Panel mockups clearly show dark vs light theme contrast
- [ ] Visual transition between MGS and Sims sections is deliberate and dramatic
- [ ] No `border-radius` except on LED circles

**Responsive (test at 1200px, 768px, 375px):**
- [ ] Collection cards stack to single column on mobile
- [ ] Hero headline scales down appropriately
- [ ] CTAs go full-width on mobile
- [ ] Code blocks scroll horizontally on small screens
- [ ] Touch targets are minimum 44px on mobile

**Accessibility:**
- [ ] Keyboard navigation works (Tab through all interactive elements)
- [ ] Focus rings visible on all interactive elements
- [ ] Skip-to-content link works
- [ ] Color contrast passes WCAG AA in neutral sections
- [ ] Color contrast passes WCAG AA in MGS section (amber/green on dark)
- [ ] Color contrast passes WCAG AA in Sims section (teal on cool dark)
- [ ] `prefers-reduced-motion` disables all animations
- [ ] Screen reader can navigate section hierarchy

**Performance:**
- [ ] Total page weight under 50KB (excluding font files)
- [ ] Lighthouse Performance score > 90
- [ ] Lighthouse Accessibility score > 95

### Browser Testing

Test in the latest versions of:
- Chrome / Edge (Chromium)
- Safari (macOS and iOS)
- Firefox

## Deployment

See [DEPLOY.md](DEPLOY.md) for the full deployment plan.

Quick version:
```bash
git add .
git commit -m "Update showcase site"
git push origin main
# GitHub Pages deploys automatically
```

## Content Updates

### Updating copy
Edit the text directly in the HTML file. All copy lives inline -- no CMS, no content files. Reference `showcase-copy.md` for the canonical copy.

### Updating Control Panel mockups
The Control Panel section uses CSS-only mini mockups (not screenshots). To update:
1. Edit the `.mini-card--mgs` and `.mini-card--sims` elements in the HTML
2. Update event names, sound filenames, and sound labels to match current config.json
3. Ensure the dark/light contrast is immediately obvious

### Updating event counts or stats
Search for the stats bar section and update the numeric values to match the current config.json event count.

## Related Documentation

- [PROJECT.md](PROJECT.md) -- Project goals and team structure
- [DEPLOY.md](DEPLOY.md) -- Hosting and deployment details
- [DESIGN-SPECS.md](DESIGN-SPECS.md) -- Complete design specifications
- [decisions.md](decisions.md) -- Decision log with rationale
- `CREATIVE-BRIEF.md` (repo root) -- Full creative direction
- `showcase-copy.md` (repo root) -- All page copy
- `showcase-site.html` (repo root) -- Working prototype
