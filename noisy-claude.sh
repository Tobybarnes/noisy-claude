#!/usr/bin/env bash
# noisy-claude.sh — Sound feedback for Claude Code v2.0
set -euo pipefail

VERSION="2.0"
NOISY_CLAUDE_DIR="${NOISY_CLAUDE_DIR:-$HOME/.noisy-claude}"
CONFIG_FILE="$NOISY_CLAUDE_DIR/config.json"
PID_FILE="$NOISY_CLAUDE_DIR/.afplay.pid"
DETECT_SCRIPT="$NOISY_CLAUDE_DIR/detect-event.sh"

# CLI commands
case "${1:-}" in
  --version) echo "noisy-claude v$VERSION"; exit 0 ;;
  --help|-h) echo "noisy-claude v$VERSION"; echo "Docs: https://github.com/Tobybarnes/noisy-claude"; exit 0 ;;
  --always) python3 -c "
import json, os
p = os.path.join(os.environ.get('NOISY_CLAUDE_DIR', os.path.expanduser('~/.noisy-claude')), 'config.json')
with open(p) as f: c = json.load(f)
c['focus_mode'] = 'always'
with open(p,'w') as f: json.dump(c,f,indent=2); f.write('\\n')
print('Focus mode: always')
"; exit 0 ;;
  --smart) python3 -c "
import json, os
p = os.path.join(os.environ.get('NOISY_CLAUDE_DIR', os.path.expanduser('~/.noisy-claude')), 'config.json')
with open(p) as f: c = json.load(f)
c['focus_mode'] = 'smart'
with open(p,'w') as f: json.dump(c,f,indent=2); f.write('\\n')
print('Focus mode: smart')
"; exit 0 ;;
  --mute) python3 -c "
import json, os
p = os.path.join(os.environ.get('NOISY_CLAUDE_DIR', os.path.expanduser('~/.noisy-claude')), 'config.json')
with open(p) as f: c = json.load(f)
c['master_enabled'] = False
with open(p,'w') as f: json.dump(c,f,indent=2); f.write('\n')
print('Master power: OFF (all sounds muted)')
"; exit 0 ;;
  --unmute) python3 -c "
import json, os
p = os.path.join(os.environ.get('NOISY_CLAUDE_DIR', os.path.expanduser('~/.noisy-claude')), 'config.json')
with open(p) as f: c = json.load(f)
c['master_enabled'] = True
with open(p,'w') as f: json.dump(c,f,indent=2); f.write('\n')
print('Master power: ON (sounds active)')
"; exit 0 ;;
  --status) python3 -c "
import json, os
p = os.path.join(os.environ.get('NOISY_CLAUDE_DIR', os.path.expanduser('~/.noisy-claude')), 'config.json')
with open(p) as f: c = json.load(f)
m = c.get('focus_mode','smart')
v = c.get('version','1.0')
master = c.get('master_enabled', True)
active = c.get('active_collection', 'default')
collections = c.get('collections', {})

print(f'noisy-claude v{v}')
print(f'Master power: {\"ON\" if master else \"OFF (muted)\"}')
print(f'Focus mode: {m}')
print(f'\\nActive collection: {active}')
if active in collections:
    coll = collections[active]
    print(f'  Name: {coll.get(\"name\", \"Unknown\")}')
    print(f'  Path: {coll.get(\"path\", \"Unknown\")}')
    if coll.get('description'):
        print(f'  Description: {coll.get(\"description\")}')

print(f'\\nTotal collections: {len(collections)}')
for cid, coll in collections.items():
    marker = '→' if cid == active else ' '
    print(f'  {marker} {cid}: {coll.get(\"name\", \"Unknown\")}')

# Get events from active collection (new structure) or top-level (old structure)
if active in collections and 'events' in collections[active]:
    events = collections[active]['events']
else:
    events = c.get('events', {})

print('\\nEnabled events:')
for n,e in events.items():
    if e.get('enabled'):
        s = e.get('sound','none')
        d = e.get('description','')
        print(f'  ✓ {n:20} → {s:25} # {d}')
print('\\nDisabled events:')
for n,e in events.items():
    if not e.get('enabled'):
        s = e.get('sound','none')
        d = e.get('description','')
        print(f'  ✗ {n:20} → {s:25} # {d}')
"; exit 0 ;;
  --list-sounds)
    python3 -c "
import json, os
p = os.path.join(os.environ.get('NOISY_CLAUDE_DIR', os.path.expanduser('~/.noisy-claude')), 'config.json')
with open(p) as f: config = json.load(f)
active = config.get('active_collection', 'default')
collections = config.get('collections', {})
if active in collections:
    sounds_path = collections[active]['path']
else:
    sounds_path = os.path.join(os.environ.get('NOISY_CLAUDE_DIR', os.path.expanduser('~/.noisy-claude')), 'sounds')
import pathlib
for f in sorted(pathlib.Path(sounds_path).glob('*')):
    if f.suffix in ['.wav', '.mp3', '.aiff', '.m4a']:
        print(f.name)
"; exit 0 ;;
  --play)
    if [ -z "${2:-}" ]; then
      echo "Usage: noisy-claude.sh --play <sound-file>"
      exit 1
    fi
    read -r SOUND_PATH VOLUME <<< $(python3 -c "
import json, os
p = os.path.join(os.environ.get('NOISY_CLAUDE_DIR', os.path.expanduser('~/.noisy-claude')), 'config.json')
with open(p) as f: config = json.load(f)
active = config.get('active_collection', 'default')
collections = config.get('collections', {})
if active in collections:
    sounds_path = collections[active]['path']
else:
    sounds_path = os.path.join(os.environ.get('NOISY_CLAUDE_DIR', os.path.expanduser('~/.noisy-claude')), 'sounds')
volume_percent = config.get('volume', 100)
print(os.path.join(sounds_path, '$2'), volume_percent / 100.0)
")
    afplay -v "$VOLUME" "$SOUND_PATH"
    exit 0
    ;;
  --control-panel|--ui|--config)
    echo "🌐 Launching Noisy Claude Control Panel..."
    exec "$NOISY_CLAUDE_DIR/launch-control-panel.sh"
    ;;
esac

# Read hook input
INPUT=$(cat)

# Detect events using the detect-event script
if [ ! -f "$DETECT_SCRIPT" ]; then
  # Fall back to original behavior
  EVENT=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('hook_event_name',''))" 2>/dev/null) || exit 0
  case "$EVENT" in
    SessionStart)  EVENTS="session_start" ;;
    Stop)          EVENTS="task_complete" ;;
    Notification)  EVENTS="permission" ;;
    *)             exit 0 ;;
  esac
else
  EVENTS=$(echo "$INPUT" | "$DETECT_SCRIPT") || exit 0
fi

if [ -z "$EVENTS" ]; then
  exit 0
fi

if [ ! -f "$CONFIG_FILE" ]; then exit 1; fi

# Update activity timestamp for idle monitor
touch "$NOISY_CLAUDE_DIR/.last_activity" 2>/dev/null || true

# Check master power switch
MASTER_ENABLED=$(python3 -c "
import json
with open('$CONFIG_FILE') as f: config = json.load(f)
print(config.get('master_enabled', True))
" 2>/dev/null) || MASTER_ENABLED="True"

if [ "$MASTER_ENABLED" != "True" ]; then exit 0; fi

# Get volume setting
VOLUME=$(python3 -c "
import json
with open('$CONFIG_FILE') as f: config = json.load(f)
volume_percent = config.get('volume', 100)
# Convert 0-100 to 0.0-1.0 for afplay
print(volume_percent / 100.0)
" 2>/dev/null) || VOLUME="1.0"

# Get focus mode
FOCUS_MODE=$(python3 -c "
import sys, json
with open('$CONFIG_FILE') as f: config = json.load(f)
print(config.get('focus_mode', 'smart'))
" 2>/dev/null) || FOCUS_MODE="smart"

# Check focus mode
if [ "$FOCUS_MODE" = "smart" ]; then
  FRONTMOST=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true' 2>/dev/null) || FRONTMOST=""
  case "$FRONTMOST" in
    Terminal|iTerm*|Alacritty|kitty|WezTerm|Ghostty|Hyper|Warp|Rio|Tabby|Code|Cursor|Zed|Windsurf) exit 0 ;;
  esac
fi

# Play sound for each detected event
while IFS= read -r EVENT; do
  [ -z "$EVENT" ] && continue

  # Get event config and active collection path
  read -r ENABLED SOUND_FILE SOUNDS_DIR_PATH <<< $(python3 -c "
import sys, json, os
with open('$CONFIG_FILE') as f: config = json.load(f)

# Get active collection
active = config.get('active_collection', 'default')
collections = config.get('collections', {})

# Get event from active collection's events (new structure) or fallback to top-level (old structure)
if active in collections and 'events' in collections[active]:
    event = collections[active]['events'].get('$EVENT', {})
else:
    event = config.get('events', {}).get('$EVENT', {})

# Get active collection path
if active in collections:
    sounds_path = collections[active]['path']
else:
    sounds_path = os.path.join(os.environ.get('NOISY_CLAUDE_DIR', os.path.expanduser('~/.noisy-claude')), 'sounds')

print(event.get('enabled', False), event.get('sound', ''), sounds_path)
" 2>/dev/null) || continue

  if [ "$ENABLED" != "True" ]; then continue; fi
  if [ -z "$SOUND_FILE" ]; then continue; fi

  SOUND_PATH="$SOUNDS_DIR_PATH/$SOUND_FILE"
  if [ ! -f "$SOUND_PATH" ]; then continue; fi

  # Kill any existing sound
  if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE" 2>/dev/null) || true
    if [ -n "$OLD_PID" ] && kill -0 "$OLD_PID" 2>/dev/null; then
      kill "$OLD_PID" 2>/dev/null || true
    fi
    rm -f "$PID_FILE"
  fi

  # Play sound with volume
  export NOISY_CLAUDE_DIR
  nohup afplay -v "$VOLUME" "$SOUND_PATH" >/dev/null 2>&1 &
  AFPLAY_PID=$!
  echo "$AFPLAY_PID" > "$PID_FILE"
  disown "$AFPLAY_PID" 2>/dev/null || true

  # Small delay between sounds if multiple events
  sleep 0.1
done <<< "$EVENTS"

exit 0
