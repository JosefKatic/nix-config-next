{
  config,
  lib,
  ...
}: {
  networking = {
    extraHosts = import ./blocker/etc-hosts.nix;
    firewall = {
      trustedInterfaces = ["tailscale0"];
      # required to connect to Tailscale exit nodes and any other VPN
      checkReversePath = "loose";

      allowedUDPPorts = [
        # allow the Tailscale UDP port through the firewall
        config.services.tailscale.port
        5353
        # syncthing QUIC
        22000
        # syncthing discovery broadcast on ipv4 and multicast ipv6
        21027
      ];

      allowedTCPPorts = [
        42355
        # syncthing
        22000
      ];
    };
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
  };
  services = {
    tailscale = {
      enable = true;
      useRoutingFeatures = lib.mkDefault "client";
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        domain = true;
        userServices = true;
      };
    };

    openssh = {
      enable = true;
      settings.UseDns = true;
    };

    # DNS resolver
    resolved.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  environment.persistence = {
    "/persist".directories = ["/var/lib/tailscale"];
  };
}
