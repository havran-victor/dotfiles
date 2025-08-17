# 🛠️ My Arch + Hyprland Dotfiles

These are my personal dotfiles for **Arch Linux** running **Hyprland** (Wayland).  
Managed with [GNU Stow](https://www.gnu.org/software/stow/).

---

## 📦 What’s inside
- Hyprland config (`~/.config/hypr/`)
- Waybar, Eww, Mako, Kitty, Alacritty
- Neovim, Zsh, Git config
- Systemd user services, environment vars
- Misc tools (btop, fastfetch, lazygit, etc.)
- `install.sh` script to bootstrap everything

---

## 🚀 Installation (fresh Arch install)

1. Install Arch using `archinstall` (with Hyprland packages if you want).
2. Install **git**:
   ```bash
   sudo pacman -Sy git
3. Clone this repo:
git clone git@github.com:havran-victor/dotfiles.git ~/dotfiles
cd ~/dotfiles
4.Run the install script:
chmod +x install.sh
./install.sh
