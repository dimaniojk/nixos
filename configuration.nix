{ config, lib, pkgs, ... }:

let
  celeritas = builtins.getFlake "/home/djk/celeritas-browser";
  pkgs32 = pkgs.pkgsi686Linux;

  radmin-vpn-linux =
    let
      pname = "radmin-vpn-linux";
      version = "1.0.0-rc6";

      src = pkgs.fetchurl {
        url = "https://github.com/baptisterajaut/radmin-vpn-linux/releases/download/v${version}/RadminVPN-Linux-x86_64.AppImage";
        hash = "sha256-Q2Lpi8JsY5eQ1zdFTbsjN2zYBKwCdAqvH5xvwhx/NEA=";
      };

      appimageContents = pkgs.appimageTools.extractType2 {
        inherit pname version src;
      };
    in
    pkgs.stdenvNoCC.mkDerivation {
      inherit pname version;

      nativeBuildInputs = [
        pkgs.makeWrapper
      ];

      dontUnpack = true;
      dontPatchELF = true;
      dontStrip = true;
      dontAutoPatchelf = true;

      installPhase = ''
        runHook preInstall

        mkdir -p "$out/opt/radmin-vpn-linux"
        cp -a ${appimageContents}/. "$out/opt/radmin-vpn-linux/"

        chmod -R u+w "$out/opt/radmin-vpn-linux"

        patchShebangs "$out/opt/radmin-vpn-linux"

        mkdir -p "$out/bin"

        makeWrapper \
          "$out/opt/radmin-vpn-linux/AppRun" \
          "$out/bin/radmin-vpn-linux" \
          --prefix PATH : "/run/wrappers/bin" \
          --suffix PATH : ${
            lib.makeBinPath [
              pkgs.bash
              pkgs.coreutils
              pkgs.iproute2
              pkgs.procps
              pkgs.util-linux
              pkgs.gnugrep
              pkgs.gnused
              pkgs.gawk
              pkgs.findutils
              pkgs.curl
              pkgs.wget
              pkgs.python3
            ]
          } \
         --prefix LD_LIBRARY_PATH : ${
            lib.makeLibraryPath [
              pkgs.freetype
              pkgs.fontconfig
              pkgs.zlib
              pkgs.libpng
              pkgs.libjpeg
              pkgs.libtiff
              pkgs.libxml2
              pkgs.openssl
              pkgs.gnutls
              pkgs.dbus
              pkgs.libpulseaudio
              pkgs.alsa-lib
              pkgs.libGL
              pkgs.vulkan-loader
              pkgs.xorg.libX11
              pkgs.xorg.libXext
              pkgs.xorg.libXrender
              pkgs.xorg.libXrandr
              pkgs.xorg.libXi
              pkgs.xorg.libXcursor
              pkgs.xorg.libXfixes
              pkgs.xorg.libXcomposite
              pkgs.xorg.libXinerama

              pkgs32.freetype
              pkgs32.fontconfig
              pkgs32.zlib
              pkgs32.libpng
              pkgs32.libjpeg
              pkgs32.libtiff
              pkgs32.libxml2
              pkgs32.openssl
              pkgs32.gnutls
              pkgs32.dbus
              pkgs32.libpulseaudio
              pkgs32.alsa-lib
              pkgs32.libGL
              pkgs32.vulkan-loader
              pkgs32.xorg.libX11
              pkgs32.xorg.libXext
              pkgs32.xorg.libXrender
              pkgs32.xorg.libXrandr
              pkgs32.xorg.libXi
              pkgs32.xorg.libXcursor
              pkgs32.xorg.libXfixes
              pkgs32.xorg.libXcomposite
              pkgs32.xorg.libXinerama
            ]
          }

        install -Dm644 ${pkgs.writeText "radmin-vpn-linux.desktop" ''
          [Desktop Entry]
          Type=Application
          Name=Radmin VPN Linux
          Comment=Unofficial Radmin VPN client for Linux
          Exec=radmin-vpn-linux
          Terminal=true
          Categories=Network;
          StartupNotify=true
        ''} "$out/share/applications/radmin-vpn-linux.desktop"

        runHook postInstall
      '';

      fixupPhase = ''
        true
      '';
    };
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

  boot.kernelModules = [
    "tun"
  ];

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

  programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
    
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  programs.fish.enable = true;
  programs.steam.enable = true;

  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      fuse
    ];
  };

  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };

  programs.niri.enable = true;
  programs.dms-shell.enable = true;

  systemd.user.services.niri.enableDefaultPath = false;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.openssh.enable = true;

  services.yggdrasil = {
    enable = true;

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

      PrivateKeyPath = "/var/lib/yggdrasil/vanity.key";
      MulticastInterfaces = [ ];
    };
  };

  services.greetd = {
    enable = true;

    settings.default_session = {
      command = "${config.programs.niri.package}/bin/niri-session";
      user = "djk";
    };
  };

  services.litellm = {
    enable = true;
    host = "127.0.0.1";
    port = 4000;

    settings = {
      model_list = [
        {
          model_name = "verity-local";

          litellm_params = {
            model = "openai/local";
            api_base = "http://127.0.0.1:8080/v1";
            api_key = "none";

            extra_body = {
              chat_template_kwargs = {
                enable_thinking = false;
              };
            };
          };
        }
      ];

      litellm_settings = {
        drop_params = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    lact
    bambu-studio
    clinfo
    ocl-icd
    radmin-vpn-linux

    llama-cpp-vulkan
    python3

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
