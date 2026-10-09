{
  stdenvNoCC,
  lib,
  makeWrapper,
  bash,
  coreutils,
  findutils,
  gnugrep,
  gawk,
  xz,
  gnused,
  j2dSources,
  fractran,
}:
let
  pname = "json2dir-fractran";
  src = j2dSources.${pname};
in
stdenvNoCC.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ fractran ];

  installPhase = ''
    mkdir -p "$out/libexec/${pname}" "$out/bin"
    cp ./json2dir ./json2dir.fractran "$out/libexec/${pname}/"
    chmod +x "$out/libexec/${pname}/json2dir"
    makeWrapper "$out/libexec/${pname}/json2dir" "$out/bin/${pname}" \
      --set JSON2DIR_FRACTRAN "${fractran}/bin/fractran" \
      --set JSON2DIR_SHELL "${bash}/bin/sh" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          findutils
          gnugrep
          gawk
          gnused
          bash
          fractran
        ]
      }"
  '';

  meta = {
    description = "FRACTRAN implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
