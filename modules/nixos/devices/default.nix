{
  config,
  inputs,
  lib,
  options,
  pkgs,
  deviceName,
  ...
}: let
in {
  imports = [
    ./boot
    ./core
    ./hardware
    ./desktop
    ./utils
    ./users
  ];
}
