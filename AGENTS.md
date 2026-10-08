# Packaging

Read README.md, the selected implementation's upstream README and its tester
manifest before changing a package. Keep upstream implementation behavior and
compiler identity intact. Prefer dependencies from the pinned Nixpkgs; define
missing dependencies once under pkgs/development.

Packages belong in pkgs/by-name/<first two letters>/<name>/package.nix, with
source pins in sources/<name>.json. Use standard Nixpkgs builders, fixed hashes,
and an executable named after the package in $out/bin. Builds must work without
network access. Wrappers must preserve arguments, stdin and the caller's working
directory. Build changed packages and test their packaged executables.

Do not claim a package passes the full tester suite from its selection record;
that record describes an earlier upstream run. Record fresh validation and
actual measured sizes separately.
