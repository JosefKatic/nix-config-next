{
  config,
  lib,
  self,
  pkgs,
  inputs,
  ...
}: let
  username = "joka";
in {
  nixpkgs = {
    overlays = [
      (final: prev: {
        lib =
          prev.lib
          // {
            colors = import "${self}/lib/colors" lib;
          };
      })
    ];
    config = {
      allowBroken = true;
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };
  };
  imports = [
    ./specialisations.nix
    ./terminal
    inputs.matugen.nixosModules.default
    inputs.nix-index-db.hmModules.nix-index
    inputs.hyprlock.homeManagerModules.default
    inputs.hypridle.homeManagerModules.default
    inputs.nur.nixosModules.nur
    inputs.impermanence.nixosModules.home-manager.impermanence
    self.nixosModules.theme
  ];

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      warn-dirty = false;
    };
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = username;
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "23.11";
    sessionPath = ["$HOME/.local/bin"];
    sessionVariables = {
      FLAKE = "$HOME/.flake-config";
    };

    persistence = {
      "/persist/home/${config.home.username}" = {
        directories = [
          "Documents"
          "Downloads"
          "Pictures"
          "Videos"
          "develop"
          ".local/bin"
          ".local/share/nix" # trusted settings and repl history
        ];
        allowOther = true;
      };
    };
  };
  # NEW
}
