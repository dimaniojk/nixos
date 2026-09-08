# Небольшой набор системных CLI/утилит, нужных службам или системной интеграции.
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lact
    clinfo
    ocl-icd
    libsecret
    xdg-utils
    docker
  ];
}
