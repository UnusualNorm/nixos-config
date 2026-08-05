{ config, lib, modulesPath, pkgs, ... }: {
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "sd_mod"
        "sr_mod"
        "sdhci_pci"
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
