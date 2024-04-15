{config, ...}: let
  variant = config.theme.name;
  colors = config.programs.matugen.theme.colors.colors.${variant};
in {
  programs.kitty = {
    enable = true;
    font = {
      size = 12;
      name = "JetBrains Mono";
    };

    settings = {
      scrollback_lines = 10000;
      window_padding_width = 15;
      placement_strategy = "center";

      allow_remote_control = "yes";
      enable_audio_bell = "no";
      visual_bell_duration = "0.1";

      copy_on_select = "clipboard";

      cursor = "#${colors.on_surface}";
      cursor_text_color = "#${colors.surface}";

      foreground = "#${colors.on_surface}";
      background = "#${colors.surface}";
      selection_foreground = "none";
      selection_background = "none";
      url_color = "#${colors.primary}";

      # black
      color0 = "#45475A";
      color8 = "#585B70";

      # red
      color1 = "#F38BA8";
      color9 = "#F38BA8";

      # green
      color2 = "#A6E3A1";
      color10 = "#A6E3A1";

      # yellow
      color3 = "#F9E2AF";
      color11 = "#F9E2AF";

      # blue
      color4 = "#89B4FA";
      color12 = "#89B4FA";

      # magenta
      color5 = "#F5C2E7";
      color13 = "#F5C2E7";

      # cyan
      color6 = "#94E2D5";
      color14 = "#94E2D5";

      # white
      color7 = "#BAC2DE";
      color15 = "#A6ADC8";
    };
  };
}
