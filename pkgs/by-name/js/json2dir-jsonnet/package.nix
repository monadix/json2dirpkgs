{
  lib,
  stdenvNoCC,
  makeWrapper,
  coreutils,
  bash,
  j2dSources,
  go-jsonnet,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-jsonnet";
  version = "2026-10-07";
  src = j2dSources.json2dir-jsonnet;
  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace json2dir.jsonnet \
      --replace-fail 'local doc = std.parseJson(text);' \
      "local doc = if has(text, nul) then fail('input contains a raw NUL byte') else std.parseJson(text);"
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 json2dir "$out/share/$pname/json2dir"
    install -Dm644 json2dir.jsonnet "$out/share/$pname/json2dir.jsonnet"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    patchShebangs "$out/share/$pname"
    mkdir -p "$out/bin"
    makeWrapper "$out/share/$pname/json2dir" "$out/bin/$pname" \
      --set JSON2DIR_JSONNET "${go-jsonnet}/bin/jsonnet" \
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
    description = "Jsonnet evaluator (go-jsonnet, std only) emitting a shell script, plus a POSIX sh launcher";
    homepage = "https://github.com/json2dir-guru/json2dir-jsonnet";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-jsonnet";
  };
}
