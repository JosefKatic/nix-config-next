{
  config,
  lib,
  pkgs,
  device,
  ...
}: {
  config = lib.mkIf device.hardware.misc.trezor.enable {
    home.packages = [pkgs.trezor-suite];
  };
}
