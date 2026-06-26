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

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  

  services.xserver.xkb.layout = "us";


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
    orchis-theme
    whitesur-icon-theme
    rofi
    bibata-cursors
    picom
    kitty
    bluetui
    wiremix
    nerd-fonts.jetbrains-mono
    (obs-studio.override { cudaSupport = true; })
    zed-editor
    btop
    vlc
    gearlever
    appimage-run
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
  nixpkgs.config.nvidia.acceptLicense = true; # Add this line right here!

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false; 
    nvidiaSettings = true;
    gsp.enable = false; 
    
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "580.142";
      sha256_64bit = "sha256-IJFfzz/+icNVDPk7YKBKKFRTFQ2S4kaOGRGkNiBEdWM="; 
      settingsSha256 = "sha256-BnrIlj5AvXTfqg/qcBt2OS9bTDDZd3uhf5jqOtTMTQM=";
      persistencedSha256 = "sha256-BnrIlj5AvXTfqg/qcBt2OS9bTDDZd3uhf5jqOtTMTQM=";
      
      postPatch = ''
        find . -name "nv-linux.h" -exec sed -i '/linux\/of_gpio.h/d' {} +
      '';
    };
  };

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

