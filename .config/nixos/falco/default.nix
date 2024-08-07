{
  device = {
    boot = {
      quietboot = {enable = false;};
      uefi = {
        enable = false;
        secureboot = false;
      };
    };
    core = {
      disableDefaults = true;
      locale = {
        defaultLocale = "en_US.UTF-8";
        supportedLocales = ["en_US.UTF-8/UTF-8" "cs_CZ.UTF-8/UTF-8"];
        timeZone = "Europe/Prague";
      };
      network = {
        domain = "clients.joka00.dev";
        services = {
          enableAvahi = false;
          enableNetworkManager = false;
          enableResolved = false;
        };
      };
      securityRules = {enable = true;};
      shells = {
        fish = {enable = true;};
        zsh = {enable = false;};
      };
      storage = {
        enablePersistence = true;
        otherDrives = [];
        swapFile = {
          enable = true;
          path = "/swap/swapfile";
          size = 4;
        };
        systemDrive = {
          encrypted = {
            enable = false;
            path = "";
          };
          name = "system";
          path = "/dev/disk/by-label/system";
        };
      };
    };
    desktop = {
      gamemode = {enable = false;};
      wayland = {
        desktopManager = {
          gnome = {enable = false;};
          plasma6 = {enable = false;};
        };
        displayManager = {
          gdm = {enable = false;};
          regreet = {
            enable = false;
            themes = {
              cursor = {
                name = "";
                package = "";
              };
              gtk = {
                name = "";
                package = "";
              };
              icons = {
                name = "";
                package = "";
              };
            };
          };
        };
        windowManager = {
          hyprland = {enable = false;};
          sway = {enable = false;};
        };
      };
    };
    hardware = {
      bluetooth = {
        enable = false;
        enableManager = false;
      };
      cpu = {
        amd = {enable = false;};
        intel = {enable = true;};
      };
      disks = {
        hdd = {enable = false;};
        ssd = {enable = true;};
      };
      gpu = {
        amd = {enable = false;};
        intel = {enable = false;};
        nvidia = {enable = false;};
      };
      misc = {
        trezor = {enable = false;};
        xbox = {enable = false;};
        yubikey = {enable = false;};
      };
    };
    server = {
      auth = {
        freeipa = {enable = false;};
        keycloak = {enable = false;};
      };
      cache = {enable = false;};
      git = {
        daemon = {
          enable = true;
        };
        cgit = {
          enable = true;
        };
      };
      hydra = {enable = false;};
      hosting = {website.enable = true;};
      minecraft = {enable = false;};
      teamspeak = {enable = false;};
      databases = {
        mysql = {enable = false;};
        postgresql = {enable = true;};
      };
      services = {
        web = {
          acme = {enable = true;};
          nginx = {enable = true;};
        };
        fail2ban = {enable = true;};
      };
    };
    utils = {
      autoUpgrade = {enable = false;};
      kdeconnect = {enable = false;};
      virtualisation = {
        docker = {enable = false;};
        libvirtd = {enable = false;};
        podman = {enable = false;};
      };
    };
  };
}
