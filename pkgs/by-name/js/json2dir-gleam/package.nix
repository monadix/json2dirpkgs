{
  lib,
  stdenv,
  j2dSources,
  makeWrapper,
  gleam,
  erlang,
  coreutils,
  gleam-stdlib,
}:
let
  pname = "json2dir-gleam";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-beb7f4f";
  src = j2dSources."json2dir-gleam";
  nativeBuildInputs = [
    makeWrapper
    gleam
    erlang
  ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    cp -r . "$TMPDIR/project"
    cd "$TMPDIR/project"
    substituteInPlace gleam.toml \
      --replace-fail 'gleam_stdlib = ">= 0.44.0 and < 2.0.0"' \
                     'gleam_stdlib = { path = "${gleam-stdlib}" }'
    rm -f manifest.toml
    gleam export erlang-shipment
  '';
  installPhase = ''
    mkdir -p "$out/share/build"
    cp -r "$TMPDIR/project/build/erlang-shipment" "$out/share/build/"
    makeWrapper "$out/share/build/erlang-shipment/entrypoint.sh" "$out/bin/${pname}" \
      --prefix PATH : ${
        lib.makeBinPath [
          erlang
          coreutils
        ]
      } \
      --add-flags run
  '';
  meta = {
    description = "Gleam on the BEAM (Erlang/OTP), gleam_stdlib only, hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-gleam";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
