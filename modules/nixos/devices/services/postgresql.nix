{
  config,
  lib,
  ...
}: {
  options.device.server.services.postgresql.enable = lib.mkEnableOption "Enable postgresql";
  config = lib.mkIf config.device.server.services.postgresql.enable {
    services.postgresql.enable = true;

    environment.persistence = lib.mkIf config.device.core.storage.enablePersistence {
      "/persist".directories = [
        "/var/lib/postgresql"
      ];
    };
  };
}
