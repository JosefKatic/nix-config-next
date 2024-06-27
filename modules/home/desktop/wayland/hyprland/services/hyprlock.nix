{config, ...}: let
  inherit (config.theme.colorscheme) colors;
  wallpaper = config.theme.wallpaper;
  font_family = "Inter";
in {
  programs.hyprlock = {
    enable = true;

    general = {
      disable_loading_bar = true;
      hide_cursor = false;
      no_fade_in = true;
    };

    backgrounds = [
      {
        monitor = "";
        path = wallpaper;
      }
    ];

    input-fields = [
      {
        monitor = "eDP-1";

        size = {
          width = 300;
          height = 50;
        };

        outline_thickness = 2;

        outer_color = "rgb(${lib.removePrefix "#" colors.primary})";
        inner_color = "rgb(${lib.removePrefix "#" colors.primary_container})";
        font_color = "rgb(${lib.removePrefix "#" colors.on_primary_container})";
        placeholder_text = ''<i>Enter your password...</i>'';
        fade_on_empty = false;
        dots_spacing = 0.3;
        dots_center = true;
      }
    ];

    labels = [
      {
        monitor = "";
        text = "$TIME";
        inherit font_family;
        font_size = 50;
        color = "rgb(${lib.removePrefix "#" colors.primary})";

        position = {
          x = 0;
          y = 80;
        };

        valign = "center";
        halign = "center";
      }
    ];
  };
}
