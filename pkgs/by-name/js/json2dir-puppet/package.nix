{
  lib,
  stdenvNoCC,
  makeWrapper,
  coreutils,
  gnused,
  bash,
  j2dSources,
  openvox,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-puppet";
  version = "2026-10-07";
  src = j2dSources.json2dir-puppet;
  postPatch = ''
    sed -i 's/^mask=$(umask)$/mask=$(umask)\numask 022/' json2dir
  '';
  nativeBuildInputs = [
    makeWrapper
    gnused
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 json2dir "$out/share/$pname/json2dir"
    install -Dm644 json2dir.pp "$out/share/$pname/json2dir.pp"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    patchShebangs "$out/share/$pname"
    mkdir -p "$out/bin"
    makeWrapper "$out/share/$pname/json2dir" "$out/bin/$pname" \
      --set JSON2DIR_PUPPET "${openvox}/bin/puppet" \
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
    description = "Puppet language manifest (hand-written JSON parser, file resources) run by puppet apply (openvox-agent 8.29.0), plus a POSIX sh launcher";
    homepage = "https://github.com/json2dir-guru/json2dir-puppet";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-puppet";
  };
}
