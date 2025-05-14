
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{inputs, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ]
    #    # 環境に応じてインポートするモジュールを変更してください
    #  ++ (with inputs.nixos-hardware.nixosModules; [
    #    common-cpu-amd
    #    common-gpu-nvidia
    #    common-pc-ssd
    #  ])
    ++ [# xremapのNixOS modulesを使えるようにする
      inputs.xremap.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  ##SMJM
  boot.initrd.kernelModules = [ "nvidia" ];
  ##

  
  networking.hostName = "yujikitaorus"; # Define your hostname.
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
  services.xserver.videoDrivers = [ "nvidia" ];

  # nixpkgs.config.allowUnfree = true;
  ##

  # # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.displayManager.gdm.autoSuspend = false;
  # #SMJM edited
  
  #  services.xserver.desktopManager.gnome = {
  #   enable = true;
  #   extraGSettingsOverrides = ''
  #     [org.gnome.desktop.interface]
  #     enable-hot-corners=true

  #     [org.gnome.shell.overrides]
  #     dynamic-workspaces=true
  #     workspaces-only-on-primary=false
  #   '';
  #   };
  # # Enable the KDE Plasma6  Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.desktopManager.plasma5 = {
  # enable = true;
  # };
  # services.xserver.desktopManager.gnome = {
  # enable = true;
  # };
  services.xserver.desktopManager.plasma5.enable = true;
  #services.xserver.windowManager.i3.enable = true;
  xdg.portal.config.common.default = "kde";
  # environment.variables = {
  #   GTK_THEME = "Breeze";
  #   QT_STYLE_OVERRIDE = "Breeze";
  # };



  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  ##sound.enable = true;  #unenable when nix flake update
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
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [
      firefox
      #  thunderbird
    ];
    shell = pkgs.zsh; 
  };
  services.logind = {
    ##  enable = true; # 必要であれば有効化
    extraConfig = ''
    HandleLidSwitch=ignore
    HandlePowerKey=ignore
    HandleSuspendKey=ignore
    HandleHibernateKey=ignore
    IdleAction=ignore
    IdleActionSec=0
  '';
  };
  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;



  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    #htop
    pciutils
  ];
  environment.variables = {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
  };
  # environment.variables = {
  #   XMODIFIERS = "@im=fcitx";
  #   GTK_IM_MODULE = "fcitx";
  #   QT_IM_MODULE = "fcitx";
  # };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  ## Enable the OpenSSH daemon.
  services.openssh.enable = true;
  #services.openssh.permitRootLogin = "no";           # rootログイン禁止
  #services.openssh.passwordAuthentication = false;   # パスワード認証を許可(true)（鍵認証にするなら false）
  services.openssh.settings = {
    Port = 443;
    X11Forwarding = true;
    X11DisplayOffset = 10;
    X11UseLocalhost = true;
  };


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
  hardware.bluetooth.enable = true;  # Bluetooth サポートを有効化
  services.xserver.displayManager.sessionCommands = ''
  # IBusデーモンの自動起動
  if [ -z "$(pgrep ibus-daemon)" ]; then
    ibus-daemon --xim --daemonize
    ibus-daemon -drx
  fi
'';
  # nix setting 
  nix = {
    settings = {
      auto-optimise-store = true; # Nix storeの最適化
      experimental-features = ["nix-command" "flakes"];
    };
    # ガベージコレクションを自動実行
    gc = {
      automatic = true;
      dates = "monthly";  # systemdタイマーを月1に
      options = "--delete-older-than 30d";  # 30日以上前のものだけ削除
    };
  };


    # Japanese
    # i18n 設定
    i18n = {
      inputMethod = {
        enabled = "ibus";
        ibus.engines = with pkgs.ibus-engines; [ anthy  mozc ];
      };
    };

    services.dbus.enable = true;
    services.dbus.packages = [ config.i18n.inputMethod.package ];

    fonts = {
      packages = with pkgs; [
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
      noisetorch.enable = true;
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
    
    # ~/.xsession ファイルを生成するスクリプトを設定
    # systemd.tmpfiles.rules = [
    #  "f /home/yujif1aero/.xsession 0644 yujif1aero users - exec ibus-daemon -drx && startplasma-x11"
    # ];

    # systemd.tmpfiles.rules = [
    #   "f /home/yujif1aero/.xsession 0644 yujif1aero users - #!/bin/zsh\nibus-daemon --xim --daemonize\nexec startplasma-x11\n"
    # ];

    ## systemd.tmpfiles.rules = [
    ##  "f /home/yujif1aero/.xsession 0644 yujif1aero users - export XMODIFIERS='@im=fcitx' && export XMODIFIER='@im=fcitx' && export GTK_IM_MODULE='fcitx' && export QT_IM_MODULE='fcitx' && fcitx & && gnome-session"
    ## ];

    nixpkgs.config.allowUnfree = true;  # 追加
    # カーネルのバージョンを変更
    boot.kernelPackages = pkgs.linuxPackages_6_1;
    # 特定のNVIDIAドライバのバージョンを指定
    #hardware.opengl.setLdLibraryPath = true; #unenable when nix flake update
    hardware.nvidia.package = pkgs.linuxPackages_6_1.nvidia_x11;
    hardware.nvidia.open = true;

    # tailscale（VPN）を有効化
    # 非常に便利なのでおすすめ
    services.tailscale.enable = true;
    networking.firewall = {
      enable = true;
      # tailscaleの仮想NICを信頼する
      # `<Tailscaleのホスト名>:<ポート番号>`のアクセスが可能になる
      allowedTCPPorts = [ 22 443  3389];
      trustedInterfaces = ["tailscale0" "enp5s0"];
#      allowedTCPPorts = [ 3389 ]; # RDP のデフォルトポート
      allowedUDPPorts = [ config.services.tailscale.port  3389 443];
    };
    
    

    # xrdpサービスを有効化
    
    services.xrdp = {
  		enable = true;
		  openFirewall = true;
		  defaultWindowManager = "${pkgs.plasma5Packages.plasma-workspace}/bin/startplasma-x11";
    };

    # Dockerをrootlessで有効化
    virtualisation = {
      docker = {
        enable = true;
        rootless = {
          enable = true;
          setSocketVariable = true; # $DOCKER_HOSTを設定
        };
      };
    };

    services.flatpak.enable = true;
    xdg.portal.enable = true; # flatpakに必要

 fileSystems."/mnt/ysraid8TB" = {
    device = "/dev/disk/by-uuid/237f7ba4-fcb2-4293-adb7-f0f581d43cc6";
    fsType = "ext4";
    options = [ "defaults" ];
  };
 # 起動時に所有者やパーミッションを設定
  systemd.tmpfiles.rules = [
    "d /mnt/ysraid8TB 0777 - - - -"
  ];
  }

