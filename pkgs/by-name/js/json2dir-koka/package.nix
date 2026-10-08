{
  stdenv,
  lib,
  koka,
  gcc,
  j2dSources,
}:
let
  pname = "json2dir-koka";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [
    koka
    gcc
  ];

  buildPhase = ''
    mkdir -p out
    koka -O2 -i"$PWD" --builddir="$TMPDIR/koka-build" -o "$PWD/out/json2dir" json2dir.kk
    chmod +x out/json2dir
  '';

  installPhase = ''
    install -Dm755 out/json2dir "$out/bin/${pname}"
  '';

  meta = {
    description = "Koka implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
