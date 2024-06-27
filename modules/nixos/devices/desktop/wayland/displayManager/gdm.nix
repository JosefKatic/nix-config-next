{
  self,
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  cfg = config.device.desktop.wayland.displayManager.gdm;
  logoFile = pkgs.fetchurl {
    url = "https://joka00.dev/assets/logo__dark.svg";
    sha256 = "1xd5hfxlh0m5687mfxndyv18a2k6aq7njna4n5smn7f7ynal1i28";
  };
  inherit (config.theme.colorscheme) colors mode;
in {
  options.device.desktop.wayland.displayManager.gdm = {
    enable = lib.mkEnableOption "Enable GDM";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;

    programs.dconf.profiles.gdm.databases = [
      {
        settings = {
          "org/gnome/desktop/background" = {
            primary-color = lib.removePrefix "#" colors.primary;
            secondary-color = lib.removePrefix "#" colors.on_primary;
          };
          "org/gnome/login-screen" = {
            logo = "${logoFile}";
          };
        };
      }
    ];
  };
}
