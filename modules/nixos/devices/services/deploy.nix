{
  config,
  lib,
  pkgs,
  options,
  self,
  ...
}: {
  options.device.server.services.deploy = {
    enable = lib.mkEnableOption "Enable deploy command and add users";
  };

  config = lib.mkIf config.device.server.services.deploy.enable {
    users.users.deploy = {
      isSystemUser = true;
      useDefaultShell = true;
      group = "deploy";
      home = "/tmp/deploy";
      createHome = true;
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH1X3Jl+Vrt02GIhzgxokACfRueZXthgo5hlUCTmrWsY deploy"];
    };
    users.groups.deploy = {};
    environment.persistence = lib.mkIf config.device.core.storage.enablePersistence {
      "/persist" = {
        directories = [
          "/var/deploy"
        ];
      };
    };

    environment.sessionVariables = {
      "DEPLOY_FLAKE" = "/var/deploy/.nix-config-next";
    };

    environment.systemPackages = [
      self.packages.${pkgs.system}.deploySystem
      self.packages.${pkgs.system}.prefetchConfig
    ];
  };
}
