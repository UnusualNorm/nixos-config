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
  version = "11.0-rc";

  src = fetchFromGitHub {
    owner = "icsharpcode";
    repo = "ILSpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VKXmbgK3jqaRq8l1uOx0RixWOV5qtxlSdl72SGh4p9s=";
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

  projectFile = "ILSpy.Desktop.slnf";
  nugetDeps = ./ilspy-deps.json;
  dotnetRestoreFlags = [
    "--force-evaluate"
  ];

  # see: https://github.com/tunnelvisionlabs/ReferenceAssemblyAnnotator/issues/94
  linkNugetPackages = true;
})
