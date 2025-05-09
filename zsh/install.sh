#!/bin/bash
echo "🐚 Setting up Zsh environment..."

# Source all Zsh config files in this module
for file in ./*.zsh; do
  [[ -f "$file" ]] && source "$file"
done

