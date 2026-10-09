{
  lib,
  stdenv,
  pkgsStatic,
  linuxPackages_latest,
  makeModulesClosure,
  makeInitrd,
  runCommand,
  writeScript,
  kmod,
  # qemu_test forces 9p ownership to root, breaking ordinary-user permissions.
  qemu,
  python3,
  makeWrapper,
  nukeReferences,
  j2dSources,
}:
let
  pname = "json2dir-syscall";
  kernel = linuxPackages_latest.kernel;
  source = j2dSources.${pname};
  module = stdenv.mkDerivation {
    name = "${pname}-module-${kernel.modDirVersion}";
    src = source;
    nativeBuildInputs = kernel.moduleBuildDependencies;
    makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];
    installPhase = ''
      mkdir -p $out
      cp json2dir.ko $out/
    '';
    # Kernel diagnostic strings otherwise retain the entire header/build tree
    # in the initramfs closure. The module needs only the matching guest kernel.
    postFixup = "${nukeReferences}/bin/nuke-refs $out/json2dir.ko";
  };
  client = pkgsStatic.stdenv.mkDerivation {
    name = "${pname}-client";
    src = source;
    dontConfigure = true;
    buildPhase = "$CC -O2 -Wall -Wextra testing/client.c -o client";
    installPhase = "mkdir -p $out/bin; cp client $out/bin/client";
  };
  modules = makeModulesClosure {
    kernel = kernel.modules;
    rootModules = [
      "9p"
      "9pnet_virtio"
      "virtio_pci"
    ];
    firmware = runCommand "empty-firmware" { } "mkdir -p $out";
  };
  init = writeScript "${pname}-init" (
    builtins.replaceStrings [ "@kmod@" ] [ "${kmod}" ] (builtins.readFile ./guest-init)
  );
  initrd = makeInitrd {
    name = "${pname}-initrd";
    contents = [
      {
        object = "${pkgsStatic.busybox}/bin/busybox";
        symlink = "/bin/busybox";
      }
      {
        object = "${client}/bin/client";
        symlink = "/client";
      }
      {
        object = "${module}/json2dir.ko";
        symlink = "/json2dir.ko";
      }
      {
        object = "${modules}/lib";
        symlink = "/lib";
      }
      {
        object = init;
        symlink = "/init";
      }
      {
        object = kmod;
        symlink = "/kmod";
      }
    ];
  };
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-${builtins.substring 0 7 source.rev}";
  src = source;
  nativeBuildInputs = [ makeWrapper ];
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cp ${./vm.py} $out/libexec/vm.py
    substituteInPlace $out/libexec/vm.py \
      --replace-fail '@upstream@' '${source}' \
      --replace-fail '@initrd@' '${initrd}' \
      --replace-fail '@kernel@' '${kernel}' \
      --replace-fail '@qemu@' '${qemu}'
    makeWrapper ${python3}/bin/python3 $out/bin/${pname} \
      --add-flags "$out/libexec/vm.py"
  '';
  meta = {
    description = "Kernel json2dir module in an isolated QEMU TCG guest with 9p filesystem transport";
    homepage = "https://github.com/Noiidor/json2dir-syscall";
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
