{
  self,
  config,
  lib,
  pkgs,
  ...
}: {
  options.device.server.services = {
    keycloak.enable = lib.mkEnableOption "Enable keycloak";
  };

  config = lib.mkIf config.device.server.services.keycloak.enable {
    services.nginx = {
      virtualHosts = {
        "auth.joka00.dev" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              proxyPass = "http://localhost:${toString config.services.keycloak.settings.http-port}/";
            };
          };
        };
      };
    };

    sops.secrets.keycloak_db = {
      sopsFile = "${self}/secrets/services/auth/secrets.yaml";
    };

    sops.secrets.keycloak = {
      sopsFile = "${self}/secrets/services/auth/secrets.yaml";
    };

    services.keycloak = {
      enable = true;

      database = {
        type = "postgresql";
        createLocally = true;
        username = "admin";
        passwordFile = config.sops.secrets.keycloak_db.path;
      };
      settings = {
        hostname = "auth.joka00.dev";
        http-relative-path = "/";
        http-host = "127.0.0.1";
        http-port = 3880;
        https-port = 38443;
        proxy = "edge";
        http-enabled = true;
        initialAdminPassword = "SaNt5x5FY98="; # change on first login
        sslCertificate = "/var/lib/acme/auth.joka00.dev/cert.pem";
        sslCertificateKey = "/var/lib/acme/auth.joka00.dev/key.pem";
      };
    };
  };
}
