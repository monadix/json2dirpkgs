{
  lib,
  stdenv,
  j2dSources,
  zig_0_16,
}:
let
  pname = "json2dir-zig";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-aa7c89b";
  src = j2dSources.json2dir-zig;
  nativeBuildInputs = [ zig_0_16 ];
  dontConfigure = true;
  buildPhase = ''
    runHook preBuild
    zig build -Doptimize=ReleaseSafe --cache-dir "$TMPDIR/zig-cache" --global-cache-dir "$TMPDIR/zig-global-cache"
    runHook postBuild
  '';
  installPhase = ''
    install -Dm755 zig-out/bin/json2dir "$out/bin/json2dir-zig"
  '';
  meta = {
    description = "Safety-focused Zig implementation of json2dir";
    homepage = "https://github.com/71g3pf4c3/json2dir-zig";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
