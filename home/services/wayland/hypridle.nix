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
    onTimeout,
    onResume ? null,
  }: [
    {
      timeout = lockTime + timeout;
      inherit onTimeout onResume;
    }
    {
      onTimeout = "${isLocked} && ${onTimeout}";
      inherit onResume timeout;
    }
  ];
in {
  services.hypridle = {
    enable = true;
    beforeSleepCmd = "${pkgs.systemd}/bin/loginctl lock-session";
    lockCmd = lib.getExe config.programs.hyprlock.package;
    listeners =
      [
        {
          timeout = lockTime;
          onTimeout = "${pkgs.systemd}/bin/loginctl lock-session";
          onResume = "";
        }
      ]
      ++
      # Mute mic
      (afterLockTimeout {
        timeout = 10;
        onTimeout = "${pactl} set-source-mute @DEFAULT_SOURCE@ yes";
        onResume = "${pactl} set-source-mute @DEFAULT_SOURCE@ no";
      })
      ++
      # Suspend
      (afterLockTimeout {
        timeout = 60;
        onTimeout = suspendScript.outPath;
        onResume = "";
      })
      ++
      # Turn off displays (hyprland)
      (lib.optionals config.wayland.windowManager.hyprland.enable (afterLockTimeout {
        timeout = 40;
        onTimeout = "${hyprctl} dispatch dpms off";
        onResume = "${hyprctl} dispatch dpms on";
      }))
      ++
      # Turn off displays (sway)
      (lib.optionals config.wayland.windowManager.sway.enable (afterLockTimeout {
        timeout = 40;
        onTimeout = "${swaymsg} 'output * dpms off'";
        onResume = "${swaymsg} 'output * dpms on'";
      }));
  };
}
