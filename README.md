# 🌵 kae3g Young Jupiter Landmark Cactus NixOS Configuration

> *A contemporary NixOS configuration optimized for Framework 16 with GNOME desktop environment*

## 🖥️ System Overview

**Hardware**: Framework 16 Laptop  
**CPU**: AMD Ryzen 7 7840HS  
**GPU**: AMD Radeon 780M (integrated) + RX 7600M XT (discrete)  
**Desktop**: GNOME with Wayland  
**Configuration**: NixOS Flakes + Home Manager  

## 🎯 Philosophy

This configuration embraces **stability over experimentation** by using GNOME as the primary desktop environment while providing VirtualBox for safe Hyprland experimentation. It's optimized specifically for Framework 16 hardware with AMD graphics.

## 📋 Template System

This repository uses a **template-based approach** that separates personal information from the configuration files:

- **Template files** (`*.nix`): Contains the main configuration logic with variables
- **Secrets file** (`secrets.nix`): Contains your personal information (gitignored)
- **Setup script** (`setup.sh`): Helps you customize the configuration for your system

This approach makes the configuration **reusable by others** while keeping your personal data secure.

## ✨ Key Features

### 🖼️ Desktop Environment
- **GNOME**: Contemporary, stable Wayland desktop
- **Dark Theme**: Adwaita-dark with custom Arizona Sedona wallpaper
- **Extensions**: Dash-to-dock, AppIndicator, Vitals, User Themes
- **Wayland Native**: Optimized for contemporary display protocols

### ⚙️ Framework 16 Optimizations
- **AMD GPU Support**: Dual GPU configuration (integrated + discrete)
- **Display Fixes**: Prevents white/flashing screen issues (`amdgpu.sg_display=0`)
- **Color Accuracy**: Fixes power saving mode colors (`amdgpu.abmlevel=0`)
- **Power Management**: power-profiles-daemon for optimal battery life
- **Thermal Control**: Advanced thermal management for AMD 7840HS
- **Sleep Prevention**: Prevents accidental wake-up in backpack
- **Audio Optimization**: Framework-specific audio compatibility

### 👨‍💻 Development Environment
- **Editor**: Kakoune (`kak`) as default everywhere
- **Git**: Configured with kae3g identity and GPG signing
- **Tools**: Full development stack (Docker, Node.js, Python, etc.)
- **Terminal**: Kitty with optimized configuration
- **Shell**: Zsh with modern tooling

### 🔬 Virtualization
- **VirtualBox**: Ready for Hyprland experimentation
- **Docker**: Container development support
- **Safe Testing**: Experiment with window managers in VMs

## 🚀 Quick Start

### Prerequisites
- Framework 16 laptop (or compatible AMD system)
- NixOS installed
- Git configured

### Installation

1. **Clone the repository**:
```bash
git clone https://github.com/kae3g/kae3g-young-jupiter-landmark-cactus-nixos-config.git
cd kae3g-young-jupiter-landmark-cactus-nixos-config
```

2. **Run the setup script**:
```bash
./setup.sh
```

3. **Customize your configuration**:
```bash
# Edit secrets.nix with your personal information
nano secrets.nix  # or use your preferred editor

# Update:
# - Username and email
# - GPG signing key (optional)
# - Editor preference
# - Timezone and locale
# - Hardware optimizations (disable for non-Framework systems)
```

4. **Copy configuration files**:
```bash
sudo cp *.nix /etc/nixos/
sudo cp wallpaper.jpg /etc/nixos/  # optional
```

5. **Rebuild system**:
```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

6. **Restart and enjoy GNOME!** 🎉

### ⚠️ Troubleshooting

If you encounter issues after the rebuild:

- **GNOME Settings won't open**: Restart your computer to ensure environment variables are properly initialized
- **Desktop environment detection issues**: A restart usually resolves XDG_CURRENT_DESKTOP conflicts
- **Home Manager activation failures**: Check for file conflicts and use the backup option in flake.nix
- **Environment variables not applied**: Log out and log back in, or restart the system

## 📁 Repository Structure

```
.
├── flake.nix                    # Main flake configuration with inputs
├── flake.lock                  # Locked dependency versions
├── configuration.nix           # NixOS system configuration (template)
├── home.nix                    # Home Manager user configuration (template)
├── hardware-configuration.nix  # Hardware-specific settings
├── secrets.nix.template        # Template for personal configuration
├── secrets.nix                 # Personal configuration (gitignored)
├── setup.sh                    # Setup script for new users
├── wallpaper.jpg              # Arizona Sedona landscape wallpaper
├── REBUILD_BLUEPRINT.md       # Detailed rebuild instructions
├── .github/workflows/          # GitHub Actions for branch mirroring
└── README.md                  # This file
```

## 🔧 Configuration Highlights

### System Configuration (`configuration.nix`)
- **GNOME Desktop**: Contemporary Wayland-based environment
- **AMD Graphics**: Optimized for Framework 16 dual GPU setup
- **VirtualBox**: Host configuration for VM experimentation
- **Security**: GPG agent with pinentry-gtk2
- **Fonts**: Comprehensive font stack including Noto and Fira Code

### User Configuration (`home.nix`)
- **Development Tools**: Kakoune, Neovim, Cursor, Zed
- **Git Setup**: kae3g identity with GPG signing (801E24E10E8FA29C)
- **Environment**: Kakoune as default editor (EDITOR=kak)
- **Applications**: Brave, Discord, Spotify, development tools
- **GNOME Integration**: Extensions and dark theme configuration

### Flake Configuration (`flake.nix`)
- **Contemporary Inputs**: nixpkgs-unstable, home-manager, hyprland (for VMs)
- **Integration**: Home Manager integrated into NixOS configuration
- **Flexibility**: Easy to extend and modify

## 🎨 Customization

### Wallpaper
Beautiful Arizona Sedona red rocks landscape from Unsplash, automatically set as GNOME background.

### Theme
- **GNOME Theme**: Adwaita-dark
- **Color Scheme**: Dark mode throughout
- **Icons**: Adwaita icon theme

### Editor
Kakoune configured as the default editor:
- `EDITOR=kak`
- `VISUAL=kak` 
- `core.editor=kak` in Git

## 🔬 Hyprland Experimentation

Instead of running Hyprland on bare metal, this configuration provides VirtualBox for safe experimentation:

1. **Create VM**: Use VirtualBox to create a new VM
2. **Install NixOS**: Install minimal NixOS in the VM
3. **Configure Hyprland**: Experiment with window manager configurations
4. **Safe Testing**: No risk to your stable GNOME environment

## 🔄 Branch Strategy

### Branches
- **`landmark-cactus`** (default): Stable production configuration
- **`dev-unstable`**: Development branch (auto-mirrored from landmark-cactus)
- **`broken-backup--12025-09-28`**: Historical Hyprland configuration backup

### GitHub Actions
- **Automatic Mirroring**: `landmark-cactus` → `dev-unstable` on every push
- **Development Workflow**: Make changes on `landmark-cactus`, test on `dev-unstable`

## 🛠️ Maintenance

### Updating
```bash
cd /home/xx/kae3g/kae3g-young-jupiter-landmark-cactus-nixos-config
git pull
sudo cp *.nix /etc/nixos/
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

### Rollback
```bash
sudo nixos-rebuild switch --rollback
```

### Cleanup
```bash
nix-collect-garbage -d
sudo nix-collect-garbage -d
```

## 🌟 Why This Configuration?

1. **Stability First**: GNOME provides a rock-solid daily driver
2. **Framework Optimized**: Specifically tuned for Framework 16 hardware
3. **Contemporary NixOS**: Uses flakes for reproducible builds
4. **Safe Experimentation**: VirtualBox for testing without breaking the host
5. **Developer Friendly**: Complete development environment included
6. **Future Proof**: Easy to extend and modify

## 🤝 Contributing

This is a personal configuration, but feel free to:
- Use parts for your own Framework 16 setup
- Report issues specific to Framework hardware
- Suggest improvements for GNOME + Framework integration

## 📄 License

Personal configuration - use at your own discretion.

---

*Configured with ❤️ for Framework 16 and GNOME*
