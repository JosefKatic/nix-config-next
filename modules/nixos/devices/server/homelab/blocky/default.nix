{
  config,
  lib,
  ...
}: let
  inherit (lib) types mkIf mkEnableOption;
  cfg = config.device.server.homelab;
in {
  options.device.server.homelab = {
    blocky = {
      enable = mkEnableOption "Blocky DNS";
    };
  };

  config = mkIf cfg.blocky.enable {
    # security.acme.certs."p.joka00.dev" = {
    #   webroot = "/var/lib/acme/.challenges";
    #   dnsProvider = "...";
    #   email = "josef+acme@joka00.dev";
    #   group = "nginx";
    #   extraDomainNames = ["*.p.joka00.dev"];
    # };

    services.blocky = {
      enable = false;
      settings = {
        ports = {
          dns = 53;
          tls = 853;
          http = 4000;
          https = 4443;
        }; # Port for incoming DNS Queries.
        upstreams = {
          groups = {
            "default" = [
              # Using Cloudflare's DNS over HTTPS server for resolving queries.
              "https://one.one.one.one/dns-query"
            ];
          };
        };
        blocking = {
          blockType = "zeroIP";
          refreshPeriod = "4h";
          downloadTimeout = "4m";
          downloadCooldown = "10s";
          denylists = {
            malware = [
              "https://urlhaus.abuse.ch/downloads/hostfile/"
            ];
            ads = [
              "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
              "https://someonewhocares.org/hosts/zero/hosts"
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
              "https://raw.githubusercontent.com/notracking/hosts-blocklists/master/hostnames.txt"
              "https://adaway.org/hosts.txt"
              "https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts"
              "https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/hosts"
            ];
          };
          clientGroupsBlock = {
            default = [
              "ads"
              "malware"
            ];
          };
        };
        customDNS = {
          customTTL = "1h";
          filterUnmappedTypes = true;
          mapping = {
            "hass.joka00.dev" = "100.89.173.85";
          };
        };
        bootstrapDns = [
          {
            upstream = "https://one.one.one.one/dns-query";
            ips = ["1.1.1.1" "1.0.0.1"];
          }
        ];
      };
    };

    networking.firewall.allowedTCPPorts = [53 4000 443];
    networking.firewall.allowedUDPPorts = [53];

    environment.persistence = mkIf config.device.core.storage.enablePersistence {
      "/persist" = {
        directories = ["/var/lib/blocky"];
      };
    };
  };
}
