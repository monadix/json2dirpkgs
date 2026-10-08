{
  stdenv,
  lib,
  intercal,
  makeWrapper,
  bash,
  coreutils,
  j2dSources,
}:
let
  pname = "json2dir-intercal";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [
    intercal
    makeWrapper
  ];

  buildPhase = ''
    mkdir -p out
    cp json2dir.i out/json2dir.i
    (cd out && ick -b json2dir.i)
  '';

  installPhase = ''
    mkdir -p "$out/libexec/${pname}" "$out/bin"
    cp ./json2dir "$out/libexec/${pname}/json2dir"
    cp -r ./out "$out/libexec/${pname}/out"
    chmod +x "$out/libexec/${pname}/json2dir"
    makeWrapper "$out/libexec/${pname}/json2dir" "$out/bin/${pname}" \
      --set JSON2DIR_INTERCAL_EVALUATOR "$out/libexec/${pname}/out/json2dir" \
      --set JSON2DIR_SHELL "${bash}/bin/sh" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          bash
        ]
      }"
  '';

  meta = {
    description = "C-INTERCAL implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
