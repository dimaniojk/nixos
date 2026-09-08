# Системный аудиостек PipeWire и совместимость с PulseAudio.
{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
}
