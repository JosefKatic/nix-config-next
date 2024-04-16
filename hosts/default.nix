{
  inputs,
  outputs,
  self,
  lib,
  sharedModules,
  homeImports,
  ...
}: let
  specialArgs = {inherit inputs self;};
  deviceNames = import "${self}/.config/nixos/default.nix";
in {
  flake = {
    nixosConfigurations = let
      inherit (inputs.nixpkgs.lib) nixosSystem;
      deviceConfigurations =
        map (deviceName: {
          name = deviceName;
          value = nixosSystem {
            specialArgs = {inherit inputs outputs self;};
            modules =
              [
                {
                  home-manager = {
                    users.joka.imports = homeImports."joka@${deviceName}";
                    extraSpecialArgs = specialArgs;
                  };
                  # services.flatpak.enable = true;
                  services.nordvpn.enable = true;
                  networking.hostName = deviceName;
                  imports = [
                    "${self}/.config/nixos/${deviceName}/default.nix"
                    "${self}/hosts/${deviceName}/hardware-configuration.nix"
                  ];
                }
              ]
              ++ sharedModules;
          };
        })
        deviceNames;
    in
      builtins.listToAttrs deviceConfigurations;

    deploy.nodes = let
      deployNodes =
        map (deviceName: {
          name = deviceName;
          value = let
            device = self.nixosConfigurations.${deviceName};
            deployHostPlatform = inputs.deploy-rs.lib.${device.config.nixpkgs.hostPlatform.system};
            hasOptinPersistence = device.config.environment.persistence ? "/persist";
          in {
            hostname = "${deviceName}";
            fastConnection = true;
            profiles = {
              system = {
                path = deployHostPlatform.activate.nixos device;
                user = "root";
              };
            };
          };
        })
        deviceNames;
    in
      builtins.listToAttrs deployNodes;

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
  };
}
