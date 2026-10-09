{
  lib,
  stdenvNoCC,
  makeWrapper,
  bash,
  gnugrep,
  findutils,
  gnused,
  coreutils,
  j2dSources,
  ansible,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-ansible";
  version = "2026-10-08";
  src = j2dSources.json2dir-ansible;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share/$pname" "$out/bin" "$out/libexec"
    cp -R "$src/." "$out/share/$pname/"
    patchShebangs "$out/share/$pname"
    cat > "$out/libexec/ansible-playbook" <<EOF
    #!${bash}/bin/bash
    export PATH="${
      lib.makeBinPath [
        coreutils
        bash
        gnugrep
        findutils
        gnused
      ]
    }"
    exec "${ansible}/bin/ansible-playbook" "\$@"
    EOF
    chmod +x "$out/libexec/ansible-playbook"
    makeWrapper "$out/share/$pname/json2dir" "$out/bin/$pname" \
      --set ANSIBLE_PLAYBOOK "$out/libexec/ansible-playbook" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          bash
          gnugrep
          findutils
          gnused
        ]
      }"

    runHook postInstall
  '';

  meta = {
    description = "json2dir-ansible upstream implementation";
    homepage = "https://github.com/json2dir-guru/json2dir-ansible";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-ansible";
  };
}
