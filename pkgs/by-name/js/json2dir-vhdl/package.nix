{
  stdenv,
  lib,
  makeWrapper,
  bash,
  coreutils,
  ghdl,
  j2dSources,
}:
let
  pname = "json2dir-vhdl";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [
    ghdl
    makeWrapper
  ];

  buildPhase = ''
    mkdir -p out
    ghdl -a --std=08 --workdir=out json2dir.vhd
    ghdl -e --std=08 --workdir=out json2dir
  '';

  installPhase = ''
    mkdir -p "$out/libexec/${pname}/out" "$out/bin"
    cp ./json2dir "$out/libexec/${pname}/json2dir"
    cp ./json2dir.vhd "$out/libexec/${pname}/json2dir.vhd"
    chmod +x "$out/libexec/${pname}/json2dir"
    touch -d @1 "$out/libexec/${pname}/json2dir.vhd"
    ghdl -a --std=08 --workdir="$out/libexec/${pname}/out" \
      "$out/libexec/${pname}/json2dir.vhd"
    ghdl -e --std=08 --workdir="$out/libexec/${pname}/out" json2dir
    makeWrapper "$out/libexec/${pname}/json2dir" "$out/bin/${pname}" \
      --set JSON2DIR_GHDL "${ghdl}/bin/ghdl" \
      --set JSON2DIR_GHDL_WORK "$out/libexec/${pname}/out" \
      --set JSON2DIR_SHELL "${bash}/bin/sh" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          bash
          ghdl
        ]
      }"
  '';

  meta = {
    description = "VHDL implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
