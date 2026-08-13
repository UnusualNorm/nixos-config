{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromForgejo,
  ffmpeg,
  glew,
  gtk3,
  libGL,
  libgdiplus,
  libice,
  libsm,
  libsoundio,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxrandr,
  openal,
  pulseaudio,
  sndio,
  SDL2,
  SDL2_mixer,
  stdenv,
  udev,
  vulkan-loader,
  wrapGAppsHook3,
}:

buildDotnetModule rec {
  pname = "ryubing-canary";
  version = "1.3.340";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromForgejo {
    domain = "git.ryujinx.app";
    owner = "projects";
    repo = "Ryubing";
    tag = "Canary-${version}";
    hash = "sha256-JOaSRXuz5gfyq7OAkmBF+Av3GZt37qawOpMM5qw35cw=";
  };

  nativeBuildInputs = [ wrapGAppsHook3 ];

  enableParallelBuilding = false;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  nugetDeps = ./deps.json;

  runtimeDeps = [
    libx11
    libgdiplus
    SDL2_mixer
    openal
    libsoundio
    sndio
    vulkan-loader
    ffmpeg

    # Avalonia UI
    glew
    libice
    libsm
    libxcursor
    libxext
    libxi
    libxrandr
    gtk3

    # Headless executable
    libGL
    SDL2

    udev
    pulseaudio
  ];

  projectFile = "Ryujinx.sln";
  testProjectFile = "src/Ryujinx.Tests/Ryujinx.Tests.csproj";

  doCheck = false;

  # Avalonia 11.3 (shipped in canary) requires a default font family to be set
  # explicitly on Linux; otherwise FontManager throws on startup with
  # "Default font family name can't be null or empty." Point it at the
  # JetBrainsMono asset that the project already bundles.
  postPatch = ''
    substituteInPlace src/Ryujinx/Program.cs --replace-fail \
      'AppBuilder.Configure<RyujinxApp>()' \
      'AppBuilder.Configure<RyujinxApp>().With(new global::Avalonia.Media.FontManagerOptions { DefaultFamilyName = "avares://Ryujinx/Assets/Fonts/Mono/#JetBrains Mono" })'
  '';

  # MSBuild picks up global properties from the environment. Setting the
  # property this way instead of via dotnetFlags avoids the %2C escape for
  # the comma (the /p: parser splits on commas), because a literal % in any
  # derivation attribute breaks nix-shell on __structuredAttrs derivations
  # (boost::bad_format_string), which in turn breaks passthru.fetch-deps.
  env.ExtraDefineConstants = "DISABLE_UPDATER";

  executables = [ "Ryujinx" ];

  preFixup = ''
    mkdir -p $out/share/{applications,icons/hicolor/256x256/apps,mime/packages}
    pushd ${src}/distribution/linux
    install -D ./app.ryujinx.Ryujinx.desktop $out/share/applications/app.ryujinx.Ryujinx.desktop
    install -D ./Ryujinx.sh       $out/bin/Ryujinx.sh
    install -D ./mime/Ryujinx.xml $out/share/mime/packages/Ryujinx.xml
    install -D ../misc/Logo.png   $out/share/icons/hicolor/256x256/apps/app.ryujinx.Ryujinx.png
    popd
  '';
}
