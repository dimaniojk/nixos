{ config, pkgs, ... }:

{
  home.username = "djk";
  home.homeDirectory = "/home/djk";

  home.packages = with pkgs; [
    firefox
    vesktop
    git
    kitty
    kdePackages.qt6ct
    micro
    fastfetch
    fjordlauncher
    hyfetch
    steam-run
    xwayland-satellite
    qbittorrent
    materialgram
    thunderbird
    vlc
    opencode
    go
    lua
    mumble
    element
    spotify
    _1password-gui
    irssi
    cloudflared
    code-cursor
    nautilus
    matrix-commander
    vscode
    file-roller
    loupe
    strawberry
    protonup-qt
    gh
	llama-cpp-vulkan
    cloudflare-warp
    python3
    gnupg
  ];



  
  programs.git = {
    enable = true;
  
    settings = {
      user = {
        name = "Dimaniojk";
        email = "deividasjk001@gmail.com";
      };
  
      init.defaultBranch = "main";
    };
  };

  programs.fish = {
    enable = true;

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch";
      nixconfig = "sudo micro /etc/nixos/configuration.nix";
      homeconfig = "sudo micro /etc/nixos/home.nix";
      
    };
  };
  
  programs.fish.functions.nixpush = ''
    cd /etc/nixos
    sudo env GH_TOKEN=(gh auth token) git push
  '';

  programs.kitty = {
    enable   = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      window_padding_width       = 15;
      font_family                = "JetBrainsMono Nerd Font";
      font_size                  = 12;
    };
    extraConfig = ''
      include dank-theme.conf
      include dank-tabs.conf
    '';
  };
  
  programs.fastfetch = {
    enable = true;
  
    settings = {
      logo = {
        type = "file";
        source = "${./assets/ascii.txt}";
  
        padding = {
          right = 3;
        };
      };
  
      display = {
        separator = "  ";
      };
  
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "display"
        "de"
        "wm"
        "terminal"
        "terminalfont"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "disk"
        "localip"
        "battery"
        "break"
        "colors"
      ];
    };
  };
  
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
    };
  };

  home.stateVersion = "26.05";
}
