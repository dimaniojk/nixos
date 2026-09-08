# Пользовательские настройки Fish: aliases и helper-функции для этого flake.
{
  programs.fish = {
    enable = true;

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch";
      nixconfig = "sudo micro /etc/nixos/configuration.nix";
      homeconfig = "sudo micro /etc/nixos/home.nix";
    };

    functions.nixpush = ''
      cd /etc/nixos
      sudo env GH_TOKEN=(gh auth token) git push
    '';
  };
}
