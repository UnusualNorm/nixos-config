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
  fileSystems."/mnt" = {
    fsType = "ext4";
    label = "data";
    options = [ "nofail" ];
  };
  hardware = {
    cpu.intel.updateMicrocode = true;
    nvidia = {
      nvidiaSettings = true;
      open = true;
    };
  };
  home-manager.users.unusualnorm.home.stateVersion = "26.05";
  imports = [ ./profiles/workstation.nix ];
  networking.hostName = "norman";
  services = {
    pipewire.extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 32;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 32;
      };
    };
    xserver.videoDrivers = [ "nvidia" ];
  };
  system.stateVersion = "26.05";
}
