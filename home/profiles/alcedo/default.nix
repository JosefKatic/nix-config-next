{
  config,
  inputs,
  self,
  lib,
  pkgs,
  ...
}: let
  monitor = lib.head (lib.filter (m: m.primary) config.monitors);
  steam-session =
    pkgs.writeTextDir "share/wayland-sessions/steam-sesson.desktop"
    /*
    ini
    */
    ''
      [Desktop Entry]
      Name=Steam Session
      Exec=${pkgs.gamescope}/bin/gamescope -W ${toString monitor.width} -H ${toString monitor.height} -O ${monitor.name} -e -- steam -gamepadui
      Type=Application
    '';
  steam-with-pkgs = pkgs.steam.override {
    extraPkgs = pkgs:
      with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
        gamescope
        mangohud
      ];
  };
in {
  monitors = [
    {
      name = "DP-1";
      width = 2560;
      height = 1440;
      x = 2560;
      primary = true;
    }
    {
      name = "DP-2";
      width = 2560;
      height = 1440;
      # noBar = true;
      x = 0;
    }
  ];

  imports = [
    # editors
    ../../editors/helix
    # ../../editors/neovim

    # programs
    ../../programs
    ../../programs/games
    ../../programs/wayland

    # services
    # ../../services/ags

    # media services
    ../../services/media/playerctl.nix

    # system services
    ../../services/system/mako.nix
    ../../services/system/kdeconnect.nix
    ../../services/system/polkit-agent.nix
    ../../services/system/power-monitor.nix
    ../../services/system/udiskie.nix

    # wayland-specific
    ../../services/wayland/waybar.nix
    # ../../services/ags.nix
    ../../services/wayland/hyprpaper.nix
    ../../services/wayland/hypridle.nix

    # terminal emulators
    ../../terminal/emulators/kitty.nix
    ../../terminal/emulators/wezterm.nix

    ../../specialisations.nix
  ];
  home.packages = with pkgs; [
    (pkgs.lutris.override {
      extraPkgs = p: [
        p.wineWowPackages.staging
        p.pixman
        p.libjpeg
        p.gnome.zenity
      ];
    })
    steam-with-pkgs
    steam-session
    gamescope
    mangohud
    protontricks
  ];
  home.persistence = {
    "/persist/home/joka" = {
      allowOther = true;
      directories = [
        ".local/share/Steam"
        ".config/lutris"
        ".local/share/lutris"
      ];
    };
  };

  wayland.windowManager.hyprland.settings = let
    accelpoints = "0.21 0.000 0.040 0.080 0.140 0.200 0.261 0.326 0.418 0.509 0.601 0.692 0.784 0.875 0.966 1.058 1.149 1.241 1.332 1.424 1.613";
  in {
    monitor =
      map (
        m: let
          resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
          position = "${toString m.x}x${toString m.y}";
        in "${m.name},${
          if m.enabled
          then "${resolution},${position},1"
          else "disable"
        }"
      ) (config.monitors)
      ++ [",prefered,auto,1"];

    # "device:elan2841:00-04f3:31eb-touchpad" = {
    # accel_profile = "custom ${accelpoints}";
    # scroll_points = accelpoints;
    # natural_scroll = true;
    # };
  };
}
