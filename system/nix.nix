# Настройки Nix, nixpkgs и внешние overlays, используемые всей системой.
{
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

    auto-optimise-store = true;
    min-free = 3 * 1024 * 1024 * 1024;
    max-free = 10 * 1024 * 1024 * 1024;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config = {
    allowUnfree = true;

    permittedInsecurePackages = [
      "olm-3.2.16"
      "electron-40.10.5"
    ];
  };

  nixpkgs.overlays = [
    (import (
      builtins.fetchTarball {
        url = "https://github.com/unmojang/FjordLauncher/releases/download/11.0.3.0/FjordLauncher-11.0.3.0.tar.gz";
        sha256 = "1a0vrv90g19l0lpwcgdg3am1cbxv4kzrh3rkpmnmcklzw98phlgi";
      }
    )).overlays.default
  ];
}
