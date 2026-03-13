#!/usr/bin/env bash
# idle-monitor.sh - Plays gentle reminder sound after 10 minutes of inactivity
set -euo pipefail

NOISY_CLAUDE_DIR="${NOISY_CLAUDE_DIR:-$HOME/.noisy-claude}"
CONFIG_FILE="$NOISY_CLAUDE_DIR/config.json"
TIMESTAMP_FILE="$NOISY_CLAUDE_DIR/.last_activity"
IDLE_MINUTES=10

# Get idle reminder sound from config
get_idle_sound() {
    python3 -c "
import json, os
with open('$CONFIG_FILE') as f: config = json.load(f)
active = config.get('active_collection', 'default')
collections = config.get('collections', {})

# Get idle event if configured
if active in collections and 'events' in collections[active]:
    event = collections[active]['events'].get('idle_reminder', {})
else:
    event = config.get('events', {}).get('idle_reminder', {})

if event.get('enabled'):
    if active in collections:
        sounds_path = collections[active]['path']
    else:
        sounds_path = os.path.join(os.environ.get('NOISY_CLAUDE_DIR', os.path.expanduser('~/.noisy-claude')), 'sounds')

    sound_file = event.get('sound', '')
    if sound_file:
        print(os.path.join(sounds_path, sound_file))
" 2>/dev/null
}

# Get volume
get_volume() {
    python3 -c "
import json
with open('$CONFIG_FILE') as f: config = json.load(f)
print(config.get('volume', 100) / 100.0)
" 2>/dev/null || echo "1.0"
}

# Check if master power is on
check_master_power() {
    python3 -c "
import json
with open('$CONFIG_FILE') as f: config = json.load(f)
print(config.get('master_enabled', True))
" 2>/dev/null || echo "True"
}

# Update last activity timestamp
touch "$TIMESTAMP_FILE"

# Monitor loop
while true; do
    sleep 60  # Check every minute

    # Skip if master power is off
    MASTER_ENABLED=$(check_master_power)
    if [ "$MASTER_ENABLED" != "True" ]; then
        continue
    fi

    # Check time since last activity
    if [ -f "$TIMESTAMP_FILE" ]; then
        LAST_ACTIVITY=$(stat -f %m "$TIMESTAMP_FILE" 2>/dev/null || stat -c %Y "$TIMESTAMP_FILE" 2>/dev/null)
        NOW=$(date +%s)
        IDLE_SECONDS=$((NOW - LAST_ACTIVITY))
        IDLE_THRESHOLD=$((IDLE_MINUTES * 60))

        # If idle for more than threshold, play sound
        if [ $IDLE_SECONDS -ge $IDLE_THRESHOLD ]; then
            SOUND_PATH=$(get_idle_sound)
            if [ -n "$SOUND_PATH" ] && [ -f "$SOUND_PATH" ]; then
                VOLUME=$(get_volume)
                afplay -v "$VOLUME" "$SOUND_PATH" &

                # Reset timestamp to avoid repeating too soon
                touch "$TIMESTAMP_FILE"
            fi
        fi
    fi
done
