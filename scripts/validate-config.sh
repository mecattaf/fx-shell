#!/bin/bash
# scripts/validate-config.sh

set -e

CONFIG_FILE="${1:-${HOME}/.config/fx-shell/config.json}"

echo "Validating config: ${CONFIG_FILE}"

if [ ! -f "${CONFIG_FILE}" ]; then
    echo "❌ Config file not found: ${CONFIG_FILE}"
    exit 1
fi

# Basic JSON validation
if ! python3 -m json.tool "${CONFIG_FILE}" > /dev/null 2>&1; then
    echo "❌ Invalid JSON in config file"
    exit 1
fi

echo "✓ Config file is valid JSON"

# TODO: Add schema validation
# For now, just check basic structure
if ! grep -q "theme" "${CONFIG_FILE}"; then
    echo "⚠️  Warning: 'theme' property not found in config"
fi

echo "✓ Config validation complete"
