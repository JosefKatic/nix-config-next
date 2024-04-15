{
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

      selection_foreground = "none";
      selection_background = "none";
    };

    theme = "Catppuccin-Mocha";
  };
}
