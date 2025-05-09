#!/bin/bash
echo "🔐 Running system module setup..."

# Source all .zsh config files in this module
for file in *.zsh; do
  [[ -f "$file" ]] && source "./$file"
done

