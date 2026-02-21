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

# Function to configure VS Code settings
configure_vscode() {
    local vscode_settings="$HOME/.config/Code/User/settings.json"
    
    echo ""
    echo "⚙️  Configuring VS Code settings..."
    
    # Check if VS Code is installed
    if ! command -v code &> /dev/null; then
        echo "  ℹ VS Code not found, skipping settings configuration"
        return 0
    fi
    
    # Create directory if needed
    mkdir -p "$(dirname "$vscode_settings")"
    
    # Check if jq is available for JSON manipulation
    if ! command -v jq &> /dev/null; then
        echo "  ⚠ jq not found, skipping VS Code settings (install jq for automatic configuration)"
        return 0
    fi
    
    # Dotfiles settings to add
    local dotfiles_settings='{
        "dotfiles.repository": "https://github.com/cuibonobo/dotfiles",
        "dotfiles.targetPath": "~/dotfiles",
        "dotfiles.installCommand": "install.sh"
    }'
    
    if [ -f "$vscode_settings" ]; then
        # File exists, merge settings
        backup_if_exists "$vscode_settings"
        jq ". += $dotfiles_settings" "$vscode_settings" > "$vscode_settings.tmp" && mv "$vscode_settings.tmp" "$vscode_settings"
        echo "  ✓ Updated existing settings: $vscode_settings"
    else
        # Create new settings file
        echo "$dotfiles_settings" | jq '.' > "$vscode_settings"
        echo "  ✓ Created new settings: $vscode_settings"
    fi
}

# Install Git configuration
echo ""
echo "📝 Installing Git configuration..."
safe_copy "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig" 644

# Install global gitignore
mkdir -p "$HOME/.config/git"
safe_copy "$DOTFILES_DIR/git/ignore" "$HOME/.config/git/ignore" 644

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

# Configure VS Code settings
configure_vscode

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ Dotfiles installation complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Next steps:"
echo "  • Reload your shell or run: source ~/.bashrc (or ~/.zshrc)"
echo "  • Check git config: git config --list"
echo "  • View global ignores: cat ~/.config/git/ignore"
echo "  • For SSH keys, ensure agent forwarding is enabled in VS Code"
echo ""
