{ pkgs, ... }: {
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "sd_mod"
        "sdhci_pci"
        "sr_mod"
        "thunderbolt"
        "usb_storage"
        "xhci_pci"
      ];
      kernelModules = [ "i915" ];
    };
    kernelModules = [ "kvm-intel" ];
  };
  hardware = {
    cpu.intel.updateMicrocode = true;
    graphics.extraPackages = with pkgs; [
      intel-media-driver
    ];
  };
  home-manager.users.unusualnorm.home.stateVersion = "26.05";
  imports = [ ./profiles/workstation.nix ];
  networking.hostName = "normette";
  system.stateVersion = "26.05";
}
