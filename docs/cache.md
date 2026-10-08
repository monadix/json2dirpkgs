# Binary cache publishing

The `Build and cache` workflow publishes to the public `json2dirpkgs` Cachix
cache on pushes to `main` that change package recipes, shared dependencies,
source pins, the selection, the flake or the workflow itself. It can also be
started manually on `main` from GitHub Actions.

Create a **write token for this cache** in Cachix and save it as the repository
Actions secret `CACHIX_AUTH_TOKEN` (Settings → Secrets and variables → Actions).
An account admin token, local Cachix login and a GitHub token inside the workflow
are unnecessary. This assumes Cachix manages the cache's signing key.

The workflow discovers all shared tools and selected implementations on every
run. Shared tools build first so implementation jobs can reuse their cached
outputs. Each matrix has four concurrent jobs; a failing package does not cancel
the others. Every selected implementation is checked, with unchanged outputs
downloaded from Cachix or the official Nixpkgs cache instead of rebuilt.

Uploads explicitly include the requested outputs and their runtime closures.
Automatic uploading of intermediate build inputs is disabled, keeping storage
comparable to the implementation-plus-shared-tool estimate in
`data/dependency-cache-size.json` and `data/cache-size.json`. New versions still
accumulate in the cache; configure retention in Cachix as needed.

To seed the cache from already built local outputs, provide the same write token
to the Cachix CLI privately, then run from this repository:

```sh
python3 -c 'import json; print("\n".join(sorted({p for f in ["data/sizes.json", "data/dependency-sizes.json"] for i in json.load(open(f))["packages"] for p in i["outputs"]})))' \
  | nix shell --inputs-from . nixpkgs#cachix --command cachix push json2dirpkgs
```

The workflow publishes builds; it does not rerun the conformance suite or update
the committed measurement reports. Those tools are described in the README.
