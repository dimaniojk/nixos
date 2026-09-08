# Загрузка, параметры ядра и kernel-модули, завязанные на железо/систему.
{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelModules = [
    # Нужен приложениям, которые создают TUN-интерфейсы.
    "tun"
  ];

  boot.kernelParams = [
    # Открывает полный набор AMDGPU powerplay-фич для ручной настройки видеокарты.
    "amdgpu.ppfeaturemask=0xffffffff"
  ];

  boot.kernel.sysctl = {
    # Требуется некоторым играм/рантаймам с большим количеством memory mappings.
    "vm.max_map_count" = 2147483642;
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
}
