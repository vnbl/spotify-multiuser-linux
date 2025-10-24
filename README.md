Perfect 👌 — here’s a **more general and polished version** of your README, with all personal references removed and neutral user examples.
It keeps the same structure, clarity, and formatting — just rewritten to be more universally applicable.

---

````markdown
# 🎧 Spotify Multiuser Config for Linux

Share the **same Spotify session and preferences** between multiple local users on a single Linux system.

> Works with Ubuntu / Debian systems using the `.deb` version of Spotify (not Snap).

---

## Overview

By default, Spotify stores session data per user in `~/.config/spotify`, requiring each local account to log in separately.

This setup allows all local users to share:
- A single Spotify login session  
- The same playlists, cache, and preferences  
- A unified configuration folder accessible to all accounts  

---

## Features

✅ Shared configuration directory (`/usr/local/share/spotify-config`)  
✅ Consistent login session for all users  
✅ `spotify-switch` launcher: closes other sessions before starting a new one  
✅ Desktop notifications with the Spotify icon  
✅ Works without sandbox restrictions (unlike the Snap version)

---

## Requirements

- Ubuntu or Debian-based system  
- Spotify **.deb package** (`spotify-client`)  
- `libnotify-bin` for desktop notifications  
- Sudo privileges for setup  

---

## Quick Setup

### 1. Clone this repository

```bash
git clone https://github.com/vnbl/spotify-multiuser-linux.git
cd spotify-multiuser-linux
````

### 2. Run the setup script

This creates the shared directory, group, and symbolic links for each user.

```bash
sudo chmod +x setup.sh spotify-switch
./setup.sh
```

### 3. Copy the launcher to your PATH

```bash
sudo cp spotify-switch /usr/local/bin/
```

---

## Usage

Instead of launching Spotify directly, run:

```bash
spotify-switch
```

The launcher will:

1. Check if Spotify is already running under another user
2. Close any other instance found
3. Start Spotify under the current user
4. Show a desktop notification confirming the switch

---

## Example Configuration

```bash
drwxrwx--- 2 admin spotify 4096 /usr/local/share/spotify-config
lrwxrwxrwx 1 user-a spotify /home/user-a/.config/spotify -> /usr/local/share/spotify-config
lrwxrwxrwx 1 user-b spotify /home/user-b/.config/spotify -> /usr/local/share/spotify-config
```

All users in the `spotify` group can access the same configuration and remain logged in with one shared session.

---

## How It Works

1. A group named `spotify` is created.
2. All target users are added to that group.
3. Spotify’s configuration folder is moved to `/usr/local/share/spotify-config`.
4. Each user’s `~/.config/spotify` is replaced with a symbolic link to that shared folder.
5. The `spotify-switch` script ensures only one instance runs at a time and handles session switching with notifications.

---

## ⚠️ Notes

* Works **only** with the `.deb` version of Spotify:

  ```bash
  sudo apt install spotify-client
  ```

  The Snap version is sandboxed and cannot share configurations.
* Notifications require:

  ```bash
  sudo apt install libnotify-bin
  ```
* GTK or `libva` warnings in terminal are harmless and can be ignored.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Credits

Developed by the vnbl
Tested on Ubuntu 24.04 LTS with Spotify 1.2.x.
Inspired by discussions on Unix StackExchange and AskUbuntu.