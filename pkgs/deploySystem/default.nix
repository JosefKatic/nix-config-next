# modified from https://github.com/gytis-ivaskevicius/flake-utils/plus
{
  coreutils,
  gnused,
  writeShellScriptBin,
  deploy-rs,
  lib,
  git,
  direnv,
}:
writeShellScriptBin "deploySystem" ''
  host="$1"
  mkdir -p /tmp/deploy
  cd /tmp/deploy
  rm -r .config
   ${lib.getExe git}  -C . pull || git clone https://github.com/JosefKatic/nix-config-next.git .

  prefetch-config

  if [ -z "$host" ]; then
      echo "No host to deploy"
      exit 2
  fi
  ${lib.getExe deploy-rs} .#$host $@
''
