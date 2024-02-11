{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.music;
in {
  options.device.programs.music.youtube-music = {
    enable = lib.mkEnableOption "Enable youtube-music";
  };

  config = lib.mkIf cfg.youtube-music.enable {
    home.packages = [pkgs.youtube-music];
  };
}
