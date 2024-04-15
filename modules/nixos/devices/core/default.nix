{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  # disableDefaults =
  # import ./no-defaults.nix { inherit config lib options pkgs; };
  # locale = import ./locale.nix { inherit config lib options pkgs; };
  # shells = import ./shells.nix { inherit config lib options pkgs; };
  # storage = import ./storage/default.nix { inherit config lib options pkgs; };
  # security = import ./security.nix { inherit config lib options pkgs; };
in {
  documentation.dev.enable = true;
  hardware.opengl.enable = true;
  imports = [
    ./storage
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./kernel.nix
    ./no-defaults.nix
    ./openssh.nix
    ./power.nix
    ./security.nix
    ./shells
    ./sops.nix
    ./sound.nix
    ./specialisations.nix
  ];

  # These are configs that needs to be everywhere
  hardware.enableRedistributableFirmware = true;
  programs.dconf.enable = true;
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  hardware.brillo.enable = true;
  # DON"T CHANGE THIS!
  system.stateVersion = lib.mkDefault "24.05";
}
