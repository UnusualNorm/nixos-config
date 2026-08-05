{ config, lib, modulesPath, pkgs, ... }: {
  boot = {
    initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
    kernelModules = [ "kvm-intel" ];
  };
  home-manager.users.unusualnorm.home.stateVersion = "26.05";
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./profiles/workstation.nix
  ];
  networking.hostName = "nixos";
  services.openssh.enable = true;
  system.stateVersion = "26.05";
}
