# Noisy Claude Showcase Site -- Project Brief

## What This Is

A standalone single-page showcase website for Noisy Claude -- a sound notification system for Claude Code. Code name: "The Player." The showcase site lives separately from the main Noisy Claude repo and serves as the public face of the project.

## Goals

1. **Sell the experience** -- Make developers want to install Noisy Claude within 10 seconds of landing on the page
2. **Demo the contrast** -- Show two completely different sound experiences (MGS and Sims 2) and let the visitor choose their vibe
3. **Drive installation** -- Clear, frictionless path from "cool" to "installed and running"
4. **Establish brand** -- Position Noisy Claude as a neutral instrument that plays two very different records

## Target Audience

- **Primary**: Claude Code users who want richer feedback from their coding sessions
- **Secondary**: Developer tooling enthusiasts, retro gaming fans, people who like tasteful UI
- **Tertiary**: Anyone curious about AI-assisted development workflows

## What Noisy Claude Actually Does

Noisy Claude hooks into Claude Code's event system (PreToolUse, PostToolUse, Stop) and plays sound effects for 40+ events: git commits, test results, context warnings, streaks, and more. It ships with two collections:

- **MGS Collection** (124 sounds) -- Tactical Espionage Audio. Coding sessions become stealth missions. Codec rings, radar blips, the "!" alert at 90% context.
- **Sims 2 Collection** (140+ sounds) -- Simlish exclamations for every coding occasion. Warm, cheerful, chaotic.

Key product features:
- **Adaptive Control Panel** (localhost:5050) -- UI theme switches based on active collection (dark/tactical for MGS, light/playful for Sims)
- **Master Power Switch** -- One-click mute all sounds (Cmd+Shift+M), preserves event settings
- **Sound Description Labels** -- `sound_label` field on all 76 events so users know what they'll hear before pressing play
- **Claude Suggests** -- AI-powered sound-to-event mapping
- **Focus Modes** -- Smart mode only plays sounds when terminal isn't focused

## Design Direction: "The Player"

The site uses a **neutral-framework** approach. Think Spotify showcasing playlists -- the player itself is neutral, the playlists have their own worlds.

**Three visual layers:**

| Layer | Aesthetic | Sections |
|-------|-----------|----------|
| **Neutral frame** | Clean dark developer tool. White accents. No collection color. | Hero, How It Works, Event Map, CTA, Footer |
| **MGS world** | Dark, tactical, amber/green. Codec screen vibes. | MGS card, MGS deep-dive |
| **Sims world** | Lighter, warmer, teal. Plumbob colors, cheerful energy. | Sims card, Sims feature section |

**Critical rule**: Terminal green (`#00FF41`) is NOT a framework color. It belongs exclusively to the MGS aesthetic. The neutral framework uses white (`#FFFFFF`).

**No sound on the website itself.** The irony is intentional. Let visitors imagine the sounds.

Full creative direction: `CREATIVE-BRIEF.md`
Full design specs: `showcase/DESIGN-SPECS.md`

## Site Structure (Delivered)

1. **Hero** (Neutral) -- "YOUR CODE HAS A SOUNDTRACK NOW" + white pulsing LED + dual CTA
2. **The Gap** (Neutral) -- Problem statement: "You're not watching your terminal"
3. **Collections Overview** (Neutral frame, themed cards) -- Side-by-side MGS and Sims cards with dramatic contrast
4. **MGS Deep Dive** (MGS world) -- Mission arc narrative, amber environment
5. **Sims Deep Dive** (Sims world) -- Equal depth to MGS, warm teal environment
6. **Control Panel** (Neutral, showcasing both themes) -- Side-by-side dark/light mockups showing adaptive UI
7. **Features Row** (Neutral) -- Claude Suggests, Adaptive Themes, Bring Your Own Sounds
8. **Event Map** (Neutral) -- 10 category modules, all-white LEDs
9. **Installation** (Neutral) -- Three steps, architecture diagram
10. **CTA** (Neutral) -- "Your terminal is too quiet" + install command
11. **Footer** -- Minimal credits

## Technical Specs

- **Format**: Single HTML file with inline CSS and minimal JS (no build step)
- **Font**: IBM Plex Mono only (400, 500, 700) via Google Fonts
- **Images**: None. All visual elements are CSS-generated (LEDs, borders, grids)
- **JS**: IntersectionObserver for scroll reveal + copy handler. Under 50 lines.
- **Performance**: Target < 50KB total page weight (excluding fonts)
- **Accessibility**: WCAG 2.1 AA. High contrast verified across all theme contexts. Skip-to-content link. Reduced motion support.

## Source Material

| File | What it contains |
|------|-----------------|
| `CREATIVE-BRIEF.md` | Full creative direction, messaging pillars, visual motifs |
| `showcase/DESIGN-SPECS.md` | Complete design tokens, component library, section specs, responsive breakpoints |
| `showcase-copy.md` | All page copy, 11 sections, tone guide |
| `showcase-site.html` | Working prototype (production-quality) |
| `control-panel.html` | The actual Control Panel -- adaptive theming via `body.theme-mgs` / `body.theme-sims` |
| `config.json` | Event definitions with `sound_label` descriptions, `master_enabled` field |
| `README.md` | Feature list, architecture, usage |
| `COLLECTIONS.md` | Collections system documentation |
| `sounds/MGS/` | 124 MGS sound files |
| `sounds/Sims2/` | 140+ Sims 2 sound files |

## Success Criteria

- Both collections feel distinct and appealing at a glance -- the contrast sells the product
- Installation path is clear and takes under 2 minutes to follow
- Site loads instantly (< 50KB excluding fonts)
- Works in Chrome, Safari, Firefox (latest versions)
- WCAG 2.1 AA compliance across all theme contexts
- Visitor leaves thinking: "I need this running in five minutes"

## Team

| Role | Task | Status |
|------|------|--------|
| Creative Director | #1 -- Vision and design direction | Complete |
| Writer | #2 -- Copy and messaging | Complete |
| Designer | #3 -- UI mockups (revised for neutral framework) | Complete |
| Developer | #4 -- Build the site | Complete (prototype is production-quality) |
| QA | #5 -- Testing and bug fixes | Pending |
| Operations | #6 -- Documentation and deployment | Complete |

## Product Features Delivered During Project

| Feature | Task | Files Changed |
|---------|------|---------------|
| Control Panel adaptive theming | #11 | `control-panel.html` (CSS themes via `body.theme-mgs` / `body.theme-sims`) |
| Sound description labels | #12 | `config.json` (`sound_label` on 76 events), `control-panel.html` |
| Master power switch | #13/#14 | `config.json` (`master_enabled`), `noisy-claude.sh` (`--mute`/`--unmute`), `control-panel.html` |
