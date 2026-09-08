# Подключение Home Manager как NixOS-модуля для пользователя djk.
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "home-manager-backup";

    users.djk = import ../home.nix;
  };
}
