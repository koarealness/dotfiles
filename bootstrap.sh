#!/bin/bash
cd "$(dirname "$0")"

echo "🔗 Unlinking existing dotfiles (just in case)..."
stow -D zsh git macos

echo "🔗 Linking dotfiles..."
stow zsh git macos

echo "✅ Dotfiles linked."

