#!/bin/bash

# devcontainer-dotfiles installer
# This script sets up personal preferences for development containers

set -e

echo "🚀 Setting up devcontainer dotfiles..."

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install Zsh if not already installed
if ! command -v zsh &> /dev/null; then
    echo "📦 Installing Zsh..."
    
    # Check if we need sudo or if we're already root
    SUDO_CMD=""
    if [ "$EUID" -ne 0 ] && command -v sudo &> /dev/null; then
        SUDO_CMD="sudo"
    fi
    
    if command -v apt-get &> /dev/null; then
        $SUDO_CMD apt-get update && $SUDO_CMD apt-get install -y zsh
    elif command -v yum &> /dev/null; then
        $SUDO_CMD yum install -y zsh
    elif command -v apk &> /dev/null; then
        $SUDO_CMD apk add zsh
    else
        echo "❌ Could not install Zsh. Please install it manually."
        exit 1
    fi
fi

# Change default shell to Zsh
echo "🐚 Setting Zsh as default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
    # Check if we need sudo or if we're already root
    SUDO_CMD=""
    if [ "$EUID" -ne 0 ] && command -v sudo &> /dev/null; then
        SUDO_CMD="sudo"
    fi
    
    # Try to change the shell, but don't fail if it doesn't work (common in containers)
    if command -v chsh &> /dev/null; then
        $SUDO_CMD chsh -s "$(which zsh)" "$USER" 2>/dev/null || echo "⚠️  Could not change default shell. You may need to restart your terminal."
    else
        echo "⚠️  chsh not available. Setting SHELL environment variable instead."
        export SHELL="$(which zsh)"
    fi
fi

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🎨 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Pure Prompt
echo "✨ Installing Pure Prompt..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/themes/pure" ]; then
    git clone https://github.com/sindresorhus/pure.git "$ZSH_CUSTOM/themes/pure"
fi

# Create symlinks for Pure theme files
ln -sf "$ZSH_CUSTOM/themes/pure/pure.zsh-theme" "$ZSH_CUSTOM/themes/pure.zsh-theme"
ln -sf "$ZSH_CUSTOM/themes/pure/async.zsh" "$ZSH_CUSTOM/themes/async.zsh-theme"

# Copy dotfiles
echo "📋 Setting up configuration files..."
cp "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
cp "$DOTFILES_DIR/aliases" "$HOME/.aliases"

# Handle additional plugins if specified
if [ ! -z "$ADDITIONAL_ZSH_PLUGINS" ]; then
    echo "🔌 Adding additional Zsh plugins: $ADDITIONAL_ZSH_PLUGINS"
    # Create a file with the additional plugins
    echo "$ADDITIONAL_ZSH_PLUGINS" > "$HOME/.additional_zsh_plugins"
fi

# Ensure Zsh is available before proceeding
if ! command -v zsh &> /dev/null; then
    echo "❌ Zsh installation failed. Cannot continue."
    exit 1
fi

# Source the new configuration
echo "🔄 Applying configuration..."
export SHELL="$(which zsh)"

# Don't use exec in non-interactive mode, just notify user
if [ -t 0 ]; then
    exec zsh -l
else
    echo "✅ Dotfiles setup complete!"
    echo "💡 Run 'exec zsh' or restart your terminal to see all changes."
fi
