{config, ...}: let
  variant = config.theme.name;
  c = config.programs.matugen.theme.colors.colors_android.${variant};
  pointer = config.home.pointerCursor;
in {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    env = [
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
    ];

    exec-once = [
      # set cursor for HL itself
      "hyprctl setcursor ${pointer.name} ${toString pointer.size}"
      "systemctl --user start clight"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 5;
      border_size = 1;
      "col.active_border" = "rgba(88888888)";
      "col.inactive_border" = "rgba(00000088)";

      allow_tearing = true;
    };

    decoration = {
      rounding = 5;
      blur = {
        enabled = true;
        size = 5;
        passes = 3;
        new_optimizations = true;
        ignore_opacity = true;
      };

      drop_shadow = true;
      shadow_ignore_window = true;
      shadow_offset = "3 3";
      shadow_range = 12;
      shadow_render_power = 3;
      "col.shadow" = "rgba(00000055)";
    };

    animations = {
      enabled = true;
      bezier = [
        "easein,0.11, 0, 0.5, 0"
        "easeout,0.5, 1, 0.89, 1"
        "easeinout,0.45, 0, 0.55, 1"
      ];

      animation = [
        "windowsIn,1,3,easeout,slide"
        "windowsOut,1,3,easein,slide"
        "windowsMove,1,3,easeout"
        "workspaces,1,2,easeout,slide"
        "fadeIn,1,3,easeout"
        "fadeOut,1,3,easein"
        "fadeSwitch,1,3,easeout"
        "fadeShadow,1,3,easeout"
        "fadeDim,1,3,easeout"
        "border,1,3,easeout"
      ];
      # animation = [
      # "border, 1, 2, default"
      # "fade, 1, 4, default"
      # "windows, 1, 3, default, popin 80%"
      # "workspaces, 1, 2, default, slide"
      # ];
    };

    group = {
      groupbar = {
        font_size = 16;
        gradients = false;
      };

      "col.border_active" = "rgba(${c.color_accent_primary}88);";
      "col.border_inactive" = "rgba(${c.color_accent_primary_variant}88)";
    };

    input = {
      kb_layout = "cz";
      kb_variant = "coder";
      # focus change on cursor move
      follow_mouse = 1;
      accel_profile = "flat";
      touchpad.scroll_factor = 0.1;
    };

    dwindle = {
      # keep floating dimentions while tiling
      pseudotile = true;
      preserve_split = true;
    };

    misc = {
      # disable auto polling for config file changes
      disable_autoreload = true;

      force_default_wallpaper = 0;

      # disable dragging animation
      animate_mouse_windowdragging = false;

      # enable variable refresh rate (effective depending on hardware)
      vrr = 1;
    };

    # touchpad gestures
    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 4;
      workspace_swipe_forever = true;
    };
    xwayland.force_zero_scaling = true;

    debug.disable_logs = false;
  };
}
