{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.theme.colorscheme;
  inherit (lib) types mkOption;

  hexColorPattern = "#([0-9a-fA-F]{3}){1,2}";
  isHexColor = c: lib.isString c && ((builtins.match hexColorPattern c) != null);
  hexColor = types.strMatching hexColorPattern;

  cfgFormat = pkgs.formats.toml {};
  generate = {
    source,
    type ? "tonal-spot",
  }:
    lib.importJSON (pkgs.runCommand "generate-theme" {} ''
      ${inputs.matugen.packages.${pkgs.system}.default}/bin/matugen ${
        if (isHexColor source)
        then "color hex"
        else "image"
      } --config ${
        cfgFormat.generate "config.toml" {
          templates = {};
          config = {
            custom_colors = {
              light-red = "#d03e3e";
              light-orange = "#d7691d";
              light-yellow = "#ad8200";
              light-green = "#31861f";
              light-cyan = "#00998f";
              light-blue = "#3173c5";
              light-magenta = "#9e57c2";
              dark-red = "#e15d67";
              dark-orange = "#fc804e";
              dark-yellow = "#e1b31a";
              dark-green = "#5db129";
              dark-cyan = "#21c992";
              dark-blue = "#00a3f2";
              dark-magenta = "#b46ee0";
            };
          };
        }
      } -j hex -t "scheme-${type}" "${source}" > $out
    '');

  generated = generate {inherit (cfg) source type;};
in {
  options.theme = {
    wallpaper = lib.mkOption {
      description = ''
        Location of the wallpaper to use throughout the system.
      '';
      type = lib.types.path;
      example = lib.literalExample "./wallpaper.png";
    };
    colorscheme = {
      source = mkOption {
        type = types.either types.path hexColor;
        # TODO: generate default from hostname
        # colorFromString = c: builtins.substring 0 6 (builtins.hashString "md5" c);
        default =
          if config.wallpaper != null
          then config.wallpaper
          else "#2B3975";
      };
      mode = mkOption {
        type = types.enum ["dark" "light"];
        default = "dark";
      };
      type = mkOption {
        type = types.enum [
          "content"
          "expressive"
          "fidelity"
        
          "fruit-salad"
          "monochrome"
          "neutral"
          "rainbow"
          "tonal-spot"
        ];
        default = "tonal-spot";
      };
      colors = mkOption {
        readOnly = true;
        type = types.attrsOf hexColor;
        default = generated.colors.${cfg.mode};
      };
    };
  };
}
