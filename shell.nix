{
  systems = ["x86_64-linux"];

  perSystem = {
    config,
    pkgs,
    inputs',
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
        config.packages.repl
      ];
      name = "config";
      DIRENV_LOG_FORMAT = "";
      shellHook = ''
        ${config.pre-commit.installationScript}
      '';
    };
  };
}
