{
  stdenv,
  lib,
  fetchFromGitHub,
  gnumake,
  coreutils,
  luajit,
  tinycc,
  lightning,
}:
stdenv.mkDerivation {
  pname = "tritium";
  version = "525d346";
  src = fetchFromGitHub {
    owner = "rdebath";
    repo = "Brainfuck";
    rev = "525d346c006ea30dfc847ae3b32ed44d44fa9925";
    hash = "sha256-y/mCTGf9aNe7GPLjLVYfMWy8cv0fHnhzgZZkO+V5apo=";
  };

  nativeBuildInputs = [
    gnumake
    coreutils
    luajit
  ];
  buildInputs = [
    tinycc
    lightning
  ];

  postPatch = ''
    substituteInPlace tritium/md5.h \
      --replace-fail 'void MD5Init ();' 'void MD5Init (MD5_CTX *);' \
      --replace-fail 'void MD5Update ();' 'void MD5Update (MD5_CTX *, unsigned char *, unsigned int);' \
      --replace-fail 'void MD5Final ();' 'void MD5Final (MD5_CTX *);'
    substituteInPlace tritium/md5.c \
      --replace-fail 'static void Transform ();' 'static void Transform (UINT4 *, UINT4 *);'
    substituteInPlace tools/dynasm/dynasm \
      --replace-fail 'LUA=/usr/bin/luajit' 'LUA=${luajit}/bin/luajit'

    # GNUmakefile's feature probes use /usr/include/dlfcn.h, which does not
    # exist in a Nix build. Probe through the compiler's configured include
    # path instead so libdl-backed TCC remains enabled.
    substituteInPlace tritium/GNUmakefile \
      --replace-fail 'ifneq ($(wildcard /usr/include/dlfcn.h),)' 'ifneq ($(shell printf "#include <dlfcn.h>\\nint main(void) { return 0; }\\n" | $(CC) -x c - -o /dev/null >/dev/null 2>&1 && echo yes),)'
  '';

  buildPhase = ''
    make -C tritium all CC=gcc
  '';

  installPhase = ''
    install -Dm755 tritium/bfi.out "$out/bin/bfi"
  '';

  meta = {
    description = "Tritium Brainfuck interpreter";
    homepage = "https://github.com/rdebath/Brainfuck";
    license = lib.licenses.gpl2Only;
    mainProgram = "bfi";
    platforms = [ "x86_64-linux" ];
  };
}
