#!/bin/bash
echo "💎 Installing Ruby module..."

# Link .gemrc and .irbrc
stow ruby

# Restrict Ruby env to local user
chmod -R 700 "$HOME/.gem"
chflags -R uchg "$HOME/.gem"

# Lock Ruby config files
chmod 600 "$HOME/.dotfiles/ruby/"*.symlink
chflags uchg "$HOME/.dotfiles/ruby/"*.symlink

# Remove global Ruby gem paths
sudo chmod -R 000 /Library/Ruby/Gems 2>/dev/null
sudo chflags -R uchg /Library/Ruby/Gems 2>/dev/null

# Revoke public read access to system ruby
sudo chmod o-r /usr/bin/ruby 2>/dev/null

