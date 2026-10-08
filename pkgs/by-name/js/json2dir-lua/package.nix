{
  lib,
  stdenvNoCC,
  makeWrapper,
  coreutils,
  bash,
  j2dSources,
  lua5_4,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-lua";
  version = "2026-10-07";
  src = j2dSources.json2dir-lua;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 json2dir "$out/share/$pname/json2dir"
    install -Dm644 json2dir.lua "$out/share/$pname/json2dir.lua"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    patchShebangs "$out/share/$pname"
    mkdir -p "$out/bin"
    makeWrapper "$out/share/$pname/json2dir" "$out/bin/$pname" \
      --set JSON2DIR_LUA "${lua5_4}/bin/lua" \
      --set JSON2DIR_SHELL "${bash}/bin/bash" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          bash
        ]
      }"
    runHook postInstall
  '';

  meta = {
    description = "json2dir in Lua 5.4 (launcher approach)";
    homepage = "https://github.com/json2dir-guru/json2dir-lua";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-lua";
  };
}
