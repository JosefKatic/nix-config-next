{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types mkIf mkEnableOption;
  cfg = config.device.server.homelab;

  scripts = import ./scripts.nix;
  # homeassistantPackages = import ./pkgs {inherit pkgs;};
in {
  options.device.server.homelab = {
    homeassistant = {
      enable = mkEnableOption "Home Assistant";
    };
  };

  config = mkIf cfg.homeassistant.enable {
    services = {
      nginx.virtualHosts."hass.joka00.dev" = {
        forceSSL = true;
        useACMEHost = "joka00.dev";
        locations."/".extraConfig = ''
          proxy_pass http://localhost:${toString config.services.home-assistant.config.http.server_port};
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        '';
      };

      home-assistant = {
        enable = cfg.homeassistant.enable;
        extraComponents = [
          # Components required to complete the onboarding
          "cloud"
          "broadlink"
          "default_config"
          "esphome"
          "met"
          "homekit"
          "homekit_controller"
          "radio_browser"
          "mqtt"
          "mobile_app"
          "network"
          "tailscale"
          "tuya"
          "samsungtv"
          "system_health"
          "system_log"
          "update"
          "websocket_api"
          "upnp"
          "zeroconf"
          "zha"
        ];
        customComponents = [
          pkgs.home-assistant-custom-components.adaptive_lighting
          pkgs.home-assistant-custom-components.localtuya
        ];
        config = {
          config = {};
          mobile_app = {};
          cloud = {};
          network = {};
          zeroconf = {};
          system_health = {};
          default_config = {};
          system_log = {};
          # Includes dependencies for a basic setup
          # https://www.home-assistant.io/integrations/default_config/
          script = import ./script.nix;
          "automation lights" = import ./automations/automation-lights.nix;
          "automation gate" = import ./automations/automation-gate.nix;
          "automation utils" = import ./automations/automation-utils.nix;
          "automation ui" = "!include automations.yaml";
        };
      };
    };
    networking.firewall.allowedTCPPorts = [21064];
    networking.firewall.allowedUDPPorts = [21064];

    systemd.tmpfiles.rules = [
      "f ${config.services.home-assistant.configDir}/automations.yaml 0755 hass hass"
    ];

    environment.persistence = mkIf config.device.core.storage.enablePersistence {
      "/persist" = {
        directories = ["/var/lib/hass"];
      };
    };
  };
}
