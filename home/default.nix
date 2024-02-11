{
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
  };
  imports = [
    ./specialisations.nix
    ./terminal
    inputs.matugen.nixosModules.default
    inputs.nix-index-db.hmModules.nix-index
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
    homeDirectory = lib.mkDefault "/home/${username}";
    stateVersion = lib.mkDefault "23.05";
    sessionPath = ["$HOME/.local/bin"];
    sessionVariables = {
      FLAKE = "$HOME/.flake-config";
    };

    persistence = {
      "/persist/home/joka" = {
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
  # disable manuals as nmd fails to build often
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };
}
