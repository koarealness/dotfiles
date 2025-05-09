k#!/bin/bash
echo "🍺 Installing Homebrew and bundling packages..."

# Install Homebrew if it's not installed
if ! command -v brew >/dev/null 2>&1; then
  echo "🔧 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Run Brewfile if it exists
BREWFILE="$HOME/.dotfiles/Brewfile"
if [[ -f "$BREWFILE" ]]; then
  echo "📦 Installing packages from Brewfile..."
  brew bundle --file="$BREWFILE"
else
  echo "⚠️ Brewfile not found at $BREWFILE"
fi

