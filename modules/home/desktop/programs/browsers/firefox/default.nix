{
  config,
  lib,
  inputs,
  options,
  pkgs,
  ...
}: let
  cfg = config.desktop.browsers;

  stigConfig = import ./stig.nix;
in {
  options.desktop.browsers.firefox = {
    enable = lib.mkEnableOption "Enable Firefox Browser";
    extraPolicies = lib.mkOption {
      type = options.programs.firefox.extraPolicies.type;
      default = {};
    };
    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = with inputs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        privacy-badger
        clearurls
        decentraleyes
        languagetool
      ];
    };
    defaultProfile = lib.mkOption {
      type = lib.types.str;
      default = "alpha";
      example = "default";
    };
    settings = lib.mkOption {
      type = options.programs.firefox.profiles.settings.type;
      default = ''
        "general.smoothScroll" = true;
        "dom.security.https_only_mode" = true;
        "identity.fxaccounts.enabled" = false;
        "privacy.trackingprotection.enabled" = true;
      '';
    };
    search = lib.mkOption {
      type = options.programs.firefox.profiles.search.type;
      default = {
        force = true;
        default = "DuckDuckGo";
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };
          "NixOS Wiki" = {
            urls = [
              {
                template = "https://nixos.wiki/index.php?search={searchTerms}";
              }
            ];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = ["@nw"];
          };
          "Wikipedia (en)".metaData.alias = "@wiki";
          "Google".metaData.alias = "@g";
          "Amazon.com".metaData.hidden = true;
          "Bing".metaData.hidden = true;
          "eBay".metaData.hidden = true;
        };
      };
    };
    profiles = lib.mkOption {
      type = options.programs.firefox.profiles.type;
      default = {};
    };
  };

  config = lib.mkIf cfg.firefox.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies =
          {
            CaptivePortal = true;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableTelemetry = true;
            DisableFirefoxAccounts = false;
            NoDefaultBookmarks = true;
            OfferToSaveLogins = false;
            OfferToSaveLoginsDefault = false;
            PasswordManagerEnabled = false;
            FirefoxHome = {
              Search = true;
              Pocket = false;
              Snippets = false;
              TopSites = false;
              Highlights = false;
            };
            UserMessaging = {
              ExtensionRecommendations = false;
              SkipOnboarding = true;
            };
          }
          // cfg.firefox.extraPolicies;
        profiles =
          {
            "default" = {
              extensions = cfg.firefox.extensions;
              search = cfg.firefox.search;
              settings = cfg.firefox.settings;
              extraSettings = stigConfig;
            };
            "alpha" = {
              extensions = cfg.firefox.extensions;
              search = cfg.firefox.search;
              settings = cfg.firefox.settings;
              extraSettings = stigConfig;
              userContent = import ./alpha/userContent.nix;
              userChrome = import ./alpha/userChrome.nix;
            };
            "cascade" = {
              extensions = cfg.firefox.extensions;
              search = cfg.firefox.search;
              settings = cfg.firefox.settings;
              extraSettings = stigConfig;
              userContent = import ./cascade/userContent.nix;
              userChrome = import ./cascade/userChrome.nix;
            };
            "minimal" = {
              extensions = cfg.firefox.extensions;
              search = cfg.firefox.search;
              settings = cfg.firefox.settings;
              extraSettings = stigConfig;
              userContent = import ./minimal/userContent.nix;
              userChrome = import ./minimal/userChrome.nix;
            };
          }
          // cfg.firefox.profiles
          // {
            profiles.${cfg.firefox.defaultProfile}.isDefault = true;
          };
      };
    };
  };
}
