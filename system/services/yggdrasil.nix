# Yggdrasil mesh-сеть и список постоянных peers.
{
  services.yggdrasil = {
    enable = true;

    settings = {
      Peers = [
        "tls://ygg.mkg20001.io:4433"
        "tcp://ygg.mkg20001.io:80"
        "tcp://ygg1.mk16.de:1337?key=0000000087ee9949eeab56bd430ee8f324cad55abf3993ed9b9be63ce693e18a"
        "tls://95.217.35.92:1337"
        "tcp://ygg-hel-1.wgos.org:45170"
        "tls://[2a01:4f9:2b:2d8f::2]:1337"
        "tls://ygg-hel-1.wgos.org:45171"
      ];

      # Сохраняем vanity key вне Nix store, чтобы приватный ключ не попадал в derivation.
      PrivateKeyPath = "/var/lib/yggdrasil/vanity.key";
      MulticastInterfaces = [ ];
    };
  };
}
