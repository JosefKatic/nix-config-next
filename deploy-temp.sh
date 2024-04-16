#!/nix/store/a1s263pmsci9zykm5xcdf7x9rv26w6d5-bash-5.2p26/bin/bash
host="$1"
shift
mkdir -p /tmp/deploy
cd /tmp/deploy
/nix/store/y56vmnczakd9p0dsjl6jgnqrkqv04yxx-git-2.44.0/bin/git -C . pull || git clone https://github.com/JosefKatic/nix-config-next.git .

prefetch-config

if [ -z "$host" ]; then
  echo "No host to deploy"
  exit 2
fi
/nix/store/r7ka5z5g357fckcw2nk2yd0rvg64nrsn-deploy-rs-unstable-2024-02-16/bin/deploy .#$host $@
