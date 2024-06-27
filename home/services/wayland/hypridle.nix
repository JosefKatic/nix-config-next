{
  pkgs,
  lib,
  config,
  ...
}: let
  hyprlock = "${config.programs.hyprlock.package}/bin/hyprlock";
  pgrep = "${pkgs.procps}/bin/pgrep";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
  swaymsg = "${config.wayland.windowManager.sway.package}/bin/swaymsg";
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running -q
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
  isLocked = "${pgrep} -x ${hyprlock}";
  lockTime = 10 * 60;
  afterLockTimeout = {
    timeout,
    on-timeout,
    on-resume ? null,
  }: [
    {
      timeout = lockTime + timeout;
      inherit on-timeout on-resume;
    }
    {
      on-timeout = "${isLocked} && ${on-timeout}";
      inherit on-resume timeout;
    }
  ];
in {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = lib.getExe config.programs.hyprlock.package;
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
      };
      listener =
        [
          {
            timeout = lockTime;
            on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
            on-resume = "";
          }
        ]
        ++
        # Mute mic
        (afterLockTimeout {
          timeout = 10;
          on-timeout = "${pactl} set-source-mute @DEFAULT_SOURCE@ yes";
          on-resume = "${pactl} set-source-mute @DEFAULT_SOURCE@ no";
        })
        ++
        # Suspend
        (afterLockTimeout {
          timeout = 60;
          on-timeout = suspendScript.outPath;
          on-resume = "";
        })
        ++
        # Turn off displays (hyprland)
        (lib.optionals config.wayland.windowManager.hyprland.enable (afterLockTimeout {
          timeout = 40;
          on-timeout = "${hyprctl} dispatch dpms off";
          on-resume = "${hyprctl} dispatch dpms on";
        }))
        ++
        # Turn off displays (sway)
        (lib.optionals config.wayland.windowManager.sway.enable (afterLockTimeout {
          timeout = 40;
          on-timeout = "${swaymsg} 'output * dpms off'";
          on-resume = "${swaymsg} 'output * dpms on'";
        }));
    };
  };
}
