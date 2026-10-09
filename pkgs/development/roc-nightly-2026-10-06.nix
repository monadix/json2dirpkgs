{
  lib,
  stdenvNoCC,
  fetchurl,
  gnutar,
  zstd,
}:
stdenvNoCC.mkDerivation {
  pname = "roc-nightly";
  version = "2026-10-06-c34079d";
  src = fetchurl {
    url = "https://github.com/roc-lang/nightlies/releases/download/nightly-2026-10-06-c34079d/roc_nightly-linux_x86_64-2026-10-06-c34079d.tar.gz";
    hash = "sha256-Eb9cc7geUXrigH9CEf6emW9I+HposehbgsSuLGSZpdY=";
  };
  basicCli = fetchurl {
    url = "https://github.com/roc-lang/basic-cli/releases/download/0.24.0/AEjfyaMFFbh8FJrkkHJy68riVNPr3Qp6c6PawWQjBwMH.tar.zst";
    hash = "sha256-UN3FXbkwjWFcgDSif53HGC1ml2SEsdHEbi2ea82cFgw=";
  };
  http = fetchurl {
    url = "https://github.com/roc-lang/http/releases/download/1.0.0/6ZUwqYhCS8PU9Mo6MF7oV82ET2o7KYb57CLKDq4cq4sS.tar.zst";
    hash = "sha256-6e+qlQ5y9vds326vAEJFcvppsEumEnMjV6wEU2ePArQ=";
  };
  nativeBuildInputs = [
    gnutar
    zstd
  ];
  dontUnpack = true;
  installPhase = ''
    mkdir -p "$out/bin" "$out/share/roc/basic-cli" "$out/share/roc/http"
    tar -xzf "$src" -C "$TMPDIR" --strip-components=1
    install -m755 "$TMPDIR/roc" "$out/bin/roc"
    tar --zstd -xf "$basicCli" -C "$out/share/roc/basic-cli"
    tar --zstd -xf "$http" -C "$out/share/roc/http"
  '';
  meta = {
    description = "Pinned Roc nightly compiler and its basic-cli dependencies";
    homepage = "https://github.com/roc-lang/nightlies/releases/tag/nightly-2026-10-06-c34079d";
    license = with lib.licenses; [
      mit
      asl20
    ];
    platforms = [ "x86_64-linux" ];
  };
}
