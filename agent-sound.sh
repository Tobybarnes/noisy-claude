#!/bin/bash
# Agent Sound Trigger Script
# Usage: ~/.noisy-claude/agent-sound.sh <action>
# Allows sub-agents to trigger sounds for specific actions

NOISY_CLAUDE_DIR="${NOISY_CLAUDE_DIR:-$HOME/.noisy-claude}"
CONFIG_FILE="$NOISY_CLAUDE_DIR/config.json"
PID_FILE="$NOISY_CLAUDE_DIR/.afplay.pid"

# Read config (focus mode and active collection)
read_config() {
    python3 -c "
import json, sys
try:
    config = json.load(open('$CONFIG_FILE'))
    focus_mode = config.get('focus_mode', 'smart')
    active_collection = config.get('active_collection', 'default')
    collections = config.get('collections', {})

    if active_collection in collections:
        sounds_path = collections[active_collection]['path']
    else:
        sounds_path = '$NOISY_CLAUDE_DIR/sounds'

    print(f'{focus_mode}|{sounds_path}')
except:
    print('smart|$NOISY_CLAUDE_DIR/sounds')
" 2>/dev/null || echo "smart|$NOISY_CLAUDE_DIR/sounds"
}

CONFIG_DATA=$(read_config)
FOCUS_MODE="${CONFIG_DATA%%|*}"
SOUNDS_DIR="${CONFIG_DATA##*|}"

# Check if terminal is focused (for smart mode)
is_terminal_focused() {
    local focused_app=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
    case "$focused_app" in
        Terminal|iTerm2|Alacritty|kitty|WezTerm|Ghostty|Hyper|Warp|"Visual Studio Code"|Code|Cursor|Zed|Windsurf)
            return 0  # Terminal is focused
            ;;
        *)
            return 1  # Terminal not focused
            ;;
    esac
}

# Play sound function
play_sound() {
    local sound_file="$1"

    # Check focus mode
    if [[ "$FOCUS_MODE" == "smart" ]] && is_terminal_focused; then
        return  # Don't play if terminal is focused in smart mode
    fi

    # Kill previous sound if playing
    if [[ -f "$PID_FILE" ]]; then
        local old_pid=$(cat "$PID_FILE")
        kill "$old_pid" 2>/dev/null
    fi

    # Play new sound in background
    afplay "$SOUNDS_DIR/$sound_file" &
    echo $! > "$PID_FILE"
}

# Action to sound mapping
case "$1" in
    # Testing
    test_passed|tests_passed)
        play_sound "FemalePLSSuccess.wav"
        ;;
    test_failed|tests_failed)
        play_sound "fBAD0.wav"
        ;;

    # Building
    build_complete|build_success)
        play_sound "mHAPPY0.wav"
        ;;
    build_failed)
        play_sound "mBAD0.wav"
        ;;

    # Errors and issues
    error|exception)
        play_sound "fOOPS0.wav"
        ;;
    bug_found|issue_found)
        play_sound "fMAD0.wav"
        ;;

    # Git operations
    commit|committed)
        play_sound "mSTORYOK.wav"
        ;;
    push|pushed)
        play_sound "fCELEB0.wav"
        ;;

    # Agent collaboration
    agent_handoff|handoff)
        play_sound "mGREETING.wav"
        ;;
    agent_done|finished)
        play_sound "MalePLSSuccess.wav"
        ;;

    # Research and analysis
    research_complete|analysis_complete)
        play_sound "fHAPPY0.wav"
        ;;

    # Waiting and blocked
    blocked|waiting)
        play_sound "fWAITING0.wav"
        ;;
    need_input)
        play_sound "mHURRYUP.wav"
        ;;

    # Success states
    success|complete)
        play_sound "FemalePLSSuccess.wav"
        ;;
    celebrate)
        play_sound "mCELEB0.wav"
        ;;

    # Custom sound (play any sound by filename)
    play)
        if [[ -n "$2" ]]; then
            play_sound "$2"
        else
            echo "Usage: agent-sound.sh play <sound_filename>"
            exit 1
        fi
        ;;

    # List available actions
    list|help|--help)
        echo "Agent Sound Trigger - Available actions:"
        echo ""
        echo "Testing:"
        echo "  test_passed, tests_passed    - Tests succeeded"
        echo "  test_failed, tests_failed    - Tests failed"
        echo ""
        echo "Building:"
        echo "  build_complete, build_success - Build succeeded"
        echo "  build_failed                  - Build failed"
        echo ""
        echo "Errors:"
        echo "  error, exception              - Error occurred"
        echo "  bug_found, issue_found        - Bug discovered"
        echo ""
        echo "Git:"
        echo "  commit, committed             - Code committed"
        echo "  push, pushed                  - Code pushed"
        echo ""
        echo "Agent collaboration:"
        echo "  agent_handoff, handoff        - Agent passing work"
        echo "  agent_done, finished          - Agent completed work"
        echo ""
        echo "Research:"
        echo "  research_complete             - Research finished"
        echo "  analysis_complete             - Analysis finished"
        echo ""
        echo "Status:"
        echo "  blocked, waiting              - Agent is blocked"
        echo "  need_input                    - Agent needs input"
        echo "  success, complete             - Generic success"
        echo "  celebrate                     - Major milestone"
        echo ""
        echo "Custom:"
        echo "  play <filename>               - Play specific sound"
        echo ""
        echo "Examples:"
        echo "  ~/.noisy-claude/agent-sound.sh test_passed"
        echo "  ~/.noisy-claude/agent-sound.sh agent_handoff"
        echo "  ~/.noisy-claude/agent-sound.sh play 'Good Shot FM.wav'"
        ;;

    *)
        echo "Unknown action: $1"
        echo "Run 'agent-sound.sh help' for available actions"
        exit 1
        ;;
esac
