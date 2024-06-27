{pkgs, ...}: {
  home.packages = with pkgs; [
    android-studio
    # misc
    libnotify
    xdg-utils

    # productivity
    # obsidian
    xournalpp
    jetbrains-toolbox
    teamspeak_client
    discord
    trezor-suite

    arduino-ide
  ];

  programs.vscode.enable = true;
}
