{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.device.core;
in {
  options.device.core = {
    network = {
      domain = lib.mkOption {
        type = lib.types.str;
        default = "clients.joka00.dev";
        description = "The domain name for the network";
      };
      services = {
        enableNetworkManager = lib.mkEnableOption "Enable NetworkManager, keep disabled on servers";
        enableAvahi = lib.mkEnableOption "Enable Avahi, keep disabled on servers";
        enableResolved = lib.mkEnableOption "Enable resolved, keep disabled on servers";
      };
    };
  };

  config = {
    security.ipa = {
      enable = true;
      server = "ipa01.de.auth.joka00.dev";
      offlinePasswords = true;
      cacheCredentials = true;
      realm = "AUTH.JOKA00.DEV";
      domain = config.networking.domain;
      basedn = "dc=auth,dc=joka00,dc=dev";
      certificate = pkgs.fetchurl {
        url = http://ipa01.de.auth.joka00.dev/ipa/config/ca.crt;
        sha256 = "0ja5pb14cddh1cpzxz8z3yklhk1lp4r2byl3g4a7z0zmxr95xfhz";
      };
    };
    # To enable homedir on first login, with login, sshd, and sssd
    security.pam.services.sss.makeHomeDir = true;
    security.pam.services.sshd.makeHomeDir = true;
    security.pam.services.login.makeHomeDir = true;

    networking = {
      domain = cfg.network.domain;
      # implement using DNS
      extraHosts = lib.mkIf (config.device.server.auth.freeipa.enable == false) ''
        100.84.29.49 ipa01.de.auth.joka00.dev
      '';
      # extraHosts = import ./blocker/etc-hosts.nix;
      firewall = {
        enable = true;
        trustedInterfaces = ["tailscale0"];
        checkReversePath = "loose";
        allowedUDPPorts = [
          config.services.tailscale.port
        ];
      };
      networkmanager = {
        enable = cfg.network.services.enableNetworkManager;
        dns = "systemd-resolved";
      };
    };
    services = {
      tailscale = {
        enable = true;
        useRoutingFeatures = lib.mkDefault "client";
      };
      avahi = {
        enable = cfg.network.services.enableAvahi;
        nssmdns4 = true;
      };

      openssh = {
        enable = true;
        settings.UseDns = true;
      };

      # DNS resolver
      resolved.enable = cfg.network.services.enableResolved;
      # Just to be sure it won't fail
      resolved.fallbackDns = ["1.1.1.1"];
    };
    environment.persistence = lib.mkIf config.device.core.storage.enablePersistence {
      "/persist" = {
        directories = [
          "/var/lib/tailscale"
          # Caching wouldn't work
          "/var/lib/sssd"
          "/var/lib/sss"
        ];
        files = ["/etc/krb5.keytab"];
      };
    };
  };
}
