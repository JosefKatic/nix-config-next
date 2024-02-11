{inputs, ...}: {
  imports = [inputs.pre-commit-hooks.flakeModule];

  perSystem.pre-commit = {
    settings.excludes = ["flake.lock" "modules/nixos/devices/core/blocker/etc-hosts.nix"];

    settings.hooks = {
      alejandra.enable = true;
      denofmt.enable = true;
      denolint.enable = true;
      prettier = {
        enable = true;
        excludes = [".js" ".md" ".ts"];
      };
    };
  };
}