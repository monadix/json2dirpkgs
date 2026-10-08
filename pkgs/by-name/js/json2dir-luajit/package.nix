{
  lib,
  stdenvNoCC,
  makeWrapper,
  j2dSources,
  luajit,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-luajit";
  version = "2026-10-07";
  src = j2dSources.json2dir-luajit;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.lua "$out/share/$pname/json2dir.lua"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${luajit}/bin/luajit" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/json2dir.lua"
    runHook postInstall
  '';

  meta = {
    description = "Pure LuaJIT, one file: hand-written JSON parser, libc via the built-in FFI";
    homepage = "https://github.com/json2dir-guru/json2dir-luajit";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-luajit";
  };
}
