#!/bin/bash
# Nano Banana Pro 2 — Install Script
# Installs the skill to ~/.claude/skills/ for Claude Code
#
# Usage:
#   ./install.sh                    # Install skill only
#   ./install.sh --with-mcp KEY    # Install skill + configure MCP with API key
#   ./install.sh --uninstall        # Remove skill

set -euo pipefail

SKILL_NAME="nano-banana"
SKILL_DIR="$HOME/.claude/skills/$SKILL_NAME"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/$SKILL_NAME"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Uninstall
if [[ "${1:-}" == "--uninstall" ]]; then
    if [[ -d "$SKILL_DIR" ]]; then
        rm -rf "$SKILL_DIR"
        info "Removed skill from $SKILL_DIR"
    else
        warn "Skill not found at $SKILL_DIR"
    fi
    exit 0
fi

# Check source exists
if [[ ! -d "$SOURCE_DIR" ]]; then
    error "Source directory not found: $SOURCE_DIR"
    exit 1
fi

# Install skill
info "Installing Nano Banana Pro 2 skill..."
mkdir -p "$SKILL_DIR"
cp -r "$SOURCE_DIR"/* "$SKILL_DIR/"
chmod +x "$SKILL_DIR/scripts/"*.py 2>/dev/null || true
info "Skill installed to $SKILL_DIR"

# Configure MCP if requested
if [[ "${1:-}" == "--with-mcp" ]]; then
    API_KEY="${2:-}"
    if [[ -z "$API_KEY" ]]; then
        error "API key required: ./install.sh --with-mcp YOUR_KEY"
        exit 1
    fi
    info "Configuring MCP server..."
    python3 "$SKILL_DIR/scripts/setup_mcp.py" --key "$API_KEY"
fi

# Validate
info "Running validation..."
python3 "$SKILL_DIR/scripts/validate_setup.py"

echo ""
info "Installation complete!"
echo "  Skill: /nano-banana"
echo "  Location: $SKILL_DIR"
echo ""
echo "Next steps:"
echo "  1. Get a free API key: https://aistudio.google.com/apikey"
echo "  2. In Claude Code, run: /nano-banana setup"
echo "  3. Restart Claude Code"
echo "  4. Try: /nano-banana generate \"a cat astronaut in space\""
