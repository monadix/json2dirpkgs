{
  lib,
  stdenv,
  j2dSources,
  go_1_27,
}:
let
  pname = "json2llm";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-14cd2aa";
  src = j2dSources.json2llm;
  nativeBuildInputs = [ go_1_27 ];
  dontConfigure = true;
  buildPhase = ''
    export GOTOOLCHAIN=local GOPROXY=off GOPATH="$TMPDIR/gopath" GOMODCACHE="$TMPDIR/modcache" GOCACHE="$TMPDIR/gocache"
    mkdir -p "$GOPATH" "$GOMODCACHE" "$GOCACHE"
    go build -trimpath -o "$TMPDIR/json2llm" .
  '';
  installPhase = ''
    install -Dm755 "$TMPDIR/json2llm" "$out/libexec/json2llm"
    mkdir -p "$out/bin"
    cat > "$out/bin/json2llm" <<'WRAPPER'
    #!${stdenv.shell}
    exec @JSON2LLM@ "$@" -b local
    WRAPPER
    substituteInPlace "$out/bin/json2llm" --replace-fail '@JSON2LLM@' "$out/libexec/json2llm"
    chmod 755 "$out/bin/json2llm"
  '';
  meta = {
    description = "Go json2dir implementation with a deterministic local backend";
    homepage = "https://github.com/lcensies/json2llm";
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
