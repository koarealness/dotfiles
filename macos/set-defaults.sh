#!/bin/bash

echo "🛠️ Setting macOS defaults..."

###############################################################################
# Keyboard and General UI
###############################################################################
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g NSScrollViewRubberbanding -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

###############################################################################
# Finder Preferences
###############################################################################
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
chflags nohidden ~/Library

###############################################################################
# Screenshot Settings
###############################################################################
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Dock Settings
###############################################################################
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Trackpad
###############################################################################
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

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
# Networking
###############################################################################
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false
sudo defaults write /Library/Preferences/com.apple.mDNSResponder NoMulticastAdvertisements -bool true
sudo defaults write /Library/Preferences/com.apple.airport.preferences RememberPreferredNetworksOnly -bool true

###############################################################################
# Finalizing UI
###############################################################################
killall Finder 2>/dev/null
killall Dock 2>/dev/null
killall SystemUIServer 2>/dev/null
echo '✅ UI processes reloaded.'

###############################################################################
# 🔒 Lock preference files immutably
###############################################################################

USE_SYSTEM_IMMUTABILITY=false  # Set to true if SIP is disabled and you want to use schg

LOCK_FLAG="uchg"
[[ "$USE_SYSTEM_IMMUTABILITY" = true ]] && LOCK_FLAG="schg"
echo "🔐 Locking preferences with: $LOCK_FLAG"

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
    sudo chflags "$LOCK_FLAG" "$file"
    echo "🔒 Locked: $file"
  fi
done

###############################################################################
# 🚫 Disable Color Profile System
###############################################################################

echo "🚫 Disabling Color Profile system..."

# Lock system-wide and user profile folders
sudo chmod 000 /Library/ColorSync/Profiles
sudo chflags uchg /Library/ColorSync/Profiles

mkdir -p ~/Library/ColorSync/Profiles
chmod 000 ~/Library/ColorSync/Profiles
chflags uchg ~/Library/ColorSync/Profiles

if [[ "$USE_SYSTEM_IMMUTABILITY" = true ]]; then
  sudo chmod 000 /System/Library/ColorSync/Profiles
  sudo chflags schg /System/Library/ColorSync/Profiles
fi

sudo pkill colorsyncd 2>/dev/null
echo '✅ Color profile system locked.'

###############################################################################
# Done
###############################################################################
echo '🎉 macOS hardening complete.'

