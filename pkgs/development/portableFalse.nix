{
  stdenv,
  lib,
  fetchurl,
  unzip,
}:
stdenv.mkDerivation {
  pname = "portable-false";
  version = "1.2b";
  src = fetchurl {
    url = "https://strlen.com/files/lang/false/False12b.zip";
    hash = "sha256-eCrI4G9J3F3Fmfn//H/Qc4YOW9ktC9i9r63DiLwmOy8=";
  };

  sourceRoot = "False12b";
  nativeBuildInputs = [ unzip ];

  postPatch = ''
    substituteInPlace false_int.c \
      --replace-fail '#define cm(o,tt) {pa(b,((X)tt))pop(d,(X)tt);pu((X)(-(int)((int)d o (int)b)));}' \
        '#define cm(o,tt) {pa(b,t1)pop(d,t1);pu((X)(-(int)((int)d o (int)b)));}'
  '';

  buildPhase = ''
    $CC -std=gnu17 -O2 -o false_int false_int.c
  '';

  installPhase = ''
    install -Dm755 false_int "$out/bin/false_int"
    install -Dm644 .Product-Info "$out/share/doc/portable-false/Product-Info"
  '';

  meta = {
    description = "Portable C interpreter for the FALSE programming language";
    homepage = "https://strlen.com/false-language/";
    license = lib.licenses.unfree;
    longDescription = "Upstream distributes this archive as freeware; no separate redistribution grant is included in the archive.";
    mainProgram = "false_int";
    platforms = [ "x86_64-linux" ];
  };
}
