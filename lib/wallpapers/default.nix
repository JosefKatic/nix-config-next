lib:
lib.listToAttrs (map
  (wallpaper: {
    inherit (wallpaper) name;
    value = builtins.fetchurl {
      inherit (wallpaper) sha256;
      url = "https://i.imgur.com/${wallpaper.id}.${wallpaper.ext}";
      name = "${wallpaper.id}-${wallpaper.sha256}.${wallpaper.ext}";
    };
  })
  (lib.importJSON ./list.json))
