# nix-ld для запуска бинарников, ожидающих стандартный dynamic linker и runtime-библиотеки.
{ pkgs, ... }:

{
  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      # AppImage/FHS-программы часто ожидают libfuse в стандартном runtime.
      fuse
    ];
  };
}
