#!/bin/bash
echo "🧠 Installing shell functions..."

# Source all functions (normal and underscore-prefixed)
for file in *.zsh _*; do
  [[ -f "$file" ]] && source "./$file"
done

