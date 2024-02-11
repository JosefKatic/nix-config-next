{
  config,
  lib,
  ...
}: let
  cfg = config.device;
in {
  options.device.utils.kdeconnect.enable = lib.mkEnableOption "Description xD";

  config = {programs = {kdeconnect.enable = cfg.utils.kdeconnect.enable;};};
}
