{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}: buildNpmPackage rec {
  pname = "wscat";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "websockets";
    repo = "wscat";
    rev = version;
    hash = "sha256-Lc7GgutBcrrPAa5FtQmtFbtWtrNfa47CtMRrh9FflIA=";
  };

  postPatch = "cp ${./package-lock.json} package-lock.json";

  npmDepsHash = "sha256-66dvzV8O1BJtVOK5Pt4Z+yTUIQF0eNQ+s45GtOKzpOw=";

  dontNpmBuild = true;
  dontNpmPrune = true;
}
