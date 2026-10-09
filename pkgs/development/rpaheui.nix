{
  lib,
  stdenv,
  fetchFromGitHub,
  pypy2,
  gnumake,
  pkg-config,
  libffi,
}:
stdenv.mkDerivation {
  pname = "rpaheui";
  version = "1.2.5-pypy-7.3.19";
  src = fetchFromGitHub {
    owner = "aheui";
    repo = "rpaheui";
    rev = "ef0507a8dbd748c3720baa7ae8e486fdcdc82c13";
    hash = "sha256-nzfOPn5+Vb/Y5q0QLiP7llH7xIcUEuLsyfMi898eEkc=";
  };
  nativeBuildInputs = [
    gnumake
    pypy2
    pkg-config
  ];
  buildInputs = [ libffi ];
  dontConfigure = true;
  postUnpack = ''
    tar -xjf ${pypy2.src}
  '';
  buildPhase = ''
    runHook preBuild
    pypy_source=$(find "$NIX_BUILD_TOP" -mindepth 1 -maxdepth 2 -type d -name 'pypy*-src' -print -quit)
    test -n "$pypy_source"
    PYTHONPATH="$pypy_source" make rpaheui-c \
      RPYTHON="${pypy2}/bin/pypy $pypy_source/rpython/bin/rpython" \
      RPYTHONFLAGS="--opt=jit"
    runHook postBuild
  '';
  installPhase = ''
    install -Dm755 rpaheui-c "$out/bin/rpaheui-c"
  '';
  meta = {
    description = "RPython JIT Aheui interpreter";
    homepage = "https://github.com/aheui/rpaheui";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "rpaheui-c";
  };
}
