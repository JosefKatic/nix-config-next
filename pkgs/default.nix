{default, ...}: {
  systems = ["x86_64-linux" "aarch64-linux"];

  perSystem = {
    pkgs,
    inputs',
    lib,
    ...
  }: {
    packages = {
      # instant repl with automatic flake loading
      repl = pkgs.callPackage ./repl {};

      catppuccin-plymouth = pkgs.callPackage ./catppuccin-plymouth {};

      overskride = pkgs.callPackage ./overskride {};

      wl-ocr = pkgs.callPackage ./wl-ocr {};
    };
  };
}
