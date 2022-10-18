{ config, lib, pkgs,  specialArgs, ... }:
{
  home-manager.users.oldmanz = {
    home = {
      stateVersion = "22.05";

      file = {
        ".config/i3".source = ./src/i3;
        ".config/alacritty".source = ./src/alacritty;
        ".config/nvim".source = ./src/nvim;
        ".config/dunst".source = ./src/dunst;
        ".config/rofi".source = ./src/rofi;
        
	#".background-image".source = ./config/wallpapers;

         #".emacs.d/init.el".source = ./src/emacs/init.el;
         #".emacs.d/custom.el".source = ./config/emacs.d/custom.el;

         ".local/share/fonts".source = ./src/fonts;
         ".xprofile".source = ./src/xprofile;
         ".2nform.conf".source = ./src/2nform.conf;
    
         ".ssh".source = ./src/ssh;
    
         ".themes".source = ./src/gtk/themes;
         ".config/gtk-3.0/settings.ini".source = ./src/gtk/settings.ini;
      };
    
  
    };
      
     

      services = {
        udiskie = {
          enable = true;
	  tray = "always";
        };
      };

      programs = {
        git = {
          enable = true;
	  userName  = "oldmanz";
	  userEmail = "travis@oldmanz.com";
	  extraConfig = {
	    user = {
              signingkey = "78FA7117E5E1A5D6980C18FB0E46772539892CBC";
	    };
	    #commit = {
	    #  gpgsign = true;
	    #};
	  };
	};
	zsh = {
	  enable = true;
	  enableCompletion = false; # enabled in oh-my-zsh
	  initExtra = ''
	    test -f ~/.dir_colors && eval $(dircolors ~/.dir_colors)
	  '';
	  shellAliases = {
	    sudo="sudo ";
            v = "nvim";
	    vi = "nvim";
	    vim = "nvim";
	    s = "nixos-rebuild switch --flake $HOME/nixos --impure";
	    h = "nixos-rebuild switch --flake $HOME/nixos --impure";
	    os = "nvim ~/nixos/system/configuration.nix";
	    oh = "nvim ~/nixos/home/home.nix";
	    w = "curl wttr.in";
	    zss = "zfs list -o space -r rpool";
	    zs = "zfs list -t snapshot";
	    e = "exit";
          };
	  oh-my-zsh = {
	    enable = true;
	    plugins = [ "git" "systemd" "rsync" "kubectl" ];
	    theme = "lambda";
	  };
	};
      };
    };
}

