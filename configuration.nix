# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{inputs, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ]
   ## 環境に応じてインポートするモジュールを変更してください
   # ++ (with inputs.nixos-hardware.nixosModules; [
   #   common-cpu-amd
   #   common-gpu-amd
   #   common-pc-ssd
   # ])
   ++ [# xremapのNixOS modulesを使えるようにする
     inputs.xremap.nixosModules.default
   ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  ##SMJM
  boot.initrd.kernelModules = [ "amdgpu" ];
##

  
  networking.hostName = "yujif1aero"; # Define your hostname.
  # NetworkManagerを有効にしてネットワーク管理を簡素化
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Avahi（mDNSリゾルバ）を有効にしてホスト名解決を行う
  services.avahi = {
    enable = true;
    nssmdns = true; # mDNSを有効にしてホスト名解決を行う
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  ## SMJM  
  services.xserver.videoDrivers = [ "amdgpu" ];
 
  ##

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  #SMJM edited
#  services.xserver.desktopManager.gnome.enable = true;
   services.xserver.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      [org.gnome.desktop.interface]
      enable-hot-corners=true

      [org.gnome.shell.overrides]
      dynamic-workspaces=true
      workspaces-only-on-primary=false
    '';
    };


  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yujif1aero = {
    isNormalUser = true;
    description = "Yuji Shimojima";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
    shell = pkgs.zsh; 
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    #htop
    pciutils
  ];

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
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  ## SMJM setup
 
  # nix setting

  

  
  nix = {
    settings = {
      auto-optimise-store = true; # Nix storeの最適化
      experimental-features = ["nix-command" "flakes"];
    };
    # ガベージコレクションを自動実行
    gc = {
     automatic = true;
     dates = "weekly";
     options = "--delete-older-than 7d";
   };
  };

  # Japanese
  i18n.inputMethod = {
   enabled = "fcitx5";
  fcitx5 = {
    addons = [ pkgs.fcitx5-mozc ];
   # config = {
   #   punctuations = ",.";
 # };
  };
 };

 fonts = {
   fonts = with pkgs; [
     noto-fonts-cjk-serif
     noto-fonts-cjk-sans
     noto-fonts-emoji
     nerdfonts
   ];
   fontDir.enable = true;
   fontconfig = {
     defaultFonts = {
       serif = ["Noto Serif CJK JP" "Noto Color Emoji"];
       sansSerif = ["Noto Sans CJK JP" "Noto Color Emoji"];
       monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
       emoji = ["Noto Color Emoji"];
     };
   };
 };

  programs = {
     git = {
       enable = true;
     };
 #    # neovim = {
 #    #   enable = true;
 #    #  # defaultEditor = true; # $EDITOR=nvimに設定
 #    #   viAlias = true;
 #    #   vimAlias = true;
 #    # };
     starship = {
       enable = true;
     };
     zsh = {
       enable = true;
     };
    
   };
 
  services.emacs = {
  enable = true;
  defaultEditor = true;
  };


   
  services.xremap = {
   userName = "yujif1aero";
   serviceMode = "system";
   config = {
     modmap = [
       {
         # CapsLockをCtrlに置換
         name = "CapsLock is dead";
         remap = {
           CapsLock = "Ctrl_L";
         };
       }
     ];
     keymap = [
       {
         # Ctrl + HがどのアプリケーションでもBackspaceになるように変更
         name = "Ctrl+H should be enabled on all apps as BackSpace";
         remap = {
           C-h = "Backspace";
         };
         # 一部アプリケーション（ターミナルエミュレータ）を対象から除外
         #application = {
         #  not = ["Alacritty" "Kitty" "Wezterm"];
         #};
       }
     ];
   };
 };
  nixpkgs.config.allowUnfree = true;  # 追加
  # OpenGL extra packages for ROCm
  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];

  # Enable the Vulkan driver for AMD
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # Enable the ROCm stack
  programs.rocm.enable = true;
 
 ##	
}
