#!/usr/bin/env bash
# detect-event.sh — Enhanced event detection for Noisy Claude v2.0
set -euo pipefail

NOISY_CLAUDE_DIR="${NOISY_CLAUDE_DIR:-$HOME/.noisy-claude}"
STATE_DIR="$NOISY_CLAUDE_DIR/.state"
mkdir -p "$STATE_DIR"

# Read hook input
INPUT=$(cat)
EVENT=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('hook_event_name',''))" 2>/dev/null) || exit 0
TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_name',''))" 2>/dev/null) || true
TOOL_RESULT=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('result',''))" 2>/dev/null) || true

# Track timing for long task detection
TASK_START_FILE="$STATE_DIR/task_start"
CURRENT_TIME=$(date +%s)

case "$EVENT" in
  PreToolUse)
    echo "$CURRENT_TIME" > "$TASK_START_FILE"
    echo "tool_pre"
    ;;

  PostToolUse)
    # Check for long task
    if [ -f "$TASK_START_FILE" ]; then
      START_TIME=$(cat "$TASK_START_FILE")
      DURATION=$((CURRENT_TIME - START_TIME))
      if [ $DURATION -gt 30 ]; then
        echo "long_task"
      fi
      rm -f "$TASK_START_FILE"
    fi

    # Detect tool success/failure
    if echo "$INPUT" | grep -q '"error"'; then
      echo "tool_failure"

      # Track error streak
      ERROR_COUNT_FILE="$STATE_DIR/error_count"
      if [ -f "$ERROR_COUNT_FILE" ]; then
        COUNT=$(cat "$ERROR_COUNT_FILE")
        COUNT=$((COUNT + 1))
      else
        COUNT=1
      fi
      echo "$COUNT" > "$ERROR_COUNT_FILE"

      if [ $COUNT -ge 3 ]; then
        echo "error_threshold"
        rm -f "$ERROR_COUNT_FILE"
      fi
    else
      echo "tool_success"
      rm -f "$STATE_DIR/error_count"

      # Track success streak
      SUCCESS_COUNT_FILE="$STATE_DIR/success_count"
      if [ -f "$SUCCESS_COUNT_FILE" ]; then
        COUNT=$(cat "$SUCCESS_COUNT_FILE")
        COUNT=$((COUNT + 1))
      else
        COUNT=1
      fi
      echo "$COUNT" > "$SUCCESS_COUNT_FILE"

      # Emit streak events
      if [ $COUNT -eq 3 ]; then
        echo "streak_3"
      elif [ $COUNT -eq 5 ]; then
        echo "streak_5"
      elif [ $COUNT -eq 10 ]; then
        echo "streak_10"
        rm -f "$SUCCESS_COUNT_FILE"
      fi
    fi

    # Detect specific tool patterns
    case "$TOOL_NAME" in
      Bash)
        # Detect git operations
        if echo "$TOOL_RESULT" | grep -q "git commit"; then
          if echo "$TOOL_RESULT" | grep -q "error\|fatal"; then
            echo "git_error"
          else
            echo "git_commit"
          fi
        fi

        if echo "$TOOL_RESULT" | grep -q "git push"; then
          if echo "$TOOL_RESULT" | grep -q "error\|fatal\|rejected"; then
            echo "git_error"
          else
            echo "git_push"
          fi
        fi

        if echo "$TOOL_RESULT" | grep -q "gh pr create"; then
          if echo "$TOOL_RESULT" | grep -q "error"; then
            echo "git_error"
          else
            echo "git_pr_create"
          fi
        fi

        # Detect test results
        if echo "$TOOL_RESULT" | grep -Eq "test|spec|jest|mocha|pytest"; then
          if echo "$TOOL_RESULT" | grep -Eq "PASS|✓|passed|success"; then
            echo "test_pass"
          elif echo "$TOOL_RESULT" | grep -Eq "FAIL|✗|failed|error"; then
            echo "test_fail"
          fi
        fi

        # Detect build operations
        if echo "$TOOL_RESULT" | grep -Eq "build|compile|webpack|vite|rollup|tsc"; then
          if echo "$TOOL_RESULT" | grep -Eq "success|complete|✓"; then
            echo "build_complete"
          elif echo "$TOOL_RESULT" | grep -Eq "error|failed"; then
            echo "build_error"
          fi
        fi
        ;;

      Skill)
        # Detect skill invocations
        SKILL_ARG=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('args',{}).get('skill',''))" 2>/dev/null) || true
        case "$SKILL_ARG" in
          commit) echo "skill_commit" ;;
          newday) echo "skill_newday" ;;
          publish) echo "skill_publish" ;;
          deploy-weekly) echo "skill_deploy" ;;
          gsd) echo "skill_gsd" ;;
        esac
        ;;

      EnterPlanMode)
        echo "plan_mode_enter"
        ;;

      ExitPlanMode)
        echo "plan_mode_exit"
        ;;

      TeamCreate)
        echo "team_created"
        ;;

      TeamDelete)
        echo "team_deleted"
        ;;
    esac
    ;;

  Stop)
    echo "task_complete"
    rm -f "$TASK_START_FILE"
    ;;

  Notification)
    MATCHER=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('matcher',''))" 2>/dev/null) || true
    case "$MATCHER" in
      permission_prompt) echo "permission" ;;
      teammate_message) echo "teammate_message" ;;
      background_task) echo "background_task_done" ;;
    esac
    ;;

  SessionStart)
    # Detect time of day
    HOUR=$(date +%H)
    if [ $HOUR -ge 6 ] && [ $HOUR -lt 12 ]; then
      echo "morning"
    elif [ $HOUR -ge 12 ] && [ $HOUR -lt 17 ]; then
      echo "afternoon"
    elif [ $HOUR -ge 17 ] && [ $HOUR -lt 22 ]; then
      echo "evening"
    else
      echo "late_night"
    fi

    echo "session_start"
    ;;

  UserPromptSubmit)
    echo "user_prompt"
    ;;

  AgentResponse)
    echo "agent_response"
    ;;
esac
