{
  lib,
  stdenvNoCC,
  makeWrapper,
  j2dSources,
  neovim,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-neovim";
  version = "2026-10-07";
  src = j2dSources.json2dir-neovim;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.lua "$out/share/$pname/json2dir.lua"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${neovim}/bin/nvim" "$out/bin/$pname" \
      --add-flags "--clean --headless -l $out/share/$pname/json2dir.lua"
    runHook postInstall
  '';

  meta = {
    description = "Lua inside Neovim (nvim -l), vim.uv for all I/O, hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-neovim";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-neovim";
  };
}
