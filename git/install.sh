#!/bin/bash
echo "🔧 Linking Git configuration files..."
stow git

# Optional: source any Git-specific Zsh files
for file in ./*.zsh; do
  [[ -f "$file" ]] && source "$file"
done

