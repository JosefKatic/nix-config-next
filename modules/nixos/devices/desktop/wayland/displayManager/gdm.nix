{
  self,
  config,
  lib,
  options,
  ...
}: let
  cfg = config.device.desktop.wayland.displayManager.gdm;
in {
  options.device.desktop.wayland.displayManager.gdm = {
    enable = lib.mkEnableOption "Enable GDM";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
  };
}
