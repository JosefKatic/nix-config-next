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
      home = "/var/deploy";
      createHome = true;
      extraGroups = ["deploy"];
      shell = pkgs.bash;
      group = "deploy";
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
      self.packages.${pkgs.system}.deploy
      self.packages.${pkgs.system}.prefetchConfig
    ];
  };
}
