{lib, ...}:
# personal lib
{
  _module.args = {
    colors = import ./colors lib;
    wallpapers = import ./wallpapers lib;
  };
}
