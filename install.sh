#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Install the changes script ────────────────────────────────────────────────
INSTALL_DIR="${HOME}/.local/bin"
mkdir -p "$INSTALL_DIR"
cp "$SCRIPT_DIR/claude-diff-view" "$INSTALL_DIR/claude-diff-view"
chmod +x "$INSTALL_DIR/claude-diff-view"
echo "✓  Installed: $INSTALL_DIR/claude-diff-view"

# Warn if not on PATH
if ! command -v changes &>/dev/null; then
  echo ""
  echo "   ~/.local/bin is not on your PATH. Add this to your shell profile:"
  echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo ""
fi

# ── Install the Claude Code slash command ─────────────────────────────────────
COMMANDS_DIR="${HOME}/.claude/commands"
mkdir -p "$COMMANDS_DIR"
cp "$SCRIPT_DIR/.claude/commands/changes.md" "$COMMANDS_DIR/changes.md"
echo "✓  Installed: $COMMANDS_DIR/changes.md  (/changes slash command)"
