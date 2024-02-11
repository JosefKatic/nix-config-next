{
  pkgs,
  config,
  ...
}: let
  ssh = "${pkgs.openssh}/bin/ssh";

  git-joka = pkgs.writeShellScriptBin "git-joka" ''
    repo="$(git remote -v | grep git@joka00.dev | head -1 | cut -d ':' -f2 | cut -d ' ' -f1)"
    # Add a .git suffix if it's missing
    if [[ "$repo" != *".git" ]]; then
      repo="$repo.git"
    fi

    if [ "$1" == "init" ]; then
      if [ "$2" == "" ]; then
        echo "You must specify a name for the repo"
        exit 1
      fi
      ${ssh} -A git@joka00.dev << EOF
        git init --bare "$2.git"
        git -C "$2.git" branch -m main
    EOF
      git remote add origin git@joka00.dev:"$2.git"
    elif [ "$1" == "ls" ]; then
      ${ssh} -A git@joka00.dev ls
    else
      ${ssh} -A git@joka00.dev git -C "/srv/git/$repo" $@
    fi
  '';
in {
  home.packages = [git-joka];
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    aliases = {
      pushall = "!git remote | xargs -L1 git push --all";
      graph = "log --decorate --oneline --graph";
      add-nowhitespace = "!git diff -U0 -w --no-color | git apply --cached --ignore-whitespace --unidiff-zero -";
    };
    userName = "Josef Katič";
    userEmail = "josef@joka00.dev";
    signing = {
      key = "0x8417626CCED5035D";
      gpgPath = "${config.programs.gpg.package}/bin/gpg2";
    };
    extraConfig = {
      feature.manyFiles = true;
      init.defaultBranch = "main";
      commit.gpgSign = true;
    };
    lfs.enable = true;
    ignores = [".direnv" "result"];
  };
}
