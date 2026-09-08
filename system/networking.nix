# Системная сеть: NetworkManager и постоянные firewall-исключения.
{
  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPorts = [
    # Minecraft/server port.
    25565
  ];
}
