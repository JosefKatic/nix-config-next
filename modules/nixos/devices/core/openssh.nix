{
  self,
  lib,
  config,
  device,
  ...
}: let
  inherit (config.networking) hostName;
  hosts = self.nixosConfigurations;
  pubKey = host: "${self}/hosts/${host}/ssh_host_ed25519_key.pub";
  # gitHost = hosts."falco".config.networking.hostName;

  # Sops needs acess to the keys before the persist dirs are even mounted; so
  # just persisting the keys won't work, we must point at /persist
  hasOptinPersistence = config.environment.persistence ? "/persist";
in {
  services.openssh = {
    enable = true;
    settings = {
      # Harden
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
      # Allow forwarding ports to everywhere
      GatewayPorts = "clientspecified";
    };

    hostKeys = [
      {
        path = "${lib.optionalString hasOptinPersistence "/persist"}/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  programs.ssh = {
    # Each hosts public key
    knownHosts =
      builtins.mapAttrs
      (name: _: {
        publicKeyFile = pubKey name;
        extraHostNames =
          lib.optional (name == hostName) "localhost"; # ++ # Alias for localhost if it's the same host
        # (lib.optionals (name == gitHost) [ "joka00.dev" "git.joka00.dev" ]); # Alias for joka00.dev and git.joka00.dev if it's the git host
      })
      hosts;
  };

  # Passwordless sudo when SSH'ing with keys
  security.pam.sshAgentAuth.enable = true;
}
