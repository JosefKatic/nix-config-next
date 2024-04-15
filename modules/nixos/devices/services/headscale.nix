{
  self,
  config,
  lib,
  ...
}: let
  cfg = config.device.server.services.headscale;
in {
  options.services.headscale = {
    settings.oidc.allowed_groups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = lib.mdDoc ''
        Groups allowed to authenticate even if not in allowedDomains.
      '';
      example = ["headscale"];
    };
  };
  options.device.server.services = {
    headscale = {
      enable = lib.mkEnableOption "Enable headscale server";
      domain = lib.mkOption {
        type = lib.types.str;
        default = "vpn.joka00.dev";
        description = "The domain name for the headscale server";
      };
      port = lib.mkOption {
        type = lib.types.int;
        default = 8080;
        description = "The port of the headscale server";
      };
    };
  };

  config = lib.mkIf (cfg.enable) {
    services = {
      headscale = {
        enable = true;
        address = "0.0.0.0";
        port = cfg.port;
        settings = {
          dns_config = {base_domain = "joka00.dev";};
          server_url = "https://${cfg.domain}";
          logtail.enabled = false;
          oidc = {
            client_id = "headscale-vpn";
            client_secret_path = config.sops.secrets.headscale_secret.path;
            issuer = "https://auth.joka00.dev/realms/92a4012f-3d57-4fb0-9d39-16d28ec44d01";
            scope = ["openid" "profile" "email"];
            # allowed_groups = ["headscale"];
          };
        };
      };

      nginx.virtualHosts.${cfg.domain} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.headscale.port}";
          proxyWebsockets = true;
        };
      };
    };

    sops.secrets.headscale_secret = {
      sopsFile = "${self}/secrets/services/headscale/secrets.yaml";
      owner = "headscale";
      group = "headscale";
    };
    environment.systemPackages = [config.services.headscale.package];
    environment.persistence = lib.mkIf config.device.core.storage.enablePersistence {
      "/persist" = {
        directories = [
          "/var/lib/headscale"
        ];
      };
    };
  };
}
