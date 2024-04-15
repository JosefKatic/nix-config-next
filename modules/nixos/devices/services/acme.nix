{
  config,
  lib,
  ...
}: {
  options.device.server.services.acme.enable = lib.mkEnableOption "Enable ACME";

  config = lib.mkIf config.device.server.services.acme.enable {
    # Enable acme for usage with nginx vhosts
    security.acme = {
      defaults.email = "josef@joka00.dev";
      acceptTerms = true;
    };

    environment.persistence = lib.mkIf config.device.core.storage.enablePersistence {
      "/persist" = {
        directories = [
          "/var/lib/acme"
        ];
      };
    };
  };
}