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
  malbolgeUnshackled,
}:
let
  pname = "json2dir-malbolge";
  src = j2dSources.${pname};
in
stdenvNoCC.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [
    makeWrapper
    xz
  ];
  buildInputs = [ malbolgeUnshackled ];

  installPhase = ''
    mkdir -p "$out/libexec/${pname}" "$out/bin"
    cp ./json2dir ./json2dir.mal.xz "$out/libexec/${pname}/"
    xz -dc "$out/libexec/${pname}/json2dir.mal.xz" > "$out/libexec/${pname}/json2dir.mal"
    rm "$out/libexec/${pname}/json2dir.mal.xz"
    chmod +x "$out/libexec/${pname}/json2dir"
    makeWrapper "$out/libexec/${pname}/json2dir" "$out/bin/${pname}" \
      --set JSON2DIR_MU "${malbolgeUnshackled}/bin/Unshackled-20" \
      --set JSON2DIR_MAL "$out/libexec/${pname}/json2dir.mal" \
      --set JSON2DIR_SHELL "${bash}/bin/sh" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          findutils
          gnugrep
          gawk
          gnused
          bash
          malbolgeUnshackled
        ]
      }"
  '';

  meta = {
    description = "Malbolge Unshackled implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
