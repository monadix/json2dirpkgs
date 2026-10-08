{
  lib,
  stdenvNoCC,
  makeWrapper,
  coreutils,
  bash,
  algol68g,
  j2dSources,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-algol68";
  version = "2026-10-07";
  src = j2dSources.json2dir-algol68;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 json2dir "$out/share/$pname/json2dir"
    install -Dm644 json2dir.a68 "$out/share/$pname/json2dir.a68"
    substituteInPlace "$out/share/$pname/json2dir" \
      --replace-fail '"$script_dir/json2dir.a68" --exit' \
      '"$script_dir/json2dir.a68" --heap 100000000 --exit'
    patchShebangs "$out/share/$pname"
    mkdir -p "$out/bin"
    makeWrapper "$out/share/$pname/json2dir" "$out/bin/$pname" \
      --set JSON2DIR_A68G "${algol68g}/bin/a68g" \
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
    description = "ALGOL 68 implementation of json2dir using Algol 68 Genie";
    homepage = "https://github.com/json2dir-guru/json2dir-algol68";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-algol68";
  };
}
