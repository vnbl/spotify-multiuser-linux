#!/bin/bash
# ------------------------------------------------------------
# spotify-multiuser-linux setup script
# Creates a shared Spotify configuration for multiple users.
# Compatible with Ubuntu/Debian systems using spotify-client (.deb)
# ------------------------------------------------------------

set -e

# Basic definitions
GROUP_NAME="spotify"
SHARED_DIR="/usr/local/share/spotify-config"

echo "🎧 Spotify Multiuser Setup"
echo "------------------------------------------------------------"

# Ask for main admin user (the one that already has Spotify configured)
read -rp "👤 Enter the main user (admin) that already has Spotify configured: " MAIN_USER

# Ask for the other users to include (space-separated)
read -rp "👥 Enter additional usernames to share Spotify with (separated by space): " -a USERS

# Show summary and ask for confirmation
echo ""
echo " Summary:"
echo "  Group name: $GROUP_NAME"
echo "  Shared directory: $SHARED_DIR"
echo "  Main user: $MAIN_USER"
echo "  Additional users: ${USERS[*]}"
echo ""
read -rp "✅ Continue with these settings? [y/N]: " CONFIRM
[[ "$CONFIRM" =~ ^[Yy]$ ]] || { echo "❌ Setup cancelled."; exit 1; }

echo ""
echo "🎧 Setting up shared Spotify configuration..."

# Create group if it doesn't exist
if ! getent group "$GROUP_NAME" >/dev/null; then
  echo "Creating group '$GROUP_NAME'..."
  sudo groupadd "$GROUP_NAME"
else
  echo "✔️  Group '$GROUP_NAME' already exists."
fi

# Add all users (including admin) to the group
ALL_USERS=("$MAIN_USER" "${USERS[@]}")
for USER in "${ALL_USERS[@]}"; do
  if id "$USER" &>/dev/null; then
    echo "👥 Adding $USER to group '$GROUP_NAME'..."
    sudo usermod -aG "$GROUP_NAME" "$USER"
  else
    echo "User '$USER' does not exist, skipping."
  fi
done

# Create shared directory
echo "Creating shared directory at $SHARED_DIR..."
sudo mkdir -p "$SHARED_DIR"
sudo chown -R "$MAIN_USER:$GROUP_NAME" "$SHARED_DIR"
sudo chmod -R 770 "$SHARED_DIR"

# Move existing config (if available)
if [ -d "/home/$MAIN_USER/.config/spotify" ]; then
  echo "Moving existing Spotify config from $MAIN_USER..."
  sudo mv /home/$MAIN_USER/.config/spotify/* "$SHARED_DIR"/ 2>/dev/null || true
fi

# Create symlinks for all users
for USER in "${ALL_USERS[@]}"; do
  USER_HOME=$(eval echo "~$USER")
  if [ -d "$USER_HOME" ]; then
    echo "🔗 Linking config for $USER..."
    sudo rm -rf "$USER_HOME/.config/spotify"
    sudo ln -s "$SHARED_DIR" "$USER_HOME/.config/spotify"
    sudo chown -h "$USER:$GROUP_NAME" "$USER_HOME/.config/spotify"
  else
    echo "⚠️ Home directory not found for $USER, skipping."
  fi
done

# Final permissions
sudo chown -R "$MAIN_USER:$GROUP_NAME" "$SHARED_DIR"
sudo chmod -R 770 "$SHARED_DIR"

echo ""
echo "✅ Shared Spotify configuration ready!"
echo "Please log out and back in for group changes to take effect."
