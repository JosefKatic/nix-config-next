{
  systems = ["x86_64-linux"];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        nix
        home-manager
        git
        alejandra
        nodePackages.prettier
        sops
        ssh-to-age
        gnupg
        age
      ];
      name = "config";
      DIRENV_LOG_FORMAT = "";
      # shellHook = ''
      # ${config.pre-commit.installationScript}
      # '';
    };
    formatter = pkgs.alejandra;
  };
}
