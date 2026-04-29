# Dotfiles Expansion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add 6 missing stow packages, curated package lists, and update install.sh so a fresh Arch install (post-Omarchy) reaches this exact configuration.

**Architecture:** Each new config is copied from the live system into a stow package dir, the original is removed, then stow creates the symlink. Package lists are plain text files the existing install.sh already reads. install.sh gets additive changes only — no structural changes.

**Tech Stack:** GNU Stow, bash, Hyprland, Zsh/Oh-My-Zsh, Powerlevel10k, ghostty, tmux, starship, walker, mako

---

## File Map

**Create:**
- `ghostty/.config/ghostty/config`
- `tmux/.config/tmux/tmux.conf`
- `starship/.config/starship.toml`
- `walker/.config/walker/config.toml`
- `mako/.config/mako/config`
- `packages/pacman.txt`
- `packages/aur.txt`

**Modify:**
- `shell/` — add `.p10k.zsh` alongside existing `.zshrc`
- `install.sh` — Oh My Zsh step, PKG_DIRS, eww chmod, battery timer, bluetooth unblock
- `hypr/.config/hypr/input.conf:28` — old window rule syntax
- `hypr/.config/hypr/hyprland.conf:87` — fullscreen match value

---

## Task 1: Fix Hyprland config bugs

**Files:**
- Modify: `hypr/.config/hypr/input.conf`
- Modify: `hypr/.config/hypr/hyprland.conf`

- [ ] **Step 1: Fix old window rule syntax in input.conf**

  In `hypr/.config/hypr/input.conf`, replace line 28:
  ```
  windowrule = scrolltouchpad 1.5, class:Alacritty
  ```
  with:
  ```
  windowrule = scrolltouchpad 1.5, match:class ^(Alacritty)$
  ```

- [ ] **Step 2: Fix fullscreen match value in hyprland.conf**

  In `hypr/.config/hypr/hyprland.conf`, replace line 87:
  ```
  windowrule = border_color rgb(FF0000) rgb(880808), match:fullscreen 1
  ```
  with:
  ```
  windowrule = border_color rgb(FF0000) rgb(880808), match:fullscreen on
  ```

- [ ] **Step 3: Verify Hyprland config reloads cleanly**

  Run:
  ```bash
  hyprctl reload
  ```
  Expected: no error output (exits 0). If Hyprland is not running, skip this step.

- [ ] **Step 4: Commit**

  ```bash
  cd ~/dotfiles
  git add hypr/.config/hypr/input.conf hypr/.config/hypr/hyprland.conf
  git commit -m "fix: update window rules to Hyprland >=0.47 syntax"
  ```

---

## Task 2: Add ghostty stow package

**Files:**
- Create: `ghostty/.config/ghostty/config`

- [ ] **Step 1: Create package directory**

  ```bash
  mkdir -p ~/dotfiles/ghostty/.config/ghostty
  ```

- [ ] **Step 2: Simulate stow to confirm no conflicts**

  ```bash
  cd ~/dotfiles
  stow --simulate -t "$HOME" ghostty 2>&1
  ```
  Expected: no output (empty = success).

- [ ] **Step 3: Copy live config into the package**

  ```bash
  cp ~/.config/ghostty/config ~/dotfiles/ghostty/.config/ghostty/config
  ```

- [ ] **Step 4: Remove the live file so stow can link it**

  ```bash
  rm ~/.config/ghostty/config
  ```

- [ ] **Step 5: Stow the package**

  ```bash
  cd ~/dotfiles
  stow -v -t "$HOME" ghostty
  ```
  Expected output contains: `LINK: .config/ghostty/config`

- [ ] **Step 6: Verify symlink**

  ```bash
  ls -la ~/.config/ghostty/config
  ```
  Expected: `~/.config/ghostty/config -> ~/dotfiles/ghostty/.config/ghostty/config`

- [ ] **Step 7: Commit**

  ```bash
  cd ~/dotfiles
  git add ghostty/
  git commit -m "feat: add ghostty dotfile package"
  ```

---

## Task 3: Add tmux stow package

**Files:**
- Create: `tmux/.config/tmux/tmux.conf`

- [ ] **Step 1: Create package directory**

  ```bash
  mkdir -p ~/dotfiles/tmux/.config/tmux
  ```

- [ ] **Step 2: Simulate stow**

  ```bash
  cd ~/dotfiles
  stow --simulate -t "$HOME" tmux 2>&1
  ```
  Expected: no output.

- [ ] **Step 3: Copy live config**

  ```bash
  cp ~/.config/tmux/tmux.conf ~/dotfiles/tmux/.config/tmux/tmux.conf
  ```

- [ ] **Step 4: Remove live file**

  ```bash
  rm ~/.config/tmux/tmux.conf
  ```

- [ ] **Step 5: Stow the package**

  ```bash
  cd ~/dotfiles
  stow -v -t "$HOME" tmux
  ```
  Expected output contains: `LINK: .config/tmux/tmux.conf`

- [ ] **Step 6: Verify symlink**

  ```bash
  ls -la ~/.config/tmux/tmux.conf
  ```
  Expected: `~/.config/tmux/tmux.conf -> ~/dotfiles/tmux/.config/tmux/tmux.conf`

- [ ] **Step 7: Commit**

  ```bash
  cd ~/dotfiles
  git add tmux/
  git commit -m "feat: add tmux dotfile package"
  ```

---

## Task 4: Add starship stow package

**Files:**
- Create: `starship/.config/starship.toml`

Note: `starship.toml` lives directly in `~/.config/` (not a subdirectory), so the stow layout is `starship/.config/starship.toml`.

- [ ] **Step 1: Create package directory**

  ```bash
  mkdir -p ~/dotfiles/starship/.config
  ```

- [ ] **Step 2: Simulate stow**

  ```bash
  cd ~/dotfiles
  stow --simulate -t "$HOME" starship 2>&1
  ```
  Expected: no output.

- [ ] **Step 3: Copy live config**

  ```bash
  cp ~/.config/starship.toml ~/dotfiles/starship/.config/starship.toml
  ```

- [ ] **Step 4: Remove live file**

  ```bash
  rm ~/.config/starship.toml
  ```

- [ ] **Step 5: Stow the package**

  ```bash
  cd ~/dotfiles
  stow -v -t "$HOME" starship
  ```
  Expected output contains: `LINK: .config/starship.toml`

- [ ] **Step 6: Verify symlink**

  ```bash
  ls -la ~/.config/starship.toml
  ```
  Expected: `~/.config/starship.toml -> ~/dotfiles/starship/.config/starship.toml`

- [ ] **Step 7: Commit**

  ```bash
  cd ~/dotfiles
  git add starship/
  git commit -m "feat: add starship dotfile package"
  ```

---

## Task 5: Add walker stow package

**Files:**
- Create: `walker/.config/walker/config.toml`

Note: `~/.config/walker/` contains backup files (`config.toml.bak.*`) — only `config.toml` is tracked.

- [ ] **Step 1: Create package directory**

  ```bash
  mkdir -p ~/dotfiles/walker/.config/walker
  ```

- [ ] **Step 2: Simulate stow**

  ```bash
  cd ~/dotfiles
  stow --simulate -t "$HOME" walker 2>&1
  ```
  Expected: no output.

- [ ] **Step 3: Copy live config (main file only)**

  ```bash
  cp ~/.config/walker/config.toml ~/dotfiles/walker/.config/walker/config.toml
  ```

- [ ] **Step 4: Remove live file**

  ```bash
  rm ~/.config/walker/config.toml
  ```

- [ ] **Step 5: Stow the package**

  ```bash
  cd ~/dotfiles
  stow -v -t "$HOME" walker
  ```
  Expected output contains: `LINK: .config/walker/config.toml`

- [ ] **Step 6: Verify symlink**

  ```bash
  ls -la ~/.config/walker/config.toml
  ```
  Expected: `~/.config/walker/config.toml -> ~/dotfiles/walker/.config/walker/config.toml`

- [ ] **Step 7: Commit**

  ```bash
  cd ~/dotfiles
  git add walker/
  git commit -m "feat: add walker dotfile package"
  ```

---

## Task 6: Add p10k.zsh to shell package

**Files:**
- Modify: `shell/` — add `.p10k.zsh`

Note: `~/.p10k.zsh` lives at the home root. The shell package already manages `~/.zshrc` via `shell/.zshrc`. Adding `shell/.p10k.zsh` will stow it to `~/.p10k.zsh`.

- [ ] **Step 1: Simulate restow with the new file in place**

  First check nothing conflicts:
  ```bash
  cd ~/dotfiles
  stow --simulate -R -t "$HOME" shell 2>&1
  ```
  Expected: no output.

- [ ] **Step 2: Copy live p10k config into shell package**

  ```bash
  cp ~/.p10k.zsh ~/dotfiles/shell/.p10k.zsh
  ```

- [ ] **Step 3: Remove the live file**

  ```bash
  rm ~/.p10k.zsh
  ```

- [ ] **Step 4: Restow the shell package**

  ```bash
  cd ~/dotfiles
  stow -v -R -t "$HOME" shell
  ```
  Expected output contains: `LINK: .p10k.zsh`

- [ ] **Step 5: Verify both symlinks exist**

  ```bash
  ls -la ~/.p10k.zsh ~/.zshrc
  ```
  Both should point into `~/dotfiles/shell/`.

- [ ] **Step 6: Commit**

  ```bash
  cd ~/dotfiles
  git add shell/.p10k.zsh
  git commit -m "feat: add p10k.zsh to shell package"
  ```

---

## Task 7: Populate mako package

**Files:**
- Create: `mako/.config/mako/config`

The live system has no `~/.config/mako/config` — mako runs on defaults. We create an explicit config that matches those defaults so the file is tracked and reproducible.

- [ ] **Step 1: Create mako config directory**

  ```bash
  mkdir -p ~/dotfiles/mako/.config/mako
  ```

- [ ] **Step 2: Write the config file**

  Create `~/dotfiles/mako/.config/mako/config` with this content:
  ```ini
  font=monospace 10
  background-color=#285577
  text-color=#ffffff
  width=300
  height=100
  border-size=2
  border-color=#4c7899
  border-radius=0
  icons=1
  max-icon-size=64
  markup=1
  actions=1
  default-timeout=0
  ignore-timeout=0
  layer=top
  ```

- [ ] **Step 3: Simulate stow**

  ```bash
  cd ~/dotfiles
  stow --simulate -R -t "$HOME" mako 2>&1
  ```
  Expected: no output.

- [ ] **Step 4: Restow mako (it was already stowed as an empty package)**

  ```bash
  cd ~/dotfiles
  stow -v -R -t "$HOME" mako
  ```
  Expected output contains: `LINK: .config/mako/config`

- [ ] **Step 5: Verify symlink**

  ```bash
  ls -la ~/.config/mako/config
  ```
  Expected: `~/.config/mako/config -> ~/dotfiles/mako/.config/mako/config`

- [ ] **Step 6: Commit**

  ```bash
  cd ~/dotfiles
  git add mako/
  git commit -m "feat: populate mako config with explicit defaults"
  ```

---

## Task 8: Create curated package lists

**Files:**
- Create: `packages/pacman.txt`
- Create: `packages/aur.txt`

- [ ] **Step 1: Create packages directory**

  ```bash
  mkdir -p ~/dotfiles/packages
  ```

- [ ] **Step 2: Write pacman.txt**

  Create `~/dotfiles/packages/pacman.txt`:
  ```
  # Hyprland stack
  hyprland
  hyprpaper
  hypridle
  hyprlock
  waybar
  eww
  mako
  xdg-desktop-portal
  xdg-desktop-portal-hyprland
  wl-clipboard
  grim
  slurp
  wtype

  # Audio
  pipewire
  wireplumber
  pipewire-alsa
  pipewire-pulse
  pipewire-jack

  # Terminals & multiplexer
  ghostty
  kitty
  alacritty
  tmux

  # Shell & prompt
  zsh
  starship
  zoxide

  # Dev tools
  git
  neovim
  ripgrep
  fd
  stow
  unzip
  zip

  # CLI tools
  btop
  fastfetch
  lazygit

  # Apps
  discord
  obsidian

  # Fonts
  fontconfig
  noto-fonts
  noto-fonts-emoji
  ttf-jetbrains-mono-nerd
  ttf-cascadia-code-nerd

  # System
  networkmanager
  bluez
  bluez-utils
  uwsm
  ```

  Note: one package per line — the install script reads with `mapfile` which expects one token per line, not space-separated.

- [ ] **Step 3: Write aur.txt**

  Create `~/dotfiles/packages/aur.txt`:
  ```
  vivaldi
  walker-bin
  spotify
  satty
  swayosd-git
  oh-my-zsh-git
  ```

- [ ] **Step 4: Dry-run the install script to verify it reads the files correctly**

  ```bash
  cd ~/dotfiles
  bash -n install.sh
  ```
  Expected: no output (syntax check passes).

  Then verify the arrays are populated correctly:
  ```bash
  source <(grep -A200 'PACMAN_FILE=' install.sh | head -20)
  mapfile -t PACMAN_PKGS < <(grep -v '^\s*#' packages/pacman.txt | sed '/^\s*$/d')
  echo "Pacman packages: ${#PACMAN_PKGS[@]}"
  mapfile -t AUR_PKGS < <(grep -v '^\s*#' packages/aur.txt | sed '/^\s*$/d')
  echo "AUR packages: ${#AUR_PKGS[@]}"
  ```
  Expected: counts match the number of non-comment, non-empty lines in each file (~33 pacman, 6 AUR).

- [ ] **Step 5: Commit**

  ```bash
  cd ~/dotfiles
  git add packages/
  git commit -m "feat: add curated pacman and AUR package lists"
  ```

---

## Task 9: Update install.sh

**Files:**
- Modify: `install.sh`

Five additive changes. Make them in order — Oh My Zsh must come before the stow step.

- [ ] **Step 1: Add Oh My Zsh installation step (before step 4 — stow)**

  After the AUR package installation block (after line ~91), insert a new section:
  ```bash
  # ---------------------------------------------------
  # 3.5) Oh My Zsh (must come before stow so .zshrc works on first launch)
  # ---------------------------------------------------
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
      "" --unattended --keep-zshrc
  fi
  ```

- [ ] **Step 2: Extend PKG_DIRS to include new packages**

  Find the line:
  ```bash
  PKG_DIRS=(alacritty eww hypr mako nvim systemd waybar envd git kitty misc shell tools)
  ```
  Replace with:
  ```bash
  PKG_DIRS=(alacritty eww hypr mako nvim systemd waybar envd git kitty misc shell tools ghostty tmux starship walker)
  ```

- [ ] **Step 3: Add eww scripts chmod (in step 5 post-steps block)**

  After the existing hypr scripts chmod block, add:
  ```bash
  if [[ -d "$HOME/.config/eww/scripts" ]]; then
    find "$HOME/.config/eww/scripts" -type f -name '*.sh' -exec chmod +x {} +
  fi
  ```

- [ ] **Step 4: Enable battery monitor timer (in step 5 services block)**

  After the existing `enable_user` calls, add:
  ```bash
  enable_user "omarchy-battery-monitor.timer"
  ```

- [ ] **Step 5: Add Bluetooth unblock (in step 5 after bluetooth service)**

  After `enable_sys "bluetooth.service"`, add:
  ```bash
  if have rfkill; then
    rfkill unblock bluetooth 2>/dev/null || true
  fi
  ```

- [ ] **Step 6: Verify install.sh syntax**

  ```bash
  bash -n ~/dotfiles/install.sh
  ```
  Expected: no output.

- [ ] **Step 7: Commit**

  ```bash
  cd ~/dotfiles
  git add install.sh
  git commit -m "feat: update install.sh — omz, new packages, services, bluetooth"
  ```

---

## Self-Review

**Spec coverage check:**

| Spec requirement | Task |
|---|---|
| ghostty stow package | Task 2 |
| tmux stow package | Task 3 |
| starship stow package | Task 4 |
| walker stow package | Task 5 |
| p10k.zsh in shell package | Task 6 |
| mako populated | Task 7 |
| packages/pacman.txt | Task 8 |
| packages/aur.txt | Task 8 |
| Oh My Zsh step in install.sh | Task 9, Step 1 |
| PKG_DIRS extended | Task 9, Step 2 |
| eww scripts chmod | Task 9, Step 3 |
| battery timer enabled | Task 9, Step 4 |
| Bluetooth unblock | Task 9, Step 5 |
| input.conf window rule fix | Task 1 |
| hyprland.conf fullscreen fix | Task 1 |

All 15 spec requirements covered. ✓
