{
  stdenv,
  lib,
  fetchFromGitHub,
  flex,
}:
stdenv.mkDerivation {
  pname = "ook-runtime";
  version = "525d346";
  src = fetchFromGitHub {
    owner = "rdebath";
    repo = "Brainfuck";
    rev = "525d346c006ea30dfc847ae3b32ed44d44fa9925";
    hash = "sha256-y/mCTGf9aNe7GPLjLVYfMWy8cv0fHnhzgZZkO+V5apo=";
  };
  nativeBuildInputs = [ flex ];
  buildPhase = ''
    runHook preBuild
    flex -o ook.c extras/ook.l
    $CC -O2 -o ook ook.c
    runHook postBuild
  '';
  installPhase = ''
    install -Dm755 ook "$out/bin/ook"
  '';
  meta = {
    description = "Ook interpreter from the pinned Brainfuck tools source";
    homepage = "https://github.com/rdebath/Brainfuck";
    license = lib.licenses.gpl2Only;
    mainProgram = "ook";
    platforms = [ "x86_64-linux" ];
  };
}
