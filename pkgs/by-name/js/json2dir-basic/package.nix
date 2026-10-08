{
  stdenv,
  lib,
  fbc,
  ncurses,
  j2dSources,
}:
let
  pname = "json2dir-basic";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ fbc ];
  buildInputs = [ ncurses ];
  hardeningDisable = [ "format" ];

  buildPhase = ''
    mkdir -p out
    fbc -O 2 json2dir.bas -x out/json2dir
  '';

  installPhase = ''
    install -Dm755 out/json2dir "$out/bin/${pname}"
  '';

  meta = {
    description = "FreeBASIC implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
