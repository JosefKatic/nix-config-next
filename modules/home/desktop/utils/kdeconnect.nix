{
  config,
  lib,
  pkgs,
  device,
  ...
}: let
  kdeconnect-cli = "${pkgs.plasma5Packages.kdeconnect-kde}/bin/kdeconnect-cli";
  fortune = "${pkgs.fortune}/bin/fortune";

  script-fortune = pkgs.writeShellScriptBin "fortune" ''
    ${kdeconnect-cli} -d $(${kdeconnect-cli} --list-available --id-only) --ping-msg "$(${fortune})"
  '';
in {
  options.desktop.utils.kdeconnect.enable =
    lib.mkEnableOption "Enable KDEConnect GUI";

  config =
    lib.mkIf config.desktop.utils.kdeconnect.enable
    && device.utils.kdeconnect.enable {
      # Hide all .desktop, except for org.kde.kdeconnect.settings
      xdg.desktopEntries = {
        "org.kde.kdeconnect.sms" = {
          exec = "";
          name = "KDE Connect SMS";
          settings.NoDisplay = "true";
        };
        "org.kde.kdeconnect.nonplasma" = {
          exec = "";
          name = "KDE Connect Indicator";
          settings.NoDisplay = "true";
        };
        "org.kde.kdeconnect.app" = {
          exec = "";
          name = "KDE Connect";
          settings.NoDisplay = "true";
        };
      };

      services.kdeconnect = {
        enable = true;
        indicator = true;
      };

      xdg.configFile = {
        "kdeconnect-scripts/fortune.sh".source = "${script-fortune}/bin/fortune";
      };

      home.persistence = lib.mkIf device.core.storage.enablePersistence {
        "/persist/home/joka".directories = [".config/kdeconnect"];
      };
    };
}
