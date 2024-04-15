{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.device.hardware.gpu;
in {
  options.device.hardware.gpu.nvidia = {
    enable = lib.mkEnableOption "Enable Nvidia GPU";
  };
  config = lib.mkIf cfg.nvidia.enable {
    services.xserver = {videoDrivers = ["nvidia"];};
    hardware = {
      opengl = {
        driSupport32Bit = true;
        extraPackages = with pkgs; [
          vaapiVdpau
          libvdpau-va-gl
          nvidia-vaapi-driver
        ];
      };
      nvidia = {
        modesetting.enable = true;
        open = true;
        nvidiaSettings = true;
        package = pkgs.linuxKernel.packages.${config.device.core.kernel}.nvidia_x11;
      };
    };
  };
}
