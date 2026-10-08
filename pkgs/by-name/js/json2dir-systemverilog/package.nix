{
  stdenv,
  lib,
  makeWrapper,
  bash,
  coreutils,
  iverilog,
  j2dSources,
}:
let
  pname = "json2dir-systemverilog";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [
    iverilog
    makeWrapper
  ];

  buildPhase = ''
    mkdir -p out
    iverilog -g2012 -o out/json2dir.vvp json2dir.sv
  '';

  installPhase = ''
    mkdir -p "$out/libexec/${pname}/out" "$out/bin"
    cp ./json2dir "$out/libexec/${pname}/json2dir"
    cp ./out/json2dir.vvp "$out/libexec/${pname}/out/json2dir.vvp"
    chmod +x "$out/libexec/${pname}/json2dir"
    makeWrapper "$out/libexec/${pname}/json2dir" "$out/bin/${pname}" \
      --set JSON2DIR_VVP "${iverilog}/bin/vvp" \
      --set JSON2DIR_SHELL "${bash}/bin/sh" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          bash
          iverilog
        ]
      }"
  '';

  meta = {
    description = "SystemVerilog implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
