# Системные security/dbus компоненты для desktop-интеграции и пользовательских приложений.
{ pkgs, ... }:

{
  programs.dconf.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  services.dbus.enable = true;
  services.gnome.gnome-keyring.enable = true;

  security.polkit.enable = true;
  security.rtkit.enable = true;
}
