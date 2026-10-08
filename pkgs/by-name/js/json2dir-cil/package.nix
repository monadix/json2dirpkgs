{
  lib,
  stdenv,
  j2dSources,
  makeWrapper,
  dotnet-ilasm,
  dotnetCorePackages,
}:
let
  pname = "json2dir-cil";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-6326b5e";
  src = j2dSources."json2dir-cil";
  nativeBuildInputs = [
    makeWrapper
    dotnet-ilasm
  ];
  buildInputs = [ dotnetCorePackages.runtime_8_0 ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out"
    ${dotnet-ilasm}/bin/ilasm -dll -quiet -output="$TMPDIR/out/json2dir.dll" json2dir.il
    cp json2dir.runtimeconfig.json "$TMPDIR/out/"
  '';
  installPhase = ''
    mkdir -p "$out/lib"
    cp -r "$TMPDIR/out"/. "$out/lib/"
    makeWrapper ${dotnetCorePackages.runtime_8_0}/bin/dotnet "$out/bin/${pname}" \
      --add-flags "$out/lib/json2dir.dll"
  '';
  meta = {
    description = "Hand-written CIL (.NET IL assembly), assembled with ilasm, hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-cil";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
