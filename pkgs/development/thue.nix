{
  stdenv,
  lib,
  fetchFromGitHub,
  gnumake,
}:
stdenv.mkDerivation {
  pname = "thue";
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "fixedpoint";
    repo = "thue";
    rev = "460ab5b0107565246345b5f406074992e4b9e92c";
    hash = "sha256-jfYOeysJvmggTpgJ/tTxgNCDHUdOaYvr9YVyt+Zdi1g=";
  };

  nativeBuildInputs = [ gnumake ];

  buildPhase = ''
    make -C src
  '';

  installPhase = ''
    make -C src install out="$out"
  '';

  meta = {
    description = "C++ interpreter for the Thue programming language";
    homepage = "https://github.com/fixedpoint/thue";
    license = lib.licenses.mit;
    mainProgram = "thue";
    platforms = [ "x86_64-linux" ];
  };
}
