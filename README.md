# Noisy Claude v2.0

Sound notifications for Claude Code. Every tool call, git commit, test result, and context warning gets its own sound. Switch between sound collections to match your mood.

## Quick Start

```bash
# Launch the control panel
~/.noisy-claude/noisy-claude.sh --control-panel

# Or use the launcher directly
~/.noisy-claude/launch-control-panel.sh
```

Then open **http://localhost:5050** in your browser.

## Sound Collections

Noisy Claude ships with two built-in collections. Switch between them in the Control Panel dropdown or by setting `"active_collection"` in `config.json`.

---

### MGS Collection -- Tactical Espionage Audio

**124 sounds** from Metal Gear Solid (PS1). Every coding session becomes a stealth mission.

Your coding session *is* a Metal Gear operation. The codec rings when you start. Flow state is sneaking through Shadow Moses. Git commits are item pickups. And when your context hits 90%... you hear *that* sound. You know the one.

**The Mission Arc:**

A typical session plays out like an MGS mission:

| Phase | What Happens | Sound | MGS Equivalent |
|-------|-------------|-------|----------------|
| Mission briefing | Session starts | `0x1a.wav` | Codec call rings in |
| Stealth ops | Tools running quietly | `0x4F.wav` | Radar blip (35ms) |
| Secure intel | Git commit | `0x67.wav` | Item pickup chime |
| Move to next area | Git push | `0x09.wav` | Area transition |
| All clear | Tests pass | `0x73.wav` | Sneaked past the guards |
| Spotted (soft) | Tests fail | `0x15.wav` | "?" -- guard heard something |
| Cardboard box | Enter plan mode | `0x40.wav` | Hiding to think |
| Call support | Subagent launches | `0x06.wav` | Codec frequency dial |
| Evasion phase | Context at 75% | `0x0D.wav` | Guards searching |
| ALERT | Context at 90% | `0x01.wav` | "!" -- you've been spotted |
| Objective complete | PR created | `0x44.wav` | Mission milestone |
| Boss defeated | 10-streak | `0x5D.wav` | Top operative |
| Get some rest | Late night coding | `0x3A.wav` | Even Snake needs sleep |
| Mission debrief | Session ends | `0x41.wav` | "Good work, Snake." |

**Sound design philosophy:**
- **Frequent events** (tool use, thinking) use sub-second blips -- the quiet hum of a well-oiled operation
- **Milestones** (commits, test passes) use short, satisfying pickup sounds
- **Big wins** (PRs, streaks, deploys) get the full mission-complete treatment
- **Warnings** escalate like MGS alert phases: Evasion at 75%, full Alert at 90%
- **Failures** use the soft "?" caution sting, not the full "!" -- you've been noticed, but it is not game over

**21 events enabled by default.** Enough to feel the theme without notification fatigue. The high-frequency events (tool_success, thinking, agent_response) are disabled out of the box. Enable them in the Control Panel if you want the full tactical experience.

All sounds are 8-bit mono WAV from the PS1 era. The lo-fi character is a feature: distinctive, nostalgic, and clean enough to cut through any ambient noise.

**Tuning notes:** The session_start codec ring runs 4 seconds (worth it for the opening moment). Some sounds share the same file across events. Volume levels vary slightly between files due to the PS1 source material. All of these can be tuned via the Control Panel -- swap any sound, adjust which events are enabled, or preview before committing.

```bash
# Switch to MGS
# In config.json, set: "active_collection": "mgs"
# Or use the Control Panel dropdown

# Preview the alert sound
noisy-claude.sh --play 0x01.wav
```

---

### Sims 2 Collection -- The Original

**140+ sounds** from The Sims 2. The collection that started it all. Simlish exclamations for every occasion -- cheerful celebrations, grumpy failures, and everything in between. A warm, playful vibe that makes coding feel like managing a very productive household.

```bash
# Switch to Sims 2
# In config.json, set: "active_collection": "default"
```

---

### Adding Your Own Collection

Any folder of audio files can be a collection. See [COLLECTIONS.md](COLLECTIONS.md) for details.

1. Put sound files (WAV/MP3/AIFF/M4A) in a folder
2. Open the Control Panel
3. Click "Add Collection" and enter the folder path
4. Click "Scan Folder" to verify, then "Claude Suggests Mappings" for automatic assignments
5. Save and switch to your new collection

## Features

### Event Management
- **Toggle events on/off** with switches
- **Change sounds** for each event with dropdown selectors
- **Preview sounds** with the play button
- **Search events** with the search box
- **Bulk actions**: Enable All / Disable All

### Claude Suggests
Click "Claude Suggests" for smart, opinionated defaults:
- Celebrates wins (commits, PR creation, test passes)
- Warns on problems (errors, failures, late-night coding)
- Disables noisy events that fire too frequently

### Focus Modes
- **Smart Mode**: Only plays sounds when you're focused elsewhere (not in terminal/editor)
- **Always Mode**: Always plays sounds regardless of focus

## Event Categories

| Category | Events | Notes |
|----------|--------|-------|
| **Core** | Session start/end, task completion, permissions | Session bookends |
| **Git** | Commits, pushes, PR creation, errors | Your deployment pipeline |
| **Testing** | Test passes, test failures | The moment of truth |
| **Building** | Build completion, build errors | Compilation feedback |
| **Context** | Alerts at 50%, 75%, 90% usage | Manage long sessions |
| **Streaks** | 3, 5, 10 successes in a row | Reward consistency |
| **Time of Day** | Morning, afternoon, evening, late night | Session awareness |
| **Agent/Teams** | Subagent lifecycle, team ops, messages | Multi-agent workflows |
| **Thinking** | Short (<5s), medium (5-15s), long (>15s) | Processing indicators |
| **Skills** | /commit, /newday, /publish, /deploy, /gsd | Skill invocations |

## Commands

```bash
# Launch control panel
noisy-claude.sh --control-panel

# Check status (shows active collection)
noisy-claude.sh --status

# Set focus mode
noisy-claude.sh --always
noisy-claude.sh --smart

# List all sounds from active collection
noisy-claude.sh --list-sounds

# Play a sound from active collection
noisy-claude.sh --play 0x01.wav
```

## Architecture

- **Frontend**: Pure HTML/CSS/JavaScript (no build step)
- **Backend**: Python Flask server
- **Config**: `~/.noisy-claude/config.json`
- **Sounds**: `~/.noisy-claude/sounds/`

## Requirements

- Python 3
- Flask (auto-installed on first launch)
- macOS (uses `afplay` for sound playback)

## Pro Tips

1. **Try the MGS collection** -- The context_90 alert sound alone is worth the switch
2. **Use Smart Mode** -- Prevents notification fatigue when you're focused
3. **Disable noisy events** -- `tool_success` and thinking events fire very frequently
4. **Celebrate wins** -- Keep git operations and test passes enabled for dopamine hits
5. **Context warnings** -- Keep 75% and 90% enabled to manage long sessions
6. **The cardboard box** -- `plan_mode_enter` with MGS sounds is a hidden gem

## Customization

Edit `config.json` directly or use the web UI:

```json
{
  "version": "2.0",
  "focus_mode": "always",
  "active_collection": "mgs",
  "collections": {
    "mgs": {
      "name": "MGS Sounds",
      "path": "/path/to/sounds/MGS",
      "description": "Metal Gear Solid game sounds - tactical espionage audio"
    }
  },
  "events": {
    "session_start": {
      "enabled": true,
      "sound": "0x1a.wav",
      "description": "When Claude Code session starts"
    }
  }
}
```

## Troubleshooting

**Control panel won't start:**
- Make sure Python 3 is installed: `python3 --version`
- Check if port 5050 is available: `lsof -i :5050`

**Sounds not playing:**
- Check focus mode setting
- Test sound playback: `afplay ~/.noisy-claude/sounds/MGS/0x01.wav`
- Verify system volume is up

**Events not triggering:**
- Check that the event is enabled in config
- Verify hooks are configured in `~/.claude/settings.json`
- Check that noisy-claude.sh is being called from hooks

## Version

Noisy Claude v2.0 with Control Panel and Collections
