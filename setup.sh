#!/bin/bash
# ------------------------------------------------------------
# spotify-multiuser-linux setup script
# Creates a shared Spotify configuration for multiple users.
# Compatible with Ubuntu/Debian systems using spotify-client (.deb)
# ------------------------------------------------------------

set -e

# 1. Define group and shared directory
GROUP_NAME="spotify"
SHARED_DIR="/usr/local/share/spotify-config"
MAIN_USER="fer"
USERS=("fer" "fer-dev" "fer-tedic")

echo "🎧 Setting up shared Spotify configuration..."

# 2. Create group if it doesn't exist
if ! getent group "$GROUP_NAME" >/dev/null; then
  echo "🆕 Creating group '$GROUP_NAME'..."
  sudo groupadd "$GROUP_NAME"
fi

# 3. Add users to the group
for USER in "${USERS[@]}"; do
  echo "👥 Adding $USER to group '$GROUP_NAME'..."
  sudo usermod -aG "$GROUP_NAME" "$USER"
done

# 4. Create shared directory
echo "📁 Creating shared directory at $SHARED_DIR..."
sudo mkdir -p "$SHARED_DIR"
sudo chown -R "$MAIN_USER:$GROUP_NAME" "$SHARED_DIR"
sudo chmod -R 770 "$SHARED_DIR"

# 5. Move existing config (if available)
if [ -d "/home/$MAIN_USER/.config/spotify" ]; then
  echo "📦 Moving existing Spotify config from $MAIN_USER..."
  sudo mv /home/$MAIN_USER/.config/spotify/* "$SHARED_DIR"/ 2>/dev/null || true
fi

# 6. Create symlinks for all users
for USER in "${USERS[@]}"; do
  echo "🔗 Linking config for $USER..."
  sudo rm -rf /home/$USER/.config/spotify
  sudo ln -s "$SHARED_DIR" /home/$USER/.config/spotify
  sudo chown -h $USER:$GROUP_NAME /home/$USER/.config/spotify
done

# 7. Final permissions
sudo chown -R "$MAIN_USER:$GROUP_NAME" "$SHARED_DIR"
sudo chmod -R 770 "$SHARED_DIR"

echo "✅ Shared Spotify configuration ready!"
echo "   Please log out and back in so group membership takes effect."
