{pkgs, ...}: {
  imports = [
    ./anyrun
    ./browsers/chromium.nix
    ./browsers/firefox.nix
    ./media
    ./gtk.nix
    ./packages.nix
    ./office
  ];
  programs.vscode.enable = true;
}
