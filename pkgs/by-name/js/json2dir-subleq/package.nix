{
  stdenv,
  lib,
  makeWrapper,
  bash,
  coreutils,
  sqrun,
  j2dSources,
}:
let
  pname = "json2dir-subleq";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out/libexec/${pname}" "$out/bin"
    cp ./json2dir ./json2dir.sq "$out/libexec/${pname}/"
    chmod +x "$out/libexec/${pname}/json2dir"
    makeWrapper "$out/libexec/${pname}/json2dir" "$out/bin/${pname}" \
      --set JSON2DIR_SQRUN "${sqrun}/bin/sqrun" \
      --set JSON2DIR_SHELL "${bash}/bin/sh" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          bash
          sqrun
        ]
      }"
  '';

  meta = {
    description = "Subleq implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
