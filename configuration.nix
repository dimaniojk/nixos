{
  imports = [
    ./hardware-configuration.nix

    ./system/audio.nix
    ./system/boot.nix
    ./system/desktop/niri.nix
    ./system/graphics.nix
    ./system/home-manager.nix
    ./system/networking.nix
    ./system/nix.nix
    ./system/packages.nix
    ./system/programs.nix
    ./system/security.nix
    ./system/services/lact.nix
    ./system/services/litellm.nix
    ./system/services/remote-access.nix
    ./system/services/yggdrasil.nix
    ./system/users.nix
    ./system/virtualization.nix
  ];

  system.stateVersion = "26.05";
}
