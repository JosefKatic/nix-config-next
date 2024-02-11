{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  cfg = config.device;
in {
  options.device.core.storage = {
    systemDrive = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "system";
        description = "The name of the system drive.";
      };
      path = lib.mkOption {
        type = lib.types.path;
        default = "/dev/disk/by-partlabel/system";
        description = "The path to the system drive.";
      };
    };
    otherDrives = lib.mkOption {
      type = lib.types.listOf {
        name = lib.mkOption {
          type = lib.types.str;
          description = "The name of the drive.";
        };
        path = lib.mkOption {
          type = lib.types.path;
          description = "The path to the drive.";
        };
      };
      default = [];
      description = "The names of the other drives.";
    };
  };
  config = {
    fileSystems = {
      "/" = {
        device = cfg.core.storage.systemDrive.path;
        fsType = "btrfs";
        options = ["subvol=@root" "compress=zstd" "noatime"];
      };

      "/home" = {
        device = cfg.core.storage.systemDrive.path;
        fsType = "btrfs";
        options = ["subvol=@home" "compress=zstd" "noatime"];
      };

      "/nix" = {
        device = cfg.core.storage.systemDrive.path;
        fsType = "btrfs";
        options = ["subvol=@nix" "compress=zstd" "noatime"];
      };

      "/persist" = {
        device = cfg.core.storage.systemDrive.path;
        fsType = "btrfs";
        options = ["subvol=@persist" "compress=zstd" "noatime"];
        neededForBoot = true;
      };

      "/swap" = {
        device = cfg.core.storage.systemDrive.path;
        fsType = "btrfs";
        options = ["subvol=@swap" "compress=zstd" "noatime"];
      };
    };
  };
}