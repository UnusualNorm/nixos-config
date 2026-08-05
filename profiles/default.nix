{ config, lib, ... }: {
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    timeout = 0;
  };
  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  fileSystems = {
    "/" = { label = "nixos"; fsType = "ext4"; };
    "/boot" = { label = "boot"; fsType = "vfat"; options = [ "umask=0077" ]; };
  };
  networking.networkmanager.enable = true;
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
  nixpkgs.hostPlatform = "x86_64-linux";
  swapDevices = [ { label = "swap"; } ];
  system.autoUpgrade = {
    enable = true;
    flags = [ "--no-write-lock-file" ];
    flake = "github:UnusualNorm/nixos-config#${config.networking.hostName}";
  };
  time.timeZone = "America/Chicago";
  users.users.unusualnorm = {
    extraGroups = [
      "input"
      "networkmanager"
      "wheel"
    ];
    isNormalUser = true;
    openssh.authorizedKeys.keyFiles = [(builtins.fetchurl {
      url = "https://github.com/UnusualNorm.keys";
      sha256 = "0y0zph4hf1ssg4v8k3s21hbbxnw22pv6cfn2j5j32qx36iw57i76";
    })];
  };
}
