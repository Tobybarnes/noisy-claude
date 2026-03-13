# Decision Log -- Noisy Claude Showcase Site

Records key decisions made during the project, their rationale, and alternatives considered.

---

## DEC-001: Showcase site is a separate project from the main Noisy Claude repo

**Date**: 2026-02-13
**Status**: Decided
**Decider**: Team Lead

**Context**: Noisy Claude is a developer tool (bash scripts, Python server, config files). The showcase site is a marketing/demo page. They serve different purposes and audiences.

**Decision**: The showcase site will be developed in a `/showcase` working directory but deployed as its own repository and GitHub Pages site, separate from the main Noisy Claude tool repo.

**Rationale**:
- Different release cadences (tool vs. marketing site)
- Different deployment targets (local install vs. web hosting)
- Cleaner separation of concerns
- Showcase site has its own team workflow (creative -> copy -> design -> build -> QA)

**Alternatives considered**:
- Single repo with `/docs` folder for GitHub Pages: simpler but mixes concerns
- Subdomain of a custom domain: adds cost and DNS complexity

---

## DEC-002: Static HTML/CSS/JS with no build step

**Date**: 2026-02-13
**Status**: Decided
**Decider**: Operations

**Context**: The showcase site needs to demo Noisy Claude with interactive sound playback. Options range from a simple HTML page to a full framework (React, Astro, Next.js).

**Decision**: Plain HTML, CSS, and JavaScript. No framework. No build step.

**Rationale**:
- Matches Noisy Claude's own architecture (control-panel.html is vanilla JS)
- Fastest path to deployment
- Zero dependency management
- GitHub Pages deploys without build configuration
- The site is a single page -- a framework would be over-engineering

**Alternatives considered**:
- Astro: Good for static sites but adds build complexity
- Next.js: Overkill for a single marketing page
- Svelte: Nice DX but unnecessary for this scope

---

## DEC-003: GitHub Pages as hosting platform

**Date**: 2026-02-13
**Status**: Decided
**Decider**: Operations

**Context**: Need free, reliable hosting for a static showcase site.

**Decision**: GitHub Pages as primary hosting. Vercel as fallback if requirements change.

**Rationale**:
- Free, no usage limits that matter for this project
- No build configuration needed for static files
- Automatic HTTPS
- Same platform as the source code
- Simplest option for a no-build-step static site

**Alternatives considered**:
- Vercel: Better if we add a framework later. Preview deploys are nice but not essential.
- Netlify: Good feature set but adds another platform to manage.
- Self-hosted: Unnecessary complexity.

See DEPLOY.md for the full comparison matrix.

---

## DEC-004: Curated audio subset for web demos

**Date**: 2026-02-13
**Status**: Decided
**Decider**: Operations

**Context**: The full MGS collection has 124 sounds, Sims 2 has 140+. Loading all of these for a web demo would be slow and wasteful.

**Decision**: Curate 8-12 iconic sounds per collection, convert to MP3 for web, keep total audio budget under 2MB.

**Rationale**:
- Page performance (target: LCP < 2.5s)
- Mobile data consciousness
- Only need enough sounds to sell the experience
- Full collection available after install

**Alternatives considered**:
- Stream all sounds on demand: Complex, requires more infrastructure
- Embed sounds as base64: Bloats HTML, defeats caching
- Use a CDN for full collection: Over-engineering for a demo page

---

## DEC-005: Team structure with sequential dependency chain

**Date**: 2026-02-13
**Status**: Decided
**Decider**: Team Lead

**Context**: Building the showcase site requires creative direction, copywriting, design, development, and QA.

**Decision**: Sequential pipeline: Creative Vision (#1) -> Copy (#2) + Design (#3, blocked by #1) -> Build (#4, blocked by #2 and #3) -> QA (#5, blocked by #4). Operations (#6) runs in parallel.

**Rationale**:
- Design cannot start without creative direction
- Development needs both copy and design as inputs
- QA can only test what has been built
- Operations (documentation, deployment planning) can proceed independently

**Alternatives considered**:
- Fully parallel with more iteration: Faster start but higher rework risk
- Waterfall with sign-offs: Too formal for this project scope

---

## DEC-006: Copy tone -- confident, direct, gaming-literate

**Date**: 2026-02-13
**Status**: Decided
**Decider**: Writer (Task #2)

**Context**: The showcase site needs a voice that appeals to developers and gamers simultaneously without alienating either.

**Decision**: Confident and direct tone. Short sentences, fragments OK. Specific numbers over adjectives. Lean hard into MGS for the tactical section, lighter and warmer for Sims. No corporate hedging. No exclamation marks.

**Rationale**:
- Target audience (Claude Code users) are technically sophisticated -- they trust specifics
- Gaming references need to feel earned, not forced
- "Vercel meets gaming culture" as a north star for tone
- The copy should feel like it was written by someone who actually uses the tool

**Key deliverable**: `showcase-copy.md` -- full copy for all 11 sections of the page

---

## DEC-007: Page structure -- 11-section single page

**Date**: 2026-02-13
**Status**: Decided
**Decider**: Writer (Task #2), aligned with Creative Director (Task #1)

**Context**: How should the showcase site be organized?

**Decision**: Single-page site with 11 sections in this order: Hero, Problem, Two Collections, MGS Deep Dive, Sims Section, Control Panel, Claude Suggests + Focus Modes, Bring Your Own Sounds, Installation, Final CTA, Footer.

**Rationale**:
- Single page keeps visitors in a narrative flow (no navigation friction)
- Structure follows classic marketing funnel: hook -> problem -> solution -> proof -> action
- MGS gets the deepest section because it has the strongest narrative (mission arc)
- Installation comes late -- sell the experience before asking for commitment

---

## DEC-008: Neutral-framework site design (direction change)

**Date**: 2026-02-13
**Status**: Decided (supersedes aspects of earlier creative direction)
**Decider**: User / Team Lead

**Context**: The initial creative direction committed the entire site to a dark, MGS-inspired tactical aesthetic. However, the Sims 2 collection has a completely different personality -- light, playful, Simlish. The Control Panel itself is neutral to collections. A site themed entirely to one collection misrepresents the product.

**Decision**: The site uses a neutral-framework approach. The base site (hero, nav, install, footer) is clean and collection-agnostic. Each collection showcase section gets its own distinct visual treatment:
- MGS section: Dark, tactical, amber/green palette
- Sims 2 section: Light, playful, teal/plumbob colors

Think Spotify showcasing different playlists -- the player is neutral, but each playlist has its own visual world.

**Rationale**:
- Noisy Claude is a platform for collections, not an MGS-branded tool
- The contrast between collections IS the value proposition
- A neutral frame lets both collections express their unique character
- Users who prefer Sims 2 shouldn't feel like the site is selling them something else
- Mirrors the actual product experience: the Control Panel is neutral, collections bring the personality

**Alternatives considered**:
- Full dark/MGS theme (previous direction): Visually striking but alienates half the product
- Full light/Sims theme: Same problem in reverse
- Two completely separate pages: Too much work, fragments the narrative

**Impact on existing docs**:
- PROJECT.md: Design Direction section updated
- DEVELOPMENT.md: Design System Reference updated with neutral + per-collection token tables
- Copy (showcase-copy.md): Already has per-collection tone shifts built in -- no changes needed

---

## DEC-009: Control Panel UI adapts theme to active collection

**Date**: 2026-02-13
**Status**: Decided
**Decider**: User / Team Lead

**Context**: With DEC-008 establishing that the showcase site uses a neutral framework with per-collection visual treatments, the user raised the logical next step: the Control Panel itself (the actual product, not just the showcase site) should also adapt its UI to match the active collection. Currently the Control Panel has one fixed dark-steel theme.

**Decision**: The Control Panel (`control-panel.html`) will support collection-specific themes that switch automatically when the user changes the active collection:
- **MGS active**: Dark UI, green LEDs, tactical aesthetic (current default)
- **Sims active**: Light/white UI, dayglow colors, playful Sims-like interface
- **Default/other**: Current dark theme as fallback

**Implementation approach**: The existing CSS uses custom properties (`:root` variables) extensively. Add a second theme via `[data-theme="sims"]` selector overriding the same variables. Toggle `data-theme` attribute on `<html>` inside the existing `switchCollection()` function (line 1689 of control-panel.html).

**Rationale**:
- Strengthens the product's value proposition: "the entire experience adapts, not just the sounds"
- Natural extension of the neutral-framework philosophy
- Technically clean -- CSS custom properties make this a variable swap, not a rewrite
- The showcase site can now show both UI themes side-by-side as proof of the feature

**Alternatives considered**:
- Keep one theme: Simpler but misses the opportunity to delight users
- Per-collection CSS files: Unnecessary complexity -- custom property overrides are sufficient
- User-selectable theme independent of collection: Adds UI complexity for low value

**Scope note**: This is a product change to `control-panel.html`, not just a showcase site change. It should be built and tested before the showcase site reflects it in screenshots.

**Impact on existing work**:
- Showcase site should show both Control Panel themes side-by-side
- showcase-copy.md may want a line about the UI adapting ("even the Control Panel changes")
- DEVELOPMENT.md updated with implementation guidance

---

## DEC-010: Add sound description labels to the Control Panel

**Date**: 2026-02-13
**Status**: Decided (field name corrected in DEC-013: use `sound_label`, not `sound_description`)
**Decider**: User / Team Lead

**Context**: The Control Panel event cards currently show the event description ("When a git commit succeeds") and the sound filename ("0x67.wav"). Filenames like "0x67.wav" tell the user nothing about what the sound actually is. Users must click play to learn that it's an "Item pickup chime."

**Decision**: Add a `sound_description` field to each event entry in config.json. Display it in the Control Panel UI beneath the sound filename dropdown. Each collection provides its own descriptions since the same event maps to different sounds per collection.

**Implementation approach**:

Config structure change -- add `sound_description` per event, per collection:
```json
{
  "events": {
    "session_start": {
      "description": "When Claude Code session starts",
      "enabled": true,
      "sound": "0x1a.wav",
      "sound_description": "Codec ring"
    }
  }
}
```

UI change -- in `createEventCard()` (line 1228 of control-panel.html), add a `<span>` beneath the sound select dropdown showing the description. The existing `.event-description` (line 1250) shows the event description; the new label shows what the sound IS.

**Why `sound_description` per event, not a separate sound metadata map:**
- Simpler: follows the existing flat event structure
- A sound might serve different "roles" in different event contexts
- No need to create and maintain a separate sound database
- When the user changes the sound dropdown, the description should update (may require a lookup or manual update)

**Trade-off**: When users swap a sound, the description becomes stale unless they also update it. Acceptable for v1 -- descriptions are primarily useful for the curated defaults.

**Alternatives considered**:
- Separate `sound_metadata` object keyed by filename: More normalized but adds complexity and a second data structure to maintain
- Tooltip on hover only: Discoverable but not visible at a glance
- No descriptions, just better filenames: Not feasible for MGS hex-coded filenames

**Scope**: Product change to `config.json` and `control-panel.html`. Both MGS and Sims 2 collections need descriptions populated.

---

## DEC-011: Master power switch for instant silence

**Date**: 2026-02-13
**Status**: Implemented (see also DEC-015 for CLI details)
**Decider**: User / Team Lead

**Context**: Users on a sudden call or in a meeting need to silence Noisy Claude instantly without disabling individual event settings.

**Decision**: Master power switch -- a single toggle that silences all sounds while preserving individual event configuration.

**Implementation (as built):**

1. **config.json** -- `"master_enabled": true` at top level.

2. **noisy-claude.sh** -- Master check at lines 139-146, runs before focus mode check. Early exit if `master_enabled` is `false`. CLI commands: `--mute` / `--unmute`. `--status` shows master power state.

3. **control-panel.html** -- Skeuomorphic 72x36px rocker switch with sliding paddle and embossed ON/OFF labels. Own rack-unit strip between title header and controls nav. Features:
   - Power indicator LED (red default, teal for Sims, amber for MGS)
   - "MASTER POWER" label with "Cmd+Shift+M" keyboard hint
   - Status readout: "Active" / "Standby"
   - Powered-off treatment via `body.powered-off` class:
     - Events grid: 25% opacity, desaturated, pointer-events disabled
     - Header controls: 35% opacity, disabled
     - Search: 35% opacity, disabled
     - Collections: 50% opacity
     - Power switch stays fully interactive
   - Theme-aware: housing color, paddle gradient, LED color, border accents all adapt per collection theme

4. **control-panel-server.py** -- No changes needed. Existing `POST /api/config` handles it.

**Rationale**:
- Solves a real, urgent user scenario (sudden calls)
- One click/shortcut to silence, one click to restore
- Preserves all event configuration -- no tedious re-enabling
- Fits the hardware rack aesthetic (power switches are standard on audio equipment)

**Relationship to focus_mode**: Independent. Focus mode controls *when* sounds play (smart vs always). Master switch controls *whether* sounds play at all.

---

## DEC-012: Final design system -- "The Player" (neutral white framework)

**Date**: 2026-02-13
**Status**: Decided (supersedes DEC-008 specifics)
**Decider**: Creative Director + Designer

**Context**: The creative brief and design specs were finalized, codifying the exact tokens and visual approach for the showcase site.

**Key decisions finalized in CREATIVE-BRIEF.md and DESIGN-SPECS.md:**

1. **Concept name**: "The Player" (previously unnamed / informally "Dark Ops Studio")
2. **Framework accent is white (`#FFFFFF`), not green**: Terminal green (`#00FF41`) belongs exclusively to the MGS aesthetic. The neutral framework uses white for LEDs, buttons, accents, focus states.
3. **Page background**: `#0A0A0A` (not `#1A1A1A` as earlier assumed). The three backgrounds go: page `#0A0A0A` -> surface `#141414` -> elevated `#1A1A1A`.
4. **MGS primary accent**: `#FFB800` (amber), not green. Green only for code/event text within MGS sections.
5. **Sims primary accent**: `#00D4AA` (plumbob teal). On the showcase site, Sims sections use a cool-dark background (`#0F1413`), not light. The Sims LIGHT theme only appears in the Control Panel itself.
6. **No images**: All visual elements are CSS-generated. Zero image files.
7. **No sound on the website**: Deliberate choice. Let visitors imagine the sounds.
8. **No `border-radius`**: Sharp corners everywhere except LED circles.
9. **IBM Plex Mono only**: One font, no secondary. All headings uppercase.
10. **Performance target**: Under 50KB total (excluding fonts).
11. **Control Panel section**: CSS-only mini mockups showing both themes side-by-side, not screenshots.
12. **11-section single page**: Hero, The Gap, Collections Overview, MGS Deep Dive, Sims Deep Dive, Control Panel, Features Row, Event Map, Installation, CTA, Footer.

**Deliverables**: `CREATIVE-BRIEF.md` (339 lines), `showcase/DESIGN-SPECS.md` (2318 lines), `showcase-site.html` (working prototype).

---

## DEC-013: Sound labels use `sound_label` field name (not `sound_description`)

**Date**: 2026-02-13
**Status**: Decided (corrects DEC-010)
**Decider**: Developer (implementation)

**Context**: DEC-010 proposed `sound_description` as the field name. The actual implementation used `sound_label` across all 76 events in config.json.

**Decision**: The canonical field name is `sound_label`, not `sound_description`.

---

## DEC-014: Control Panel theming via body classes (not data-theme attribute)

**Date**: 2026-02-13
**Status**: Decided (corrects DEC-009)
**Decider**: Developer (implementation)

**Context**: DEC-009 proposed theming via `[data-theme="sims"]` on the `<html>` element. The actual implementation uses `body.theme-mgs` and `body.theme-sims` CSS classes.

**Decision**: The canonical theming mechanism is CSS classes on `<body>`, not `data-theme` attributes.

---

## DEC-015: Master power switch implements --mute/--unmute CLI commands

**Date**: 2026-02-13
**Status**: Decided (extends DEC-011)
**Decider**: Developer (implementation)

**Context**: DEC-011 documented the master switch with a config field and UI toggle. The implementation also added `--mute` and `--unmute` CLI commands to `noisy-claude.sh`, plus the `--status` command now shows master power state.

**Decision**: Master power is controllable via three interfaces:
1. `config.json` field: `master_enabled` (boolean)
2. CLI: `noisy-claude.sh --mute` / `noisy-claude.sh --unmute`
3. Control Panel UI: Power switch + Cmd+Shift+M keyboard shortcut

---

## DEC-016: Delete CONTROL-PANEL-THEMES.md (stale, superseded)

**Date**: 2026-02-13
**Status**: Decided
**Decider**: Operations, on recommendation from Creative Director

**Context**: `showcase/CONTROL-PANEL-THEMES.md` was an early pre-implementation spec for collection-adaptive theming. It documented a `data-theme` attribute approach on `<html>` (line 15) with `document.documentElement.setAttribute('data-theme', ...)` (line 22). The actual implementation uses `body.theme-mgs` / `body.theme-sims` CSS classes (see DEC-014). The file also used `sound_description` instead of the correct `sound_label` field name (see DEC-013).

**Decision**: Delete the file entirely. All accurate theming, sound label, and master power switch documentation now lives in:
- `showcase/DEVELOPMENT.md` -- implementation details with correct mechanisms
- `showcase/DESIGN-SPECS.md` -- complete design tokens and component specs
- `CREATIVE-BRIEF.md` -- creative rationale and visual direction

**Rationale**:
- Every code example in the file used the wrong theming mechanism (`data-theme` vs body classes)
- Sound label section used the wrong field name (`sound_description` vs `sound_label`)
- Keeping it risked confusing anyone implementing from the wrong spec
- A deprecation header was considered but deletion is cleaner -- no partial-truth documents

**Alternatives considered**:
- Add a deprecation notice pointing to DEVELOPMENT.md: Adds clutter, document has no remaining unique value
- Keep as historical reference: Git history preserves it if needed

---

*Add new decisions below as they arise during the project.*
