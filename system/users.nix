# Системная учетная запись djk и группы для доступа к устройствам/службам.
{ pkgs, ... }:

{
  users.users.djk = {
    isNormalUser = true;
    description = "djk";
    shell = pkgs.fish;

    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "render"
      "video"
      "audio"
      "docker"
    ];
  };
}
