{
  lib,
  stdenv,
  j2dSources,
  roc-nightly-2026-10-06,
}:
let
  pname = "json2dir-roc";
  platformUrl = "https://github.com/roc-lang/basic-cli/releases/download/0.24.0/AEjfyaMFFbh8FJrkkHJy68riVNPr3Qp6c6PawWQjBwMH.tar.zst";
  httpUrl = "https://github.com/roc-lang/http/releases/download/1.0.0/6ZUwqYhCS8PU9Mo6MF7oV82ET2o7KYb57CLKDq4cq4sS.tar.zst";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-e25e583";
  src = j2dSources.json2dir-roc;
  nativeBuildInputs = [ roc-nightly-2026-10-06 ];
  dontConfigure = true;
  buildPhase = ''
    mkdir -p "$TMPDIR/out" "$TMPDIR/roc-cache"
    export XDG_CACHE_HOME="$TMPDIR/roc-cache"
    roc build --opt=speed --replace-dep ${lib.escapeShellArg platformUrl} ${lib.escapeShellArg "${roc-nightly-2026-10-06}/share/roc/basic-cli/main.roc"} --replace-dep ${lib.escapeShellArg httpUrl} ${lib.escapeShellArg "${roc-nightly-2026-10-06}/share/roc/http/main.roc"} --output="$TMPDIR/out/json2dir" main.roc
  '';
  installPhase = ''install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-roc"'';
  meta = {
    description = "Roc implementation of json2dir on basic-cli";
    homepage = "https://github.com/json2dir-guru/json2dir-roc";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
