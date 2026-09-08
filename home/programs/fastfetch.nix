# Настройки Fastfetch и кастомный ASCII-логотип.
{
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        type = "file";
        source = "${../../assets/ascii.txt}";

        padding = {
          right = 3;
        };
      };

      display = {
        separator = "  ";
      };

      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "display"
        "de"
        "wm"
        "terminal"
        "terminalfont"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "disk"
        "localip"
        "battery"
        "break"
        "colors"
      ];
    };
  };
}
