{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.browsers;
in {
  options.desktop.browsers = {
    default = lib.mkOption {
      type = lib.types.nullOr lib.types.enum ["firefox" "chromium" "brave"];
      default = null;
      description = "Default browser";
    };
  };

  config =
    lib.mkIf cfg.default
    != null {
      home = {sessionVariables.BROWSER = "${cfg.default}";};

      xdg.mimeApps.defaultApplications = let
        defaultBrowser = "${cfg.default}.desktop";
      in {
        "text/html" = ["${defaultBrowser}"];
        "text/xml" = ["${defaultBrowser}"];
        "x-scheme-handler/http" = ["${defaultBrowser}"];
        "x-scheme-handler/https" = ["${defaultBrowser}"];
      };
    };
  imports = [./firefox ./brave ./chromium];
}
