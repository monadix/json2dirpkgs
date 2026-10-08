{
  stdenvNoCC,
  fetchurl,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "gleam-stdlib";
  version = "1.0.5";
  src = fetchurl {
    url = "https://repo.hex.pm/tarballs/gleam_stdlib-1.0.5.tar";
    hash = "sha256-zuW2wHaoW0X2DFhfQxbGPsi3EnwRnVc4w5WKnE1QQE4=";
  };
  dontUnpack = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p "$out"
    tar -xOf "$src" contents.tar.gz | tar -xz -C "$out"
  '';
  meta = {
    description = "Gleam standard library source package, locked by json2dir-gleam";
    homepage = "https://hex.pm/packages/gleam_stdlib";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
