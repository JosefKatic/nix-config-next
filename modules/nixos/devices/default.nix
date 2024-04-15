{
  self,
  config,
  inputs,
  lib,
  options,
  pkgs,
  deviceName,
  ...
}: {
  imports = [
    ./boot
    ./core
    ./hardware
    ./desktop
    ./utils
    ./users
    ./services
  ];
}
