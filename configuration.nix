# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.useOSProber = true;

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

  services.displayManager.sddm.enable = true;

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
     dbeaver-bin

     # Node Environment
     nodejs_22
     bun

     # Rust
     rustup

     # Terminal Goodies
     alacritty
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
     sddm
     waybar
     tokyo-night-gtk
     bibata-cursors

     # System Utilities
     brightnessctl
     pavucontrol
     pipewire
     wireplumber
     networkmanagerapplet
     dunst
     home-manager

     # Utilities
     slack
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
     obs-studio

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
    TERMINAL = "alacritty";
  };

  # Enable Screensharing
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
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
		  ohMyZsh = {
			  enable = true;
			  theme = "robbyrussell";
			  plugins = [
				  "git"
				  "npm"
				  "history"
				  "node"
				  "rust"
				  "deno"
			  ];
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
