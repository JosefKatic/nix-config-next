{
  pkgs,
  self,
  inputs,
  lib,
  ...
}: let
  deploy-system-script = pkgs.writeShellScript "deploySystemScript" ''
    host="$2"
    shift
    mkdir -p /tmp/deploy/flake
    cd /tmp/deploy/flake
    rm -r .config
     ${lib.getExe pkgs.git}  -C . pull || git clone https://github.com/JosefKatic/nix-config-next.git .

    ${lib.getExe self.packages.${pkgs.system}.prefetchConfig}

    if [ -z "$host" ]; then
        echo "No host to deploy"
        exit 2
    fi
    ${lib.getExe pkgs.deploy-rs} .#$host $@
  '';
in {
  environment.systemPackages = [
    pkgs.git
    inputs.matugen.packages.${pkgs.system}.default
    pkgs.yubikey-manager-qt
    pkgs.libyubikey
    pkgs.ntfs3g
    pkgs.woeusb
  ];

  programs.nh = {
    enable = true;
    package = inputs.nh.packages.x86_64-linux.default;
    # weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 1w";
    };
  };

  nix = {
    settings = {
      substituters = [
        "https://anyrun.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
      trusted-users = ["root" "@wheel" "nix-ssh" "deploy"];
      auto-optimise-store = lib.mkDefault true;
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      warn-dirty = false;
      system-features = ["kvm" "big-parallel" "nixos-test"];
      flake-registry = "/etc/nix/registry.json";

      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;
    };
    # Add each flake input as a registry
    # To make nix3 commands consistent with the flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # Add nixpkgs input to NIX_PATH
    # This lets nix2 commzands still use <nixpkgs>
    nixPath = ["nixpkgs=${inputs.nixpkgs.outPath}"];
    sshServe = {
      enable = true;
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMrMubi3ooI8JN1E3iGF+j51TwloMRnkUCXQWO6gIYCj nix-ssh"
      ];
      protocol = "ssh";
      write = true;
    };
  };
  nixpkgs = {
    overlays = [
      (final: prev: {
        inputs =
          builtins.mapAttrs (
            _: flake: let
              legacyPackages = (flake.legacyPackages or {}).${final.system} or {};
              packages = (flake.packages or {}).${final.system} or {};
            in
              if legacyPackages != {}
              then legacyPackages
              else packages
          )
          inputs;
      })
      (final: prev: {
        deploySystem = final.writeShellScriptBin "deploySystem" ''
          /run/wrappers/bin/sudo ${deploy-system-script}
        '';
        lib =
          prev.lib
          // {
            colors = import "${self}/lib/colors" prev.lib;
          };
      })
      inputs.nix-minecraft.overlay
    ];
    config = {
      allowBroken = true;
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };
  };
}
