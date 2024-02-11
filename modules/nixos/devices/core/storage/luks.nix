{
  config,
  lib,
  ...
}: let
  cfg = config.device.core.storage;
in {
  options.device.core.storage.systemDrive.encrypted =
    lib.mkEnableOption "Encrypt system drive";

  config = lib.mkIf cfg.systemDrive.encrypted {
    boot.initrd.luks.devices = {
      ${cfg.systemDrive.name}.device =
        cfg.systemDrive.path;
    };
  };
}
