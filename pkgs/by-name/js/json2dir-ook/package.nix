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
  ookRuntime,
}:
let
  pname = "json2dir-ook";
  src = j2dSources.${pname};
in
stdenvNoCC.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ookRuntime ];

  installPhase = ''
    mkdir -p "$out/libexec/${pname}" "$out/bin"
    cp ./json2dir ./json2dir.ook "$out/libexec/${pname}/"
    chmod +x "$out/libexec/${pname}/json2dir"
    makeWrapper "$out/libexec/${pname}/json2dir" "$out/bin/${pname}" \
      --set JSON2DIR_OOK "${ookRuntime}/bin/ook -ook -r" \
      --set JSON2DIR_SHELL "${bash}/bin/sh" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          findutils
          gnugrep
          gawk
          gnused
          bash
          ookRuntime
        ]
      }"
  '';

  meta = {
    description = "Ook! implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
