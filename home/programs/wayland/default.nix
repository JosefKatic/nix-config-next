{
  config,
  pkgs,
  self,
  inputs,
  ...
}:
# Wayland config
{
  imports = [
    ./hyprland
    ./hyprlock.nix
    ./wlogout.nix
  ];

  home.packages = with pkgs; [
    # screenshot
    grim
    slurp

    # utils
    self.packages.${pkgs.system}.wl-ocr
    wl-clipboard
    wl-screenrec
    wlr-randr
  ];

  # make stuff work on wayland
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  # programs.eww-hyprland = {
  #   enable = true;
  #   package = inputs.eww.packages.${pkgs.system}.eww-wayland;
  #   colors = builtins.readFile "${self}/home/services/eww/css/colors-${config.theme.name}.scss";
  # };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };
}
