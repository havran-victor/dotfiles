# 🛠️ My Arch + Hyprland Dotfiles

These are my personal dotfiles for **Arch Linux** running **Hyprland** (Wayland).  
They are managed with [GNU Stow](https://www.gnu.org/software/stow/) to keep configs clean, portable, and reproducible.

---

## 📦 What’s Included
- **Hyprland** (`~/.config/hypr/`)
- **Waybar**, **Eww**, **Mako**
- **Kitty**, **Alacritty**
- **Neovim**
- **Zsh** (with a clean `.zshrc`)
- **Git** config
- **Systemd user services** (`~/.config/systemd/user/`)
- **Environment variables** (`~/.config/environment.d/`)
- **Tools**: btop, lazygit, fastfetch, neofetch, etc.
- **Install script** (`install.sh`) to bootstrap a new system

---

## 🚀 Installation (Fresh Arch Install)

1. Install Arch Linux using `archinstall` (choose your base system and drivers as needed).

2. Install **Omarchy**:
   ```bash
   wget -qO- https://omarchy.org/install | bash
   ```

3. Install **git**:
   ```bash
   sudo pacman -Sy git
   ```

4. Clone this repo:
   ```bash
   git clone git@github.com:havran-victor/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

5. Run the install script:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

The script will:
- Install pacman + AUR dependencies (from `packages/pacman.txt` and `packages/aur.txt` if available, otherwise defaults).
- Stow all dotfiles into `$HOME`.
- Enable common services (PipeWire, WirePlumber, Portals, NetworkManager, Bluetooth).
- Set `zsh` as the default shell.

---

## 🖼️ Extras & Tips

- **Wallpapers & Themes**  
  Put wallpapers under `hypr/.config/hypr/wallpapers/` and reference them in `hyprpaper.conf`.  
  Optional assets:
  ```
  misc/.local/share/fonts/
  misc/.local/share/icons/
  misc/.themes/
  ```

- **Secrets**  
  Do not commit tokens or secrets. Keep machine-specific stuff in `~/.zshrc.local` (gitignored).  
  Example include in `.zshrc`:
  ```zsh
  [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
  ```

- **Freeze your exact packages** (optional, run on your main box):
  ```bash
  mkdir -p packages
  pacman -Qqe | grep -vxFf <(pacman -Qqm) > packages/pacman.txt
  pacman -Qqm > packages/aur.txt
  git add packages && git commit -m "freeze: pacman + aur lists"
  ```

---

## 🧪 Test on a fresh user (optional)
```bash
sudo useradd -m testuser
sudo passwd testuser
sudo -iu testuser bash -lc '
  sudo pacman -Sy git
  git clone git@github.com:havran-victor/dotfiles ~/dotfiles
  cd ~/dotfiles && ./install.sh
'
```

---

## 🙌 Credits
- [Hyprland](https://hyprland.org/)
- [Arch Wiki](https://wiki.archlinux.org/)
- The r/unixporn & r/archlinux communities

