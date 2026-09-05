{ inputs }:

final: _prev:
let
  system = final.stdenv.hostPlatform.system;
in
{
  ilspy = final.callPackage ./ilspy/package.nix { };
  rsi-launcher = inputs.nix-citizen.packages.${system}.rsi-launcher;
  ryubing-canary = final.callPackage ./ryubing-canary/package.nix { };
  wscat = final.callPackage ./wscat/package.nix { };
}
