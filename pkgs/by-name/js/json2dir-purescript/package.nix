{
  lib,
  stdenv,
  j2dSources,
  makeWrapper,
  purescript,
  esbuild,
  nodejs,
  purescript-package-set,
}:
let
  pname = "json2dir-purescript";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-dd12e82";
  src = j2dSources."json2dir-purescript";
  nativeBuildInputs = [
    makeWrapper
    purescript
    esbuild
  ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p .spago/packages "$TMPDIR/out"
    cp -R ${purescript-package-set}/. .spago/packages/
    purs compile 'src/**/*.purs' '.spago/packages/*/*/src/**/*.purs' --output "$TMPDIR/output"
    cat > "$TMPDIR/entry.js" <<EOF
    import { main } from "$TMPDIR/output/Main/index.js";
    main();
    EOF
    esbuild "$TMPDIR/entry.js" --bundle --platform=node --format=esm --outfile="$TMPDIR/out/json2dir.js"
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm644 "$TMPDIR/out/json2dir.js" "$out/share/json2dir.js"
    for license in ${purescript-package-set}/*/*/LICENSE; do
      relative="''${license#${purescript-package-set}/}"
      install -Dm644 "$license" "$out/share/licenses/${pname}/$relative"
    done
    makeWrapper ${nodejs}/bin/node "$out/bin/json2dir-purescript" --add-flags "$out/share/json2dir.js"
  '';
  meta = {
    description = "PureScript compiled to JavaScript and run on Node.js, using its standard core libraries.";
    homepage = "https://github.com/json2dir-guru/json2dir-purescript";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
