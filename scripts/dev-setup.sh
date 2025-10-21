#!/bin/bash
# scripts/dev-setup.sh

set -e

echo "════════════════════════════════════════"
echo "  fx-shell Development Setup"
echo "════════════════════════════════════════"
echo ""

# Check dependencies
echo "Checking dependencies..."

command -v quickshell >/dev/null 2>&1 || {
    echo "❌ Error: quickshell not found"
    echo "Please install QuickShell first:"
    echo "  https://github.com/quickshell/quickshell"
    exit 1
}
echo "✓ QuickShell found: $(quickshell --version)"

command -v sway >/dev/null 2>&1 || {
    echo "⚠️  Warning: Sway not found"
    echo "fx-shell requires Sway compositor"
}
echo "✓ Sway found: $(sway --version)"

# Create config directory
CONFIG_DIR="${HOME}/.config/fx-shell"
echo ""
echo "Creating config directory: ${CONFIG_DIR}"
mkdir -p "${CONFIG_DIR}"
echo "✓ Config directory created"

# Link development shell.qml
echo ""
echo "Linking development shell.qml..."
ln -sf "$(pwd)/shell.qml" "${CONFIG_DIR}/shell.qml"
echo "✓ Development shell linked"

# Set up environment variables
echo ""
echo "Setting up environment..."
export FX_SHELL_DEV=1
export FX_SHELL_DEBUG=1
echo "✓ Environment configured"

# Create default config if it doesn't exist
if [ ! -f "${CONFIG_DIR}/config.json" ]; then
    echo ""
    echo "Creating default config..."
    cat > "${CONFIG_DIR}/config.json" <<EOF
{
  "theme": "material-dark",
  "accentColor": "#4285f4",
  "fontFamily": "Inter",
  "fontSize": 11,
  "compositor": "sway"
}
EOF
    echo "✓ Default config created"
fi

echo ""
echo "════════════════════════════════════════"
echo "  Development environment ready!"
echo "════════════════════════════════════════"
echo ""
echo "To start fx-shell in development mode:"
echo "  cd $(pwd)"
echo "  ./scripts/run-dev.sh"
echo ""
echo "Or manually:"
echo "  quickshell ./shell.qml"
echo ""
