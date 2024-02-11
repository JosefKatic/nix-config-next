{
  config,
  lib,
  ...
}: let
  cfg = config.device;
in {
  options.device.boot.legacy = {
    enable = lib.mkEnableOption "Enable legacy boot loader";
  };

  config = lib.mkIf cfg.boot.legacy.enable {
    boot = {
      initrd = {
        systemd.enable = true;
        supportedFilesystems = ["btrfs"];
      };
      loader = {
        grub = {
          enable = lib.mkDefault true;
          device = lib.mkDefault "/dev/vda";
        };
      };
    };
    fileSystems."/boot" = {
      device = cfg.core.systemDrive.path;
      fsType = "btrfs";
      options = ["subvol=@boot"];
    };
  };
}
