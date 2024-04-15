{
  users = {
    "joka@hirundo" = {
      user = {
        desktop = {
          hyprland = {
            binding = {
              browser = "SUPER,b";
              terminal = "SUPER,q";
              lock = "SUPER,backspace";
              screenshot = "SUPERSHIFT,s";
            };
          };
        };
        monitors = {
          "eDP-1" = {
            enable = true;
            primary = true;
            width = 1920;
            height = 1080;
            refreshRate = 60;
            x = 0;
            y = 0;
          };
        };
        services = {};
        programs = {
          editors = {
            vscode = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
