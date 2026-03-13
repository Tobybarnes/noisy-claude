# Noisy Claude -- Showcase Website Creative Brief

## Project Overview

**Product**: Noisy Claude -- Sound notifications for Claude Code
**Deliverable**: A single-page showcase website that sells the experience of coding with game audio feedback
**Audience**: Developers who grew up on gaming and want their terminal to feel alive
**Goal**: Show two completely different sound experiences and let the visitor choose their vibe

---

## The Big Idea

**"Your terminal has a soundtrack now."**

Noisy Claude turns every Claude Code session into a game. Git commits trigger sounds. Test failures trigger different sounds. Context warnings escalate. The showcase site should make this *feel* inevitable -- like of course your terminal should have audio feedback.

The site does not sell a utility. It sells a vibe -- or rather, two vibes. The MGS collection turns your session into a stealth operation. The Sims collection turns it into a cheerful household. The site must celebrate both equally, letting each collection express its own character within a neutral frame.

---

## Creative Direction: "The Player" (Neutral Frame, Distinct Collections)

Think of the site like Spotify showcasing playlists, or a record player displaying album art. The player itself is neutral and clean. The albums it showcases are vivid and distinct.

### The Neutral Frame (the site itself)
The hero, navigation, control panel, event map, installation, and CTA sections all use a clean, modern developer-tool aesthetic. No collection-specific theming bleeds into these shared sections. The frame is confident, minimal, and professional.

**Key references:**
- Vercel homepage -- clean dark mode, code-first hero, sharp typography
- Linear landing page -- smooth scroll sections, understated confidence
- Raycast -- product screenshots floating in space, keyboard-first appeal
- The existing Noisy Claude control panel -- dark steel, green LEDs, IBM Plex Mono

### The MGS World (dark, tactical, tense)
When the visitor scrolls into the MGS section, the entire visual environment shifts. The background darkens. Amber light bleeds in. The typography tightens. The content reads like a mission briefing. This is a self-contained world within the page.

**Key references:**
- MGS codec call screen (dark green on black, frequency readout)
- MGS item pickup overlay (clean, centered, brief)
- PS1-era 8-bit aesthetic -- lo-fi, sharp, monochromatic
- Military briefing documents -- structured data, codenames, mission phases

### The Sims World (warm, playful, expressive)
When the visitor scrolls into the Sims section, the environment shifts again -- but in the opposite direction. The background warms up. Teal and soft colors appear. The tone loosens. The content feels like a mood board for a cheerful household. This section should feel like opening The Sims 2 for the first time.

**Key references:**
- Sims 2 UI chrome -- plumbob green, need bars, mood panels
- Sims 2 loading screens -- warm backgrounds, playful typography
- The Sims "build mode" catalog -- organized, colorful, inviting
- Simlish itself -- cheerful, expressive, slightly chaotic

---

## Color Palette

### Primary Palette (Neutral Frame)

| Role | Color | Hex | Usage |
|------|-------|-----|-------|
| Background | Neutral dark | `#1A1A1A` | Page background -- not pure black |
| Surface | Panel gray | `#222222` | Cards, panels, content blocks |
| Surface elevated | Light gray | `#2A2A2A` | Hover states, elevated panels |
| Code background | Near-black | `#141414` | Code blocks only |
| Border | Subtle white | `rgba(255,255,255,0.08)` | Panel edges, dividers |

### Accent System -- Neutral frame + distinct collection palettes

| Accent | Color | Hex | Context |
|--------|-------|-----|---------|
| System green | Terminal green | `#00FF41` | Neutral frame: LEDs, active states, CTAs, code blocks |
| MGS amber | Codec amber | `#FFB800` | MGS section only: headings, borders, stats, glow |
| Sims teal | Plumbob teal | `#00D4AA` | Sims section only: headings, borders, stats, glow |
| Danger red | Alert red | `#FF3333` | Shared: error states, context_90 warning |

### MGS Section Palette (goes DARKER than the frame)

The MGS section drops to pure black -- darker than the neutral frame. A tactical void.

| Role | Color | Hex | Usage |
|------|-------|-----|-------|
| MGS background | Pure black | `#0A0A0A` | Section background, deep void |
| MGS surface | Dark steel | `#111111` | Table rows in MGS section |
| MGS border | Amber edge | `rgba(255, 184, 0, 0.08)` | Table grid lines, dividers |
| MGS text | White | `#FFFFFF` | Headings, event names |
| MGS secondary | Dim white | `rgba(255, 255, 255, 0.6)` | Body text, descriptions |

### Sims Section Palette (goes LIGHTER than the frame)

The Sims section flips to light. White background, dark text. A completely different world.

| Role | Color | Hex | Usage |
|------|-------|-----|-------|
| Sims background | Warm white | `#F4F1EC` | Section background -- warm off-white |
| Sims surface | Pure white | `#FFFFFF` | Table rows, cards |
| Sims surface alt | Light warm | `#EAE6DF` | Table headers, hover states |
| Sims border | Light gray | `rgba(0, 0, 0, 0.10)` | Table grid lines, dividers |
| Sims text primary | Near-black | `#1A1A1A` | Headings, event names |
| Sims text secondary | Dark gray | `#4A4A4A` | Body text, descriptions |
| Sims text tertiary | Medium gray | `#7A7A7A` | Metadata, italic moods |
| Sims teal (on light) | Dark teal | `#009B7D` | Accent color -- darker than normal teal for contrast on white |

**Design principle**: The two collection sections go in opposite directions from the neutral frame. MGS goes darker (neutral #1A1A1A -> MGS #0A0A0A). Sims goes lighter (neutral #1A1A1A -> Sims #F4F1EC). The contrast between these worlds is dramatic and intentional -- as you scroll through the page, you physically experience the difference between the two collections.

### Glow Effects

Every accent color gets a corresponding glow for LED/indicator moments:
- Green glow: `0 0 12px rgba(0, 255, 65, 0.4)`
- Amber glow: `0 0 12px rgba(255, 184, 0, 0.4)`
- Teal glow: `0 0 12px rgba(0, 212, 170, 0.4)`
- Red glow: `0 0 12px rgba(255, 51, 51, 0.5)`

### Text Hierarchy

| Level | Color | Usage |
|-------|-------|-------|
| Primary | `#FFFFFF` | Headlines, key values |
| Secondary | `rgba(255,255,255,0.65)` | Body text, descriptions |
| Tertiary | `rgba(255,255,255,0.40)` | Labels, captions, metadata |
| Accent | `#00FF41` | Code snippets, commands, interactive elements |

---

## Typography

### Type System

| Role | Font | Weight | Size | Tracking | Case |
|------|------|--------|------|----------|------|
| Display (hero) | IBM Plex Mono | 700 | 56px / 3.5rem | +0.04em | Uppercase |
| Heading 1 | IBM Plex Mono | 700 | 36px / 2.25rem | +0.06em | Uppercase |
| Heading 2 | IBM Plex Mono | 700 | 24px / 1.5rem | +0.08em | Uppercase |
| Heading 3 | IBM Plex Mono | 500 | 18px / 1.125rem | +0.06em | Uppercase |
| Body | IBM Plex Mono | 400 | 16px / 1rem | normal | Sentence |
| Small / Label | IBM Plex Mono | 500 | 12px / 0.75rem | +0.08em | Uppercase |
| Micro / Badge | IBM Plex Mono | 500 | 10px / 0.625rem | +0.1em | Uppercase |
| Code | IBM Plex Mono | 400 | 14px / 0.875rem | normal | As-is |

### Type Rules
- **One font, many weights.** IBM Plex Mono only. No secondary font. Monospace is the entire personality.
- **Uppercase for all headings and labels.** This is studio equipment. Rack labels are always uppercase.
- **Generous line height for body text.** 1.6 for readability on dark backgrounds.
- **Tabular numerals everywhere.** Stats, counters, and spec values use `font-variant-numeric: tabular-nums` so numbers align in grids.

---

## Key Messaging Pillars

### Pillar 1: "Your Terminal Has a Soundtrack"
The headline promise. Coding is silent by default. Noisy Claude changes that. Every event becomes a moment. Every session has an arc.

**Supporting messages:**
- "40+ events. 2 built-in collections. Your session, your soundtrack."
- "Because the best notification is the one you don't have to look at."
- "Because coding in silence was always the real bug."

### Pillar 2: "Two Collections. Two Worlds."
MGS and Sims are separate inputs, not variations of the same theme. MGS is a stealth operation. Sims is a cheerful household. They share the same event system but create completely different emotional experiences. The site must present them as equal, distinct choices -- not a primary and a secondary.

**Supporting messages:**
- MGS: "Every session is a stealth mission. The codec rings when you start. Flow state is sneaking through Shadow Moses."
- Sims: "Your codebase is a household. Commits are promotions. Test failures get the grumpy Simlish treatment."
- "Switch collections to match your mood. Tactical Tuesday. Simlish Friday."
- "Same events. Different worlds."

### Pillar 3: "Professional-Grade Control"
This is not a toy. The control panel is a proper instrument with 40+ events, per-event sound selection, AI-powered mapping, focus modes, and a REST API. The dark steel aesthetic is not decoration -- it signals serious craft.

**Supporting messages:**
- "A control panel that looks like it belongs in a recording studio."
- "AI-powered sound mapping. Drop a folder. Get instant assignments."
- "Smart mode, focus detection, CLI control. Built for how you actually work."

### Pillar 4: "Built for Claude Code"
First-class Claude Code integration. Hooks into the lifecycle. Works with agents, teams, skills. Not a generic notification system bolted on -- this is purpose-built for the Claude Code workflow.

**Supporting messages:**
- "Hooks into every Claude Code lifecycle event."
- "From session_start to context_90. Every moment accounted for."
- "Works with agents, teams, and skills out of the box."

---

## Site Structure

A single-page scroll. The neutral frame holds the product story. The collection sections are immersive worlds that break from the frame to express their own character.

### Section 1: HERO (Neutral Frame)
- Full-viewport, clean dark background
- "YOUR CODE HAS A SOUNDTRACK NOW" in display type
- Tagline mentioning both collections equally
- Green LED pulse -- the universal "Noisy Claude is on" signal
- Two CTAs: "Get Noisy Claude" (primary green) and "See the collections" (ghost)

### Section 2: THE GAP (Neutral Frame)
- Problem statement: "You're not watching your terminal"
- Clean, minimal, body-text-driven section

### Section 3: COLLECTIONS OVERVIEW (Neutral Frame)
- "Two iconic sound packs. Ready on install."
- Side-by-side cards -- equal size, equal weight
- **MGS Card**: Amber accent border, amber stats, dark tone
- **Sims Card**: Teal accent border, teal stats, warmer tone
- Both cards are entry points that tease their respective deep-dive sections

### Section 4: MGS DEEP DIVE (MGS World)
- Background shifts to amber-tinted darkness
- Full mission arc narrative table
- The context_90 alert row highlighted in red
- Closing with sound design philosophy
- Visually contained -- clearly "you have entered the MGS zone"

### Section 5: SIMS DEEP DIVE (Sims World)
- Background shifts to warm teal-tinted environment
- **Equal depth to MGS** -- not a brief afterthought
- Sims-specific event mapping table showing Simlish sounds
- Mood-based narrative: how different events map to Sims emotions
- Event -> sound name examples (fCELEB0.wav, fOOPS0.wav, mGREETING.wav)
- Closing with the "household" metaphor
- Visually contained -- clearly "you have entered the Sims zone"

### Section 6: CONTROL PANEL (Adaptive Themes)
- "The UI adapts to your collection" -- the key revelation
- **Side-by-side mockups** showing both themes simultaneously:
  - Left: MGS theme (deep black `#0A0A0A`, amber buttons, green LEDs, codec filenames)
  - Right: Sims theme (warm white `#F4F1EC`, teal buttons, teal LEDs, Simlish filenames)
- Each mockup shows the same events with their collection-specific sounds
- Labeled "MGS Collection Active" and "Sims 2 Collection Active"
- Feature bullets for control panel capabilities
- The actual `control-panel.html` implements theme switching via CSS custom properties and `body.theme-mgs` / `body.theme-sims` classes

### Section 7: FEATURES ROW (Neutral Frame)
- Claude Suggests, Adaptive Themes, Bring Your Own Sounds
- Three equal feature cards, no collection-specific theming

### Section 8: EVENT MAP (Neutral Frame)
- 10 category modules in a grid
- Stats bar with totals
- Pure information design, no collection flavor

### Section 9: INSTALLATION (Neutral Frame)
- Three steps, code blocks, architecture diagram
- Clean and functional

### Section 10: CTA (Neutral Frame)
- "Your terminal is too quiet"
- Install command with copy button
- GitHub link

### Section 11: FOOTER
- Minimal credits, MIT license, year

---

## Interaction Design

### Micro-interactions
- **LED pulse**: The green LED in the hero pulses on a 3-second loop. It is the heartbeat of the page.
- **Hover states**: Cards and buttons get a subtle 1px accent border glow on hover. No dramatic transforms.
- **Code blocks**: Green text on near-black. Cursor blink animation optional.
- **Collection cards**: Subtle parallax or elevation shift on hover. The card you are looking at should feel "selected."
- **Scroll reveal**: Sections fade in gently as they enter the viewport. No bounce, no slide. Just opacity 0->1 over 400ms.

### What NOT to do
- No sound on the website itself. The irony is intentional. Let them imagine the sounds.
- No heavy animations. The aesthetic is "precision instrument" not "gaming montage."
- No emoji in headings or body copy. Emojis are for the README, not the showcase.
- No light mode toggle. The neutral frame stays dark. Collection sections can warm up but never go fully light.
- No parallax scrolling backgrounds. Keep the scroll physics native.
- No hamburger menu. It is a single page. Let them scroll.

---

## Visual Motifs

### The LED
A small, glowing green circle. Appears in the hero, next to section headings, and as toggle indicators. It is the universal "Noisy Claude is on" signal. The LED should have:
- Solid `#00FF41` fill
- Soft glow shadow: `0 0 8px rgba(0, 255, 65, 0.5)`
- Optional steel bezel ring: 2px `#4A4A4A` outline with 1px gap

### The Grid
A subtle 4px dot grid or line grid at 2-3% opacity in the background. References: PCB traces, recording studio acoustic panels, graph paper from hardware schematics. The grid should be barely visible -- a texture, not a pattern.

### The Border
Panels and cards use a single 1px border in `rgba(255,255,255,0.08)`. No border-radius. No shadows. Sharp corners everywhere. This is rack-mounted equipment. Rounded corners are for consumer products.

### The Accent Line
Section dividers and emphasis use a 2-4px left border in the accent color. Like the selection indicator on a channel strip. Used sparingly -- the green line means "pay attention here."

---

## Content Tone

### Voice
- **Confident, not boastful.** State what it does. Do not oversell.
- **Dry wit, not comedy.** "Because coding in silence was always the real bug" -- one joke per section maximum.
- **Technical, not jargony.** Speak developer. CLI commands are copy. API endpoints are features. JSON is documentation.
- **Referential, not fan-service.** One Shadow Moses reference is evocative. One "Sul sul" is charming. Five of either is cosplay. Each collection section gets its own voice but keeps it contained.

### Copy Rules
- Short paragraphs. 2-3 sentences maximum.
- Headlines are 3-7 words. All uppercase.
- Body copy is sentence case. Professional register.
- Code examples use actual Noisy Claude commands and config.
- Never use "powerful", "robust", "seamless", or "cutting-edge."
- Never use exclamation marks in headlines.
- Use em-dashes for asides. Not parentheses.

---

## Responsive Considerations

- **Desktop (1200px+)**: Full two-column layouts for collection cards. Wide event grid. Maximum whitespace.
- **Tablet (768-1199px)**: Single column. Collection cards stack. Event grid condenses to 2 columns.
- **Mobile (below 768px)**: Full single column. Code blocks scroll horizontally. Hero text sizes down to 2rem. Touch targets minimum 44px.
- The site should feel excellent at every breakpoint but be designed desktop-first. The primary audience is developers at their workstations.

---

## Deliverable Specifications

- **Format**: Single HTML file with inline CSS and minimal JS (no build step, matching Noisy Claude's own architecture)
- **Fonts**: Google Fonts link for IBM Plex Mono (400, 500, 700)
- **Images**: None required. All visual elements are CSS-generated (LEDs, borders, grids, gradients)
- **JS**: Scroll reveal animations, code copy button, smooth scroll anchors. No framework.
- **Performance**: Should load instantly. Target < 50KB total page weight excluding font files.
- **Accessibility**: WCAG AA minimum. High contrast ratios on dark background. Keyboard navigation. Semantic HTML.

---

## Summary

The Noisy Claude showcase site is a neutral, confident frame that hosts two vivid collection worlds. The base site looks like a modern developer tool (Vercel, Linear). The MGS section plunges into dark amber tactical tension. The Sims section opens into warm teal playfulness. The contrast between these worlds is the site's signature moment -- the visitor sees that Noisy Claude is not one vibe but a choice between completely different experiences.

The design uses sharp corners, green LEDs, and IBM Plex Mono for the neutral frame. Collection sections break from the frame with their own color environments. The copy is confident, dry, and developer-native. No gimmicks. No sound on the page. Just a beautifully presented argument that your terminal should not be silent -- and that you should get to choose what it sounds like.

The visitor should leave thinking: "I need this running in five minutes."
