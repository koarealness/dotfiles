#!/bin/bash
echo "📝 Installing editors module..."

# Load all editor-related env and custom scripts
for file in *.zsh; do
  [[ -f "$file" ]] && source "./$file"
done

