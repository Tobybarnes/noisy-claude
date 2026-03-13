#!/usr/bin/env bash
# Launch the Noisy Claude Control Panel

set -euo pipefail

NOISY_CLAUDE_DIR="$HOME/.noisy-claude"

echo "🔊 Noisy Claude Control Panel Launcher"
echo ""

# Check for Python 3
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not found"
    exit 1
fi

# Check for pip and install dependencies if needed
echo "📦 Checking dependencies..."

if ! python3 -c "import flask" 2>/dev/null; then
    echo "📥 Installing Flask..."
    pip3 install flask flask-cors --quiet
fi

echo "✅ Dependencies ready"
echo ""

# Start the server
cd "$NOISY_CLAUDE_DIR"
python3 control-panel-server.py
