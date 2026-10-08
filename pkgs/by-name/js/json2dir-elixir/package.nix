{
  lib,
  stdenvNoCC,
  makeWrapper,
  beam,
  j2dSources,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-elixir";
  version = "2026-10-07";
  src = j2dSources.json2dir-elixir;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.exs "$out/share/$pname/json2dir.exs"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${beam.packages.erlang.elixir}/bin/elixir" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/json2dir.exs" \
      --prefix PATH : "${lib.makeBinPath [ beam.packages.erlang.erlang ]}"
    runHook postInstall
  '';

  meta = {
    description = "Elixir on the BEAM (Erlang/OTP), Elixir + OTP stdlib only, hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-elixir";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-elixir";
  };
}
