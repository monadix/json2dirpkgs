{
  stdenv,
  lib,
  checkedc,
  j2dSources,
}:
let
  pname = "json2dir-checkedc";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ checkedc ];
  hardeningDisable = [
    "fortify"
    "zerocallusedregs"
    "strictflexarrays1"
    "strictflexarrays3"
  ];

  buildPhase = ''
    mkdir -p out
    ${checkedc}/bin/clang -O2 -o out/json2dir json2dir.c
  '';

  installPhase = ''
    install -Dm755 out/json2dir "$out/bin/${pname}"
  '';

  meta = {
    description = "Checked C implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
