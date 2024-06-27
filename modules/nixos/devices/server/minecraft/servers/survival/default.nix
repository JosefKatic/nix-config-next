{
  self,
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.device.server.minecraft.enable {
    services.minecraft-servers.servers.survival = {
      enable = true;
      enableReload = true;
      package = pkgs.inputs.nix-minecraft.paperServers.paper-1_21;
      jvmOpts = ((import ../../flags.nix) "6G") + "-Dpaper.disableChannelLimit=true";
      whitelist = import ../../whitelist.nix;
      serverProperties = {
        server-port = 25571;
        online-mode = false;
        enable-rcon = true;
        white-list = true;
        gamemode = 0;
        difficulty = 2;
        max-players = 5;
        view-distance = 16;
        simulation-distance = 16;
        force-gamemode = true;
        "rcon.password" = "@RCON_PASSWORD@";
        "rcon.port" = 24471;
      };
      files = {
        "config/paper-global.yml".value = {
          proxies.velocity = {
            enabled = true;
            online-mode = false;
            secret = "@VELOCITY_FORWARDING_SECRET@";
          };
        };
        "bukkit.yml".value = {
          settings.shutdown-message = "Servidor fechado (provavelmente reiniciando).";
        };
        "spigot.yml".value = {
          messages = {
            whitelist = "You have to be on whitelist!";
            unknown-command = "Unknown command.";
            restart = "Server is restarting!";
          };
        };
      };
      symlinks = {
        "plugins/Dynmap.jar" = pkgs.fetchurl rec {
          pname = "Dynmap";
          version = "3.7-beta-6-spigot";
          url = "https://cdn.modrinth.com/data/fRQREgAc/versions/QtTWJjW6/${pname}-${version}.jar";
          hash = "sha256-c1gWhb/JBZ8aD5fWE7vqVOhqGwlPAi08aZ82SIRSU94=";
        };
        "datapacks/ServerSleep.zip" = pkgs.fetchurl rec {
          pname = "ServerSleep";
          url = "https://cdn.modrinth.com/data/Cw8IlnGM/versions/smQOT3XO/${pname}.zip";
          hash = "sha256-h2s7ODR+unGVp6LOZ60ga5OPo/t3SUKTlq/NmmXdq9E=";
        };
        "plugins/HidePLayerJoinQuit.jar" = pkgs.fetchurl rec {
          pname = "HidePLayerJoinQuit";
          version = "1.0";
          url = "https://github.com/OskarZyg/${pname}/releases/download/v${version}-full-version/${pname}-${version}-Final.jar";
          hash = "sha256-UjLlZb+lF0Mh3SaijNdwPM7ZdU37CHPBlERLR3LoxSU=";
        };
      };
    };

    services.nginx.virtualHosts."survival.joka00.dev" = {
      listenAddresses = ["193.41.237.192"];
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:8123";
      };
    };
  };
}
