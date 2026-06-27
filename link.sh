#!/bin/bash
# macOS/Linux symlink creator

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

# Each entry is "source:target" — source relative to DOTFILES_DIR, target absolute
SYMLINKS=(
    "nvim:$HOME_DIR/.config/nvim"
    "wezterm:$HOME_DIR/.config/wezterm"
    "xonfig:$HOME_DIR/.config/xonsh"
)

echo "Creating symlinks in $HOME_DIR..."

for entry in "${SYMLINKS[@]}"; do
    source="${entry%%:*}"
    target="${entry#*:}"

    if [ ! -e "$DOTFILES_DIR/$source" ]; then
        echo "Skipping $source (not found)"
        continue
    fi

    mkdir -p "$(dirname "$target")"

    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "Removing existing file: $target"
        rm -rf "$target"
    fi

    echo "Linking: $DOTFILES_DIR/$source → $target"
    ln -s "$DOTFILES_DIR/$source" "$target"
done

echo "Done!"
