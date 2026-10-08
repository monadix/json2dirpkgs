{
  lib,
  stdenvNoCC,
  makeWrapper,
  luaPackages,
  luajit,
  j2dSources,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-fennel";
  version = "2026-10-07";
  src = j2dSources.json2dir-fennel;
  nativeBuildInputs = [
    makeWrapper
    luaPackages.fennel
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p build
    fennel --compile json2dir.fnl > build/json2dir.lua
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 build/json2dir.lua "$out/share/$pname/json2dir.lua"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${luajit}/bin/luajit" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/json2dir.lua"
    runHook postInstall
  '';

  meta = {
    description = "Fennel compiled to Lua, run on LuaJIT: hand-written JSON parser, libc via the built-in FFI";
    homepage = "https://github.com/json2dir-guru/json2dir-fennel";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-fennel";
  };
}
