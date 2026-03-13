#!/usr/bin/env bash
# quick-ping.sh — Claude Code hook script v1.0
set -euo pipefail

VERSION="1.0"
QUICK_PING_DIR="${QUICK_PING_DIR:-$HOME/.quick-ping}"
CONFIG_FILE="$QUICK_PING_DIR/config.json"
PID_FILE="$QUICK_PING_DIR/.afplay.pid"

case "${1:-}" in
  --version) echo "quick-ping v$VERSION"; exit 0 ;;
  --help|-h) echo "quick-ping v$VERSION"; echo "Docs: https://github.com/Tobybarnes/noisy-claude"; exit 0 ;;
  --always) python3 -c "
import json, os
p = os.path.join(os.environ.get('QUICK_PING_DIR', os.path.expanduser('~/.noisy-claude')), 'config.json')
with open(p) as f: c = json.load(f)
c['focus_mode'] = 'always'
with open(p,'w') as f: json.dump(c,f,indent=2); f.write('\\n')
print('Focus mode: always')
"; exit 0 ;;
  --smart) python3 -c "
import json, os
p = os.path.join(os.environ.get('QUICK_PING_DIR', os.path.expanduser('~/.noisy-claude')), 'config.json')
with open(p) as f: c = json.load(f)
c['focus_mode'] = 'smart'
with open(p,'w') as f: json.dump(c,f,indent=2); f.write('\\n')
print('Focus mode: smart')
"; exit 0 ;;
  --status) python3 -c "
import json, os
p = os.path.join(os.environ.get('QUICK_PING_DIR', os.path.expanduser('~/.noisy-claude')), 'config.json')
with open(p) as f: c = json.load(f)
m = c.get('focus_mode','smart')
print(f'quick-ping v${VERSION}')
print(f'Focus mode: {m}')
for n,e in c.get('events',{}).items():
    print(f'  {n}: {\'on\' if e.get(\'enabled\') else \'off\'} ({e.get(\'sound\',\'none\')})')
"; exit 0 ;;
esac

INPUT=$(cat)
EVENT=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('hook_event_name',''))" 2>/dev/null) || exit 0

case "$EVENT" in
  SessionStart)        CONFIG_KEY="session_start" ;;
  SessionEnd)          CONFIG_KEY="session_end" ;;
  Stop)                CONFIG_KEY="task_complete" ;;
  Notification)        CONFIG_KEY="permission" ;;
  SubagentStart)       CONFIG_KEY="subagent_start" ;;
  SubagentStop)        CONFIG_KEY="subagent_stop" ;;
  PostToolUse)         CONFIG_KEY="tool_success" ;;
  PostToolUseFailure)  CONFIG_KEY="tool_failure" ;;
  PreToolUse)          CONFIG_KEY="tool_pre" ;;
  *)                   exit 0 ;;
esac

if [ ! -f "$CONFIG_FILE" ]; then exit 1; fi

read -r ENABLED SOUND_FILE FOCUS_MODE <<< $(python3 -c "
import sys, json
with open('$CONFIG_FILE') as f: config = json.load(f)
event = config.get('events', {}).get('$CONFIG_KEY', {})
print(event.get('enabled', False), event.get('sound', ''), config.get('focus_mode', 'smart'))
" 2>/dev/null) || exit 0

if [ "$ENABLED" != "True" ]; then exit 0; fi

SOUND_PATH="$QUICK_PING_DIR/sounds/$SOUND_FILE"
if [ ! -f "$SOUND_PATH" ]; then exit 0; fi

if [ "$FOCUS_MODE" = "smart" ]; then
  FRONTMOST=$(osascript -e 'tell application "System Events" to get name of first process whose frontmost is true' 2>/dev/null) || FRONTMOST=""
  case "$FRONTMOST" in
    Terminal|iTerm*|Alacritty|kitty|WezTerm|Ghostty|Hyper|Warp|Rio|Tabby|Code|Cursor|Zed|Windsurf) exit 0 ;;
  esac
fi

if [ -f "$PID_FILE" ]; then
  OLD_PID=$(cat "$PID_FILE" 2>/dev/null) || true
  if [ -n "$OLD_PID" ] && kill -0 "$OLD_PID" 2>/dev/null; then kill "$OLD_PID" 2>/dev/null || true; fi
  rm -f "$PID_FILE"
fi

export QUICK_PING_DIR
nohup afplay "$SOUND_PATH" >/dev/null 2>&1 &
AFPLAY_PID=$!
echo "$AFPLAY_PID" > "$PID_FILE"
disown "$AFPLAY_PID" 2>/dev/null || true
exit 0
