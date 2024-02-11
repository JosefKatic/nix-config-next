{
  self,
  inputs,
  withSystem,
  module_args,
  ...
}: let
  extraSpecialArgs = {inherit inputs self;};

  homeImports = {"joka@hirundo" = ["${self}/home" "${self}/home/profiles/hirundo" module_args];};

  inherit (inputs.hm.lib) homeManagerConfiguration;
in {
  imports = [
    # we need to pass this to NixOS' HM module
    {_module.args = {inherit homeImports;};}
  ];

  flake = {
    homeConfigurations = withSystem "x86_64-linux" ({pkgs, ...}: {
      "joka@hirundo" = homeManagerConfiguration {
        modules = homeImports."joka@hirundo";
        inherit pkgs extraSpecialArgs;
      };
    });
  };
}
