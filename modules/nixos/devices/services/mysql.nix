{
  config,
  lib,
  pkgs,
  ...
}: {
  options.device.services.mysql.enable = lib.mkEnableOption "Enable postgresql";
  config = lib.mkIf config.device.services.mysql.enable {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    environment.persistence = lib.mkIf config.device.core.storage.enablePersistence {
      "/persist".directories = [
        "/var/lib/mysql"
      ];
    };
  };
}
