{
  stdenv,
  lib,
  makeWrapper,
  bash,
  coreutils,
  portableFalse,
  j2dSources,
}:
let
  pname = "json2dir-false";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out/libexec/${pname}" "$out/bin"
    cp ./json2dir ./json2dir.f "$out/libexec/${pname}/"
    chmod +x "$out/libexec/${pname}/json2dir"
    makeWrapper "$out/libexec/${pname}/json2dir" "$out/bin/${pname}" \
      --set JSON2DIR_FALSE "${portableFalse}/bin/false_int" \
      --set JSON2DIR_SHELL "${bash}/bin/sh" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          bash
          portableFalse
        ]
      }"
  '';

  meta = {
    description = "FALSE implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
