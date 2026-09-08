# Настройки терминала Kitty и его пользовательского оформления.
{
  programs.kitty = {
    enable = true;

    settings = {
      confirm_os_window_close = 0;
      window_padding_width = 15;
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;
      background_opacity = "0.85";
    };

    extraConfig = ''
      include dank-theme.conf
      include dank-tabs.conf
    '';
  };

  xdg.configFile = {
    "kitty/dank-theme.conf" = {
      force = true;
      text = ''
        cursor #e4e2e3
        cursor_text_color #c8c6c7

        foreground            #e4e2e3
        background            #131315
        selection_foreground  #2b303c
        selection_background  #c4c6d0
        url_color             #ffffff

        color0   #2a2a2a
        color1   #ff7272
        color2   #9bff7f
        color3   #ffe372
        color4   #f2f2f2
        color5   #767676
        color6   #ffffff
        color7   #ffefef
        color8   #a59999
        color9   #ff9f9f
        color10  #b9ffa5
        color11  #ffeda5
        color12  #ffffff
        color13  #ffffff
        color14  #ffffff
        color15  #fff8f8
      '';
    };

    "kitty/dank-tabs.conf" = {
      force = true;
      text = ''
        tab_bar_edge            top
        tab_bar_style           powerline
        tab_powerline_style     slanted
        tab_bar_align           left
        tab_bar_min_tabs        2
        tab_bar_margin_width    0.0
        tab_bar_margin_height   2.5 1.5
        tab_bar_margin_color    #131315

        tab_bar_background              #131315

        active_tab_foreground           #2b303c
        active_tab_background           #ffffff
        active_tab_font_style           bold

        inactive_tab_foreground         #c8c6c7
        inactive_tab_background         #131315
        inactive_tab_font_style         normal

        tab_activity_symbol             " ● "

        tab_title_template              "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title[:30]}{title[30:] and '…'} [{index}]"
        active_tab_title_template       "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title[:30]}{title[30:] and '…'} [{index}]"
      '';
    };
  };
}
