#!/usr/bin/env bash
# Rehydrate my Arch + Hyprland dotfiles
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

log() { printf "\n\033[1;36m==>\033[0m %s\n" "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# -------------------------
# 0) Sanity / prerequisites
# -------------------------
if ! grep -qi "arch" /etc/os-release; then
  echo "This script is intended for Arch-based systems."
  exit 1
fi

log "Installing base tools (git, stow)..."
sudo pacman -Syu --noconfirm --needed git stow

# -------------------------
# 1) AUR helper (yay)
# -------------------------
if ! have yay; then
  log "Installing yay (AUR helper)..."
  sudo pacman -S --noconfirm --needed base-devel
  tmpdir="$(mktemp -d)"
  pushd "$tmpdir" >/dev/null
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -si --noconfirm
  popd >/dev/null
  rm -rf "$tmpdir"
fi

# ---------------------------------------------------------
# 2) Package sets
#    If packages/{pacman.txt,aur.txt} exist, they are used.
#    Otherwise, fall back to minimal defaults for Hyprland.
# ---------------------------------------------------------
DEFAULT_PACMAN_PKGS=(
  # Hyprland stack
  hyprland waybar eww mako hyprpaper
  xdg-desktop-portal xdg-desktop-portal-hyprland
  wl-clipboard grim slurp wtype

  # Audio/portals
  pipewire wireplumber pipewire-alsa pipewire-pulse pipewire-jack

  # Shell / Dev
  zsh git neovim ripgrep fd unzip zip
  btop fastfetch lazygit

  # Fonts
  fontconfig noto-fonts noto-fonts-emoji
)

DEFAULT_AUR_PKGS=(
  ttf-jetbrains-mono-nerd
  hypridle
  hyprlock
  swayosd
)

PACMAN_FILE="packages/pacman.txt"
AUR_FILE="packages/aur.txt"

if [[ -f $PACMAN_FILE ]]; then
  mapfile -t PACMAN_PKGS < <(grep -v '^\s*#' "$PACMAN_FILE" | sed '/^\s*$/d')
else
  PACMAN_PKGS=("${DEFAULT_PACMAN_PKGS[@]}")
fi

if [[ -f $AUR_FILE ]]; then
  mapfile -t AUR_PKGS < <(grep -v '^\s*#' "$AUR_FILE" | sed '/^\s*$/d')
else
  AUR_PKGS=("${DEFAULT_AUR_PKGS[@]}")
fi

# --------------------------------
# 3) Install packages (idempotent)
# --------------------------------
if ((${#PACMAN_PKGS[@]})); then
  log "Installing pacman packages..."
  sudo pacman -S --noconfirm --needed "${PACMAN_PKGS[@]}"
fi
if ((${#AUR_PKGS[@]})); then
  log "Installing AUR packages..."
  yay -S --noconfirm --needed "${AUR_PKGS[@]}"
fi

# ---------------------------------------------------
# 4) Stow dotfiles (your current repo packages)
# ---------------------------------------------------
# Only stow these top-level dirs you have today:
PKG_DIRS=(alacritty eww hypr mako nvim systemd waybar envd git kitty misc shell tools)

log "Stowing packages into \$HOME..."
for pkg in "${PKG_DIRS[@]}"; do
  [[ -d "$pkg" ]] || continue
  # only stow if it contains something
  if compgen -G "$pkg/*" >/dev/null; then
    stow -v -R -t "$HOME" "$pkg"
  fi
done

# ---------------------------------------------------
# 5) Post-steps: perms, fonts, services, shell
# ---------------------------------------------------
# Ensure Hypr scripts are executable
if [[ -d "$HOME/.config/hypr/scripts" ]]; then
  find "$HOME/.config/hypr/scripts" -type f -name '*.sh' -exec chmod +x {} +
fi

# Rebuild font cache if repo ships fonts
if [[ -d "$HOME/.local/share/fonts" ]]; then
  log "Refreshing font cache..."
  fc-cache -f
fi

# Enable common services (best-effort; safe if missing)
enable_user() { systemctl --user enable --now "$1" 2>/dev/null || true; }
enable_sys()  { sudo systemctl enable --now "$1" 2>/dev/null || true; }

log "Enabling common services (best effort)..."
enable_user "pipewire.service"
enable_user "wireplumber.service"
enable_user "xdg-desktop-portal.service"
enable_user "xdg-desktop-portal-hyprland.service"

# Network/Bluetooth are often wanted; comment if you manage differently
enable_sys "NetworkManager.service"
enable_sys "bluetooth.service"

# Make zsh default shell (skip silently if already set)
if have zsh && [[ "${SHELL:-}" != *zsh ]]; then
  log "Setting default shell to zsh..."
  chsh -s "$(command -v zsh)" || true
fi

log "✅ Done! Log out/in (or reboot) if environment.d or services changed."
