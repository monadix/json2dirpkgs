{
  stdenvNoCC,
  lib,
  fetchurl,
}:
stdenvNoCC.mkDerivation {
  pname = "ironspring-pli";
  version = "1.4.1";
  src = fetchurl {
    url = "http://www.iron-spring.com/pli-1.4.1.tgz";
    hash = "sha256-H1invnKwMVjC4fl/b6rkGipgEYg5xmcYYZkHWITm+Hg=";
  };

  sourceRoot = "pli-1.4.1";
  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/bin" "$out/lib" "$out/share/doc/ironspring-pli"
    install -m755 plic "$out/plic"
    ln -s ../plic "$out/bin/plic"
    install -m644 lib/libprf.a "$out/lib/libprf.a"
    install -m644 readme_linux.html "$out/share/doc/ironspring-pli/"
    install -m644 lgpl.html "$out/share/doc/ironspring-pli/"
  '';

  meta = {
    description = "Iron Spring PL/I compiler and static PL/I runtime";
    homepage = "https://www.iron-spring.com/";
    license = [
      {
        shortName = "iron-spring-pli";
        fullName = "Iron Spring PL/I Compiler License";
        url = "https://www.iron-spring.com/readme_linux.html";
        free = false;
        redistributable = true;
      }
      lib.licenses.lgpl21Plus
    ];
    mainProgram = "plic";
    platforms = [ "x86_64-linux" ];
  };
}
