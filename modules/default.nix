{
  self,
  inputs,
  wallpapers,
  ...
}: let
  # system-agnostic args
  module_args._module.args = {
    inherit wallpapers inputs self;
  };
in {
  imports = [
    {
      _module.args = {
        # we need to pass this to HM
        inherit module_args;

        # NixOS modules
        sharedModules = [
          {
            home-manager = {
              # useGlobalPkgs = true;
              useUserPackages = true;
            };
          }

          inputs.hm.nixosModule
          inputs.hyprland.nixosModules.default
          inputs.kmonad.nixosModules.default
          inputs.nh.nixosModules.default
          inputs.nix-gaming.nixosModules.pipewireLowLatency
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.sops-nix.nixosModules.sops
          inputs.impermanence.nixosModules.impermanence
          module_args

          self.nixosModules.device
          self.nixosModules.theme
          self.nixosModules.nordvpn
        ];
      };
    }
  ];

  flake = {
    nixosModules = {
      device = import ./nixos/devices;
      theme = import ./theme;
      nordvpn = import ./nordvpn.nix;
    };
  };
}
