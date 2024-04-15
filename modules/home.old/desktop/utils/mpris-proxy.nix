{
  config,
  pkgs,
  lib,
  device,
  ...
}: {
  config = lib.mkIf device.hardware.bluetooth.enable {
    systemd.user.services = {
      mpris-proxy = {
        description = "Mpris proxy";
        after = ["network.target" "sound.target"];
        wantedBy = ["default.target"];
        serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      };
    };
  };
}
