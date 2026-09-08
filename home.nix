# Точка сборки Home Manager для пользователя djk.
{
  imports = [
    ./home/packages.nix
    ./home/desktop/gtk.nix
    ./home/desktop/qt.nix
    ./home/programs/fastfetch.nix
    ./home/programs/firefox.nix
    ./home/programs/fish.nix
    ./home/programs/git.nix
    ./home/programs/kitty.nix
    ./home/programs/obs.nix
    ./home/xdg.nix
  ];

  home.username = "djk";
  home.homeDirectory = "/home/djk";

  home.sessionVariables = {
    # Оставлено как в исходном конфиге: Firefox запускается без Wayland backend.
    MOZ_ENABLE_WAYLAND = "0";
  };

  home.stateVersion = "25.11";
}
