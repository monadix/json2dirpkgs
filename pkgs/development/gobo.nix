{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
}:
stdenv.mkDerivation {
  pname = "gobo";
  version = "26.09.03";
  src = fetchFromGitHub {
    owner = "gobo-eiffel";
    repo = "gobo";
    rev = "8969a11dda12cf4d78bf3c87379e4f864c3afe20";
    hash = "sha256-Powjibkarz8MCAA5DayPj2vaN4Gxf9Mp4XLTuPHxCxY=";
  };
  nativeBuildInputs = [ makeWrapper ];
  dontConfigure = true;
  buildPhase = ''
    runHook preBuild
    export GOBO="$PWD"
    patchShebangs bin tool/gec/bootstrap
    sh tool/gec/bootstrap/bootstrap.sh --thread=2 gcc
    (cd bin; ./gec --finalize --thread=2 ../tool/gecc/src/system.ecf)
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/tool/gec/backend/c"
    cp bin/gec bin/gecc "$out/bin/"
    cp -a library "$out/"
    cp -a tool/gec/backend/c/config tool/gec/backend/c/runtime "$out/tool/gec/backend/c/"
    cp LICENSE.txt "$out/"
    for program in gec gecc; do
      wrapProgram "$out/bin/$program" --set GOBO "$out" \
        --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}
    done
    runHook postInstall
  '';
  meta = {
    description = "Gobo Eiffel compiler, C backend, and libraries";
    homepage = "https://www.gobosoft.com/";
    license = lib.licenses.mit;
    mainProgram = "gec";
    platforms = [ "x86_64-linux" ];
  };
}
