{
  lib,
  stdenvNoCC,
  makeWrapper,
  j2dSources,
  beam,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-erlang";
  version = "2026-10-07";
  src = j2dSources.json2dir-erlang;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.erl "$out/share/$pname/json2dir.erl"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${beam.packages.erlang.erlang}/bin/escript" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/json2dir.erl"
    runHook postInstall
  '';

  meta = {
    description = "Erlang/OTP escript, kernel/stdlib only, hand-written binary-matching JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-erlang";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-erlang";
  };
}
