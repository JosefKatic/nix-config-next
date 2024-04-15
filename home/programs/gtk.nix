{
  pkgs,
  config,
  ...
}: let
  variant = config.theme.name;
in {
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;

    font = {
      name = "Fira Sans";
      package = pkgs.fira;
      size = 12;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };

    theme = {
      name =
        if variant == "light"
        then "adw-gtk3"
        else "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };
}
