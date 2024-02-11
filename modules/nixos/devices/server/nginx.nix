{
  lib,
  config,
  ...
}: let
  inherit (config.networking) hostName;
  cfg = config.device;
in {
  # options = {
  # server.nginx = lib.mkEnableOption "Description xD";
  # };
  # config = {
  services = {
    nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      clientMaxBodySize = "300m";

      virtualHosts."${hostName}.joka00.dev" = {
        default = true;
        forceSSL = true;
        enableACME = true;
        locations."/metrics" = {
          proxyPass = "http://localhost:${
            toString config.services.prometheus.exporters.nginxlog.port
          }";
        };
      };
    };

    prometheus.exporters.nginxlog = {
      enable = true;
      group = "nginx";
      settings.namespaces = [
        {
          name = "filelogger";
          source.files = ["/var/log/nginx/access.log"];
          format = ''
            $remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent"'';
        }
      ];
    };

    uwsgi = {
      enable = true;
      user = "nginx";
      group = "nginx";
      plugins = ["cgi"];
      instance = {
        type = "emperor";
        vassals = lib.mkBefore {};
      };
    };
  };
  networking.firewall.allowedTCPPorts = [80 443];
  # So we don't have to do this later...
  security.acme = {
    acceptTerms = true;
    defaults.email = "josef@joka00.dev";
  };
  environment.persistence = {
    "/persist" = {directories = ["/var/lib/acme"];};
  };
  # };
}
