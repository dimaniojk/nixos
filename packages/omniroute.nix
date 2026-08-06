{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
  buildFHSEnv,
  writeShellScript,
  symlinkJoin,

  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libGL,
  libnotify,
  libpulseaudio,
  libsecret,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  wayland,
  xdg-utils,

  libX11,
  libxcb,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXScrnSaver,
  libXtst,
}:

let
  pname = "omniroute";
  version = "3.8.48";

  src = fetchurl {
    url = "https://github.com/diegosouzapw/OmniRoute/releases/download/v${version}/OmniRoute-${version}.AppImage";
    hash = "sha256-gy5GthCtTwrdFHQ9PQpW4l1AOD08IadMngh+ILsa+KQ=";
  };

  extracted = appimageTools.extractType2 {
    inherit pname version src;
  };

  patched = stdenvNoCC.mkDerivation {
    pname = "${pname}-patched";
    inherit version;

    src = extracted;

    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"

      # Сохраняем структуру и симлинки AppImage.
      cp -a . "$out/"

      app="$out/resources/app"
      modules="$app/node_modules"

      if [ ! -d "$app" ]; then
        echo "OmniRoute resources/app not found"
        find "$out" -maxdepth 3 -type d | sort
        exit 1
      fi

      if [ ! -d "$modules" ]; then
        echo "OmniRoute node_modules not found at $modules"
        exit 1
      fi

      echo "Repairing absolute GitHub Actions symlinks"

      fixed=0
      missing=0

      while IFS= read -r -d "" link; do
        target="$(readlink "$link")"

        case "$target" in
          /home/runner/*)
            # Например:
            #
            # /home/runner/.../node_modules/ws
            # /home/runner/.../node_modules/pino
            # /home/runner/.../node_modules/@scope/package
            #
            # Получаем реальный путь пакета после последнего node_modules/.
            packagePath="''${target##*/node_modules/}"
            replacement="$modules/$packagePath"

             if [ -e "$replacement" ]; then
               rm "$link"
               ln -s "$replacement" "$link"
             
               echo "fixed: $link -> $replacement"
               fixed=$((fixed + 1))
             elif [ "$packagePath" = "keytar" ]; then
               echo "Creating keytar compatibility stub"
             
               mkdir -p "$modules/keytar"
               
               printf '%s\n' \
                 '{' \
                 '  "name": "keytar",' \
                 '  "version": "0.0.0-nixos-stub",' \
                 '  "main": "index.js",' \
                 '  "type": "commonjs"' \
                 '}' \
                 > "$modules/keytar/package.json"
               
               printf '%s\n' \
                 '"use strict";' \
                 'const store = new Map();' \
                 'function makeKey(service, account) {' \
                 '  return String(service) + "\u0000" + String(account);' \
                 '}' \
                 'async function getPassword(service, account) {' \
                 '  const key = makeKey(service, account);' \
                 '  return store.has(key) ? store.get(key) : null;' \
                 '}' \
                 'async function setPassword(service, account, password) {' \
                 '  store.set(makeKey(service, account), String(password));' \
                 '}' \
                 'async function deletePassword(service, account) {' \
                 '  return store.delete(makeKey(service, account));' \
                 '}' \
                 'async function findPassword(service) {' \
                 '  const prefix = String(service) + "\u0000";' \
                 '  for (const [key, value] of store.entries()) {' \
                 '    if (key.startsWith(prefix)) {' \
                 '      return value;' \
                 '    }' \
                 '  }' \
                 '  return null;' \
                 '}' \
                 'async function findCredentials(service) {' \
                 '  const prefix = String(service) + "\u0000";' \
                 '  const results = [];' \
                 '  for (const [key, password] of store.entries()) {' \
                 '    if (key.startsWith(prefix)) {' \
                 '      results.push({' \
                 '        account: key.slice(prefix.length),' \
                 '        password: password,' \
                 '      });' \
                 '    }' \
                 '  }' \
                 '  return results;' \
                 '}' \
                 'module.exports = {' \
                 '  getPassword,' \
                 '  setPassword,' \
                 '  deletePassword,' \
                 '  findPassword,' \
                 '  findCredentials,' \
                 '};' \
                 > "$modules/keytar/index.js"
             
                
             
               rm "$link"
               ln -s "$modules/keytar" "$link"
             
               echo "stubbed: $link -> $modules/keytar"
               fixed=$((fixed + 1))
             else
               echo "missing package: $packagePath"
               echo "  link:   $link"
               echo "  target: $target"
             
               missing=$((missing + 1))
             fi
            ;;
        esac
      done < <(find "$out" -type l -print0)

      echo "Fixed broken links: $fixed"
      echo "Unresolved links:    $missing"

      echo "Remaining /home/runner links:"

      remaining=0

      while IFS= read -r -d "" link; do
        target="$(readlink "$link")"

        case "$target" in
          /home/runner/*)
            echo "$link -> $target"
            remaining=$((remaining + 1))
            ;;
        esac
      done < <(find "$out" -type l -print0)

      if [ "$remaining" -ne 0 ]; then
        echo "There are still $remaining unrepaired GitHub Actions links"
        exit 1
      fi

      runHook postInstall
    '';
  };

  launchScript = writeShellScript "omniroute-launch" ''
    set -e

    export NIXOS_OZONE_WL="''${NIXOS_OZONE_WL:-1}"
    export ELECTRON_OZONE_PLATFORM_HINT="''${ELECTRON_OZONE_PLATFORM_HINT:-auto}"

    # Некоторые Electron-приложения ожидают writable HOME и XDG-каталоги.
    export XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"
    export XDG_CACHE_HOME="''${XDG_CACHE_HOME:-$HOME/.cache}"
    export XDG_DATA_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}"

    mkdir -p \
      "$XDG_CONFIG_HOME" \
      "$XDG_CACHE_HOME" \
      "$XDG_DATA_HOME"

    cd ${patched}

    if [ -x ${patched}/AppRun ]; then
      exec ${patched}/AppRun "$@"
    fi

    if [ -x ${patched}/omniroute-desktop ]; then
      exec ${patched}/omniroute-desktop "$@"
    fi

    echo "OmniRoute entrypoint not found" >&2
    exit 1
  '';

  fhs = buildFHSEnv {
    name = "omniroute";

    targetPkgs = pkgs: [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      glib
      gtk3
      libdrm
      libgbm
      libGL
      libnotify
      libpulseaudio
      libsecret
      libxkbcommon
      mesa
      nspr
      nss
      pango
      systemd
      wayland
      xdg-utils

      libX11
      libxcb
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXrandr
      libXrender
      libXScrnSaver
      libXtst
    ];

    runScript = launchScript;
  };

  desktopFiles = stdenvNoCC.mkDerivation {
    pname = "${pname}-desktop-files";
    inherit version;

    dontUnpack = true;

    installPhase = ''
      mkdir -p "$out/share/applications"
      mkdir -p "$out/share/icons/hicolor/512x512/apps"

      cat > "$out/share/applications/omniroute.desktop" <<'EOF'
      [Desktop Entry]
      Name=OmniRoute
      Comment=Unified AI router
      Exec=omniroute
      Terminal=false
      Type=Application
      Categories=Development;Utility;
      StartupNotify=true
      StartupWMClass=OmniRoute
      Keywords=AI;LLM;OpenAI;Anthropic;Router;
      EOF

      iconFound=0

      for icon in \
        "${patched}/omniroute.png" \
        "${patched}/OmniRoute.png" \
        "${patched}/usr/share/icons/hicolor/512x512/apps/omniroute.png" \
        "${patched}/usr/share/icons/hicolor/512x512/apps/OmniRoute.png" \
        "${patched}/usr/share/icons/hicolor/512x512/apps/omniroute-desktop.png"
      do
        if [ -f "$icon" ]; then
          cp "$icon" \
            "$out/share/icons/hicolor/512x512/apps/omniroute.png"

          iconFound=1
          break
        fi
      done

      if [ "$iconFound" = 1 ]; then
        echo "Icon=omniroute" \
          >> "$out/share/applications/omniroute.desktop"
      fi
    '';
  };
in
symlinkJoin {
  name = "${pname}-${version}";

  paths = [
    fhs
    desktopFiles
  ];

  meta = {
    description = "Unified AI router with Electron GUI";
    homepage = "https://github.com/diegosouzapw/OmniRoute";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "omniroute";
  };
}
