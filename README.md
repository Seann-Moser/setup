# setup

- https://developer.1password.com/docs/cli/get-started/

- https://neovim.io/

- https://lazy.folke.io/

- https://github.com/tmux/tmux/wiki

## Local

```bash
./install_apps.sh
make update-config
```

### Summary
```
sudo crontab -e
```

```bash
# Step 1: apt-get update at 10:00 AM
0 10 * * * DISPLAY=:0 notify-send "Starting Update" "Running apt-get update" && apt-get update -y && DISPLAY=:0 notify-send "Finished Update" "apt-get update completed"

# Step 2: apt-get upgrade at 10:05 AM
5 10 * * * DISPLAY=:0 notify-send "Starting Upgrade" "Running apt-get upgrade" && apt-get upgrade -y && DISPLAY=:0 notify-send "Finished Upgrade" "apt-get upgrade completed"

# Step 3: apt-get dist-upgrade at 10:10 AM
10 10 * * * DISPLAY=:0 notify-send "Starting Dist-Upgrade" "Running apt-get dist-upgrade" && apt-get dist-upgrade -y && DISPLAY=:0 notify-send "Finished Dist-Upgrade" "apt-get dist-upgrade completed"

# Step 4: brew update & upgrade at 10:15 AM
15 10 * * * DISPLAY=:0 notify-send "Starting Homebrew Update" "Running brew update & upgrade" && brew update && brew upgrade --quiet && DISPLAY=:0 notify-send "Finished Homebrew Update" "brew update & upgrade completed"

# Step 5: flatpak update at 10:20 AM
20 10 * * * DISPLAY=:0 notify-send "Starting Flatpak Update" "Running flatpak update" && flatpak update -y && DISPLAY=:0 notify-send "Finished Flatpak Update" "flatpak update completed"
```
