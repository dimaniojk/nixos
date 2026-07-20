{ config, lib, pkgs, ... }:

let
  celeritas = builtins.getFlake "/home/djk/celeritas-browser";
in
{
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xffffffff"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPorts = [
    25565
  ];

  time.timeZone = "Europe/Riga";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    trusted-substituters = [
      "https://unmojang.cachix.org"
    ];

    trusted-public-keys = [
      "unmojang.cachix.org-1:OfHnbBNduZ6Smx9oNbLFbYyvOWSoxb2uPcnXPj4EDQY="
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;

    permittedInsecurePackages = [
      "olm-3.2.16"
    ];
  };

  nixpkgs.overlays = [
    (import (
      builtins.fetchTarball
        "https://github.com/unmojang/FjordLauncher/releases/download/11.0.3.0/FjordLauncher-11.0.3.0.tar.gz"
    )).overlays.default
  ];

  users.users.djk = {
    isNormalUser = true;
    description = "djk";
    shell = pkgs.fish;

    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "render"
      "video"
      "audio"
      "docker"
    ];
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.openssh.enable = true;

  services.yggdrasil = {
    enable = true;
    persistentKeys = true;

    settings = {
      Peers = [
        "tls://ygg.mkg20001.io:4433"
        "tcp://ygg.mkg20001.io:80"
        "tcp://ygg1.mk16.de:1337?key=0000000087ee9949eeab56bd430ee8f324cad55abf3993ed9b9be63ce693e18a"
        "tls://95.217.35.92:1337"
        "tcp://ygg-hel-1.wgos.org:45170"
        "tls://[2a01:4f9:2b:2d8f::2]:1337"
        "tls://ygg-hel-1.wgos.org:45171"
      ];

      MulticastInterfaces = [ ];
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.fish.enable = true;

  programs.steam.enable = true;

  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };

  programs.niri.enable = true;
  programs.dms-shell.enable = true;

  systemd.user.services.niri.enableDefaultPath = false;

  services.greetd = {
    enable = true;

    settings.default_session = {
      command = "${config.programs.niri.package}/bin/niri-session";
      user = "djk";
    };
  };

  environment.systemPackages = with pkgs; [
    # Нужен системному сервису LACT.
    lact
    bambu-studio

    # Локальный разрабатываемый браузер пока безопаснее оставить системно.
    celeritas.packages.${pkgs.system}.default
  ];

  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    enable = true;

    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/lact daemon";
    };

    wantedBy = [
      "multi-user.target"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "home-manager-backup";

    users.djk = import ./home.nix;
  };

  system.stateVersion = "26.05";
}
