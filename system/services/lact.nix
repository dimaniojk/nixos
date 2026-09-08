# Системный daemon LACT для управления AMDGPU.
{
  systemd.services.lact = {
    description = "AMDGPU Control Daemon";
    enable = true;

    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/lact daemon";
    };

    wantedBy = [
      "multi-user.target"
    ];
  };
}
