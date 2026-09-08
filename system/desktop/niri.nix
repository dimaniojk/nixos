# Системная часть графической сессии Niri и вход через greetd.
{ config, ... }:

{
  programs.niri.enable = true;
  programs.dms-shell.enable = true;

  # Niri session сам подготавливает окружение; дефолтный PATH user-unit здесь мешает.
  systemd.user.services.niri.enableDefaultPath = false;

  services.greetd = {
    enable = true;

    settings.default_session = {
      command = "${config.programs.niri.package}/bin/niri-session";
      user = "djk";
    };
  };
}
