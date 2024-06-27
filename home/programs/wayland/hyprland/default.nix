{
  inputs,
  lib,
  pkgs,
  ...
}: let
  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland.override {wrapRuntimeDeps = false;};
  xdph = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland.override {inherit hyprland;};
in {
  imports = [
    ./binds.nix
    ./rules.nix
    ./plugins.nix
    ./settings.nix
  ];

  xdg.portal = {
    extraPortals = [xdph];
    configPackages = [hyprland];
  };

  home.packages = [
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
  ];

  # start swayidle as part of hyprland, not sway
  systemd.user.services.hypridle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];

  # enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland;
    systemd = {
      variables = ["--all"];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
  };
}
