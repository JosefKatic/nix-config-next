{
  config,
  lib,
  hostName,
  ...
}: {
  options = {
    enable = lib.mkEnableOption "Description xD";
    binding = {
      terminal = lib.mkOption {
        type = lib.types.str;
        default = "q";
      };
      browser = lib.mkOption {
        type = lib.types.str;
        default = "b";
      };
      editor = lib.mkOption {
        type = lib.types.str;
        default = "e";
      };
      launcher = lib.mkOption {
        type = lib.types.str;
        default = "a";
      };
    };
  };

  config = {
    wayland.windowManager.hyprland.settings = {
      binds = let
        cfg = config.users.devices.${hostName}.windowManager.hyprland.settings.binding;
      in [
        "SUPER,${cfg.terminal},exec, run-as-service ${config.home.sessionVariables.TERMINAl}"
        "SUPER,${cfg.browser},exec ${config.home.sessionVariables.TERMINAl}"
      ];
    };
  };
}
