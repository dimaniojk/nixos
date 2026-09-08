{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
  makeWrapper,
  bash,
  coreutils,
  iproute2,
  procps,
  util-linux,
  gnugrep,
  gnused,
  gawk,
  findutils,
  curl,
  wget,
  python3,
  freetype,
  fontconfig,
  zlib,
  libpng,
  libjpeg,
  libtiff,
  libxml2,
  openssl,
  gnutls,
  dbus,
  libpulseaudio,
  alsa-lib,
  libGL,
  vulkan-loader,
  libx11,
  libxext,
  libxrender,
  libxrandr,
  libxi,
  libxcursor,
  libxfixes,
  libxcomposite,
  libxinerama,
  pkgsi686Linux,
  writeText,
}:

let
  pname = "radmin-vpn-linux";
  version = "1.0.0-rc6";

  pkgs32 = pkgsi686Linux;

  src = fetchurl {
    url = "https://github.com/baptisterajaut/radmin-vpn-linux/releases/download/v${version}/RadminVPN-Linux-x86_64.AppImage";
    hash = "sha256-wBmvWG8acbu1l5wxSnG0fRlh0HWa/KVO7VB5aeMfmJI=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  nativeBuildInputs = [
    makeWrapper
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
          bash
          coreutils
          iproute2
          procps
          util-linux
          gnugrep
          gnused
          gawk
          findutils
          curl
          wget
          python3
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          freetype
          fontconfig
          zlib
          libpng
          libjpeg
          libtiff
          libxml2
          openssl
          gnutls
          dbus
          libpulseaudio
          alsa-lib
          libGL
          vulkan-loader
          libx11
          libxext
          libxrender
          libxrandr
          libxi
          libxcursor
          libxfixes
          libxcomposite
          libxinerama

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
          pkgs32.libx11
          pkgs32.libxext
          pkgs32.libxrender
          pkgs32.libxrandr
          pkgs32.libxi
          pkgs32.libxcursor
          pkgs32.libxfixes
          pkgs32.libxcomposite
          pkgs32.libxinerama
        ]
      }

    install -Dm644 ${writeText "radmin-vpn-linux.desktop" ''
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
}
