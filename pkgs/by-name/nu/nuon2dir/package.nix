{
  lib,
  stdenvNoCC,
  makeWrapper,
  coreutils,
  bash,
  nushell,
  j2dSources,
}:

stdenvNoCC.mkDerivation {
  pname = "nuon2dir";
  version = "2026-10-07";
  src = j2dSources.nuon2dir;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/json2dir "$out/share/$pname/bin/json2dir"
    install -Dm644 bin/json2dir.nu "$out/share/$pname/bin/json2dir.nu"
    install -Dm644 nuon2dir.nu "$out/share/$pname/nuon2dir.nu"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    patchShebangs "$out/share/$pname"
    mkdir -p "$out/bin"
    makeWrapper "$out/share/$pname/bin/json2dir" "$out/bin/$pname" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          bash
          nushell
        ]
      }"
    runHook postInstall
  '';

  meta = {
    description = "Nushell module that turns a native record into a directory tree; its strict-JSON stdin wrapper";
    homepage = "https://github.com/monadix/nuon2dir";
    license = lib.licenses.isc;
    platforms = [ "x86_64-linux" ];
    mainProgram = "nuon2dir";
  };
}
