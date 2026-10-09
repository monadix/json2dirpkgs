{
  lib,
  stdenv,
  makeWrapper,
  bash,
  coreutils,
  findutils,
  gnugrep,
  gawk,
  splRuntime,
  j2dSources,
}:
let
  pname = "json2dir-shakespeare";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ splRuntime ];

  buildPhase = ''
    runHook preBuild
    mkdir -p out
    ${splRuntime}/bin/spl2c < json2dir.spl > out/json2dir.c
    $CC -O1 -w -fcommon -I${splRuntime}/include out/json2dir.c ${splRuntime}/lib/libspl.a -lm -o out/json2dir
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p "$out/libexec/${pname}" "$out/bin"
    cp ./out/json2dir "$out/libexec/${pname}/evaluator"
    cp ./json2dir "$out/libexec/${pname}/launcher"
    chmod +x "$out/libexec/${pname}/evaluator" "$out/libexec/${pname}/launcher"
    makeWrapper "$out/libexec/${pname}/launcher" "$out/bin/${pname}" \
      --set JSON2DIR_SPL "$out/libexec/${pname}/evaluator" \
      --set JSON2DIR_SHELL "${bash}/bin/sh" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          findutils
          gnugrep
          gawk
          bash
        ]
      }"
  '';

  meta = {
    description = "Shakespeare Programming Language implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
