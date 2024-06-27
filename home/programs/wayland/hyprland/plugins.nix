{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = {
    plugins = [
      inputs.hyprsplit.packages.${pkgs.system}.hyprsplit
    ];
    settings = {
      "plugin:hyprsplit" = {
        num_workspaces = 10;
      };
    };
  };
}
