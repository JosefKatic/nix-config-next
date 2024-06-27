{
  self,
  inputs,
  ...
}: {
  imports = [
    ../../specialisations.nix
    ../../terminal/shell/fish.nix
    ../../terminal/shell/starship.nix

    ../../terminal/programs/bat.nix
    ../../terminal/programs/btop.nix
    ../../terminal/programs/nix.nix
    ../../terminal/programs/git.nix

    ../../specialisations.nix
  ];
}
