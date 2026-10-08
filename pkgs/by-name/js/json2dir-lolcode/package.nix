{
  stdenv,
  lib,
  lolcode-future,
  makeWrapper,
  bash,
  coreutils,
  j2dSources,
}:
let
  pname = "json2dir-lolcode";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ lolcode-future ];

  installPhase = ''
    mkdir -p "$out/libexec/${pname}" "$out/bin"
    cp ./json2dir "$out/libexec/${pname}/json2dir"
    cp ./json2dir.lol "$out/libexec/${pname}/json2dir.lol"
    chmod +x "$out/libexec/${pname}/json2dir"
    makeWrapper "$out/libexec/${pname}/json2dir" "$out/bin/${pname}" \
      --set JSON2DIR_LCI "${lolcode-future}/bin/lolcode-lci" \
      --set JSON2DIR_SHELL "${bash}/bin/sh" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          bash
          lolcode-future
        ]
      }"
  '';

  meta = {
    description = "LOLCODE implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
