{
  config,
  lib,
  inputs,
  options,
  ...
}: let
  cfg = config.device.hardware.cpu;
in {
  options.device.hardware.cpu = {
    amd = {enable = lib.mkEnableOption "Enable AMD CPU support";};
    intel = {enable = lib.mkEnableOption "Enable Intel CPU support";};
  };

  config = {
    hardware.cpu.amd.updateMicrocode = cfg.amd.enable;
    hardware.cpu.intel.updateMicrocode = cfg.intel.enable;
  };
}
