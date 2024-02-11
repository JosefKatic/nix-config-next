{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.browsers;
in {
  options.desktop.browsers.chromium.enable =
    lib.mkEnableOption "Enable Chromium browser";

  config = lib.mkIf cfg.chromium.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.chromium;
    };
  };
}
