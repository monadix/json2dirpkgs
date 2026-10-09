{
  lib,
  stdenvNoCC,
  bash,
  j2dSources,
  sqlite,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-sqlite";
  version = "2026-10-08";
  src = j2dSources.json2dir-sqlite;

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.sql "$out/share/$pname/json2dir.sql"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    cat > "$out/bin/$pname" <<EOF2
    #!${bash}/bin/bash
    exec "${sqlite}/bin/sqlite3" -bail :memory: ".read $out/share/$pname/json2dir.sql" "\$@"
    EOF2
    chmod +x "$out/bin/$pname"
    runHook postInstall
  '';

  meta = {
    description = "json2dir as SQL using SQLite JSON1 and fileio functions";
    homepage = "https://github.com/json2dir-guru/json2dir-sqlite";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-sqlite";
  };
}
