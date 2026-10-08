{
  stdenv,
  lib,
  opencilk,
  glibc,
  j2dSources,
}:
let
  pname = "json2dir-cilk";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ opencilk ];
  buildInputs = [ glibc.static ];

  buildPhase = ''
    mkdir -p out
    ${opencilk}/bin/clang -fopencilk -O2 -Wall -Wextra -static \
      -o out/json2dir json2dir.c
  '';

  installPhase = ''
    install -Dm755 out/json2dir "$out/bin/${pname}"
  '';

  meta = {
    description = "OpenCilk implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
