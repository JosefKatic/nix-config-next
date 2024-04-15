{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.user.services.media.playerctl;
in {
  options.user.services.media = {
    playerctl = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.playerctld.enable = true;
  };
}
