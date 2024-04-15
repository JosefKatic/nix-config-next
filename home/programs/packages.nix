{pkgs, ...}: {
  home.packages = with pkgs; [
    # messaging
    tdesktop

    # misc
    libnotify
    xdg-utils

    # productivity
    obsidian
    xournalpp
    jetbrains-toolbox
    teamspeak_client
    discord
    trezor-suite
  ];

  programs.vscode.enable = true;
}
