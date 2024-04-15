{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.browsers;
in {
  options.desktop.browsers.brave.enable =
    lib.mkEnableOption "Enable Brave browser";

  config = lib.mkIf cfg.brave.enable {home.packages = [pkgs.brave];};
}
