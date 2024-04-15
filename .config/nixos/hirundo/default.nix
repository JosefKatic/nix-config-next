{
  device = {
    boot = {
      quietboot = {enable = true;};
      uefi = {
        enable = true;
        secureboot = true;
      };
    };
    core = {
      locale = {
        defaultLocale = "en_US.UTF-8";
        supportedLocales = ["en_US.UTF-8/UTF-8" "cs_CZ.UTF-8/UTF-8"];
        timeZone = "Europe/Prague";
      };
      kernel = "linux_zen";
      network = {
        domain = "clients.joka00.dev";
        services = {
          enableAvahi = true;
          enableNetworkManager = true;
          enableResolved = true;
        };
      };
      shells = {fish = {enable = true;};};
      storage = {
        enablePersistence = true;
        swapFile = {
          path = "/swap/swapfile";
          size = 18;
        };
        systemDrive = {
          encrypted = {
            enable = true;
            path = "/dev/disk/by-partlabel/cryptsystem";
          };
          name = "system";
          path = "/dev/disk/by-label/system";
        };
      };
    };
    desktop = {
      gamemode = {enable = true;};
      wayland = {
        displayManager = {
          gdm = {enable = true;};
          regreet = {enable = false;};
        };
        windowManager = {
          hyprland = {enable = true;};
          sway = {enable = true;};
        };
      };
    };
    hardware = {
      bluetooth = {enable = true;};
      cpu = {amd = {enable = true;};};
      disks = {ssd = {enable = true;};};
      gpu = {amd = {enable = true;};};
      misc = {
        trezor = {enable = true;};
        xbox = {enable = true;};
        yubikey = {enable = true;};
      };
    };
    server = {
      services = {
        deploy = {
          enable = true;
        };
      };
    };
    utils = {
      autoUpgrade = {enable = true;};
      kdeconnect = {enable = true;};
      virtualisation = {
        docker = {enable = true;};
        libvirtd = {enable = true;};
        podman = {enable = false;};
      };
    };
  };
}
