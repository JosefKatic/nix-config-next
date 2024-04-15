{
  options.user.desktop = {
    enable = true;
    
  };
  imports = [
    ./wayland
    ./programs
    ./monitors.nix
  ];
}