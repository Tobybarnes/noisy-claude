# Noisy Claude Showcase Website Copy (v2 -- Neutral Framework)

> **Design intent:** The site itself is neutral -- clean, modern, developer-tool aesthetic.
> Each collection gets its own visually distinct section that expresses its unique character.
> Think Spotify: the player is neutral, but each playlist has its own world.

---

## 1. HERO SECTION (Neutral)

### Headline
**Your code has a soundtrack now.**

### Tagline
Sound notifications for Claude Code. Two iconic collections out of the box. Every commit, every test, every context warning -- heard, not missed.

### Sub-tagline (smaller, below fold)
Because the best notification is the one you don't have to look at.

### Visual note
Hero should show both collections side by side or a toggle/switcher that previews both vibes -- dark tactical on one side, bright playful on the other. The contrast IS the hook.

---

## 2. THE PROBLEM (Section: "The Gap") (Neutral)

### Headline
**You're not watching your terminal. Neither are we.**

### Body
You kicked off a Claude Code session. You switched to Slack. Or Figma. Or your phone. Ten minutes later you switch back and discover Claude finished seven minutes ago.

That's dead time. Every day.

Noisy Claude closes the loop. When Claude commits, you hear it. When tests fail, you hear it. When context hits 90% and your session is about to compress -- you *definitely* hear it.

No browser tabs. No menubar widgets. No polling. Just sound.

---

## 3. THE COLLECTIONS INTRO (Neutral)

### Headline
**Two vibes. Pick yours.**

### Body
Noisy Claude ships with two built-in sound collections. Each one transforms your entire experience -- the sounds, the UI, the feel of your coding session. Switch between them in one click. No reconfiguration.

Same events. Same control panel. Completely different world.

---

## 4. MGS COLLECTION SECTION (Dark, tactical, immersive -- its own visual world)

> **Visual treatment:** Dark background, amber/green accents, scanline texture,
> monospace type, radar/codec imagery. This section should feel like you stepped
> into Shadow Moses.

### Section label
COLLECTION 01

### Headline
**Tactical Espionage Audio.**

### Subtitle
124 sounds from Metal Gear Solid (PS1). Your coding session is a stealth mission.

### Intro
The codec rings. Session started. You're in.

Every tool call is a radar blip -- quick, sub-second, peripheral. You're in flow state, sneaking through Shadow Moses. The sounds don't interrupt. They orient.

### The Mission Arc

Git commit? Item pickup. That satisfying chime means progress is saved.

Git push? Area transition. Intel secured, moving to the next objective.

Tests pass? You sneaked past the guards. Clean.

Tests fail? The soft "?" sting. A guard heard something. Not game over -- just a heads up.

Plan mode? You ducked into the cardboard box. Time to think.

Context at 75%? Guards are searching. Evasion phase. Wrap up or refactor.

**Context at 90%? That sound. The "!" alert. You've been spotted. Handle it now.**

PR created? Mission milestone complete. The full fanfare.

10-commit streak? Boss defeated. Top operative.

Late night coding? "Get some rest." Even Snake needs sleep.

Session ends? "Good work, Snake." Mission debrief.

### Stats bar
- 124 sounds
- 8-bit mono WAV
- PS1 era
- 21 events enabled by default

### Closing
21 events enabled out of the box. Enough to feel the theme without notification fatigue. Enable more in the Control Panel for the full tactical experience.

All sounds are 8-bit mono WAV from the PS1 era. The lo-fi character is the point -- distinctive, nostalgic, and sharp enough to cut through any mix.

---

## 5. SIMS 2 COLLECTION SECTION (Light, warm, playful -- its own visual world)

> **Visual treatment:** Light/warm background, teal and plumbob green accents,
> rounded shapes, softer type, Sims diamond/plumbob motifs. This section should
> feel like you opened a different app entirely -- that's the point.

### Section label
COLLECTION 02

### Headline
**Sul sul! Your code is speaking Simlish.**

### Subtitle
140+ sounds from The Sims 2. Coding feels like managing a very productive household.

### Intro
A cheerful greeting. Session started. The household is awake.

Every tool call gets a little Simlish murmur -- the ambient chatter of a busy Sim going about their day. You're not debugging. You're just... improving the kitchen layout.

### The Household Arc

Git commit? An enthusiastic "Dag dag!" -- your Sim accomplished something.

Git push? Satisfied humming. The renovation is going well.

Tests pass? A bright, celebratory exclamation. Needs met. Mood bar: green.

Tests fail? Grumpy muttering. Someone stepped in a puddle. The plumber is coming.

Plan mode? Your Sim sat down to study. Thinking noises. Concentration face.

Context at 75%? Restless fidgeting. Needs are dropping. Time for a snack.

**Context at 90%? Full-on Simlish complaint. Your Sim is hungry, tired, and about to throw a tantrum. Save your work.**

PR created? House party. Everyone's dancing.

10-commit streak? Lifetime aspiration achieved. Platinum mood.

Late night coding? Yawning. Eye rubbing. Your Sim needs the "sleep" interaction.

Session ends? A warm goodbye. "Buh bye!" The household is at peace.

### Stats bar
- 140+ sounds
- Original Simlish audio
- The Sims 2 era
- The collection that started it all

### Closing
The original Noisy Claude collection. Warm, chaotic, and endlessly entertaining. Every sound is a genuine Simlish exclamation -- no two reactions are quite the same.

If MGS turns coding into a mission, Sims turns it into a life well lived.

---

## 6. THE SWITCH (Neutral, between or after both collection sections)

### Headline
**Switch vibes in one click. The whole UI follows.**

### Body
Both collections map to the same 40+ events. Swap between them instantly in the Control Panel dropdown. No remapping. No restart.

But it's not just the sounds that change. The entire control panel transforms. Switch to MGS and you get dark steel, green LEDs, tactical readouts. Switch to Sims and the UI goes light, bright, and playful -- dayglow colors, softer edges, a completely different feel.

Same tool. Same events. Same workflow. Completely different world.

Monday morning? Tactical espionage. Dark mode. Green indicators.
Friday afternoon? Simlish chaos. Light mode. Color everywhere.

Or bring your own sounds entirely.

### Visual note
This is the strongest demo moment on the site. Show the control panel switching themes in real time -- ideally an animated transition or a side-by-side before/after. The UI transformation sells the product more than any copy can.

---

## 7. FEATURE SECTIONS (Neutral, developer-tool aesthetic)

### 7A. The Control Panel

**Headline:** Your sounds. Your rules. Your aesthetic.

**Body:**
A control panel that adapts to your collection. MGS active? Dark steel, green LEDs, tactical readouts. Sims active? Light UI, dayglow colors, playful and warm. The interface matches the vibe of whatever you're listening to.

Toggle events. Swap sounds. Preview before you commit. Search, filter, bulk enable, bulk disable. Every sound has a human-readable label -- "Item pickup chime", "Oops!", "Guards searching" -- so you know what you'll hear without pressing play.

Pure HTML/CSS/JS. No build step. Runs on localhost:5050.

**Feature bullets:**
- Master power switch -- one click to silence everything, one click to restore
- Adaptive UI theme -- switches with your active collection
- Sound description labels -- know what every sound is at a glance
- 40+ event types across 10 categories
- Toggle any event on or off with one click
- Swap the sound for any event via dropdown
- Preview any sound before assigning it
- Search and filter events instantly
- Bulk actions: enable all, disable all, Claude Suggests

---

### 7B. Claude Suggests

**Headline:** Let Claude pick the sounds.

**Body:**
Click one button. Claude analyzes every sound filename against every event and picks opinionated, balanced defaults. Wins get celebrated. Failures get flagged. Noisy events get muted.

Smart defaults, not busy defaults.

---

### 7C. Focus Modes

**Headline:** Smart enough to shut up.

**Body:**
**Smart Mode** only plays sounds when your terminal isn't focused. If you're already staring at the output, you don't need a ping.

**Always Mode** plays every sound, every time. For when you want the full soundtrack.

---

### 7D. Master Power Switch

**Headline:** One switch. Instant silence.

**Body:**
You're on a call. Your teammate just screenshared. The client is in the room. You need every sound off, right now, without losing your carefully tuned event configuration.

Hit the master switch. Everything goes silent. The control panel dims. Your settings stay exactly where they are.

Hit it again. Everything comes back. Exactly as it was.

Cmd+Shift+M if your hands are already on the keyboard.

**UI note:**
Skeuomorphic hardware power switch in the control panel header. Visually distinct from the small LED event toggles. When powered off, the entire control panel drops to half opacity -- unmistakable at a glance.

---

### 7E. Bring Your Own Sounds

**Headline:** Any folder. Any sounds. One scan.

**Body:**
Point Noisy Claude at any folder of audio files. Click "Scan Folder." Click "Claude Suggests Mappings." Save. Done.

WAV, MP3, AIFF, M4A. Your sounds, your vibe, your rules.

---

## 8. EVENT CATEGORIES (Neutral, informational)

### Headline
**40+ events. 10 categories. Full coverage.**

### Body
Noisy Claude listens for everything Claude Code does and maps it to sound.

| Category | What it covers |
|----------|---------------|
| **Core** | Session start, session end, task completion |
| **Git** | Commits, pushes, PR creation, errors |
| **Testing** | Test passes, test failures |
| **Building** | Build completion, build errors |
| **Context** | Warnings at 50%, 75%, 90% usage |
| **Streaks** | 3, 5, 10 successes in a row |
| **Time of Day** | Morning, afternoon, evening, late night |
| **Agent/Teams** | Subagent lifecycle, team operations |
| **Thinking** | Short, medium, and long processing |
| **Skills** | /commit, /deploy, /publish invocations |

Enable what matters. Disable the noise. Every event is independently toggleable.

---

## 9. INSTALLATION SECTION (Neutral)

### Headline
**Three steps. Two minutes. All the sounds.**

### Step 1: Clone and install
```
git clone https://github.com/Tobybarnes/noisy-claude.git
pip3 install flask flask-cors
```
Pure Python + vanilla JS. No build step. No node_modules. No webpack.

### Step 2: Hook into Claude Code
Add Noisy Claude to your Claude Code hooks in `~/.claude/settings.json`. One config block, three hook points (PreToolUse, PostToolUse, Stop). Copy, paste, done.

### Step 3: Launch and pick a vibe
```
./launch-control-panel.sh
```
Open localhost:5050. Pick a collection. Start coding.

### Requirements footnote
macOS (uses afplay), Python 3, Flask. That's it.

---

## 10. CALL-TO-ACTION SECTIONS

### Primary CTA (end of page, neutral)
**Headline:** Your terminal is too quiet.

**Button text:** Get Noisy Claude

**Sub-text:** Free. Open source. Two sound packs included.

---

### Secondary CTA (between collection sections, neutral)
**Headline:** Pick a side. Or don't.

**Button text:** View on GitHub

**Sub-text:** Both collections included. Switch anytime.

---

### Tertiary CTA (floating/sticky)
**Button text:** Get Started

---

## 11. MICRO-COPY AND UI ELEMENTS

### Navigation labels
- Features
- Collections
- Install
- GitHub

### Collection switcher labels (used in interactive demo/toggle)
- MGS -- Tactical Espionage Audio
- SIMS 2 -- Simlish Sound System

### Feature badge text
- "124 PS1 SOUNDS"
- "140+ SIMLISH SOUNDS"
- "40+ EVENTS"
- "ZERO BUILD STEP"
- "macOS"
- "2 COLLECTIONS"

### Master power switch labels (control panel UI)
- ON state: "POWER" (with green LED glow)
- OFF state: "POWER" (LED dark, panel dimmed)
- Tooltip on hover: "Master switch -- silence all sounds instantly (Cmd+Shift+M)"
- Toast on power off: "All sounds muted. Your settings are preserved."
- Toast on power on: "Sounds restored."

### Tooltip / hover states
- "Hear it instead of checking for it"
- "Smart Mode: sounds only when you're away"
- "Every commit. Every test. Every warning."
- "Switch collections in one click"
- "One switch to silence everything"

### Footer tagline
Built for developers who alt-tab. Powered by nostalgia.

---

## 12. SOCIAL / SHARING COPY

### Open Graph title
Noisy Claude -- Your code has a soundtrack now.

### Open Graph description
Sound notifications for Claude Code. Ships with Metal Gear Solid and Sims 2 sound collections -- and the entire UI adapts to match. Every commit, test, and context warning gets its own sound. Free and open source.

### Twitter/X card
Your Claude Code sessions just got a soundtrack. Switch between Metal Gear Solid tactical mode and Simlish chaos -- the sounds AND the entire UI transform. Two collections, 40+ events, zero configuration. Free and open source.

---

## 13. TONE GUIDE (For the designer/developer building the site)

### Overall site voice
**Neutral, confident, developer-first.** The site framework doesn't pick a side between MGS and Sims. It's clean, modern, and lets each collection section carry its own personality.

### Section-specific tones

**Neutral sections** (hero, problem, features, install, CTAs):
- Direct and technical. Short sentences. Specific numbers.
- Think Vercel or Linear marketing pages -- clean, confident, no fluff.
- No gaming references in neutral sections. Let the product speak.

**MGS section:**
- Tactical, cinematic, terse. Military brevity.
- Present tense, second person. "The codec rings. You're in."
- Lean into the mission metaphor fully. It's immersive copy.
- Okay to be dramatic here -- the section earns it.

**Sims section:**
- Warm, playful, slightly chaotic. Domestic comedy.
- Present tense, second person. Same structure as MGS but opposite energy.
- Lean into the household/life-sim metaphor.
- Okay to be funny here -- Simlish is inherently absurd.

### Rhythm
Short sentences. Fragments are fine. Let the copy breathe. One idea per line where possible.

### Technical credibility
Drop specific numbers (124 sounds, 140+ sounds, 40+ events, 8-bit mono WAV, PS1 era, localhost:5050). Developers trust specifics over adjectives.

### The contrast is the feature
The most compelling thing about Noisy Claude is that switching collections transforms *everything* -- not just the sounds, but the entire UI. The control panel goes from dark tactical steel to bright playful Sims aesthetic. The site should make that contrast visceral. Show the theme switch. Make it the centerpiece demo. Same tool, wildly different world.

### What to avoid
- "Revolutionary" / "game-changing" / "leverage" / "unlock"
- Exclamation marks (the copy should be confident, not excited)
- Lengthy paragraphs -- if it's more than 3 lines, break it up
- Explaining what sound notifications are -- the audience gets it instantly
- Favoring one collection over the other in neutral sections
- Gaming jargon in the neutral framework sections

---

## 14. PAGE FLOW SUMMARY

1. **Hero** (neutral) -- headline + tagline + split visual showing both vibes
2. **The Problem** (neutral) -- "you're not watching your terminal"
3. **Collections Intro** (neutral) -- "Two vibes. Pick yours."
4. **MGS Section** (dark, tactical) -- full narrative, mission arc, immersive
5. **The Switch** (neutral) -- "Switch vibes in one click"
6. **Sims Section** (light, playful) -- full narrative, household arc, charming
7. **Features** (neutral) -- control panel, Claude Suggests, focus modes
8. **Event Categories** (neutral) -- the full table
9. **Bring Your Own Sounds** (neutral) -- custom collections
10. **Installation** (neutral) -- three steps
11. **Final CTA** (neutral) -- "Your terminal is too quiet"
12. **Footer** (neutral) -- links, tagline, credits

### Flow rationale
The two collection sections are sandwiched between neutral sections, with "The Switch" as a palate cleanser between them. This lets each collection section be fully immersive in its own aesthetic without the site committing to either one. The neutral framework holds it all together.
