{
  writeShellScriptBin,
  lib,
  curl,
  jq,
}: let
  _ = lib.getExe;
in
  writeShellScriptBin "request-devices" ''
    ${_ curl} http://localhost:3000/api/nix/hirundo | ${_ jq} . > $out/response.json'
  ''
