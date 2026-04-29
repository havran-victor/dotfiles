# Dotfiles Expansion & Bootstrap Install Script

**Date:** 2026-04-29  
**Status:** Approved

## Goal

Add missing dotfile packages for configs that exist on the current system but are untracked, create curated package lists, and update `install.sh` so a fresh Arch Linux install (with Omarchy already set up manually) can reach this exact configuration by running a single script.

## Scope

- Omarchy is installed manually before the script is run — out of scope.
- All other packages, configs, and services are handled by the script.

---

## 1. New Stow Packages

Six additions to the repo, each following the existing stow layout (`<package>/.config/<tool>/` or `<package>/.<file>`):

| Package dir | Tracked path | Source on current system |
|---|---|---|
| `ghostty/` | `~/.config/ghostty/config` | `/home/victor/.config/ghostty/config` |
| `tmux/` | `~/.config/tmux/tmux.conf` | `/home/victor/.config/tmux/tmux.conf` |
| `starship/` | `~/.config/starship.toml` | `/home/victor/.config/starship.toml` |
| `walker/` | `~/.config/walker/config.toml` | `/home/victor/.config/walker/config.toml` |
| `shell/` (extend) | `~/.p10k.zsh` | `/home/victor/.p10k.zsh` |
| `mako/` (populate) | `~/.config/mako/config` | Currently empty — add minimal explicit config |

The `mako` directory already exists in the repo but has no files, making the stow step a no-op. A minimal config capturing the mako defaults will be added so it is reproducible.

---

## 2. Package Lists

Two new files that the existing install script already reads when present.

### `packages/pacman.txt`

```
# Hyprland stack
hyprland hyprpaper hypridle hyprlock
waybar eww mako
xdg-desktop-portal xdg-desktop-portal-hyprland
wl-clipboard grim slurp wtype

# Audio
pipewire wireplumber pipewire-alsa pipewire-pulse pipewire-jack

# Terminals & multiplexer
ghostty kitty alacritty tmux

# Shell & prompt
zsh starship zoxide

# Dev tools
git neovim ripgrep fd stow unzip zip

# CLI tools
btop fastfetch lazygit

# Apps
discord obsidian

# Fonts
fontconfig noto-fonts noto-fonts-emoji
ttf-jetbrains-mono-nerd ttf-cascadia-code-nerd

# System
networkmanager bluez bluez-utils uwsm
```

### `packages/aur.txt`

```
vivaldi
walker-bin
spotify
satty
swayosd-git
oh-my-zsh-git
```

---

## 3. Install Script Changes

All changes are additive to the existing `install.sh`. Order matters — Oh My Zsh must be installed before stowing so `.zshrc` doesn't error on first launch.

### 3a. Oh My Zsh (new step, before stow)

```bash
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended --keep-zshrc
fi
```

`--keep-zshrc` prevents the installer from overwriting the stowed `.zshrc`.

### 3b. Extend PKG_DIRS (step 4)

```bash
PKG_DIRS=(alacritty eww hypr mako nvim systemd waybar envd git kitty misc shell tools ghostty tmux starship walker)
```

### 3c. Make eww scripts executable (step 5)

```bash
if [[ -d "$HOME/.config/eww/scripts" ]]; then
  find "$HOME/.config/eww/scripts" -type f -name '*.sh' -exec chmod +x {} +
fi
```

### 3d. Enable battery monitor (step 5)

```bash
enable_user "omarchy-battery-monitor.timer"
```

### 3e. Unblock Bluetooth (step 5)

```bash
if have rfkill; then
  rfkill unblock bluetooth 2>/dev/null || true
fi
```

---

## 4. Bug Fixes

Two silent issues found during review, fixed while touching the files:

| File | Line | Issue | Fix |
|---|---|---|---|
| `hypr/input.conf` | 28 | Old v1 window rule: `windowrule = scrolltouchpad 1.5, class:Alacritty` | `windowrule = scrolltouchpad 1.5, match:class ^(Alacritty)$` |
| `hypr/hyprland.conf` | 87 | `match:fullscreen 1` not recognized in Hyprland ≥0.47 | `match:fullscreen on` |

---

## Out of Scope

- Omarchy installation (manual prerequisite)
- Vivaldi profile/extension sync
- SSH keys, GPG keys, secrets
- Machine-specific overrides (handled by `~/.zshrc.local` per existing README tip)
- Wallpapers and themes (referenced in README as optional assets)
