# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, outputs, config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # input home manager
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    backupFileExtension = "backup";
    users = {
      # Import your home-manager configuration
      fikri = import ./home.nix;
    };
  };

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.useOSProber = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.enableAllFirmware = true;
  hardware.firmware = [ pkgs.firmwareLinuxNonfree pkgs.sof-firmware ];

  networking.hostName = "DLLPTP"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    enable = true;
  };

  # services.displayManager.sddm.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fikri = {
    isNormalUser = true;
    description = "Rijalul Fikri";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowInsecure = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
    # Editor
    neovim
    emacs
    vscode
    helix
    zed-editor

    # PHP Development Goodies
    php82
    php82Packages.composer
    php82Extensions.gd
    php82Extensions.mbstring
    phpactor
    emacsPackages.phpactor
    dbeaver-bin

    # Node Environment
    nodejs_22
    bun

    # Rust
    rustup

    # Terminal Goodies
    fd
    xh # curl alt
    jless # json viewer
    kitty
    tmux
    zellij
    yazi
    wtf
    nnn
    git
    tldr
    ripgrep
    fzf
    bat
    zoxide
    lazygit
    starship

    # EyeCandies
    hyprland
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    hyprpaper
    xwayland
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    rofi-wayland
    waybar
    tokyo-night-gtk
    bibata-cursors
    figlet

    # System Utilities
    brightnessctl
    pavucontrol
    pipewire
    wireplumber
    networkmanagerapplet
    dunst
    home-manager

    # Utilities
    nix-prefetch
    slack
    obs-studio
    killall
    gum
    htop
    wget
    grim
    slurp
    xclip
    wlroots
    unzip
    mpv
    gcc

    # Browsers
    brave
    firefox-wayland
    arc-browser

    # Misc
    fastfetch
  ]) ++ (with pkgs.gnome; [
      nautilus # file manager
      zenity # shell dialog
      gnome-tweaks # eye candy
      eog # image viewer
    ]);

  services.nginx.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Hint Electron apps to use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Set System Variable
  environment.variables = {
    EDITOR = "helix";
    BROWSER = "brave";
    TERMINAL = "kitty";
  };

  # Enable Screensharing
  services.dbus.enable = true;
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };

  # fix issue with waybar
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];

  # fonts
  fonts.packages = with pkgs; [
    nerdfonts
    meslo-lgs-nf
    google-fonts
  ];

  # sounds
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Let's setup ZSH
  # for global user
  users.defaultUserShell=pkgs.zsh;

  # enable zsh and oh my zsh
  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      zsh-autoenv.enable = true;
      syntaxHighlighting.enable = true;
    };
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$python$character";
        directory = {
          style = "blue";
        };
        character = {
          success_symbol = "[❯](purple)";
          error_symbol = "[❯](red)";
          vimcmd_symbol = "[❮](green)";
        };
        git_branch = {
          format = "[$branch]($style)";
          style = "bright-black";
        };
        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
          style = "cyan";
          conflicted = "​";
          untracked = "​";
          modified = "​";
          staged = "​";
          renamed = "​";
          deleted = "​";
          stashed = "≡";
        };
        git_state = {
          format = "\([$state( $progress_current/$progress_total)]($style)\) ";
          style = "bright-black";
        };
        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
        };
        python = {
          format = "[$virtualenv]($style) ";
          style = "bright-black";
        };
      };
    };
  };

  # Styling Options
  stylix = {
    enable = true;
    image = ./config/wallpapers/beautifulmountainscape.jpg;
    # base16Scheme = {
    #   base00 = "232136";
    #   base01 = "2a273f";
    #   base02 = "393552";
    #   base03 = "6e6a86";
    #   base04 = "908caa";
    #   base05 = "e0def4";
    #   base06 = "e0def4";
    #   base07 = "56526e";
    #   base08 = "eb6f92";
    #   base09 = "f6c177";
    #   base0A = "ea9a97";
    #   base0B = "3e8fb0";
    #   base0C = "9ccfd8";
    #   base0D = "c4a7e7";
    #   base0E = "f6c177";
    #   base0F = "56526e";
    # };
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 15;
        terminal = 19;
        desktop = 15;
        popups = 15;
      };
    };
  };

  # Enable automatic garbage collection
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";  # Set to daily, monthly, etc., as needed

  # Optional: Limit the number of generations to keep
  nix.gc.options = "--delete-older-than 7d";  # Adjust as necessary

  # Optimize storage
  nix.optimise.automatic = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
