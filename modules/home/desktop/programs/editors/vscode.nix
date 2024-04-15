
{ config, lib, pkgs, ... }:
let
  cfg = config.user.programs.editors.vscode;
in {
  options = {
    user.programs.editors = {
      vscode =  {
        enable = lib.mkEnableOption "Enable VSCode";
        package = lib.mkOption = {
          type = lib.types.package;
          default = pkgs.vscode;
          description = "Package "
        };
      };
    };
  };

  config = lib.mkIf cfg.enable  {
    programs.vscode = {
      enable = cfg.enable;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = true;
      mutableExtensionsDir = true;
    };
  };
}