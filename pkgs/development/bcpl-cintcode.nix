{
  stdenv,
  lib,
  fetchFromGitHub,
  gnumake,
}:
stdenv.mkDerivation {
  pname = "bcpl-cintcode";
  version = "2015-07-27";
  src = fetchFromGitHub {
    owner = "8l";
    repo = "bcpl";
    rev = "bad6eec7682368ca7ded866005cc4a47e8a67569";
    hash = "sha256-0HTRdfgBm/pdyrT6ykl+b8TGoz43ggDDbAl02k9tdHQ=";
  };

  nativeBuildInputs = [ gnumake ];

  postPatch = ''
    substituteInPlace cintcode/sysc/cfuncs64.c \
      --replace-fail '  int ipaddr = -1;' '  struct in_addr ipaddr;' \
      --replace-fail 'inet_aton(hname, &ipaddr)) return ntohl(ipaddr);' \
        'inet_aton(hname, &ipaddr)) return ntohl(ipaddr.s_addr);'
  '';

  buildPhase = ''
    export BCPL64ROOT="$PWD/cintcode"
    export BCPL64PATH="$BCPL64ROOT/cin64"
    export BCPL64HDRS="$BCPL64ROOT/g"
    export BCPLHDRS="$BCPL64ROOT/g"
    export PATH="$BCPL64ROOT/bin:$PATH"
    mkdir -p cintcode/obj
    make -C cintcode 'CC=gcc -O4 -DforLinux64' \
      'CFLAGS=-fcommon -fno-strict-aliasing -include arpa/inet.h' sys64
  '';

  installPhase = ''
    mkdir -p "$out/BCPL/cintcode"
    mkdir -p "$out/BCPL/cintcode/bin"
    cp -a cintcode/bin/cintsys64 "$out/BCPL/cintcode/bin/"
    cp -a cintcode/cin64 cintcode/g "$out/BCPL/cintcode/"
  '';

  meta = {
    description = "Martin Richards' Cintcode BCPL distribution";
    homepage = "https://github.com/8l/bcpl";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
