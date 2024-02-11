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
    package = lib.mkOption {
      type = lib.types.path;
      default = pkgs.linuxKernel.packages.linux_zen.nvidia_x11;
      description = "Nvidia driver package";
    };
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
        package = cfg.nvidia.package;
      };
    };
  };
}
