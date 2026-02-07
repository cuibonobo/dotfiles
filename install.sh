#!/usr/bin/env bash
#
# Dotfiles installation script for dev containers
# This script is idempotent and can be run multiple times safely
#

set -e  # Exit on error

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Installing dotfiles from: $DOTFILES_DIR"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Function to backup existing files
backup_if_exists() {
    local file="$1"
    if [ -f "$file" ] && [ ! -L "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d%H%M%S)"
        echo "  📦 Backing up existing file: $file → $backup"
        cp "$file" "$backup"
    fi
}

# Function to safely copy file
safe_copy() {
    local src="$1"
    local dest="$2"
    local mode="$3"

    if [ -f "$src" ]; then
        backup_if_exists "$dest"
        cp "$src" "$dest"
        chmod "$mode" "$dest"
        echo "  ✓ Installed: $dest"
    else
        echo "  ⚠ Skipping (not found): $src"
    fi
}

# Install Git configuration
echo ""
echo "📝 Installing Git configuration..."
safe_copy "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig" 644

# Setup SSH directory (config intentionally not included for security)
echo ""
echo "🔐 Setting up SSH directory..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
echo "  ✓ SSH directory created with correct permissions"
echo "  ℹ SSH config not managed by dotfiles (kept on host for security)"

# Install shell configurations
echo ""
echo "🐚 Installing shell configurations..."
safe_copy "$DOTFILES_DIR/shell/.bashrc" "$HOME/.bashrc" 644
safe_copy "$DOTFILES_DIR/shell/.bash_profile" "$HOME/.bash_profile" 644
safe_copy "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc" 644
safe_copy "$DOTFILES_DIR/shell/.zprofile" "$HOME/.zprofile" 644

# Set up known_hosts if it doesn't exist
if [ ! -f "$HOME/.ssh/known_hosts" ]; then
    touch "$HOME/.ssh/known_hosts"
    chmod 600 "$HOME/.ssh/known_hosts"
    echo "  ✓ Created: $HOME/.ssh/known_hosts"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ Dotfiles installation complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Next steps:"
echo "  • Reload your shell or run: source ~/.bashrc (or ~/.zshrc)"
echo "  • Check git config: git config --list"
echo "  • For SSH keys, ensure agent forwarding is enabled in VS Code"
echo ""
