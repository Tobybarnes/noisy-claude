# Noisy Claude Showcase Site -- Design Specifications

**Version**: 2.0
**Date**: 2026-02-13
**Status**: Ready for development (revised)
**Input**: CREATIVE-BRIEF.md, showcase-copy.md, control-panel.html design tokens

**Revision note (v2):** The site framework is now **collection-neutral**. The base aesthetic is a clean, modern developer-tool dark theme -- like the control panel itself. Each collection section gets its own distinct visual treatment. The site does not favor MGS or Sims; it celebrates the contrast between them.

This document contains every detail a developer needs to build the showcase site without asking questions. All values are exact.

---

## Table of Contents

1. [Design Philosophy](#0-design-philosophy)
2. [Design Tokens](#1-design-tokens)
3. [Global Styles](#2-global-styles)
4. [Component Library](#3-component-library)
5. [Section-by-Section Specs](#4-section-by-section-specs)
6. [Interaction States](#5-interaction-states)
7. [Animations](#6-animations)
8. [Responsive Breakpoints](#7-responsive-breakpoints)
9. [Accessibility](#8-accessibility)
10. [Performance Budget](#9-performance-budget)

---

## 0. Design Philosophy

### The Spotify Model

Think of the showcase site like Spotify showcasing different playlists. The player is neutral -- dark, clean, functional. But each playlist (collection) has its own mood, color, and character.

**Three layers of visual identity:**

| Layer | Aesthetic | Where |
|-------|-----------|-------|
| **Framework** (neutral) | Clean dark developer tool. Matches the control panel. White/gray accents. No collection-specific color. | Hero, How It Works, Event Map, CTA, Footer |
| **MGS Collection** | Dark, tactical, military-industrial. Amber/green codec screen vibes. Dense, technical, serious. | MGS card, MGS deep-dive section |
| **Sims Collection** | Lighter, warmer, playful. Teal/plumbob colors. More whitespace, softer edges within the card. Cheerful energy. | Sims card, Sims feature section |

### Key Principle

The site should feel like a **neutral instrument** that plays two very different records. A visitor should be able to imagine ANY collection working in Noisy Claude, not just these two.

---

## 1. Design Tokens

### 1.1 Color Palette

```css
:root {
  /* === FRAMEWORK COLORS (neutral, collection-agnostic) === */

  /* Backgrounds */
  --bg-page:           #0A0A0A;
  --bg-surface:        #141414;
  --bg-elevated:       #1A1A1A;
  --bg-inset:          #0D0D0D;  /* Code blocks, deepest recesses */

  /* Borders */
  --border-default:    rgba(255, 255, 255, 0.08);
  --border-hover:      rgba(255, 255, 255, 0.15);
  --border-active:     rgba(255, 255, 255, 0.25);

  /* Framework Accent (neutral white -- NOT collection-colored) */
  --accent:            #FFFFFF;
  --accent-dim:        rgba(255, 255, 255, 0.08);
  --accent-glow:       0 0 12px rgba(255, 255, 255, 0.15);

  /* Text Hierarchy */
  --text-primary:      #FFFFFF;
  --text-secondary:    rgba(255, 255, 255, 0.65);
  --text-tertiary:     rgba(255, 255, 255, 0.40);

  /* Semantic (framework) */
  --led-on:            #FFFFFF;    /* Neutral white LED for framework sections */
  --led-off:           rgba(255, 255, 255, 0.10);
  --led-bezel:         #4A4A4A;

  /* Error / warning (shared across all contexts) */
  --red:               #FF3333;
  --red-dim:           rgba(255, 51, 51, 0.08);
  --glow-red:          0 0 12px rgba(255, 51, 51, 0.5);

  /* === MGS COLLECTION COLORS === */
  --mgs-primary:       #FFB800;   /* Codec amber */
  --mgs-secondary:     #00FF41;   /* Terminal green (for code/event names within MGS) */
  --mgs-bg:            #0D0D0A;   /* Slightly warm near-black */
  --mgs-surface:       #141410;   /* Slightly warm dark surface */
  --mgs-dim:           rgba(255, 184, 0, 0.08);
  --mgs-glow:          0 0 12px rgba(255, 184, 0, 0.4);
  --mgs-border:        rgba(255, 184, 0, 0.15);

  /* === SIMS COLLECTION COLORS === */
  --sims-primary:      #00D4AA;   /* Plumbob teal */
  --sims-secondary:    #7BE87B;   /* Soft green (needs panel, not terminal green) */
  --sims-bg:           #0F1413;   /* Slightly cool near-black */
  --sims-surface:      #141A18;   /* Slightly cool dark surface */
  --sims-warm:         #1C2420;   /* Warm elevated surface for Sims sections */
  --sims-dim:          rgba(0, 212, 170, 0.08);
  --sims-glow:         0 0 12px rgba(0, 212, 170, 0.4);
  --sims-border:       rgba(0, 212, 170, 0.15);
}
```

### Color Usage Rules

| Context | Primary Accent | LED Color | Border Accent | Code/Event Text |
|---------|---------------|-----------|---------------|-----------------|
| Framework sections (hero, how-it-works, event map, CTA, footer) | `#FFFFFF` | `#FFFFFF` | `rgba(255,255,255,0.15)` | `rgba(255,255,255,0.65)` |
| MGS collection section | `#FFB800` | `#FFB800` | `rgba(255,184,0,0.15)` | `#00FF41` (terminal green) |
| Sims collection section | `#00D4AA` | `#00D4AA` | `rgba(0,212,170,0.15)` | `#00D4AA` |

**Critical rule:** Terminal green (`#00FF41`) is NOT a framework color. It belongs exclusively to the MGS aesthetic. The neutral framework uses white. This prevents the entire site from feeling like an MGS codec screen.

### 1.2 Typography

All text uses IBM Plex Mono. No exceptions.

```
Google Fonts URL:
https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;700&display=swap
```

| Token          | Weight | Size        | Tracking   | Case       | Line Height |
|----------------|--------|-------------|------------|------------|-------------|
| `--type-display` | 700    | 56px / 3.5rem  | +0.04em    | uppercase  | 1.1         |
| `--type-h1`     | 700    | 36px / 2.25rem | +0.06em    | uppercase  | 1.2         |
| `--type-h2`     | 700    | 24px / 1.5rem  | +0.08em    | uppercase  | 1.3         |
| `--type-h3`     | 500    | 18px / 1.125rem| +0.06em    | uppercase  | 1.3         |
| `--type-body`   | 400    | 16px / 1rem    | normal     | sentence   | 1.6         |
| `--type-small`  | 500    | 12px / 0.75rem | +0.08em    | uppercase  | 1.4         |
| `--type-micro`  | 500    | 10px / 0.625rem| +0.10em    | uppercase  | 1.4         |
| `--type-code`   | 400    | 14px / 0.875rem| normal     | as-is      | 1.5         |

**Rules:**
- All headings and labels: `text-transform: uppercase`
- All numeric displays: `font-variant-numeric: tabular-nums`
- Body text line-height: 1.6 (critical for readability on dark backgrounds)
- No italic usage anywhere on the site
- Font stack fallback: `'IBM Plex Mono', 'SF Mono', 'Monaco', 'Courier New', monospace`

### 1.3 Spacing Scale (4px base grid)

```css
--space-1:   4px;    /* 0.25rem */
--space-2:   8px;    /* 0.5rem  */
--space-3:   12px;   /* 0.75rem */
--space-4:   16px;   /* 1rem    */
--space-5:   20px;   /* 1.25rem */
--space-6:   24px;   /* 1.5rem  */
--space-8:   32px;   /* 2rem    */
--space-10:  40px;   /* 2.5rem  */
--space-12:  48px;   /* 3rem    */
--space-16:  64px;   /* 4rem    */
--space-20:  80px;   /* 5rem    */
--space-24:  96px;   /* 6rem    */
```

### 1.4 Transitions

```css
--transition-fast:    80ms ease;      /* Button press, LED toggle */
--transition-normal:  150ms ease;     /* Hover states */
--transition-slow:    400ms ease;     /* Scroll reveal, section transitions */
```

### 1.5 Z-Index Scale

```css
--z-base:     1;
--z-card:     10;
--z-overlay:  100;
--z-sticky:   200;
```

---

## 2. Global Styles

### 2.1 Reset and Base

```css
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html {
  scroll-behavior: smooth;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

body {
  font-family: 'IBM Plex Mono', 'SF Mono', 'Monaco', 'Courier New', monospace;
  background: #0A0A0A;
  color: rgba(255, 255, 255, 0.65);  /* Default to secondary text */
  font-size: 16px;
  line-height: 1.6;
  overflow-x: hidden;
}
```

### 2.2 Background Grid Texture

A subtle dot grid across the entire page. CSS only -- no images.

```css
body::before {
  content: '';
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-image: radial-gradient(
    rgba(255, 255, 255, 0.03) 1px,
    transparent 1px
  );
  background-size: 24px 24px;
  pointer-events: none;
  z-index: 0;
}
```

24px dot grid at ~3% opacity. Barely visible -- a texture, not a pattern.

### 2.3 Page Container

```css
.page-container {
  position: relative;
  z-index: 1;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
}
```

- Maximum content width: 1200px
- Side gutters: 24px (all breakpoints)

### 2.4 Section Spacing

```css
.section {
  padding: 96px 0;
}

.section + .section {
  border-top: 1px solid rgba(255, 255, 255, 0.08);
}
```

Sections are separated by 1px borders. Exception: collection-themed sections (MGS, Sims) may override the border with their accent color at low opacity.

### 2.5 Selection Color

```css
/* Neutral framework selection */
::selection {
  background: rgba(255, 255, 255, 0.20);
  color: #FFFFFF;
}

/* Override inside collection sections */
.mgs-theme ::selection {
  background: rgba(255, 184, 0, 0.25);
  color: #FFFFFF;
}

.sims-theme ::selection {
  background: rgba(0, 212, 170, 0.25);
  color: #FFFFFF;
}
```

---

## 3. Component Library

### 3.1 The LED Indicator

A small glowing circle. Color varies by context.

**Dimensions and Structure:**

```
        +-----------+
        |   bezel   |   <- 2px #4A4A4A ring
        | +-------+ |
        | |  LED  | |   <- 8px diameter, filled circle
        | +-------+ |
        +-----------+
           12px total (8px LED + 2px bezel each side)
```

**CSS:**

```css
.led {
  display: inline-block;
  width: 8px;
  height: 8px;
  border-radius: 50%;        /* ONLY element allowed border-radius */
  background: #FFFFFF;       /* Default: neutral white */
  box-shadow: 0 0 8px rgba(255, 255, 255, 0.3);
  outline: 2px solid #4A4A4A;
  outline-offset: 1px;
}

.led--off {
  background: rgba(255, 255, 255, 0.10);
  box-shadow: none;
}

.led--amber {
  background: #FFB800;
  box-shadow: 0 0 8px rgba(255, 184, 0, 0.5);
}

.led--green {
  background: #00FF41;
  box-shadow: 0 0 8px rgba(0, 255, 65, 0.5);
}

.led--teal {
  background: #00D4AA;
  box-shadow: 0 0 8px rgba(0, 212, 170, 0.5);
}

.led--red {
  background: #FF3333;
  box-shadow: 0 0 8px rgba(255, 51, 51, 0.5);
}
```

**Context rules for LED color:**
- Hero section: **white** (neutral)
- Framework section labels: **white** (neutral)
- MGS card/section: **amber** (`#FFB800`)
- Sims card/section: **teal** (`#00D4AA`)
- Event map LEDs: **white** (neutral -- events are collection-agnostic)

**Note:** The LED is the ONLY element in the entire design that uses `border-radius`. Everything else is sharp corners. No exceptions.

### 3.2 Buttons

Two button variants: Primary (filled) and Ghost (outlined).

#### Primary Button

```
+----------------------------------+
|  VIEW ON GITHUB                  |   height: 48px
+----------------------------------+
    ^white bg, dark text
```

```css
.btn-primary {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  height: 48px;
  padding: 0 24px;
  background: #FFFFFF;
  color: #0A0A0A;
  border: 2px solid #FFFFFF;
  font-family: inherit;
  font-size: 12px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  cursor: pointer;
  text-decoration: none;
  transition: all 150ms ease;
}

.btn-primary:hover {
  background: rgba(255, 255, 255, 0.90);
  border-color: rgba(255, 255, 255, 0.90);
  box-shadow: 0 0 16px rgba(255, 255, 255, 0.15);
}

.btn-primary:active {
  transform: translateY(1px);
  box-shadow: none;
}

.btn-primary:focus-visible {
  outline: 2px solid #FFB800;  /* Use amber for focus -- visible against white */
  outline-offset: 2px;
}
```

**Collection-themed button variants** (used inside collection sections only):

```css
/* MGS context */
.mgs-theme .btn-primary {
  background: #FFB800;
  color: #0A0A0A;
  border-color: #FFB800;
}
.mgs-theme .btn-primary:hover {
  background: #E5A600;
  border-color: #E5A600;
  box-shadow: 0 0 16px rgba(255, 184, 0, 0.3);
}

/* Sims context */
.sims-theme .btn-primary {
  background: #00D4AA;
  color: #0A0A0A;
  border-color: #00D4AA;
}
.sims-theme .btn-primary:hover {
  background: #00BF99;
  border-color: #00BF99;
  box-shadow: 0 0 16px rgba(0, 212, 170, 0.3);
}
```

#### Ghost Button

```css
.btn-ghost {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  height: 48px;
  padding: 0 24px;
  background: transparent;
  color: rgba(255, 255, 255, 0.65);
  border: 1px solid rgba(255, 255, 255, 0.15);
  font-family: inherit;
  font-size: 12px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  cursor: pointer;
  text-decoration: none;
  transition: all 150ms ease;
}

.btn-ghost:hover {
  color: #FFFFFF;
  border-color: rgba(255, 255, 255, 0.40);
  background: rgba(255, 255, 255, 0.03);
}

.btn-ghost:active {
  transform: translateY(1px);
}

.btn-ghost:focus-visible {
  outline: 2px solid #FFFFFF;
  outline-offset: 2px;
}
```

### 3.3 Code Blocks

Terminal-style code display. Neutral styling in framework sections; collection-colored in collection sections.

**Framework (neutral) code block:**

```css
.code-block {
  position: relative;
  background: #0D0D0D;
  border: 1px solid rgba(255, 255, 255, 0.08);
  padding: 20px 24px;
  font-family: 'IBM Plex Mono', monospace;
  font-size: 14px;
  line-height: 1.5;
  color: rgba(255, 255, 255, 0.80);    /* Neutral light gray, NOT green */
  overflow-x: auto;
  white-space: pre;
  -webkit-overflow-scrolling: touch;
}

.code-block .prompt {
  color: rgba(255, 255, 255, 0.40);
  user-select: none;
}

.code-block .comment {
  color: rgba(255, 255, 255, 0.30);
}
```

**MGS-themed code block** (inside `.mgs-theme`):

```css
.mgs-theme .code-block {
  color: #00FF41;          /* Terminal green -- MGS territory */
  background: #0A0A08;
}
```

**Sims-themed code block** (inside `.sims-theme`):

```css
.sims-theme .code-block {
  color: #00D4AA;          /* Teal */
  background: #0A0D0C;
}
```

**Copy Button** (same across all themes):

```css
.code-copy-btn {
  position: absolute;
  top: 8px;
  right: 8px;
  width: 32px;
  height: 32px;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.10);
  color: rgba(255, 255, 255, 0.40);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  transition: all 150ms ease;
}

.code-copy-btn:hover {
  background: rgba(255, 255, 255, 0.10);
  color: #FFFFFF;
}

.code-copy-btn.copied {
  background: rgba(255, 255, 255, 0.15);
  color: #FFFFFF;
  border-color: rgba(255, 255, 255, 0.30);
}
```

### 3.4 Collection Cards

Two variants with dramatically different visual treatments. These sit side-by-side and the CONTRAST between them is the design feature.

**Base Card Structure:**

```
+------------------------------------------+
| [LED]  COLLECTION-LABEL          BADGE   |  <- Header bar
|------------------------------------------|
|                                          |
|  CARD TITLE                              |  <- H2, accent color
|  Subtitle text here                      |  <- Secondary text
|                                          |
|  +------------------------------------+  |
|  | Content area: table, list, or grid |  |  <- Inset panel
|  +------------------------------------+  |
|                                          |
|  Feature bullet one                      |
|  Feature bullet two                      |
|  Feature bullet three                    |
|                                          |
|  "Pull quote or evocative line"          |  <- Accent-colored text
|                                          |
+------------------------------------------+
```

**Base Card CSS:**

```css
.collection-card {
  padding: 0;
  display: flex;
  flex-direction: column;
  transition: border-color 150ms ease;
}

.collection-card__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 24px;
}

.collection-card__header-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 10px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.10em;
}

.collection-card__body {
  padding: 32px 24px;
  flex: 1;
}

.collection-card__title {
  font-size: 24px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  line-height: 1.3;
  margin-bottom: 8px;
}

.collection-card__subtitle {
  font-size: 16px;
  line-height: 1.6;
  margin-bottom: 24px;
}

.collection-card__quote {
  font-size: 14px;
  padding-left: 16px;
  border-left: 3px solid;
  margin-top: 24px;
  line-height: 1.6;
}
```

#### MGS Card -- Dark, Tactical, Dense

The MGS card should feel like a codec briefing screen. Dark, tight, amber accents.

```css
.collection-card--mgs {
  background: #0D0D0A;                          /* Warm near-black */
  border: 1px solid rgba(255, 184, 0, 0.12);
}

.collection-card--mgs .collection-card__header {
  border-bottom: 1px solid rgba(255, 184, 0, 0.12);
  background: #111110;
}

.collection-card--mgs .collection-card__header-label {
  color: rgba(255, 184, 0, 0.60);
}

.collection-card--mgs .collection-card__title {
  color: #FFB800;
}

.collection-card--mgs .collection-card__subtitle {
  color: rgba(255, 255, 255, 0.55);
}

.collection-card--mgs .collection-card__quote {
  border-left-color: #FFB800;
  color: rgba(255, 255, 255, 0.55);
}

.collection-card--mgs:hover {
  border-color: rgba(255, 184, 0, 0.30);
}

/* MGS internal table uses terminal green for event names */
.collection-card--mgs .mission-table td:first-child {
  color: #00FF41;
}
```

#### Sims Card -- Lighter, Warmer, Playful

The Sims card should feel noticeably different from MGS. Slightly lighter background, more breathing room, teal accents. Like going from a military bunker into a cheerful living room.

```css
.collection-card--sims {
  background: #111514;                          /* Cool-tinted dark */
  border: 1px solid rgba(0, 212, 170, 0.12);
}

.collection-card--sims .collection-card__header {
  border-bottom: 1px solid rgba(0, 212, 170, 0.12);
  background: #141A18;
}

.collection-card--sims .collection-card__header-label {
  color: rgba(0, 212, 170, 0.60);
}

.collection-card--sims .collection-card__title {
  color: #00D4AA;
}

.collection-card--sims .collection-card__subtitle {
  color: rgba(255, 255, 255, 0.60);             /* Slightly brighter than MGS */
}

.collection-card--sims .collection-card__quote {
  border-left-color: #00D4AA;
  color: rgba(255, 255, 255, 0.60);
}

.collection-card--sims:hover {
  border-color: rgba(0, 212, 170, 0.30);
}

/* Sims internal table uses teal for event names */
.collection-card--sims .mission-table td:first-child {
  color: #00D4AA;
}
```

**Side-by-side contrast check:**

| Property | MGS Card | Sims Card |
|----------|----------|-----------|
| Background | `#0D0D0A` (warm black) | `#111514` (cool, slightly lighter) |
| Header bg | `#111110` | `#141A18` |
| Title color | `#FFB800` (amber) | `#00D4AA` (teal) |
| Border color | `rgba(255,184,0,0.12)` | `rgba(0,212,170,0.12)` |
| LED color | Amber | Teal |
| Event name color | `#00FF41` (terminal green) | `#00D4AA` (teal) |
| Mood | Dense, tactical, serious | Lighter, warmer, playful |

These two cards placed side-by-side should make the dual-personality of Noisy Claude immediately obvious.

### 3.5 Badge / Tag

Small inline labels. Neutral by default, themed in collection context.

```css
.badge {
  display: inline-block;
  padding: 4px 8px;
  font-size: 10px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.10em;
  border: 1px solid rgba(255, 255, 255, 0.15);
  color: rgba(255, 255, 255, 0.65);
  background: transparent;
  white-space: nowrap;
}

.badge--amber {
  border-color: rgba(255, 184, 0, 0.30);
  color: #FFB800;
}

.badge--teal {
  border-color: rgba(0, 212, 170, 0.30);
  color: #00D4AA;
}

.badge--white {
  border-color: rgba(255, 255, 255, 0.25);
  color: #FFFFFF;
}
```

### 3.6 Section Header

Used at the start of each major section. LED color and label color match the section context.

```
[LED]  SECTION LABEL

SECTION HEADLINE
Description text goes here, kept to 2-3 sentences max.
```

```css
.section-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 10px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.10em;
  color: rgba(255, 255, 255, 0.50);   /* Neutral: muted white */
  margin-bottom: 16px;
}

/* In collection contexts, label takes the collection color */
.mgs-theme .section-label {
  color: rgba(255, 184, 0, 0.70);
}

.sims-theme .section-label {
  color: rgba(0, 212, 170, 0.70);
}

.section-headline {
  font-size: 36px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  line-height: 1.2;
  color: #FFFFFF;
  margin-bottom: 16px;
}

.section-description {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.65);
  line-height: 1.6;
  max-width: 640px;
}
```

### 3.7 Stats Bar

Horizontal row of key metrics. Always neutral.

```
+------+---------+--------+--------+
| 40+  |    2    |  264+  |  ZERO  |
|EVENTS|COLLECTNS| SOUNDS | BUILD  |
+------+---------+--------+--------+
```

```css
.stats-bar {
  display: flex;
  gap: 0;
  border: 1px solid rgba(255, 255, 255, 0.08);
  background: #141414;
}

.stats-bar__item {
  flex: 1;
  padding: 20px 16px;
  text-align: center;
  border-right: 1px solid rgba(255, 255, 255, 0.08);
}

.stats-bar__item:last-child {
  border-right: none;
}

.stats-bar__value {
  font-size: 24px;
  font-weight: 700;
  color: #FFFFFF;
  font-variant-numeric: tabular-nums;
  line-height: 1;
  margin-bottom: 4px;
}

.stats-bar__label {
  font-size: 10px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.10em;
  color: rgba(255, 255, 255, 0.40);
}
```

### 3.8 Event Channel Strip

For the Event Map section. Neutral styling -- events belong to Noisy Claude, not a specific collection.

```css
.channel-strip {
  background: #141414;
  border: 1px solid rgba(255, 255, 255, 0.08);
  margin-bottom: 8px;
}

.channel-strip__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  background: #1A1A1A;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.channel-strip__name {
  font-size: 12px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: #FFFFFF;
}

.channel-strip__count {
  font-size: 10px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.10em;
  color: rgba(255, 255, 255, 0.40);
  font-variant-numeric: tabular-nums;
}

.channel-strip__event {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.04);
}

.channel-strip__event:last-child {
  border-bottom: none;
}

.channel-strip__event-name {
  font-size: 14px;
  font-weight: 400;
  color: rgba(255, 255, 255, 0.80);   /* Neutral -- NOT green */
  min-width: 160px;
  flex-shrink: 0;
}

.channel-strip__event-desc {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.40);
}
```

### 3.9 Step Card (How It Works)

Neutral styling.

```css
.step {
  display: grid;
  grid-template-columns: 80px 1fr;
  gap: 0;
  border: 1px solid rgba(255, 255, 255, 0.08);
  background: #141414;
  margin-bottom: 8px;
}

.step__number {
  display: flex;
  align-items: flex-start;
  justify-content: center;
  padding-top: 32px;
  font-size: 36px;
  font-weight: 700;
  color: rgba(255, 255, 255, 0.15);
  border-right: 1px solid rgba(255, 255, 255, 0.08);
  font-variant-numeric: tabular-nums;
}

.step__content {
  padding: 24px;
}

.step__title {
  font-size: 18px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: #FFFFFF;
  margin-bottom: 8px;
}

.step__desc {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.65);
  line-height: 1.6;
  margin-bottom: 16px;
}
```

### 3.10 Accent Line

Left-border emphasis. Color matches context.

```css
.accent-line {
  border-left: 3px solid rgba(255, 255, 255, 0.25);  /* Neutral default */
  padding-left: 16px;
}

.accent-line--amber {
  border-left-color: #FFB800;
}

.accent-line--teal {
  border-left-color: #00D4AA;
}
```

### 3.11 Feature List (inside cards)

```css
.feature-list {
  list-style: none;
  padding: 0;
  margin: 16px 0;
}

.feature-list li {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.65);
  line-height: 1.6;
  padding: 4px 0 4px 16px;
  position: relative;
}

.feature-list li::before {
  content: '';
  position: absolute;
  left: 0;
  top: 11px;
  width: 4px;
  height: 4px;
  background: currentColor;
}
```

Bullet markers are small 4px squares, not circles. Sharp corners.

### 3.12 Internal Table (Mission Arc / Event Mapping)

Used inside collection cards.

```css
.mapping-table {
  width: 100%;
  border-collapse: collapse;
  margin: 16px 0;
  border: 1px solid rgba(255, 255, 255, 0.08);
}

.mapping-table th {
  font-size: 10px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.10em;
  color: rgba(255, 255, 255, 0.40);
  text-align: left;
  padding: 8px 12px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.mapping-table td {
  font-size: 13px;
  padding: 6px 12px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.04);
  color: rgba(255, 255, 255, 0.65);
}
```

Background color of the table inherits from the card context (warm-black for MGS, cool-dark for Sims).

---

## 4. Section-by-Section Specs

### 4.1 HERO -- "Your Code Has a Soundtrack Now"

**Theme: NEUTRAL. No collection colors.**

```
+================================================================+
|                                                                |
|                                                                |
|                       [LED white, pulsing]                     |
|                                                                |
|              YOUR CODE HAS A SOUNDTRACK NOW                    |
|                                                                |
|   Sound notifications for Claude Code. 124 Metal Gear Solid   |
|   sounds. 140+ Sims 2 sounds. Every commit, every test,       |
|   every context warning -- heard, not missed.                  |
|                                                                |
|       [VIEW ON GITHUB]     [SEE HOW IT WORKS]                 |
|                                                                |
|   Because the best notification is the one you don't have to   |
|   look at.                                                     |
|                                                                |
+================================================================+
```

```css
.hero {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 96px 24px;
  position: relative;
}

.hero__led {
  margin-bottom: 32px;
  /* White LED with pulse animation */
}

.hero__headline {
  font-size: 56px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  line-height: 1.1;
  color: #FFFFFF;
  margin-bottom: 24px;
  max-width: 800px;
}

.hero__tagline {
  font-size: 16px;
  font-weight: 400;
  color: rgba(255, 255, 255, 0.65);
  line-height: 1.6;
  max-width: 600px;
  margin-bottom: 48px;
}

.hero__cta-group {
  display: flex;
  gap: 16px;
  align-items: center;
  margin-bottom: 64px;
}

.hero__sub-tagline {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.40);
  line-height: 1.6;
  max-width: 500px;
}
```

**Content:**
- LED: **White**, pulsing on a 3-second loop
- Headline: "YOUR CODE HAS A SOUNDTRACK NOW"
- Tagline: From showcase-copy.md
- CTA 1 (primary, white): "VIEW ON GITHUB"
- CTA 2 (ghost): "SEE HOW IT WORKS"
- Sub-tagline: "Because the best notification is the one you don't have to look at."

---

### 4.2 THE EXPERIENCE -- "Two Collections, Zero Configuration"

**Theme: NEUTRAL framework with collection-themed cards inside.**

This is the most important section visually. The two cards should feel like two different worlds placed side-by-side.

```
+================================================================+
|                                                                |
|  [LED white]  COLLECTIONS                                      |
|                                                                |
|  TWO ICONIC SOUND PACKS. READY ON INSTALL.                    |
|  Pick a vibe. Start coding.                                    |
|                                                                |
|  +--MGS CARD (warm black)--+ +--SIMS CARD (cool dark)---+    |
|  | [LED amber] MGS COLL'N  | | [LED teal] SIMS 2 COLL'N|    |
|  |  amber header bar       | |  teal header bar         |    |
|  |-------------------------| |---------------------------|    |
|  |                         | |                           |    |
|  | TACTICAL ESPIONAGE      | | SIMLISH SOUND             |    |
|  | AUDIO                   | | DESIGN                    |    |
|  |                         | |                           |    |
|  | +-----MGS table------+ | | +-----Sims table------+  |    |
|  | | Event | Sound      | | | | Event | Sound        |  |    |
|  | | start | Codec ring | | | | commit| Cheerful     |  |    |
|  | | fail  | Alert ?    | | | | fail  | Grumpy       |  |    |
|  | | ctx_90| Alert !    | | | | push  | Excited      |  |    |
|  | +--------------------+ | | +----------------------+  |    |
|  |                         | |                           |    |
|  | * 124 sounds, 8-bit WAV| | * 140+ sounds             |    |
|  | * 21 events default on | | * Every emotion covered   |    |
|  |                         | |                           |    |
|  | "You hear *that* sound  | | "Your codebase is a      |    |
|  |  at context_90."        | |  household."             |    |
|  +-------------------------+ +---------------------------+    |
|                                                                |
+================================================================+
```

```css
.experience {
  padding: 96px 0;
}

.experience__cards {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-top: 48px;
}
```

The section header uses a white LED and neutral label color. The cards themselves carry the collection theming.

---

### 4.3 THE CONTROL PANEL -- "The UI Adapts Too"

**Theme: NEUTRAL framework, showcasing BOTH collection themes.**

The control panel section demonstrates that Noisy Claude is more than sound swapping -- the entire UI adapts to match the active collection's aesthetic. This section shows two side-by-side mockups: the MGS dark theme and the Sims light theme.

**Key message:** "Switch collections, and the entire interface transforms. Not just the sounds -- the whole experience."

```
+================================================================+
|                                                                |
|  [LED white]  CONTROL PANEL                                    |
|                                                                |
|  THE UI ADAPTS TOO                                              |
|  Switch collections, and the entire interface transforms.      |
|  Dark and tactical for MGS. Light and playful for Sims.        |
|                                                                |
|  +--MGS THEME (dark mock)--+  +--SIMS THEME (light mock)-+   |
|  | [dark bg #1A1A1A]       |  | [light bg #F5F5F0]       |   |
|  | NOISY CLAUDE  [PWR][*]  |  | NOISY CLAUDE   [PWR][*]  |   |
|  | [green LED strip]       |  | [teal LED strip]          |   |
|  |                         |  |                            |   |
|  | SESSION START     [*]   |  | SESSION START     [*]     |   |
|  | [0x1a.wav        v] [>] |  | [mGREETING.wav   v] [>]  |   |
|  | "Codec ring"            |  | "Cheerful greeting"       |   |
|  |                         |  |                            |   |
|  | [red Save Changes]      |  | [teal Save Changes]       |   |
|  +-------------------------+  +----------------------------+   |
|                                                                |
|  "The entire experience adapts to your collection's vibe."     |
|                                                                |
|  localhost:5050 -- One URL, two worlds.                        |
|                                                                |
|  [MASTER POWER] [PREVIEW SOUNDS] [AI-MAPPED] [THEME ADAPTS]  |
|                                                                |
+================================================================+
```

**Dual Screenshot Frame Layout:**

```css
.control-panel-showcase {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin: 48px 0 24px 0;
}

@media (max-width: 767px) {
  .control-panel-showcase {
    grid-template-columns: 1fr;
  }
}
```

**MGS Screenshot Frame (Dark):**

```css
.screenshot-frame--mgs {
  background: #0D0D0D;
  border: 2px solid rgba(255, 184, 0, 0.15);
  padding: 2px;
  position: relative;
}

.screenshot-frame--mgs .screenshot-frame__chrome {
  background: #1A1A1A;
  padding: 8px 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.10);
  display: flex;
  align-items: center;
  gap: 8px;
}

.screenshot-frame--mgs .screenshot-frame__url {
  font-size: 11px;
  color: rgba(255, 255, 255, 0.40);
}

.screenshot-frame--mgs .screenshot-frame__content {
  padding: 24px;
  min-height: 280px;
  background: #1A1A1A;
}

.screenshot-frame--mgs .screenshot-frame__label {
  font-size: 10px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.10em;
  color: #FFB800;
  text-align: center;
  padding: 8px;
  background: #0D0D0D;
  border-top: 1px solid rgba(255, 184, 0, 0.15);
}
```

**Sims Screenshot Frame (Light):**

```css
.screenshot-frame--sims {
  background: #ECEEE8;
  border: 2px solid rgba(0, 179, 137, 0.15);
  padding: 2px;
  position: relative;
}

.screenshot-frame--sims .screenshot-frame__chrome {
  background: #FFFFFF;
  padding: 8px 16px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.08);
  display: flex;
  align-items: center;
  gap: 8px;
}

.screenshot-frame--sims .screenshot-frame__url {
  font-size: 11px;
  color: rgba(26, 42, 36, 0.40);
}

.screenshot-frame--sims .screenshot-frame__content {
  padding: 24px;
  min-height: 280px;
  background: #F5F5F0;
}

.screenshot-frame--sims .screenshot-frame__label {
  font-size: 10px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.10em;
  color: #00B389;
  text-align: center;
  padding: 8px;
  background: #ECEEE8;
  border-top: 1px solid rgba(0, 179, 137, 0.15);
}
```

**Simplified Mockup Elements (inside each frame):**

Each frame contains a CSS-only simplified version of the control panel showing:
1. Header with "NOISY CLAUDE" title
2. A mini event card with LED strip, event name, toggle, and sound select
3. A primary button in the theme's accent color
4. Appropriate LED colors and text contrast

These mockups do NOT need to be full replicas. They should convey the mood difference at a glance -- dark/green/tactical vs light/teal/playful.

**Mini Event Card (MGS variant, inside dark frame):**

```css
.mini-card--mgs {
  background: #151515;
  border: 1px solid rgba(255, 255, 255, 0.10);
  padding: 12px;
  position: relative;
}

.mini-card--mgs .mini-led-strip {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: #00FF00;
  box-shadow: 0 0 4px #00FF00;
}

.mini-card--mgs .mini-event-name {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: #FFFFFF;
  margin-top: 4px;
}

.mini-card--mgs .mini-sound-name {
  font-size: 10px;
  color: rgba(255, 255, 255, 0.45);
  margin-top: 4px;
}

/* Sound description label -- tells user what the sound IS */
.mini-card--mgs .mini-sound-desc {
  font-size: 9px;
  color: rgba(255, 255, 255, 0.35);
  margin-top: 2px;
  letter-spacing: 0.02em;
  /* e.g. "Codec ring", "Alert (!)", "Item pickup chime" */
}

.mini-btn--mgs {
  display: inline-block;
  padding: 4px 12px;
  background: #D63500;
  color: #FFFFFF;
  font-size: 10px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  margin-top: 12px;
  border: none;
}
```

**Mini Event Card (Sims variant, inside light frame):**

```css
.mini-card--sims {
  background: #FFFFFF;
  border: 1px solid rgba(0, 0, 0, 0.08);
  padding: 12px;
  position: relative;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.mini-card--sims .mini-led-strip {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: #00D4AA;
  box-shadow: 0 0 4px rgba(0, 212, 170, 0.4);
}

.mini-card--sims .mini-event-name {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: #1A2A24;
  margin-top: 4px;
}

.mini-card--sims .mini-sound-name {
  font-size: 10px;
  color: rgba(26, 42, 36, 0.45);
  margin-top: 4px;
}

/* Sound description label -- tells user what the sound IS */
.mini-card--sims .mini-sound-desc {
  font-size: 9px;
  color: rgba(26, 42, 36, 0.35);
  margin-top: 2px;
  letter-spacing: 0.02em;
  /* e.g. "Cheerful greeting", "Enthusiastic 'Dag dag!'" */
}

.mini-btn--sims {
  display: inline-block;
  padding: 4px 12px;
  background: #00B389;
  color: #1A2A24;
  font-size: 10px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  margin-top: 12px;
  border: none;
}
```

**Tagline below the dual mockups:**

```css
.control-panel-tagline {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.65);
  text-align: center;
  margin-top: 24px;
  margin-bottom: 24px;
  line-height: 1.6;
}
```

Content: "The entire experience adapts to your collection's vibe. Not just the sounds -- the whole interface."

**Feature Badges Row (updated):**

Below the tagline, a row of feature badges. Updated to include "THEME ADAPTS":

```
[TOGGLE ON/OFF] [PREVIEW SOUNDS] [AI-MAPPED DEFAULTS] [THEME ADAPTS]
```

Uses the `.badge` component from Section 3.5.

---

### 4.4 EVENT MAP -- "40+ Events. Every Moment Covered."

**Theme: NEUTRAL. Events belong to Noisy Claude, not a collection.**

Same layout as v1 but with neutral (white) LEDs and neutral event name colors.

```css
.event-map__grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 8px;
  margin-top: 32px;
}

.event-map__grid .channel-strip:first-child {
  grid-column: 1 / -1;
}
```

Channel strip categories remain the same:

| Category | Example Events | Count |
|----------|---------------|-------|
| Core | session_start, session_end, tool_start, tool_end, stop | ~5 |
| Git | git_commit, git_push, git_pull, git_checkout, pr_created, pr_merged | ~6 |
| Testing | test_pass, test_fail, test_start, test_suite_complete | ~4 |
| Building | build_start, build_success, build_fail | ~3 |
| Context | context_50, context_75, context_90 | ~3 |
| Streaks | streak_3, streak_5, streak_10 | ~3 |
| Time | session_30m, session_1h, late_night | ~3 |
| Agent | agent_start, agent_handoff, agent_complete | ~3 |
| Thinking | plan_start, plan_end, thinking | ~3 |
| Skills | skill_start, skill_end | ~2 |

---

### 4.5 HOW IT WORKS -- "Three Steps. Two Minutes."

**Theme: NEUTRAL.**

Same layout as v1. Step cards, architecture diagram, tech badges. All neutral styling.

Architecture diagram nodes use neutral white borders and text. No collection colors.

Tech badges: PYTHON FLASK, VANILLA JS, REST API, macOS, ZERO DEPENDENCIES -- all `.badge` (default neutral variant).

---

### 4.6 CTA -- "Your Terminal Is Too Quiet"

**Theme: NEUTRAL. White border, not green.**

```
+================================================================+
|                                                                |
|  +========================================================+   |
|  ||                                                      ||   |
|  ||              YOUR TERMINAL IS TOO QUIET              ||   |
|  ||                                                      ||   |
|  ||  +--------------------------------------------------+||   |
|  ||  | $ git clone https://github.com/user/qp2.git  [CP]|||   |
|  ||  +--------------------------------------------------+||   |
|  ||                                                      ||   |
|  ||          [GET NOISY CLAUDE]     [VIEW ON GITHUB]       ||   |
|  ||                                                      ||   |
|  ||  Free. Open source. Two sound packs included.        ||   |
|  ||                                                      ||   |
|  ||  Because coding in silence was always the real bug.  ||   |
|  ||                                                      ||   |
|  +========================================================+   |
|                                                                |
+================================================================+
```

```css
.cta-panel {
  border: 2px solid rgba(255, 255, 255, 0.25);     /* Neutral white, NOT green */
  background: #141414;
  padding: 64px 48px;
  text-align: center;
  position: relative;
}

.cta-panel::before {
  content: '';
  position: absolute;
  inset: -1px;
  border: 1px solid rgba(255, 255, 255, 0.05);
  pointer-events: none;
}

.cta-panel__headline {
  font-size: 36px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: #FFFFFF;
  margin-bottom: 32px;
}

.cta-panel__code {
  max-width: 600px;
  margin: 0 auto 32px auto;
}

.cta-panel__buttons {
  display: flex;
  gap: 16px;
  justify-content: center;
  margin-bottom: 32px;
}

.cta-panel__small-print {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.40);
  margin-bottom: 16px;
}

.cta-panel__tagline {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.65);
}
```

---

### 4.7 FOOTER

**Theme: NEUTRAL.**

```css
.footer {
  padding: 48px 0;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
}

.footer__top {
  display: flex;
  align-items: center;
  gap: 24px;
  margin-bottom: 16px;
}

.footer__brand {
  font-size: 12px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: #FFFFFF;
}

.footer__meta {
  font-size: 11px;
  color: rgba(255, 255, 255, 0.30);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.footer__tagline {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.30);
  line-height: 1.6;
}
```

---

## 5. Interaction States

### 5.1 Hover States

| Element | Hover Effect |
|---------|-------------|
| Primary button (neutral) | `rgba(255,255,255,0.90)` bg, `box-shadow: 0 0 16px rgba(255,255,255,0.15)` |
| Primary button (MGS context) | `#E5A600` bg, `box-shadow: 0 0 16px rgba(255,184,0,0.3)` |
| Primary button (Sims context) | `#00BF99` bg, `box-shadow: 0 0 16px rgba(0,212,170,0.3)` |
| Ghost button | Border to `rgba(255,255,255,0.40)`, text to `#FFFFFF`, bg `rgba(255,255,255,0.03)` |
| MGS collection card | Border to `rgba(255,184,0,0.30)` |
| Sims collection card | Border to `rgba(0,212,170,0.30)` |
| Channel strip | No hover. Static. |
| Code block | No hover on block. Copy button has independent hover. |
| Copy button | Bg to `rgba(255,255,255,0.10)`, text to `#FFFFFF` |
| Footer links | Color to `#FFFFFF` |
| Badges | No hover. Static. |

All hover transitions: `150ms ease`.

### 5.2 Active / Pressed States

| Element | Active Effect |
|---------|-------------|
| Primary button | `translateY(1px)`, remove box-shadow |
| Ghost button | `translateY(1px)` |
| Copy button | Brief flash -- bg `rgba(255,255,255,0.15)`, text `#FFFFFF`. 1500ms, then reverts. |

### 5.3 Focus States (Keyboard Navigation)

```css
:focus-visible {
  outline: 2px solid #FFFFFF;    /* Neutral white focus ring */
  outline-offset: 2px;
}

:focus:not(:focus-visible) {
  outline: none;
}
```

| Element | Focus Style |
|---------|------------|
| Primary button (neutral) | `outline: 2px solid #FFB800; outline-offset: 2px;` (amber visible against white bg) |
| Primary button (MGS) | `outline: 2px solid #FFFFFF; outline-offset: 2px;` (white visible against amber bg) |
| Primary button (Sims) | `outline: 2px solid #FFFFFF; outline-offset: 2px;` (white visible against teal bg) |
| Ghost button | `outline: 2px solid #FFFFFF; outline-offset: 2px;` |
| Code copy button | `outline: 2px solid #FFFFFF; outline-offset: 2px;` |
| Links | `outline: 2px solid #FFFFFF; outline-offset: 2px;` |

### 5.4 Disabled States

Not applicable. All elements are always active.

---

## 6. Animations

### 6.1 LED Pulse (Hero)

White LED breathing pulse.

```css
@keyframes led-pulse {
  0%, 100% {
    opacity: 1;
    box-shadow: 0 0 8px rgba(255, 255, 255, 0.4),
                0 0 16px rgba(255, 255, 255, 0.15);
  }
  50% {
    opacity: 0.5;
    box-shadow: 0 0 4px rgba(255, 255, 255, 0.2),
                0 0 8px rgba(255, 255, 255, 0.05);
  }
}

.led--pulse {
  animation: led-pulse 3s ease-in-out infinite;
}
```

- Duration: 3 seconds
- Easing: ease-in-out
- Loop: infinite
- Only used on the hero LED. All other LEDs are static.

### 6.2 Scroll Reveal

```css
.reveal {
  opacity: 0;
  transform: translateY(16px);
  transition: opacity 400ms ease, transform 400ms ease;
}

.reveal.visible {
  opacity: 1;
  transform: translateY(0);
}
```

**JavaScript (IntersectionObserver):**

```javascript
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
      observer.unobserve(entry.target);
    }
  });
}, {
  threshold: 0.1,
  rootMargin: '0px 0px -40px 0px'
});

document.querySelectorAll('.reveal').forEach(el => {
  observer.observe(el);
});
```

**Rules:**
- Apply `.reveal` to each `<section>` and to each collection card individually
- Each element animates independently
- Animation triggers once. No repeat on scroll back up.
- No bounce. No slide. No overshoot.

### 6.3 Code Block Cursor Blink (Optional)

```css
@keyframes cursor-blink {
  0%, 100% { opacity: 1; }
  50% { opacity: 0; }
}

.code-block__cursor {
  display: inline-block;
  width: 8px;
  height: 16px;
  background: rgba(255, 255, 255, 0.60);   /* Neutral, not green */
  animation: cursor-blink 1s step-end infinite;
  vertical-align: text-bottom;
  margin-left: 2px;
}
```

Only used on the CTA code block. One blinking cursor maximum.

### 6.4 Copy Confirmation

```javascript
function handleCopy(button, text) {
  navigator.clipboard.writeText(text).then(() => {
    button.classList.add('copied');
    setTimeout(() => button.classList.remove('copied'), 1500);
  });
}
```

---

## 7. Responsive Breakpoints

### 7.1 Breakpoint Definitions

```css
/* Desktop-first. Three breakpoints. */
/* Large desktop: 1200px+ (default) */
@media (max-width: 1199px) { ... }  /* Tablet */
@media (max-width: 767px) { ... }   /* Mobile */
@media (max-width: 479px) { ... }   /* Small mobile */
```

### 7.2 Section Adaptations

#### Hero

| Property | Desktop (1200+) | Tablet (768-1199) | Mobile (<768) |
|----------|----------------|-------------------|---------------|
| Headline size | 56px | 40px | 28px |
| Tagline max-width | 600px | 500px | 100% |
| CTA layout | Flex row | Flex row | Flex column, full-width |
| Min-height | 100vh | 100vh | auto, padding: 64px 0 |
| Sub-tagline | Visible | Visible | Hidden |

```css
@media (max-width: 1199px) {
  .hero__headline { font-size: 40px; }
}

@media (max-width: 767px) {
  .hero {
    min-height: auto;
    padding: 64px 24px;
  }
  .hero__headline { font-size: 28px; letter-spacing: 0.02em; }
  .hero__tagline { font-size: 14px; }
  .hero__cta-group {
    flex-direction: column;
    width: 100%;
  }
  .hero__cta-group .btn-primary,
  .hero__cta-group .btn-ghost {
    width: 100%;
    justify-content: center;
  }
  .hero__sub-tagline { display: none; }
}
```

#### Collection Cards

| Property | Desktop | Tablet | Mobile |
|----------|---------|--------|--------|
| Grid | 2 columns | 2 columns | 1 column (stacked) |
| Card padding | 32px body | 24px body | 20px body |
| Internal table | Full width | Full width | Horizontal scroll if needed |

```css
@media (max-width: 767px) {
  .experience__cards {
    grid-template-columns: 1fr;
    gap: 16px;
  }
}
```

#### Event Map

```css
@media (max-width: 1199px) {
  .event-map__grid {
    grid-template-columns: 1fr 1fr;
  }
}

@media (max-width: 767px) {
  .event-map__grid {
    grid-template-columns: 1fr;
  }
  .channel-strip__event {
    flex-wrap: wrap;
  }
  .channel-strip__event-name {
    min-width: auto;
    width: 100%;
  }
}
```

#### Stats Bar

```css
@media (max-width: 767px) {
  .stats-bar {
    display: grid;
    grid-template-columns: 1fr 1fr;
  }
  .stats-bar__item {
    border-right: none;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  }
  .stats-bar__item:nth-child(odd) {
    border-right: 1px solid rgba(255, 255, 255, 0.08);
  }
  .stats-bar__item:nth-last-child(-n+2) {
    border-bottom: none;
  }
}
```

#### Step Cards

```css
@media (max-width: 767px) {
  .step {
    grid-template-columns: 1fr;
  }
  .step__number {
    padding: 16px 24px 0 24px;
    justify-content: flex-start;
    border-right: none;
    font-size: 24px;
  }
  .code-block {
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
  }
}
```

#### Architecture Diagram

```css
@media (max-width: 767px) {
  .architecture__flow {
    flex-direction: column;
  }
  .architecture__arrow {
    width: 1px;
    height: 32px;
  }
  .architecture__arrow::after {
    right: auto;
    bottom: 0;
    left: -3px;
    top: auto;
    border: 3px solid transparent;
    border-top-color: rgba(255, 255, 255, 0.20);
  }
}
```

#### CTA Panel

```css
@media (max-width: 767px) {
  .cta-panel {
    padding: 32px 20px;
  }
  .cta-panel__headline { font-size: 24px; }
  .cta-panel__buttons {
    flex-direction: column;
    align-items: stretch;
  }
}
```

### 7.3 Touch Targets

```css
@media (max-width: 767px) {
  .btn-primary,
  .btn-ghost {
    min-height: 48px;
  }
  .code-copy-btn {
    width: 44px;
    height: 44px;
  }
}
```

---

## 8. Accessibility

### 8.1 WCAG 2.1 AA Compliance

#### Color Contrast Ratios

| Text | Background | Ratio | Pass? |
|------|-----------|-------|-------|
| `#FFFFFF` on `#0A0A0A` | Page bg | 19.3:1 | AA + AAA |
| `rgba(255,255,255,0.65)` on `#0A0A0A` | Page bg | ~11.5:1 | AA + AAA |
| `rgba(255,255,255,0.40)` on `#0A0A0A` | Page bg | ~6.3:1 | AA (large text only) |
| `rgba(255,255,255,0.80)` on `#0A0A0A` | Code text on page | ~14.8:1 | AA + AAA |
| `#FFB800` on `#0D0D0A` | MGS title | ~10.7:1 | AA + AAA |
| `#00FF41` on `#0D0D0A` | MGS event name | ~12.6:1 | AA + AAA |
| `#00D4AA` on `#111514` | Sims title | ~9.2:1 | AA + AAA |
| `#0A0A0A` on `#FFFFFF` | Primary btn | 19.3:1 | AA + AAA |
| `#0A0A0A` on `#FFB800` | MGS primary btn | ~10.7:1 | AA + AAA |
| `#0A0A0A` on `#00D4AA` | Sims primary btn | ~10.1:1 | AA + AAA |

Note: Tertiary text (`rgba(255,255,255,0.40)`) passes AA only for large text. Used only for non-essential labels. If any tertiary text conveys essential information, bump to `rgba(255,255,255,0.55)`.

#### Semantic HTML Structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Noisy Claude -- Sound Notifications for Claude Code</title>
  <meta name="description" content="...">
</head>
<body>
  <a href="#hero" class="skip-link">Skip to content</a>
  <main>
    <section id="hero" aria-label="Introduction">...</section>
    <section id="experience" aria-label="Sound Collections">
      <div class="collection-card--mgs mgs-theme" role="article">...</div>
      <div class="collection-card--sims sims-theme" role="article">...</div>
    </section>
    <section id="control-panel" aria-label="Control Panel Features">...</section>
    <section id="event-map" aria-label="Event Map">...</section>
    <section id="how-it-works" aria-label="Installation Guide">...</section>
    <section id="cta" aria-label="Get Started">...</section>
  </main>
  <footer>...</footer>
</body>
</html>
```

**Rules:**
- One `<h1>` in hero, `<h2>` for sections, `<h3>` for subsections
- No heading skips
- Collection cards use `role="article"` for content grouping
- All sections have `aria-label` or `aria-labelledby`

#### Keyboard Navigation

- Tab order follows visual reading order
- All interactive elements reachable via Tab
- Focus indicators visible (see Section 5.3)
- Skip-to-content link:

```css
.skip-link {
  position: absolute;
  top: -100px;
  left: 16px;
  background: #FFFFFF;
  color: #0A0A0A;
  padding: 8px 16px;
  font-size: 12px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  z-index: 999;
  text-decoration: none;
}

.skip-link:focus {
  top: 16px;
}
```

#### Reduced Motion

```css
@media (prefers-reduced-motion: reduce) {
  .led--pulse {
    animation: none;
  }
  .reveal {
    opacity: 1;
    transform: none;
    transition: none;
  }
  .code-block__cursor {
    animation: none;
    opacity: 1;
  }
  * {
    transition-duration: 0.01ms !important;
  }
}
```

#### Screen Reader Notes

- LED indicators: `aria-hidden="true"` (decorative)
- Code blocks: `<pre><code>` with `aria-label="Installation command"` etc.
- Background grid: pseudo-element, naturally hidden from AT
- Copy buttons: `aria-label="Copy code to clipboard"`, updates to `aria-label="Copied"` on click

### 8.2 Meta Tags

```html
<meta name="description" content="Noisy Claude: Sound notifications for Claude Code. 124 Metal Gear Solid sounds and 140+ Sims 2 sounds. Every commit, test, and context warning gets its own sound.">
<meta property="og:title" content="Noisy Claude -- Your Terminal Has a Soundtrack Now">
<meta property="og:description" content="Sound notifications for Claude Code. 124 Metal Gear Solid sounds and 140+ Sims 2 sounds.">
<meta property="og:type" content="website">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Noisy Claude -- Your Terminal Has a Soundtrack Now">
<meta name="twitter:description" content="Your Claude Code sessions just got a soundtrack. Metal Gear Solid alert sounds for context warnings. Simlish celebrations for passing tests. Free and open source.">
```

---

## 9. Performance Budget

### 9.1 Target: Under 50KB Total (Excluding Fonts)

| Resource | Budget |
|----------|--------|
| HTML | ~15KB |
| Inline CSS | ~22KB (slightly larger due to dual-theme CSS) |
| Inline JS | ~5KB |
| External fonts (IBM Plex Mono 400, 500, 700) | ~150KB (separate, cached) |
| Images | 0KB (all CSS-generated) |
| **Total page weight (excluding fonts)** | **~42KB** |

### 9.2 Loading Strategy

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;700&display=swap" rel="stylesheet">
```

- All CSS inline in `<style>`
- All JS inline at bottom of `<body>`
- No images
- `font-display: swap` for immediate text rendering

---

## Appendix A: Full Page ASCII Blueprint (v2 -- Neutral Framework)

```
+=============================================================+
|                                                             |
|                   [LED WHITE pulsing]                       |
|                                                             |
|           YOUR CODE HAS A SOUNDTRACK NOW                    |
|                                                             |
|   Sound notifications for Claude Code...                    |
|                                                             |
|     [VIEW ON GITHUB (white)]  [SEE HOW IT WORKS (ghost)]   |
|                                                             |
|   Because the best notification is the one you don't        |
|   have to look at.                                          |
|                                                             |
|------- neutral 1px border ----------------------------------|
|                                                             |
|  [LED white] COLLECTIONS                                    |
|  TWO ICONIC SOUND PACKS. READY ON INSTALL.                  |
|                                                             |
|  +==MGS (warm black bg)====+ +==SIMS (cool dark bg)=====+  |
|  | [LED amber] MGS         | | [LED teal] SIMS 2        |  |
|  | amber border accent     | | teal border accent        |  |
|  |--------------------------| |---------------------------|  |
|  | TACTICAL ESPIONAGE AUDIO| | SIMLISH SOUND DESIGN      |  |
|  |                         | |                            |  |
|  | Event table (green txt) | | Event table (teal txt)    |  |
|  |                         | |                            |  |
|  | * 124 sounds, 8-bit WAV | | * 140+ sounds             |  |
|  | "You hear *that*..."    | | "Your codebase is..."     |  |
|  +==========================+ +===========================+  |
|                                                             |
|  ^ WARM / TACTICAL / DENSE    COOL / PLAYFUL / LIGHTER ^   |
|                                                             |
|------- neutral 1px border ----------------------------------|
|                                                             |
|  [LED white] CONTROL PANEL                                  |
|  THE UI ADAPTS TOO                                          |
|                                                             |
|  +--MGS (dark mock)------+ +--SIMS (light mock)-----+     |
|  | Dark bg, green LEDs   | | Light bg, teal LEDs    |     |
|  | 0x1a.wav  "Codec ring"| | mGREETING "Cheerful"   |     |
|  | Red accent buttons    | | Green accent buttons   |     |
|  +------------------------+ +------------------------+     |
|                                                             |
|  "The entire experience adapts to your collection's vibe."  |
|                                                             |
|  [TOGGLE] [PREVIEW] [AI-MAPPED] [THEME ADAPTS]             |
|                                                             |
|------- neutral 1px border ----------------------------------|
|                                                             |
|  [LED white] EVENT MAP                                      |
|  40+ EVENTS. EVERY MOMENT COVERED.                          |
|                                                             |
|  Stats bar (neutral white values)                           |
|                                                             |
|  Channel strips with WHITE LEDs (neutral)                   |
|  Event names in neutral rgba(255,255,255,0.80)              |
|                                                             |
|------- neutral 1px border ----------------------------------|
|                                                             |
|  [LED white] HOW IT WORKS                                   |
|  THREE STEPS. TWO MINUTES.                                  |
|                                                             |
|  Step cards (neutral)                                       |
|  Architecture diagram (neutral)                             |
|  Tech badges (neutral)                                      |
|                                                             |
|------- neutral 1px border ----------------------------------|
|                                                             |
|  +=====[WHITE BORDER]==================================+    |
|  ||                                                   ||    |
|  ||          YOUR TERMINAL IS TOO QUIET               ||    |
|  ||                                                   ||    |
|  ||  $ git clone ...    (neutral gray code text) [CP] ||    |
|  ||                                                   ||    |
|  ||  [GET NOISY CLAUDE (white)]  [VIEW ON GITHUB]      ||    |
|  ||                                                   ||    |
|  ||  Free. Open source. Two sound packs included.     ||    |
|  ||  Because coding in silence was always the         ||    |
|  ||  real bug.                                        ||    |
|  +=================================================== +    |
|                                                             |
|------- neutral 1px border ----------------------------------|
|                                                             |
|  NOISY CLAUDE    MIT License    2026                        |
|  Built for developers who alt-tab.                          |
|                                                             |
+=============================================================+
```

---

## Appendix B: What NOT to Do

1. **No `border-radius`** except LED circles
2. **No shadows** on cards (only glow on LEDs/accents)
3. **No gradients** in backgrounds (exception: dot grid radial)
4. **No emoji** anywhere
5. **No light mode** toggle
6. **No hamburger menu** or nav bar
7. **No parallax** scrolling
8. **No bounce or overshoot** in animations
9. **No images** -- all CSS-generated
10. **No external CSS or JS** -- everything inline
11. **No framework** -- vanilla HTML/CSS/JS only
12. **No italic text**
13. **No rounded buttons**
14. **No hover transforms** on cards (no scale, rotate, translateZ)
15. **No sound on the website**
16. **No terminal green (`#00FF41`) in framework sections** -- green is an MGS color, not a framework color
17. **No single collection dominating the overall site palette** -- the framework is neutral

---

## Appendix C: Implementation Notes for the Developer

1. **The key concept is "neutral framework, themed islands."** The site defaults to white/gray accents. Collection theming only appears inside `.mgs-theme` and `.sims-theme` containers.

2. **Start with the Hero in neutral.** White LED, white primary button, no collection colors. This proves the neutral framework works.

3. **Build both collection cards early.** Place them side-by-side. If the contrast between MGS (warm/dark/amber) and Sims (cool/lighter/teal) is immediately obvious, the design is working.

4. **Use CSS scoping, not global overrides.** Collection colors are applied via parent class (`.mgs-theme .btn-primary`, `.sims-theme .code-block`). The base components stay neutral.

5. **Test the card contrast at arm's length.** Squint at the two cards. If you can tell them apart by color temperature alone (warm left, cool right), the design succeeds.

6. **The framework accent is white, not green.** This is the biggest change from v1. Green (`#00FF41`) only appears inside MGS-themed areas. Everywhere else: white.

7. **Code block text is neutral by default.** `rgba(255,255,255,0.80)` in framework sections. Only collection-scoped code blocks use colored text.

8. **The collection backgrounds are subtly different.** MGS: `#0D0D0A` (warm). Sims: `#111514` (cool, slightly lighter). The page bg is `#0A0A0A` (true neutral). These differences are subtle but perceptible.

9. **Test at 1200px, 768px, and 375px.** Three critical widths. If cards stack well on mobile and the theme contrast survives the single-column layout, the responsive design works.

10. **The IntersectionObserver + copy handler is the only JS.** Under 50 lines total.

---

## Appendix D: Color Usage Quick Reference

| Where | Accent Color | LED | Button BG | Code Text | Borders |
|-------|-------------|-----|-----------|-----------|---------|
| Hero | White | White | White | -- | `rgba(255,255,255,0.08)` |
| Collections intro | White | White | -- | -- | `rgba(255,255,255,0.08)` |
| MGS card | Amber `#FFB800` | Amber | Amber | Green `#00FF41` | `rgba(255,184,0,0.12)` |
| Sims card | Teal `#00D4AA` | Teal | Teal | Teal `#00D4AA` | `rgba(0,212,170,0.12)` |
| Control Panel | White | White | White | `rgba(255,255,255,0.80)` | `rgba(255,255,255,0.08)` |
| Event Map | White | White | -- | `rgba(255,255,255,0.80)` | `rgba(255,255,255,0.08)` |
| How It Works | White | White | -- | `rgba(255,255,255,0.80)` | `rgba(255,255,255,0.08)` |
| CTA | White | -- | White | `rgba(255,255,255,0.80)` | `rgba(255,255,255,0.25)` |
| Footer | White | -- | -- | -- | `rgba(255,255,255,0.08)` |

This table is the definitive guide. If in doubt about what color to use where, consult this table.
