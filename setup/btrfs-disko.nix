{disks ? ["/dev/nvme0n1"], ...}: {
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            EFI = {
              label = "EFI";
              priority = 1;
              name = "EFI";
              extraArgs = ["-L EFI"];
              start = "1M";
              end = "512MiB";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/efi";
              };
            };
            cryptsystem = {
              label = "cryptsystem";
              size = "100%";
              content = {
                type = "luks";
                name = "system";
                settings = {
                  allowDiscards = true;
                  keyFile = "/dev/mapper/cryptkey";
                  keySize = 8192;
                };
                content = {
                  type = "btrfs";
                  extraArgs = ["-f" "-L system"]; # Override existing partition
                  subvolumes = {
                    # Subvolume name is different from mountpoint
                    "/@root" = {
                      mountpoint = "/";
                      mountOptions = ["subvol=@root" "compress=zstd" "noatime"];
                    };
                    # Mountpoints inferred from subvolume name
                    "/@home" = {
                      mountpoint = "/home";
                      mountOptions = ["subvol=@home" "compress=zstd" "noatime"];
                    };
                    "/@nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["subvol=@nix" "compress=zstd" "noatime"];
                    };
                    "/@persist" = {
                      mountpoint = "/persist";
                      mountOptions = ["subvol=@persist" "compress=zstd" "noatime"];
                    };
                    "/@swap" = {
                      mountpoint = "/swap";
                      mountOptions = ["subvol=@swap" "compress=zstd" "noatime"];
                    };
                  };
                  postCreateHook = ''
                    cryptsetup luksAddKey --key-file /dev/mapper/cryptkey \
                            --keyfile-size 8192 \
                            /dev/disk/by-partlabel/cryptsystem /tmp/disk.key

                    MNTPOINT=$(mktemp -d)
                    mount "/dev/mapper/system" "$MNTPOINT" -o subvol=/
                    trap 'umount $MNTPOINT; rm -rf $MNTPOINT' EXIT
                    btrfs subvolume snapshot -r $MNTPOINT/@root $MNTPOINT/@root-blank
                  '';
                };
              };
            };
          };
        };
      };
    };
  };
}
