# Sets reasonable macOS defaults.
#
# Or, in other words, set shit how I like in macOS.
#
# The original idea (and a couple settings) were grabbed from:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.macos
#
# Run ./set-defaults.sh and you'll be good to go.

#!/bin/bash

echo "🔧 Applying macOS system defaults..."

###############################################################################
# General UI/UX
###############################################################################

defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false
defaults write -g NSScrollViewRubberbanding -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

###############################################################################
# Terminal & Keyboard Responsiveness
###############################################################################

defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false
defaults write -g NSScrollViewRubberbanding -bool false

###############################################################################
# Finder
###############################################################################

defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

###############################################################################
# Screenshot Improvements
###############################################################################

defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Dock
###############################################################################

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Trackpad
###############################################################################

defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool 
true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool 
true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad 
TrackpadThreeFingerDrag -bool true

###############################################################################
# Privacy & Analytics
###############################################################################

defaults write com.apple.assistant.support "Assistant Enabled" -bool false
defaults write com.apple.CrashReporter DialogType none
defaults write com.apple.SubmitDiagInfo AutoSubmit -bool false
defaults write com.apple.SubmitDiagInfo SubmitEnabled -bool false
defaults write com.apple.Spotlight SuggestionsEnabled -bool false
defaults write com.apple.lookup.shared LookupSuggestionsDisabled -bool true
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

###############################################################################
# DNS & Network Privacy
###############################################################################

sudo defaults write 
/Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool 
false
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist 
NoMulticastAdvertisements -bool true
sudo defaults write /Library/Preferences/com.apple.airport.preferences.plist 
RememberPreferredNetworksOnly -bool true

###############################################################################
# Security Settings
###############################################################################

defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

###############################################################################
# PartlyCloudy Touches
###############################################################################

echo "alias lifxon='python3 ~/venv/Projects/lifxlan/Scripts/lifx_on.py'" >> 
~/.zshrc
echo "alias lifxoff='python3 ~/venv/Projects/lifxlan/Scripts/lifx_off.py'" >> 
~/.zshrc

###############################################################################
# 🚫 Disable Color Profiles & ColorSync Access
###############################################################################

echo "🚫 Disabling Color Profile access..."

# Lock global profile folders
sudo chmod 000 /Library/ColorSync/Profiles
sudo chflags uchg /Library/ColorSync/Profiles

# Lock user-level profiles
rm -rf ~/Library/ColorSync/Profiles
mkdir -p ~/Library/ColorSync/Profiles
chmod 000 ~/Library/ColorSync/Profiles
chflags uchg ~/Library/ColorSync/Profiles

# If SIP is disabled, go further:
if [[ "$USE_SYSTEM_IMMUTABILITY" = true ]]; then
  echo "🔐 SIP-disabled: locking system ColorSync resources..."
  sudo chmod 000 /System/Library/ColorSync/Profiles
  sudo chflags uchg /System/Library/ColorSync/Profiles
fi

# Optional: kill the color profile daemon
sudo pkill colorsyncd 2>/dev/null

echo "✅ Color profile access locked down."


###############################################################################
# 🔒 Lock all preference files to prevent modification
###############################################################################

# Toggle this to enable system-level immutable flags (requires SIP disabled)
USE_SYSTEM_IMMUTABILITY=false

# Which chflags mode to use
LOCK_FLAG="uchg"
[[ "$USE_SYSTEM_IMMUTABILITY" = true ]] && LOCK_FLAG="schg"

echo "🔐 Locking preference files using: $LOCK_FLAG"

PREF_FILES=(
  ~/Library/Preferences/.GlobalPreferences.plist
  ~/Library/Preferences/com.apple.finder.plist
  ~/Library/Preferences/com.apple.dock.plist
  ~/Library/Preferences/com.apple.AppleMultitouchTrackpad.plist
  ~/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.trackpad.plist
  ~/Library/Preferences/com.apple.desktopservices.plist
  ~/Library/Preferences/com.apple.screencapture.plist
  ~/Library/Preferences/com.apple.Safari.plist
  ~/Library/Preferences/com.apple.assistant.support.plist
  ~/Library/Preferences/com.apple.CrashReporter.plist
  ~/Library/Preferences/com.apple.SubmitDiagInfo.plist
  ~/Library/Preferences/com.apple.lookup.shared.plist
  ~/Library/Preferences/com.apple.Spotlight.plist
)

for file in "${PREF_FILES[@]}"; do
  if [[ -f "$file" ]]; then
    echo "🔒 Locking: $file"
    sudo chflags "$LOCK_FLAG" "$file"
  else
    echo "⚠️  Skipping missing file: $file"
  fi
done

echo "✅ Preference files locked with chflags $LOCK_FLAG"


###############################################################################
# Finalize
###############################################################################

killall Finder
killall Dock
killall SystemUIServer

echo "✅ macOS defaults applied."

