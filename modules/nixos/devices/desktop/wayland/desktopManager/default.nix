{
  config,
  lib,
  pkgs,
  wallpapers,
  ...
}: let
  cfg = config.device.desktop.wayland.desktopManager;
  logoFile = pkgs.fetchurl {
    url = "https://joka00.dev/assets/logo_white.png";
    sha256 = "0nj3igrr5p4m1h32i7aa9mlacam6mjljrc34cs6nj11ig3hz6s36";
    downloadToTemp = true;
  };
in {
  options.device.desktop.wayland.desktopManager = {
    gnome = {enable = lib.mkEnableOption "Enable Gnome";};
    plasma6 = {enable = lib.mkEnableOption "Enable Plasma6";};
  };

  config = {
    # programs.dconf.profiles.gdm.databases = [
    # {
    # settings = {
    # "org/gnome/login-screen" = {
    # logo = "file://${logoFile}";
    # };
    # };
    # }
    # ];
    services.xserver.desktopManager.gnome.enable = cfg.gnome.enable;
    # Taken from https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
    # Most of the excluded packages are replaced by alternatives in home config
    environment.gnome.excludePackages =
      (with pkgs; [
        gnome-photos
        gnome-tour
        gedit
      ])
      ++ (with pkgs.gnome; [
        cheese # webcam tool
        gnome-music
        epiphany # web browser
        geary # email reader
        gnome-characters
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        yelp # Help view
        gnome-contacts
        gnome-initial-setup
      ]);
    environment.systemPackages = with pkgs;
      lib.optionals (cfg.gnome.enable) [
        gnome.gnome-tweaks
      ];

    services.desktopManager.plasma6.enable = cfg.plasma6.enable;
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      oxygen
    ];
  };
}
