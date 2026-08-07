{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (builtins.fetchGit { url = "https://github.com/FlameFlag/nixcord.git"; ref = "main"; } + /modules/nixos)
    ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };

  boot.loader.efi = { 
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  networking.hostName = "nixos-btw"; # Define your hostname.

  networking.networkmanager.enable = true;
  

  time.timeZone = "Asia/Baghdad";


  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus28";
    keyMap = "us";
  };


  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };


  users.users.seoz = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 
  environment.systemPackages = with pkgs; [
    neovim
    firefox
    wget
    git
    fastfetch
    dysk
    bibata-cursors
    bluetui
    wiremix
    nerd-fonts.jetbrains-mono
    obs-studio
    zed-editor
    btop
    vlc
  ];


  _module.args.nixcordPkgs = pkgs; 
  
  programs.nixcord = {
    enable = true;
    user = "seoz";
    discord = {
      enable = true;
      openASAR.enable = true;
      vencord.enable = false;
      equicord.enable = true;
    };

    config = {
      useQuickCss = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  hardware.graphics.enable = true;

  services.openssh.enable = true;
  services.envfs.enable = true;
  hardware.bluetooth.enable = true;
  services.flatpak.enable = true;
  # system.copySystemConfiguration = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      glib
      expat
    ];
  };

  # !!!DO NOT TOUCH!!!
  system.stateVersion = "25.11"; # Did you read the comment?

}

