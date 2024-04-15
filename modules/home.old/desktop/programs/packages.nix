{pkgs, ...}: {
  home.packages = with pkgs; [
    # misc
    libnotify
    xdg-utils

    # productivity
    obsidian
    # xournalpp
  ];
}
