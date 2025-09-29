# 🚀 Framework 16 NixOS GNOME Rebuild Blueprint

## 📋 Pre-Rebuild Checklist
- [x] Configuration files updated for GNOME
- [x] Flakes enabled
- [x] Framework 16 AMD optimizations applied
- [x] Git configured with kae3g identity and Kakoune editor
- [x] VirtualBox support for Hyprland experimentation

## 🔧 Rebuild Instructions

### Step 1: Copy Configuration Files
```bash
sudo cp /home/xx/kae3g/kae3g-young-jupiter-landmark-cactus-nixos-config/configuration.nix /etc/nixos/
sudo cp /home/xx/kae3g/kae3g-young-jupiter-landmark-cactus-nixos-config/flake.nix /etc/nixos/
```

### Step 2: Enable Flakes System-Wide (if not already enabled)
```bash
sudo mkdir -p /etc/nix
echo "experimental-features = nix-command flakes" | sudo tee /etc/nix/nix.conf
```

### Step 3: Rebuild System
```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

## 🖥️ What This Configuration Provides

### Framework 16 Optimizations
- **AMD GPU Support**: Optimized for Ryzen 7 7840HS + Radeon 780M + RX 7600M XT
- **Power Management**: power-profiles-daemon for better battery life
- **Display Fixes**: Prevents white/flashing screen issues (`amdgpu.sg_display=0`)
- **Color Accuracy**: Fixes power saving mode color issues (`amdgpu.abmlevel=0`)
- **Thermal Management**: thermald for better heat management
- **Firmware Updates**: fwupd for Framework firmware updates
- **Sleep Prevention**: Prevents wake-up in backpack

### GNOME Desktop Environment
- **Modern Desktop**: GNOME with Wayland support
- **Dark Theme**: Adwaita-dark theme configured
- **Extensions Ready**: Dash-to-dock, AppIndicator, Vitals, User Themes
- **GNOME Tools**: Tweaks, dconf-editor, extension-manager

### Development Environment
- **Editor**: Kakoune set as default (EDITOR=kak, VISUAL=kak, core.editor=kak)
- **Git**: Configured with kae3g identity and GPG signing
- **Development Tools**: Full suite including Docker, Node.js, Python, etc.
- **VirtualBox**: Ready for Hyprland experimentation

### Applications
- **Browsers**: Brave with Wayland optimizations
- **Communication**: Discord, Signal
- **Media**: Spotify
- **Development**: Cursor, Zed, Neovim, Kakoune
- **Terminals**: Kitty (configured)

## 🔄 Post-Rebuild Steps

1. **Restart your machine** - Essential for GPU drivers and kernel changes
2. **Log into GNOME** - Should boot into GDM with GNOME desktop
3. **Test Cursor** - Should work with Wayland optimizations
4. **Setup VirtualBox VM** - For Hyprland experimentation
5. **Install GNOME Extensions** - Use Extension Manager

## ⚠️ Important Notes

- **Backup**: Your current Hyprland config is preserved in `broken-backup--12025-09-28` branch
- **VirtualBox**: Use for Hyprland experimentation instead of bare metal
- **Framework**: Optimized specifically for Framework 16 AMD hardware
- **Flakes**: Modern Nix configuration management enabled

## 🆘 Troubleshooting

If something goes wrong:
- Boot into previous generation from GRUB menu
- Check logs: `journalctl -xb`
- Revert: `sudo nixos-rebuild switch --rollback`

## 📱 Contact
If you need help, the configuration is in the `landmark-cactus` branch at:
`~/kae3g/kae3g-young-jupiter-landmark-cactus-nixos-config`

Good luck! 🍀
