{
  lib,
  pkgs,
  ...
}: {
  options.device.hardware.gpu.amd = {
    enable = lib.mkEnableOption "Enable AMD GPU support";
  };
  config = {
    services.xserver.videoDrivers = lib.mkDefault ["modesetting"];

    hardware.opengl = {
      driSupport = lib.mkDefault true;
      driSupport32Bit = lib.mkDefault true;
    };
    boot.initrd.kernelModules = ["amdgpu"];
    hardware.opengl.extraPackages =
      if pkgs ? rocmPackages.clr
      then with pkgs.rocmPackages; [clr clr.icd]
      else with pkgs; [rocm-opencl-icd rocm-opencl-runtime];
  };
}
