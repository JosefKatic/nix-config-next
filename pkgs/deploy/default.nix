# modified from https://github.com/gytis-ivaskevicius/flake-utils/plus
{
  coreutils,
  gnused,
  writeShellScriptBin,
  deploy-rs,
  lib,
}:
writeShellScriptBin "deploy" ''
  host="$1"
  shift

  prefetch-config

  if [ -z "$host" ]; then
      echo "No host to deploy"
      exit 2
  fi
  ${lib.getExe deploy-rs} $DEPLOY_FLAKE#$host $@
''
