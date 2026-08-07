{ pkgs, ... }:
let
  notify-send-all = pkgs.writeShellApplication {
    name = "notify-send-all";
    text = ''
      shopt -s nullglob
      for bus in /run/user/[0-9]*/bus; do
        uid="''${bus#/run/user/}"
        uid="''${uid%/bus}"
        passwd_entry="$(
          ${pkgs.getent}/bin/getent passwd "$uid"
        )"
        [[ -n "$passwd_entry" ]] || continue
        user="''${passwd_entry%%:*}"
        ${pkgs.util-linux}/bin/runuser -u "$user" -- \
          ${pkgs.coreutils}/bin/env \
          XDG_RUNTIME_DIR="/run/user/$uid" \
          DBUS_SESSION_BUS_ADDRESS="unix:path=$bus" \
          ${pkgs.libnotify}/bin/notify-send "$@"
      done
    '';
  };
in
{
  boot = {
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];
    plymouth = {
      enable = true;
      theme = "theme";
      themePackages = [(pkgs.stdenvNoCC.mkDerivation {
        dontBuild = true;
        installPhase = ''
          themeDir="$out/share/plymouth/themes/theme"
          mkdir -p "$themeDir"
          cp -r * "$themeDir"
          substituteInPlace "$themeDir/theme.plymouth" \
              --replace-fail "@THEME_DIR@" "$themeDir"
        '';
        name = "plymouthTheme";
        src = ../plymouth;
      })];
    };
  };
  environment = {
    etc."niri/config.kdl".source = ../niri/config.kdl;
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      android-tools
      audacity
      bitwarden-desktop
      blockbench
      brave-origin
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
      fastfetch
      foot
      fuzzel
      gimp
      git
      imhex
      kdePackages.kdenlive
      mako
      nixd
      notify-send-all
      pavucontrol
      spotify
      thunderbird
      vim
      xwayland-satellite
      zed-editor
    ];
  };
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ font-awesome ];
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
  home-manager.users.unusualnorm = { pkgs, ... }: {
    gtk = {
      colorScheme = "dark";
      enable = true;
      gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
    };
    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      x11.enable = true;
    };
    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style.name = "adwaita-dark";
    };
  };
  imports = [ ./default.nix ];
  networking.firewall = {
    allowedTCPPorts = [ 57621 ];
    allowedUDPPorts = [ 5353 ];
  };
  nixpkgs.config.allowUnfree = true;
  programs = {
    bash.interactiveShellInit = "fastfetch";
    niri.enable = true;
    nix-ld = {
      enable = true;
      libraries = pkgs.steam-run.args.multiPkgs pkgs;
    };
    steam = {
      enable = true;
      extest.enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    waybar.enable = true;
  };
  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };
  services = {
    blueman.enable = true;
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet -rt";
      };
    };
    gvfs.enable = true;
    pipewire = {
      alsa.enable = true;
      alsa.support32Bit = true;
      configPackages = [(pkgs.writeTextDir
        "share/pipewire/pipewire.conf.d/99-input-denoising.conf"
        (builtins.replaceStrings
            [ "%RNNOISE_PLUGIN%" ]
            [ "${pkgs.rnnoise-plugin}" ]
            (builtins.readFile ../pipewire/99-input-denoising.conf))
      )];
      enable = true;
      pulse.enable = true;
    };
    power-profiles-daemon.enable = true;
    tumbler.enable = true;
    zerotierone = {
      enable = true;
      joinNetworks = [ "a84ac5c10a761621" ];
    };
  };
  systemd = {
    services = {
      nixos-upgrade = {
        onFailure = [ "nixos-upgrade-notify-failure.service" ];
        onSuccess = [ "nixos-upgrade-notify-success.service" ];
      };
      nixos-upgrade-notify-failure = {
        serviceConfig = {
          Type = "oneshot";
        };
        script = ''
          ${notify-send-all}/bin/notify-send-all \
            --urgency=critical \
            "NixOS Upgrade Failure" \
            "journalctl -u nixos-upgrade.service"
        '';
      };
      nixos-upgrade-notify-success = {
        serviceConfig = {
          Type = "oneshot";
        };
        script = ''
          ${notify-send-all}/bin/notify-send-all \
            "NixOS Upgrade Success"
        '';
      };
    };
    user = {
      services = {
        niri.enableDefaultPath = false;
        swaybg = {
          after = [ "graphical-session.target" ];
          description = "swaybg";
          partOf = [ "graphical-session.target" ];
          serviceConfig = {
            ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${../swaybg/wallpaper.png} -m fill";
            Restart = "on-failure";
          };
          wantedBy = [ "graphical-session.target" ];
        };
        waybar.path = [ pkgs.pavucontrol ];
      };
      targets.graphical-session.wants = [ "foot-server.service" ];
    };
  };
}
