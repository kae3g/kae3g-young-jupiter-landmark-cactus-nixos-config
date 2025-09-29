{ config, pkgs, inputs, ... }:

let
  secrets = import ./secrets.nix;
in

{
  # Basic Home Manager configuration
  home.username = secrets.user.username;
  home.homeDirectory = secrets.user.homeDirectory;
  home.stateVersion = "25.05";

  # Note: nixpkgs.config removed due to useGlobalPkgs in flake

  # Disable Home Manager unstable nixpkgs warning
  home.enableNixpkgsReleaseCheck = false;

  # Packages
  home.packages = with pkgs; [
    # Development tools
    git
    neovim
    emacs
    kakoune
    vim
    zed-editor
    code-cursor
    docker
    meson
    python3
    uv
    nodejs_24
    nodePackages.pnpm
    nodePackages.yarn
    nushell
    zsh
    tmux
    zellij
    screen

    # System utilities
    gnupg
    pinentry
    networkmanagerapplet
    wayland-protocols
    wayland-utils
    wl-clipboard
    xdg-desktop-portal-gtk

    # GNOME extensions and tools
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.vitals
    gnomeExtensions.user-themes
    gnome-tweaks
    dconf-editor
    gnome-extension-manager

    # VirtualBox for Hyprland experimentation
    virtualbox

    # Screenshot tools (GNOME compatible)
    gnome-screenshot
    flameshot

    # Applications
    brave
    discord
    signal-desktop
    spotify
    bluebubbles
    ollama
    open-webui
    oterm
    nautilus
    speedtest-cli
  ];

  # Environment variables
  home.sessionVariables = {
    # Editor
    EDITOR = secrets.editor.default;
    VISUAL = secrets.editor.default;
    
    # Wayland support
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "GNOME";
    XDG_SESSION_DESKTOP = "GNOME";
  };

  # Shell configurations
  programs.bash = {
    enable = true;
    shellAliases = {
      speedtest = "speedtest --secure";
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      speedtest = "speedtest --secure";
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = secrets.git.userName;
    userEmail = secrets.git.userEmail;
    extraConfig = {
      commit.gpgsign = secrets.git.enableSigning;
      tag.gpgSign = secrets.git.enableSigning;
      user.signingkey = if secrets.git.enableSigning then secrets.git.signingKey else null;
      core.editor = secrets.editor.default;
    };
  };

  # GPG configuration
  programs.gpg.enable = true;

  # Services
  services = {
    gnome-keyring.enable = true;
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gtk2;
    };
  };

  # Chromium/Brave configuration
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--enable-wayland-ime"
      "--ozone-platform=wayland"
      "--enable-features=UseOzonePlatform"
      "--disable-gpu-sandbox"
      "--enable-unsafe-webgpu"
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
      "--disable-dev-shm-usage"
      "--no-sandbox"
      "--disable-setuid-sandbox"
    ];
  };

  # VS Code/Cursor configuration
  programs.vscode = {
    enable = true;
    package = pkgs.code-cursor;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Add extensions here
      ];
      userSettings = {
        "window.titleBarStyle" = "custom";
        "window.useNativeTitleBar" = false;
        
        # Terminal environment variables for GPG support
        "terminal.integrated.env.linux" = {
          "GPG_TTY" = "$(tty)";
          "GNOME_KEYRING_CONTROL" = "$XDG_RUNTIME_DIR/keyring";
          "SSH_AUTH_SOCK" = "$XDG_RUNTIME_DIR/keyring/ssh";
          # Additional GPG environment variables
          "GPG_AGENT_INFO" = "$XDG_RUNTIME_DIR/gnupg/S.gpg-agent";
        };
        
        # Git configuration for GPG signing
        "git.enableCommitSigning" = true;
        "git.gpgPath" = "gpg";
        "git.signingKey" = "801E24E10E8FA29C";  # Your main GPG key ID
        "git.autoStash" = true;
        "git.confirmSync" = false;
        
        # Cursor-specific Git settings
        "git.useCommitInputAsStashMessage" = true;
        "git.showProgress" = "always";
        "git.allowNoVerifyCommit" = false;
        "git.allowCommitSigning" = true;
        "git.autoFetch" = true;
        "git.autofetch" = true;
        
        # Terminal settings
        "terminal.integrated.shell.linux" = "/home/xx/.nix-profile/bin/zsh";
        "terminal.integrated.inheritEnv" = true;
      };
    };
  };

  # Hyprland configuration
  programs.kitty = {
    enable = true;
    settings = {
      shell = "/home/xx/.nix-profile/bin/zsh";
      wayland_enable = true;
      startup_session = "none";
      close_on_child_death = "no";
      allow_remote_control = "no";
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };
  };
  
  # GNOME configuration and extensions
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Adwaita";
    };
    
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,minimize,maximize:";
    };
    
    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/xx/Pictures/wallpaper.jpg";
      picture-uri-dark = "file:///home/xx/Pictures/wallpaper.jpg";
    };
  };

  # Additional GNOME configuration

  # VirtualBox configuration for Hyprland experimentation
  home.file = {
    ".local/share/applications/hyprland-vm.desktop".text = ''
      [Desktop Entry]
      Name=Hyprland VM
      Comment=Launch Hyprland in VirtualBox for experimentation
      Exec=virtualbox --startvm "Hyprland-Test" --separate
      Icon=virtualbox
      Type=Application
      Categories=Development;
    '';
    
    # Copy wallpaper to Pictures directory
    "Pictures/wallpaper.jpg".source = ./wallpaper.jpg;
  };
}
