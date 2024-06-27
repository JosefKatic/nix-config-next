{
  config,
  lib,
  ...
}: let
  inherit (config.theme.colorscheme) colors mode;
  removeFilterPrefixAttrs = prefix: attrs:
    lib.mapAttrs' (n: v: {
      name = lib.removePrefix prefix n;
      value = v;
    }) (lib.filterAttrs (n: _: lib.hasPrefix prefix n) attrs);

  custom = removeFilterPrefixAttrs "${mode}-" colors;
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

      foreground = "${colors.on_surface}";
      background = "${colors.surface}";
      selection_background = "${colors.on_surface}";
      selection_foreground = "${colors.surface}";
      url_color = "${colors.on_surface_variant}";
      cursor = "${colors.on_surface}";
      active_border_color = "${colors.outline}";
      inactive_border_color = "${colors.surface_bright}";
      active_tab_background = "${colors.surface}";
      active_tab_foreground = "${colors.on_surface}";
      inactive_tab_background = "${colors.surface_bright}";
      inactive_tab_foreground = "${colors.on_surface_variant}";
      tab_bar_background = "${colors.surface_bright}";
      color0 = "${colors.surface}";
      color1 = "${custom.red}";
      color2 = "${custom.green}";
      color3 = "${custom.yellow}";
      color4 = "${custom.blue}";
      color5 = "${custom.magenta}";
      color6 = "${custom.cyan}";
      color7 = "${colors.on_surface}";
      color8 = "${colors.outline}";
      color9 = "${custom.red}";
      color10 = "${custom.green}";
      color11 = "${custom.yellow}";
      color12 = "${custom.blue}";
      color13 = "${custom.magenta}";
      color14 = "${custom.cyan}";
      color15 = "${colors.surface_dim}";
      color16 = "${custom.orange}";
      color17 = "${colors.error}";
      color18 = "${colors.surface_bright}";
      color19 = "${colors.surface_container}";
      color20 = "${colors.on_surface_variant}";
      color21 = "${colors.inverse_surface}";
    };
  };
}
