{
  stdenv,
  lib,
  makeWrapper,
  marst,
  gcc,
  coreutils,
  bash,
  j2dSources,
}:
let
  pname = "json2dir-algol60";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [
    makeWrapper
    marst
    gcc
  ];

  buildPhase = ''
    runHook preBuild
    sh ./build.sh ${marst}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/libexec/${pname}/out" "$out/bin"
    cp ./json2dir "$out/libexec/${pname}/json2dir"
    cp ./out/json2dir-eval "$out/libexec/${pname}/out/json2dir-eval"
    chmod +x "$out/libexec/${pname}/json2dir"
    makeWrapper "$out/libexec/${pname}/json2dir" "$out/bin/${pname}" \
      --set JSON2DIR_EVAL "$out/libexec/${pname}/out/json2dir-eval" \
      --set JSON2DIR_SHELL "${bash}/bin/sh" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          bash
        ]
      }"
    runHook postInstall
  '';

  meta = {
    description = "ALGOL 60 implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
