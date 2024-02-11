{
  devices = {
    "hirundo" = {
      device = {
        boot.uefi = {
          enable = true;
          secureboot = true;
        };
        hardware = {
          cpu.amd.enable = true;
          gpu.amd.enable = true;
          disks.ssd.enable = true;
          misc = {yubikey.enable = true;};
        };
        core = {
          shells = {
            fish.enable = true;
          };
          storage = {
            systemDrive = {
              name = "system";
              path = "/dev/disk/by-label/system";
              encrypted = true;
            };
            enablePersistence = true;
            swapFile = {
              path = "/swap/swapfile";
              # Size in GiB
              size = 18;
            };
          };
        };
        desktop = {
          gamemode.enable = true;
          wayland = {
            displayManager = {regreet = {enable = true;};};
            windowManager = {
              sway.enable = true;
              hyprland.enable = true;
            };
          };
        };
        utils = {
          autoUpgrade.enable = true;
          virtualisation = {
            docker.enable = true;
            libvirtd.enable = true;
          };
        };
      };
    };
    # "alcedo" = {
    #   boot.secureboot.enable = true;
    #   hardware = {
    #     cpu.intel.enable = true;
    #     gpu.nvidia.enable = true;
    #     ssd.enable = true;
    #     yubikey.enable = true;
    #   };
    #   core = {
    #     storage = {
    #       systemDrive = {
    #         name = "system";
    #         path = "/dev/disk/by-label/system";
    #       };
    #       enablePersistence = true;
    #       enableEncryption = true;
    #       swapFile = {
    #         path = "/swap/swapfile";
    #         # Size in GiB
    #         size = 18;
    #       };
    #     };
    #   };
    #   desktop = { gamemode.enable = true; };
    #   utils = {
    #     autoUpgrade.enable = true;
    #     virtualisation = {
    #       docker.enable = true;
    #       libvirt.enable = true;
    #     };
    #   };
    # };
    # "falco" = { hardware.ssd.enable = true; };
    # "strix" = { hardware.ssd.enable = true; };
  };
}
