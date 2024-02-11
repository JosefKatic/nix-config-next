{
  inputs,
  outputs,
  self,
  sharedModules,
  homeImports,
  ...
}: let
  specialArgs = {inherit inputs self;};
in {
  flake.nixosConfigurations = let
    inherit (inputs.nixpkgs.lib) nixosSystem;
    list = import ./devices.nix;
    deviceNames = builtins.attrNames list.devices;
    deviceConfigurations =
      map (deviceName: {
        name = deviceName;
        value = nixosSystem {
          specialArgs = {inherit inputs outputs self;};
          modules =
            [
              list.devices.${deviceName}
              {
                home-manager = {
                  users.joka.imports = homeImports."joka@${deviceName}";
                  extraSpecialArgs = specialArgs;
                };
                networking.hostName = deviceName;
                imports = ["${self}/hosts/${deviceName}/hardware-configuration.nix"];
              }
            ]
            ++ sharedModules;
        };
      })
      deviceNames;
  in
    builtins.listToAttrs deviceConfigurations;
}
