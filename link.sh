#!/bin/bash
# macOS/Linux symlink creator

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

# Define symlinks as: source:target
# source is relative to DOTFILES_DIR, target is relative to HOME_DIR
declare -A SYMLINKS=(
    ["nvim"]="$HOME_DIR/.config/nvim"
    ["wezterm"]="$HOME_DIR/.config/wezterm"
    ["nushell"]="$HOME_DIR/.config/nushell"
)

echo "Creating symlinks in $HOME_DIR..."

for source in "${!SYMLINKS[@]}"; do
    target="${SYMLINKS[$source]}"

    if [ ! -e "$DOTFILES_DIR/$source" ]; then
        echo "Skipping $source (not found)"
        continue
    fi

    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"

    # Remove existing file/symlink and overwrite
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "Removing existing file: $target"
        rm -rf "$target"
    fi

    echo "Linking: $DOTFILES_DIR/$source → $target"
    ln -s "$DOTFILES_DIR/$source" "$target"
done

echo "Done!"
