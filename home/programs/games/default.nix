{
  pkgs,
  inputs,
  ...
}:
# games
{
  home.packages = with pkgs; [
    gamescope
    prismlauncher
    (lutris.override
      {
        extraPkgs = p: [
          p.wineWowPackages.staging
          p.pixman
          p.libjpeg
          p.gnome.zenity
        ];
      })
    winetricks
  ];

  home.persistence = {
    "/persist/home/joka" = {
      allowOther = true;
      directories = [
        {
          # Use symlink, as games may be IO-heavy
          directory = "Games";
          method = "symlink";
        }
      ];
    };
  };
}
