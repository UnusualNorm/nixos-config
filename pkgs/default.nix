final: _prev: {
  ilspy = final.callPackage ./ilspy/package.nix { };
  ryubing-canary = final.callPackage ./ryubing-canary/package.nix { };
  wscat = final.callPackage ./wscat/package.nix { };
}
