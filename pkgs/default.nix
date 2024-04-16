{default, ...}: {
  systems = ["x86_64-linux" "aarch64-linux"];

  perSystem = {
    pkgs,
    inputs',
    lib,
    ...
  }: {
    packages = {
      _389-ds-base = pkgs.callPackage ./_389-ds-base {};
      deploySystem = pkgs.callPackage ./deploySystem {};
      prefetchConfig = pkgs.callPackage ./prefetch-config {};
      nordvpn = pkgs.callPackage ./nordvpn {};
      wl-ocr = pkgs.callPackage ./wl-ocr {};
    };
  };
}
