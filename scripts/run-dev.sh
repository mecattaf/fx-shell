#!/bin/bash
# scripts/run-dev.sh

set -e

export FX_SHELL_DEV=1
export FX_SHELL_DEBUG=1
export QT_LOGGING_RULES="*.debug=true"

echo "════════════════════════════════════════"
echo "  Starting fx-shell in development mode"
echo "════════════════════════════════════════"
echo ""

quickshell ./shell.qml
