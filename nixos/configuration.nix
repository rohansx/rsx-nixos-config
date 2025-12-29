# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable graphics
  hardware.graphics.enable = true;

  # Nvidia Configuration for Wayland
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    powerManagement.enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  # ===== HYPRLAND CONFIGURATION =====
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Environment variables for Hyprland + NVIDIA
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    # NVIDIA specific
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };

  # Use greetd as display manager for Hyprland
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # XDG Portal for screen sharing, file picker, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Enable dbus for AGS
  services.dbus.enable = true;

  # Fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.iosevka
      material-design-icons
      papirus-icon-theme
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.rsx = {
    isNormalUser = true;
    description = "rsx";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" "input" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "beekeeper-studio-5.3.4"
    "qtwebengine-5.15.19"
  ];

  # Enable Zsh system-wide
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "docker" "node" "npm" "rust" "golang" ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Browsers
    brave
    firefox

    # Dev tools
    git
    vim
    neovim
    vscode
    code-cursor
    beekeeper-studio

    # Languages & runtimes
    nodejs_22
    python3
    go
    rustup
    bun

    # Docker
    docker
    docker-compose

    # Terminal
    kitty
    foot           # lightweight wayland terminal
    tmux
    fzf
    ripgrep
    curl
    wget
    unzip
    jq
    appimage-run

    # Apps
    slack

    # Zsh plugins
    zsh-autosuggestions
    zsh-syntax-highlighting

    # AI coding tools
    opencode
    claude-code

    # ===== Hyprland & ML4W Dependencies =====
    waybar             # status bar
    wofi               # launcher
    rofi               # alternative launcher
    dunst              # notifications
    swww               # wallpaper daemon
    hyprlock           # lock screen
    hypridle           # idle daemon
    hyprpicker         # color picker
    hyprshot           # screenshot tool

    # GTK theming
    gtk3
    gtk4
    adwaita-icon-theme
    gnome-themes-extra
    papirus-icon-theme

    # Qt theming
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct
    qt6Packages.qt6ct

    # System utilities for widgets
    networkmanager     # for wifi widget
    bluez              # for bluetooth widget
    upower             # for battery widget

    # File manager
    nautilus
    kdePackages.dolphin  # KDE file manager (ML4W uses this)

    # Image viewer
    imv

    # Notifications
    libnotify

    # Screenshot
    grim
    slurp

    # Clipboard
    wl-clipboard
    cliphist

    # ML4W additional dependencies
    playerctl          # media controls
    brightnessctl      # brightness control
    pamixer            # audio control
    pavucontrol        # audio GUI
    wlsunset           # night light
    swaylock-effects   # fancy lock screen
    wlogout            # logout menu
    yad                # GUI dialogs
    python312Packages.pywal  # color scheme generator
    fastfetch          # system info
    btop               # system monitor
    eza                # modern ls
    polkit_gnome       # authentication agent
    swaynotificationcenter  # swaync notification daemon
    networkmanagerapplet    # nm-applet
    psmisc             # killall, pstree, etc.
    killall            # process killer
    jq                 # JSON processor (for scripts)
    socat              # socket utility
    power-profiles-daemon  # power management
  ];

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Power management
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # Polkit for authentication dialogs
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
