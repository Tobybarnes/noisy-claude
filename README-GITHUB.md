# Noisy Claude 🎚️

**Professional audio rack-style sound notification system for Claude Code**

A dark steel, hardware-inspired control panel for managing sound events in Claude Code. Think SSL console meets OP-1 synthesizer meets Dieter Rams minimalism.

![Noisy Claude](https://via.placeholder.com/800x400/1A1A1A/00FF00?text=Noisy Claude+2+Control+Panel)

## Features

### 🎛️ Audio Equipment Aesthetic
- **Dark steel theme** - Gunmetal gray (#1A1A1A) professional look
- **Bright green LEDs** - Hardware rack-style power indicators with steel bezels
- **IBM Plex Mono** - Technical readout typography
- **Tight 4px spacing** - Precision grid system
- **Minimal design** - No decoration, pure function (Dieter Rams approved)

### 📚 Collections System
- **Multiple sound libraries** - Manage different sound packs
- **Easy switching** - Change entire library with one click
- **Smart scanning** - Auto-detect audio files in any folder
- **AI-powered mapping** - Claude suggests sound-to-event assignments based on filenames
- **Theme support** - Different collections for different moods/contexts

### 🎵 Event Management
- **40+ event types** - Git operations, tests, builds, teams, streaks, time-of-day
- **Toggle on/off** - Simple checkboxes (not iOS-style pills)
- **Sound selection** - Dropdown per event
- **Preview playback** - Test sounds before assigning
- **Bulk actions** - Enable/disable all at once
- **Search & filter** - Find events quickly

### ✨ Claude Suggests
AI-powered smart recommendations:
- Balances useful notifications vs. noise
- Celebrates wins (commits, PRs, test passes)
- Warns on problems (errors, failures)
- Disables noisy events (tool_success fires too often)

### 🎯 Focus Modes
- **Smart Mode** - Only plays sounds when you're not focused in terminal/editor
- **Always Mode** - Always plays sounds regardless of focus

## Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/noisy-claude.git ~/ep/projects/noisy-claude

# Install dependencies (Flask for control panel)
pip3 install flask flask-cors

# Put sound files in the sounds/ directory
# (WAV, MP3, AIFF, M4A formats supported)

# Launch the control panel
~/ep/projects/noisy-claude/launch-control-panel.sh
```

Open http://localhost:5050 in your browser

### Integrate with Claude Code

Add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": ".*",
      "hooks": [{
        "type": "command",
        "command": "/Users/yourusername/ep/projects/noisy-claude/noisy-claude.sh",
        "async": true,
        "timeout": 5
      }]
    }],
    "PostToolUse": [{
      "matcher": ".*",
      "hooks": [{
        "type": "command",
        "command": "/Users/yourusername/ep/projects/noisy-claude/noisy-claude.sh",
        "async": true,
        "timeout": 5
      }]
    }],
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "/Users/yourusername/ep/projects/noisy-claude/noisy-claude.sh",
        "async": true,
        "timeout": 5
      }]
    }]
  }
}
```

## Usage

### Command Line

```bash
# Launch control panel
noisy-claude.sh --control-panel

# Check status (shows collections, events)
noisy-claude.sh --status

# Set focus mode
noisy-claude.sh --always
noisy-claude.sh --smart

# List sounds from active collection
noisy-claude.sh --list-sounds

# Play a sound
noisy-claude.sh --play mGREETING.wav
```

### Adding Sound Collections

1. Click "Add Collection" in the control panel
2. Enter collection name (e.g., "Retro Games")
3. Enter folder path (e.g., `/Users/you/sounds/retro`)
4. Click "Scan Folder" to detect audio files
5. Click "Claude Suggests Mappings" for AI-powered assignments
6. Save and switch between collections via dropdown

### Event Categories

- **Core Events**: Session start/end, task complete, permissions
- **Git Operations**: Commits, pushes, PR creation, errors
- **Testing & Building**: Test pass/fail, build complete/error
- **Agent & Teams**: Subagent lifecycle, team operations
- **Performance**: Long tasks, error thresholds, background tasks
- **Context Usage**: Alerts at 50%, 75%, 90% context
- **Streaks**: 3, 5, 10 successful operations in a row
- **Time of Day**: Morning, afternoon, evening, late night
- **Skills**: Sounds for /commit, /newday, /publish, etc.

## Design Philosophy

> **"Less, but better"** — Dieter Rams

Noisy Claude follows **Teenage Engineering × Dieter Rams** design principles:

### Rams' 10 Principles Applied
1. ✅ **Innovative** - Modern web tech, minimal JavaScript
2. ✅ **Useful** - Every element serves a purpose
3. ✅ **Aesthetic** - Beauty through precision and restraint
4. ✅ **Understandable** - No manual needed
5. ✅ **Unobtrusive** - Interface recedes, function comes forward
6. ✅ **Honest** - No false affordances
7. ✅ **Long-lasting** - Timeless aesthetic, will work in 10 years
8. ✅ **Thorough** - Perfect alignment, accessibility
9. ✅ **Environmental** - Minimal bundle size, semantic HTML
10. ✅ **Minimal** - Removed everything until it broke

### Visual References
- **OP-1 Field** - High-contrast OLED, all-caps labels
- **TX-6 Mixer** - Modular sections, LED indicators
- **SSL Console** - Dark studio equipment aesthetic
- **Braun ET66** - Perfect grid system
- **606 Shelving** - Timeless modularity

## Architecture

```
noisy-claude/
├── control-panel.html          # Web UI (dark steel, green LEDs)
├── control-panel-server.py     # Flask API backend
├── launch-control-panel.sh     # Server launcher
├── noisy-claude.sh           # Enhanced hook script (collections support)
├── detect-event.sh            # Smart event detection
├── config.json                # Configuration (events, collections, settings)
├── sounds/                    # Default sound collection
├── README.md                  # Documentation
├── COLLECTIONS.md             # Collections system guide
└── IMPLEMENTATION_SUMMARY.md  # Technical details
```

## Configuration

`config.json` structure:

```json
{
  "version": "2.0",
  "focus_mode": "always",
  "active_collection": "default",
  "collections": {
    "default": {
      "name": "Sims Sounds",
      "path": "/Users/you/ep/projects/noisy-claude/sounds",
      "description": "Original Sims game sounds"
    }
  },
  "events": {
    "git_commit": {
      "enabled": true,
      "sound": "Good Shot M.wav",
      "description": "When a git commit succeeds"
    }
  }
}
```

## Requirements

- **macOS** (uses `afplay` for sound playback)
- **Python 3** (for Flask server)
- **Flask** + **flask-cors** (auto-installed on first launch)
- **Claude Code** (for hook integration)
- **Audio files** (WAV, MP3, AIFF, M4A)

## API Endpoints

The control panel exposes a REST API:

- `GET /api/config` - Get full configuration
- `POST /api/config` - Update configuration
- `GET /api/sounds` - List sounds from active collection
- `POST /api/play-sound` - Play a sound
- `GET /api/collections` - List all collections
- `POST /api/collections` - Add new collection
- `PUT /api/collections/active` - Set active collection
- `POST /api/collections/scan` - Scan folder for audio files
- `POST /api/collections/suggest` - Get AI-powered mappings
- `GET /api/claude-suggests` - Get smart event recommendations

## Accessibility

- **WCAG AAA compliant** - High contrast, semantic HTML
- **Keyboard navigation** - Full tab order, keyboard shortcuts
- **Screen reader support** - ARIA labels, live regions
- **Focus indicators** - Visible focus states on all interactive elements
- **Shortcuts**: Cmd+S (save), Cmd+F (search)

## Credits

**Design Inspiration:**
- Dieter Rams (Braun design philosophy)
- Teenage Engineering (OP-1, TX-6, OB-4)
- SSL/Neve (Professional audio equipment)
- Ableton Live (Dark theme UI)

**Created for:**
Claude Code sound notification system

## License

MIT License - See LICENSE file for details

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly (accessibility, cross-browser)
5. Submit a pull request

Design changes should follow Rams/TE aesthetic principles.

## Changelog

### v2.0 (Current)
- Collections system with multi-library support
- AI-powered filename-to-event mapping
- Dark steel theme with green LEDs
- Tight 4px spacing grid
- Complete Dieter Rams redesign
- Enhanced accessibility (WCAG AAA)
- Smart event detection
- 40+ event types

### v1.0 (Original)
- Basic sound notification system
- Single sound library
- Light theme
- Basic event handling

---

**"Weniger, aber besser"** — Less, but better.
