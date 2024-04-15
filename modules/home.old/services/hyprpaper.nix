{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${config.wallpaper}
    wallpaper = ,${config.wallpaper}
  '';

  systemd.user.services.hyprpaper = {
    Unit = {Description = "hyprpaper";};
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
      Restart = "on-failure";
    };
    Install = {WantedBy = ["hyprland-session.target"];};
  };
}
