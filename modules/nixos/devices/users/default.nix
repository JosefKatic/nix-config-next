{
  self,
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.networking) hostName;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  username = "joka";
in {
  options = {
    device.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          shell = lib.mkOption {
            type = lib.types.path;
            default = pkgs.fish;
          };
          extraGroups = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            example = ["wheel"];
          };
        };
      });
      default = {};
    };
  };

  config = {
    users.mutableUsers = false;
    # Loop

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQsZc3jXTE6h1VsbCjYP+VlQN1ouBO5t/fhNImWQBsW"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQSA9z9P7MXhY97IHi6IJYGtxGMp6EsRrcslp98P+KL"
    ];

    users.extraUsers.nix-deploy = {
      isNormalUser = true;
      shell = pkgs.bash;
      group = "nix-deploy";
      extraGroups = [
        "wheel"
      ];
      home = "/.deploy";
      hashedPasswordFile = config.sops.secrets.joka-password.path;
      openssh.authorizedKeys.keys = [(builtins.readFile "${self}/home/joka/ssh.pub")];
    };

    security.sudo.extraRules = [
      {
        users = ["nixos-deploy"];
        commands = [
          {
            command = "${lib.getExe pkgs.deploy-rs}";
            options = ["SETENV" "NOPASSWD"];
          }
        ];
      }
    ];

    users.groups.nix-deploy = {};
    users.users.${username} = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups =
        [
          "wheel"
          "video"
          "audio"
          "network"
          "i2c"
        ]
        # ++ ifTheyExist [
          "minecraft"
          "wireshark"
          "mysql"
          "nordvpn"
          "docker"
          "podman"
          "git"
          "libvirtd"
          "deluge"
        ];
      openssh.authorizedKeys.keys = [(builtins.readFile "${self}/home/${username}/ssh.pub")];
      hashedPasswordFile = config.sops.secrets.joka-password.path;
      packages = [
        pkgs.home-manager
      ];
    };

    # Loop
    sops.secrets.joka-password = {
      sopsFile = "${self}/secrets/${username}/secrets.yaml";
      neededForUsers = true;
    };
  };
}
