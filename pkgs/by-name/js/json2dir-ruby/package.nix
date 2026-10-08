{
  lib,
  stdenvNoCC,
  makeWrapper,
  j2dSources,
  ruby,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-ruby";
  version = "2026-10-07";
  src = j2dSources.json2dir-ruby;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.rb "$out/share/$pname/json2dir.rb"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${ruby}/bin/ruby" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/json2dir.rb"
    runHook postInstall
  '';

  meta = {
    description = "Plain Ruby, stdlib only, one file";
    homepage = "https://github.com/json2dir-guru/json2dir-ruby";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-ruby";
  };
}
