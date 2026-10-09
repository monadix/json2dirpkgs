{
  lib,
  stdenv,
  fetchFromGitHub,
  lean4,
  gnused,
}:
stdenv.mkDerivation {
  pname = "fractran-runtime";
  version = "unstable-2026-10-08";
  src = fetchFromGitHub {
    owner = "pimlu";
    repo = "fractran";
    rev = "6742361d272f61a2e1da80937eba6a43614754c7";
    hash = "sha256-/2BtfgZb+loeSwZPZzjROOLsaEhV7t8jvoaX+jmARJI=";
  };
  sourceRoot = "source/fractran-lean";
  nativeBuildInputs = [
    lean4
    gnused
  ];
  postPatch = ''
    sed -i '/^\[\[require\]\]/,+3d' lakefile.toml
    rm -f lake-manifest.json
  '';
  buildPhase = ''
    runHook preBuild
    lake build fractran
    runHook postBuild
  '';
  installPhase = ''
    install -Dm755 .lake/build/bin/fractran "$out/bin/fractran"
  '';
  meta = {
    description = "FRACTRAN interpreter from the runtime-only Lean target";
    homepage = "https://github.com/pimlu/fractran";
    license = lib.licenses.mit;
    mainProgram = "fractran";
    platforms = [ "x86_64-linux" ];
  };
}
