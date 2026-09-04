{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  powershell,
  darwin,
  glibcLocales,
}:
buildDotnetModule (finalAttrs: {
  pname = "ilspy";
  version = "11.0";

  src = fetchFromGitHub {
    owner = "icsharpcode";
    repo = "ILSpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DXQEe3pNgXiwiZo4npYGHGDjg4LV6cs6aFk4raGjpus=";
  };

  nativeBuildInputs = [
    powershell
  ]
  ++ lib.optionals (stdenvNoCC.hostPlatform.isDarwin && stdenvNoCC.hostPlatform.isAarch64) [
    darwin.autoSignDarwinBinariesHook
  ];

  # https://github.com/NixOS/nixpkgs/issues/38991
  # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  env.LOCALE_ARCHIVE = lib.optionalString stdenvNoCC.hostPlatform.isLinux "${glibcLocales}/lib/locale/locale-archive";

  dotnet-sdk = dotnetCorePackages.sdk_11_0;
  dotnetRestoreFlags = [ "--force-evaluate" ];

  projectFile = "ILSpy/ILSpy.csproj";
  nugetDeps = ./deps.json;

  # see: https://github.com/tunnelvisionlabs/ReferenceAssemblyAnnotator/issues/94
  linkNugetPackages = true;
})
