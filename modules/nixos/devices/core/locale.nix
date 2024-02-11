{
  lib,
  options,
  config,
  ...
}: let
  cfg = config.device.core;
in {
  options.device.core.locale = {
    defaultLocale = lib.mkOption {
      type = options.i18n.defaultLocale.type;
      default = "en_US.UTF-8";
    };
    supportedLocales = lib.mkOption {
      type = options.i18n.supportedLocales.type;
      default = ["en_US.UTF-8/UTF-8" "cs_CZ.UTF-8/UTF-8"];
    };
    timeZone = lib.mkOption {
      type = options.time.timeZone.type;
      default = "Europe/Prague";
    };
  };
  config = {
    i18n = {
      defaultLocale = cfg.locale.defaultLocale;
      supportedLocales = cfg.locale.supportedLocales;
    };
    time.timeZone = cfg.locale.timeZone;
  };
}
