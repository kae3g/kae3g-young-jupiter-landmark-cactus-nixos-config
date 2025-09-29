# kae3g Young Jupiter Landmark Cactus NixOS Configuration
# GNOME Desktop Environment with VirtualBox support for Hyprland experimentation

{ config, pkgs, inputs, ... }:

let
  secrets = import ./secrets.nix;
in

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Framework 16 AMD 7840HS specific kernel parameters
  boot.kernelParams = [ 
    "amdgpu.sg_display=0"  # Fix for white/flashing screens
    "amdgpu.abmlevel=0"    # Fix color accuracy in power saving modes
  ];
  
  # AMD GPU support
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Enable flakes and new nix command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Networking
  networking.hostName = secrets.system.hostname;
  networking.networkmanager.enable = true;

  # Time zone and internationalization
  time.timeZone = secrets.system.timezone;
  i18n.defaultLocale = secrets.system.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # GNOME Desktop Environment
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # VirtualBox support for Hyprland experimentation
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "xx" ];

  # Docker support
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "xx" ];

  # User account
  users.users.${secrets.user.username} = {
    isNormalUser = true;
    description = secrets.user.name;
    extraGroups = [ "networkmanager" "wheel" "vboxusers" "docker" ];
    shell = pkgs.zsh;
  };

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # GPG support
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  # Essential system packages
  environment.systemPackages = with pkgs; [
    # Editors
    kakoune
    neovim
    vim
    
    # Development tools
    git
    curl
    wget
    
    # System utilities
    htop
    tree
    unzip
    zip
    
    # GNOME extensions and tools
    gnome-tweaks
    dconf-editor
    gnome-extension-manager
    
    # VirtualBox
    virtualbox
    
    # Terminal
    kitty
    
    # File management
    nautilus
    
    # Network tools
    networkmanagerapplet
  ];

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
  ];

  # Enable OpenGL with AMD optimizations
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # AMD GPU acceleration
      mesa
      # OpenCL support
      rocmPackages.clr.icd
    ];
  };

  # Framework 16 power management
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;
  
  # Firmware updates
  services.fwupd.enable = true;
  
  # Prevent wake up in backpack (Framework specific)
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
    SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0014", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
  '';

  # Framework audio compatibility
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=framework-laptop
  '';

  # System version
  system.stateVersion = "25.05";
}
