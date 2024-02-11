{
  self,
  config,
  lib,
  pkgs,
  default,
  ...
}: let
  variant = config.theme.name;
  cfg = config.device.desktop.wayland.displayManager.regreet;

  homeCfgs = config.home-manager.users;
  homeSharePaths = lib.mapAttrsToList (n: v: "${v.home.path}/share") homeCfgs;
  vars = ''
    XDG_DATA_DIRS="$XDG_DATA_DIRS:${lib.concatStringsSep ":" homeSharePaths}"'';

  # TODO: this should not be coupled to my home config
  # Or at least have some kind of fallback values if it's not present on this machine
  gtkTheme = {
    name =
      if variant == "light"
      then "adw-gtk3"
      else "adw-gtk3-dark";
    package = pkgs.adw-gtk3;
  };
  iconTheme = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
  };
  cursorTheme = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
  };

  sway-kiosk = command: "${lib.getExe pkgs.sway} --unsupported-gpu --config ${
    pkgs.writeText "kiosk.config" ''
      output * bg #000000 solid_color
      xwayland disable
      input "type:touchpad" {
        tap enabled
      }
      exec 'WLR_NO_HARDWARE_CURSORS=1 GTK_USE_PORTAL=0 ${vars} ${command}; ${pkgs.sway}/bin/swaymsg exit'
    ''
  }";
in {
  options.device.desktop.wayland.displayManager.regreet = {
    enable =
      lib.mkEnableOption "Enable greetd as the display manager for wayland";
    themes = {
      gtk = {
        name = lib.mkOption {
          type = lib.types.str;
          default = gtkTheme.name;
        };
        package = lib.mkOption {
          type = lib.types.path;
          default = gtkTheme.package;
        };
      };
      icons = {
        name = lib.mkOption {
          type = lib.types.str;
          default = iconTheme.name;
        };
        package = lib.mkOption {
          type = lib.types.path;
          default = iconTheme.package;
        };
      };
      cursor = {
        name = lib.mkOption {
          type = lib.types.str;
          default = cursorTheme.name;
        };
        package = lib.mkOption {
          type = lib.types.path;
          default = cursorTheme.package;
        };
      };
    };
  };
  config = lib.mkIf cfg.enable {
    users.extraUsers.greeter = {
      packages = [
        cfg.themes.gtk.package
        cfg.themes.icons.package
        cfg.themes.cursor.package
      ];
      # For caching and such
      home = "/tmp/greeter-home";
      createHome = true;
    };

    programs.regreet = {
      enable = true;
      settings = {
        GTK = {
          icon_theme_name = cfg.themes.icons.name;
          theme_name = cfg.themes.gtk.name;
          cursor_theme_name = cfg.themes.cursor.name;
        };
        background = {
          path = homeCfgs.joka.theme.wallpaper;
          fit = "Cover";
        };
      };
    };
    services.greetd = {
      enable = true;
      settings.default_session.command =
        sway-kiosk (lib.getExe config.programs.regreet.package);
    };
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
