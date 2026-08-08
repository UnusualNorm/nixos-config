{ ... }: {
  boot = {
    initrd = {
      availableKernelModules = [
        "vmd"
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "sr_mod"
      ];
    };
    kernelModules = [ "kvm-intel" ];
  };
  hardware.cpu.intel.updateMicrocode = true;
  home-manager.users.unusualnorm.home.stateVersion = "26.05";
  imports = [ ./profiles/workstation.nix ];
  networking.hostName = "norman";
  services.xserver.videoDrivers = [ "nvidia" ];
  system.stateVersion = "26.05";
}
