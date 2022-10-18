{ config, pkgs, ... }:
let 
  my-python-packages = python-packages: with python-packages; [ 
    pandas
    requests
    docker
    rich
  ];
  python-with-my-packages = pkgs.python3.withPackages my-python-packages;
in
{
  environment.systemPackages = with pkgs; [
    qgis
    virt-manager
    sublime4
    sublime-merge
    libreoffice
    awscli2
    spotify
    mixxx
    qbittorrent
    gotop
    flameshot
    feh
    vim
    wget
    git
    acpi
    dunst
    neovim
    dbeaver
    remmina
    freerdp
    slack
    firefox
    google-chrome
    alacritty
    brightnessctl
    unzip
    ranger
    vscode-with-extensions
    python-with-my-packages
    guile
    android-tools
    scrcpy
    nodejs
    xpra
    arandr
    autorandr
    emacs
    ripgrep
    fd
  ];  
}

