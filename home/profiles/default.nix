{
  self,
  withSystem,
  inputs,
  module_args,
  ...
}: let
  extraSpecialArgs = {inherit inputs self;};

  homeImports = {
    "joka@alcedo" = ["${self}/home" "${self}/home/profiles/alcedo" module_args];
    "joka@hirundo" = ["${self}/home" "${self}/home/profiles/hirundo" module_args];
    "joka@falco" = ["${self}/home" "${self}/home/profiles/falco" module_args];
    "joka@regulus" = ["${self}/home" "${self}/home/profiles/regulus" module_args];
    "joka@strix" = ["${self}/home" "${self}/home/profiles/strix" module_args];
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;
in {
  imports = [
    # we need to pass this to NixOS' HM module
    {_module.args = {inherit homeImports;};}
  ];

  flake = {
    homeConfigurations = withSystem "x86_64-linux" ({pkgs, ...}: {
      "joka@alcedo" = homeManagerConfiguration {
        modules = homeImports."joka@alcedo";
        inherit pkgs extraSpecialArgs;
      };
      "joka@hirundo" = homeManagerConfiguration {
        modules = homeImports."joka@hirundo";
        inherit pkgs extraSpecialArgs;
      };
      "joka@falco" = homeManagerConfiguration {
        modules = homeImports."joka@falco";
        inherit pkgs extraSpecialArgs;
      };
      "joka@regulus" = homeManagerConfiguration {
        modules = homeImports."joka@regulus";
        inherit pkgs extraSpecialArgs;
      };
      "joka@strix" = homeManagerConfiguration {
        modules = homeImports."joka@strix";
        inherit pkgs extraSpecialArgs;
      };
    });
    # homeManagerModules.eww-hyprland = import ../services/eww;
  };
}
