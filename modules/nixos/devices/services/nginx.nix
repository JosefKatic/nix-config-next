{
  lib,
  config,
  ...
}: let
  inherit (config.networking) hostName;
  cfg = config.device;
in {
  options.device.server.services.nginx.enable = lib.mkEnableOption "Enable nginx with metrics";
  config = lib.mkIf cfg.server.services.nginx.enable {
    services = {
      nginx = {
        enable = true;
        recommendedTlsSettings = true;
        recommendedProxySettings = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        clientMaxBodySize = "300m";
        defaultListenAddresses = ["193.41.237.192"];

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
  };
}
