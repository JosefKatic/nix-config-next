{
  coreutils,
  gnused,
  lib,
  writeShellScriptBin,
  nix,
  curl,
  jq,
}:
writeShellScriptBin "prefetch-config" ''
  mkdir -p /tmp/deploy/.config/nixos
  ${lib.getExe curl} -o /tmp/deploy/.config/nixos/response.json -s http://localhost:3000/api/nix/devices
  ${nix}/bin/nix-instantiate --eval -E "builtins.fromJSON (builtins.readFile /tmp/deploy/.config/nixos/response.json)" > /tmp/deploy/.config/nixos/default.nix
  for deviceName in $(${lib.getExe jq} -r '.[]' /tmp/deploy/.config/nixos/response.json); do
    mkdir -p /tmp/deploy/.config/nixos/$deviceName
    ${lib.getExe curl} -o /tmp/deploy/.config/nixos/$deviceName/response.json -s "http://localhost:3000/api/nix/$deviceName"
    ${nix}/bin/nix-instantiate --eval -E 'builtins.fromJSON (builtins.readFile /tmp/deploy/.config/nixos/'$deviceName'/response.json)' > /tmp/deploy/.config/nixos/$deviceName/default.nix
  done
''
