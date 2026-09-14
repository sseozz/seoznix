{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = [ "amdgpu" ];

  networking.hostName = "nixos-btw"; # Define your hostname.


  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Baghdad";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users."seoz" = {
    isNormalUser = true;
    description = "seoz";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;

  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  hardware.graphics.enable = true;
  hardware.amdgpu.opencl.enable = true;
  hardware.graphics.enable32Bit = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    fastfetch
    dysk
    alacritty
    firefox
    noctalia
    hyprmod
    bibata-cursors
    mpv
    btop
    equibop
    nwg-look
    adw-gtk3
    whitesur-icon-theme
    distrobox
    podman
    nautilus
    pear-desktop
    prismlauncher
    cloudflare-warp
    comma
    eza
    bat
    localsend
    nix-index
    gcc
    gnumake
    unzip
    ripgrep
    fd
    nodejs
    tree-sitter
    obs-studio
  ];

  fonts.packages = with pkgs; [
    victor-mono
    nerd-fonts.symbols-only
  ];

  services.ollama = {
    enable = true;
    package  = pkgs.ollama-rocm;
    # rocmOverrideGfx = "12.0.0";
  };

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;
  services.displayManager.ly.enable = true;
  services.flatpak.enable = true;
  services.cloudflare-warp.enable = true;
  virtualisation.podman.enable = true;
  security.polkit.enable = true;
  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true; # Emulates PulseAudio so your apps still have sound
    jack.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    configPackages = [
      pkgs.hyprland
    ];
    config = {
      hyprland = {
        default = [ "hyprland" "gtk" ];
      };
      common = {
        default = [ "gtk" ];
      };
    };
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };


  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  system.copySystemConfiguration = true;

  system.stateVersion = "26.05"; # Did you read the comment?

}
