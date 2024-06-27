{lib, ...}: {
  boot = {
    initrd = {
      availableKernelModules = ["ata_piix" "sr_mod" "uhci_hcd" "virtio_blk" "virtio_pci"];
    };
  };

  virtualisation.hypervGuest.enable = true;
  systemd.services.hv-kvp.unitConfig.ConditionPathExists = ["/dev/vmbus/hv_kvp"];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
