# {
#   devices = {
#     "hirundo" = {
#       device = {
#         boot = {
#           uefi = {
#             enable = true;
#             secureboot = true;
#           };
#           quietboot.enable = true;
#         };
#         hardware = {
#           cpu.amd.enable = true;
#           gpu.amd.enable = true;
#           disks.ssd.enable = true;
#           bluetooth.enable = true;
#           misc = {
#             yubikey.enable = true;
#             trezor.enable = true;
#             xbox.enable = true;
#           };
#         };
#         core = {
#           network = {
#             domain = "clients.joka00.dev";
#             services = {
#               enableNetworkManager = true;
#               enableAvahi = true;
#               enableResolved = true;
#             };
#           };
#           shells = {
#             fish.enable = true;
#           };
#           storage = {
#             systemDrive = {
#               name = "system";
#               path = "/dev/disk/by-label/system";
#               encrypted = {
#                 enable = true;
#                 path = "/dev/disk/by-partlabel/cryptsystem";
#               };
#             };
#             enablePersistence = true;
#             swapFile = {
#               path = "/swap/swapfile";
#               # Size in GiB
#               size = 18;
#             };
#           };
#         };
#         desktop = {
#           gamemode.enable = true;
#           wayland = {
#             displayManager = {regreet = {enable = false;};};
#             windowManager = {
#               sway.enable = true;
#               hyprland.enable = true;
#             };
#             desktopManager = {
#               gnome.enable = false;
#             };
#           };
#         };
#         utils = {
#           autoUpgrade.enable = true;
#           virtualisation = {
#             docker.enable = true;
#             libvirtd.enable = true;
#           };
#         };
#       };
#     };
#     "strix" = {
#       device = {
#         boot.legacy.enable = true;
#         hardware = {
#           cpu.amd.enable = true;
#           disks.ssd.enable = true;
#         };
#         core = {
#           network = {
#             domain = "servers.joka00.dev";
#           };
#           shells = {
#             fish.enable = true;
#           };
#           storage = {
#             systemDrive = {
#               name = "system";
#               path = "/dev/disk/by-label/system";
#               encrypted.enable = false;
#             };
#             enablePersistence = true;
#             swapFile = {
#               path = "/swap/swapfile";
#               # Size in GiB
#               size = 8;
#             };
#           };
#         };
#         server = {
#           services = {
#             acme.enable = true;
#             fail2ban.enable = true;
#             freeipaServer.enable = true;
#             keycloak.enable = true;
#             nginx.enable = true;
#             postgresql.enable = true;
#             teamspeak.enable = true;
#             headscale.enable = true;
#           };
#         };
#         utils = {
#           autoUpgrade.enable = true;
#         };
#       };
#     };
#     # "alcedo" = {
#     #   boot.secureboot.enable = true;
#     #   hardware = {
#     #     cpu.intel.enable = true;
#     #     gpu.nvidia.enable = true;
#     #     ssd.enable = true;
#     #     yubikey.enable = true;
#     #   };
#     #   core = {
#     #     storage = {
#     #       systemDrive = {
#     #         name = "system";
#     #         path = "/dev/disk/by-label/system";
#     #       };
#     #       enablePersistence = true;
#     #       enableEncryption = true;
#     #       swapFile = {
#     #         path = "/swap/swapfile";
#     #         # Size in GiB
#     #         size = 18;
#     #       };
#     #     };
#     #   };
#     #   desktop = { gamemode.enable = true; };
#     #   utils = {
#     #     autoUpgrade.enable = true;
#     #     virtualisation = {
#     #       docker.enable = true;
#     #       libvirt.enable = true;
#     #     };
#     #   };
#     # };
#     # "falco" = { hardware.ssd.enable = true; };
#     # "strix" = { hardware.ssd.enable = true; };
#   };
# }
