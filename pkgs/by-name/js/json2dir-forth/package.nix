{
  lib,
  stdenvNoCC,
  makeWrapper,
  coreutils,
  gcc,
  libtool,
  binutils,
  glibc,
  j2dSources,
  gforth,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-forth";
  version = "2026-10-07";
  src = j2dSources.json2dir-forth;
  nativeBuildInputs = [
    makeWrapper
    gcc
    libtool
    binutils
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p "$out/share/$pname/libcc"
    install -Dm644 json2dir.fs "$out/share/$pname/json2dir.fs"
    printf '{}' | libccnameddir="$out/share/$pname" "${gforth}/bin/gforth" \
      "$out/share/$pname/json2dir.fs" -e bye
    runHook postBuild
  '';

  postBuild = ''
    strip --strip-debug "$out/share/.libs/"*.so.*
  '';

  disallowedReferences = [
    gcc
    gcc.cc
    glibc.dev
  ];

  installPhase = ''
    runHook preInstall
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${gforth}/bin/gforth" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/json2dir.fs -e bye" \
      --set libccnameddir "$out/share/$pname" \
      --prefix PATH : "${lib.makeBinPath [ coreutils ]}"
    runHook postInstall
  '';

  meta = {
    description = "Forth on Gforth, hand-written UTF-8 check and JSON parser, POSIX calls via Gforth's C interface and libtool/gcc";
    homepage = "https://github.com/json2dir-guru/json2dir-forth";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-forth";
  };
}
