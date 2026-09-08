# Пользовательская Qt-настройка для приложений, которым нужен qt6ct.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.qt6ct
  ];
}
