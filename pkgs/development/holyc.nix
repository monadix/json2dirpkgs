{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gnumake,
}:
stdenv.mkDerivation {
  pname = "holyc";
  version = "0.0.15-unstable-2026-09-06";
  src = fetchFromGitHub {
    owner = "Jamesbarford";
    repo = "holyc-lang";
    rev = "06ca61140ef143fe83218a33dbc9cf9e2c199509";
    hash = "sha256-S9eRzHY2/1/tOLMZzWJSc2uyIIq5d4roG0jrHzDoTf0=";
  };

  sourceRoot = "source/src";

  nativeBuildInputs = [
    cmake
    gnumake
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DHCC_ENABLE_JIT=ON"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib"
    cmake --install .
    runHook postInstall
  '';

  meta = {
    description = "HolyC compiler and transpiler";
    homepage = "https://github.com/Jamesbarford/holyc-lang";
    license = lib.licenses.bsd2;
    mainProgram = "hcc";
    platforms = [ "x86_64-linux" ];
  };
}
