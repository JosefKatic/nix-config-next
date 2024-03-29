{
  config,
  lib,
  pkgs,
  ...
}: {
  options.device.hardware.gpu.intel = {
    enable = lib.mkEnableOption "Enable Intel GPU support";
  };
  config = {
    boot.initrd.kernelModules = ["i915"];

    environment.variables = {
      VDPAU_DRIVER =
        lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
    };

    hardware.opengl.extraPackages = with pkgs; [
      (
        if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11")
        then vaapiIntel
        else intel-vaapi-driver
      )
      libvdpau-va-gl
      intel-media-driver
    ];
  };
}
