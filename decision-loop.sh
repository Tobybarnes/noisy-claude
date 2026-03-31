#!/usr/bin/env bash
# decision-loop.sh — Repeating alert while Claude awaits a decision

NOISY_CLAUDE_DIR="${NOISY_CLAUDE_DIR:-$HOME/.noisy-claude}"
CONFIG_FILE="$NOISY_CLAUDE_DIR/config.json"
LOOP_PID_FILE="$NOISY_CLAUDE_DIR/.decision-loop.pid"
DAEMON_SCRIPT="$NOISY_CLAUDE_DIR/decision-loop-daemon.py"

stop_loop() {
    if [ -f "$LOOP_PID_FILE" ]; then
        PID=$(cat "$LOOP_PID_FILE" 2>/dev/null) || true
        if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
            kill "$PID" 2>/dev/null || true
        fi
        rm -f "$LOOP_PID_FILE"
    fi
}

start_loop() {
    stop_loop
    [ ! -f "$CONFIG_FILE" ] && exit 0
    [ ! -f "$DAEMON_SCRIPT" ] && exit 0
    python3 "$DAEMON_SCRIPT" "$LOOP_PID_FILE" "$CONFIG_FILE" 2>/dev/null
}

case "${1:-}" in
    start) start_loop ;;
    stop)  stop_loop ;;
    *)     echo "Usage: decision-loop.sh [start|stop]" ;;
esac
