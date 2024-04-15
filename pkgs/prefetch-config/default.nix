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
  if [ -z "$DEPLOY_FLAKE" ]
  then
    echo "\$DEPLOY_FLAKE is empty"
    exit 1
  fi
    mkdir -p $DEPLOY_FLAKE/.config/nixos
    ${lib.getExe curl} -o $DEPLOY_FLAKE/.config/nixos/response.json -s http://localhost:3000/api/nix/devices
    ${nix}/bin/nix-instantiate --eval -E "builtins.fromJSON (builtins.readFile $DEPLOY_FLAKE/.config/nixos/response.json)" > $DEPLOY_FLAKE/.config/nixos/default.nix
    for deviceName in $(${lib.getExe jq} -r '.[]' $DEPLOY_FLAKE/.config/nixos/response.json); do
      mkdir -p $DEPLOY_FLAKE/.config/nixos/$deviceName
      ${lib.getExe curl} -o $DEPLOY_FLAKE/.config/nixos/$deviceName/response.json -s "http://localhost:3000/api/nix/$deviceName"
      ${nix}/bin/nix-instantiate --eval -E 'builtins.fromJSON (builtins.readFile '$DEPLOY_FLAKE'/.config/nixos/'$deviceName'/response.json)' > $DEPLOY_FLAKE/.config/nixos/$deviceName/default.nix
    done
''
