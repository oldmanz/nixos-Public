{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./packages.nix
      ../home/home.nix
    ];



  environment.persistence."/persist" = {
	hideMounts = true;
	directories = [
	  "/var/log"
	  "/var/lib/bluetooth"
	  "/var/lib/docker"
	  "/var/lib/libvirt"
	  "/etc/NetworkManager/system-connections"
	];
  };


  #environment.loginShellInit = ''
  #  [ -d "$HOME/.nix-profile" ] || /nix/var/nix/profiles/per-user/$USER/home-manager/activate &> /dev/null
  #'';


  nix = {
    # Automate garbage collection
    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 7d";
    };

    # Flakes settings
    # package = pkgs.nixFlakes;
    # registry = lib.mapAttrs' (n: v: lib.nameValuePair n { flake = v; }) inputs;

    # Avoid unwanted garbage collection when using nix-direnv
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';

    settings = {
      # Automate `nix store --optimise`
      auto-optimise-store = true;

      # Required by Cachix to be used as non-root user
      trusted-users = [ "root" "gvolpe" ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (pkg: true);
    };
  };
  
  fonts.fonts = with pkgs; [
    fira-code
  ];
  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
    autoSnapshot.enable = true;
  };

  boot = {
    initrd.postDeviceCommands = lib.mkAfter ''
      zfs rollback -r rpool/local/root@blank
    '';
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
  };
 
  networking = {
    hostName = "Znform";
    hostId = "72439742";
    networkmanager.enable = true;
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    emacs.enable = true;
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    xserver = {
      enable = true;
      layout = "us";

      libinput = {
        enable = true;
	touchpad.naturalScrolling = true;
      };

      displayManager = {
        defaultSession = "gnome";
	gdm.enable = true;
      };

      desktopManager = {
	xterm.enable = false;
	gnome.enable = true;
	xfce = {
	  enable = true;
	  noDesktop = true;
	  enableXfwm = false;
	};
      };

      windowManager = {
        xmonad = {
	  enable = true;
	  enableContribAndExtras = true;
	};
        i3 = {
          enable = true;
          extraPackages = with pkgs; [
         	rofi
		i3blocks
		i3lock
		i3status
          ];
        };
      };
    };
    printing.enable = true;
    openssh.enable = true;
    logind = {
      lidSwitch = "suspend";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
      extraConfig = "IdleAction=hybrid-sleep \n IdleActionSec=30min";
    };
  };

  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
  };

  sound.enable = true;
  hardware = {
    pulseaudio = {
      enable = true;
    };
    bluetooth.enable = true;
  };

  services.blueman.enable = true;

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
    users.oldmanz = {
      isNormalUser = true;
      password = "Z";
      extraGroups = [ "wheel" "docker" "audio" "libvirtd" ];
    };
    extraUsers = {
      root = {
        password = "Z";
      };
    };
  };

  programs = {
    zsh.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };


  systemd = {
    services = {
      upower.enable = true;
    };
  };


  system = {
    stateVersion = "22.05";
  };

}

