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
  npiet,
}:
let
  pname = "json2dir-piet";
  src = j2dSources.${pname};
in
stdenvNoCC.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ npiet ];

  installPhase = ''
    mkdir -p "$out/libexec/${pname}" "$out/bin"
    cp ./json2dir ./json2dir.png "$out/libexec/${pname}/"
    chmod +x "$out/libexec/${pname}/json2dir"
    makeWrapper "$out/libexec/${pname}/json2dir" "$out/bin/${pname}" \
      --set JSON2DIR_NPIET "${npiet}/bin/npiet" \
      --set JSON2DIR_SHELL "${bash}/bin/sh" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          findutils
          gnugrep
          gawk
          gnused
          bash
          npiet
        ]
      }"
  '';

  meta = {
    description = "Piet implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
