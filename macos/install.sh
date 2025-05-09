#!/bin/bash
echo "🛠️ Applying macOS settings..."

# Load all .sh and .zsh files in this module
for file in ./*.sh ./*.zsh; do
  [[ -f "$file" ]] && source "$file"
done

