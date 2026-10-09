# json2dirpkgs

Nix packages for json2dir implementations, using Nixpkgs builders and a shared,
pinned dependency set. The initial target is `x86_64-linux`.

The package inventory is recorded in `data/selection.json`, alongside historical
tester results from Awesome. The first packaging wave selected implementations
with zero failures and skips; the inventory now includes the remaining
implementations, including those with known failures. Sources are pinned
separately in `sources/`. Fresh validation of packaged programs is recorded
separately; a historical result does not establish their current behavior.
The recorded local validation covers 158 of 160 packages. Malbolge and Taxi were
intentionally skipped; the report records these exclusions rather than claiming
complete local coverage.

## Use

```sh
nix build .#json2dir-python
./result/bin/json2dir-python < document.json
```

Each package installs its own name in `bin/`. It writes into the caller's current
directory, following that implementation's CLI. Interpreted implementations
include their interpreter in the runtime closure; compiled implementations keep
their original compiler and build approach.
Swift uses a shared standard library because the pinned Nixpkgs toolchain omits
the static Swift runtime; account for this difference when comparing benchmarks
with the original tester build.
`json2dir-syscall` loads its module only inside a fresh QEMU TCG guest, using the
matching pinned kernel and 9p access to the caller's directory and its siblings.
The guest writer uses the caller's uid, gid and umask. Its benchmarks include VM
startup and filesystem transport, as in the tester's kernel-module adapter.

Prebuilt packages are available from the public binary cache at
<https://json2dirpkgs.cachix.org>. Add these settings to `nix.conf` to use it:

```conf
extra-substituters = https://json2dirpkgs.cachix.org
extra-trusted-public-keys = json2dirpkgs.cachix.org-1:65NBBfjvYOT+/ebY7XFg/XXSWTTsrCvGJuEhEVcRSGM=
```

## Layout

- `pkgs/by-name/`: individual implementation recipes.
- `pkgs/development/`: shared dependencies absent from Nixpkgs.
- `sources/`: upstream repository, revision and archive hash for each package.
- `data/`: selection provenance and generated validation/size reports.
- `scripts/`: build, validation and storage accounting tools.

Nixpkgs supplies dependencies whenever possible. Dependencies already served by
its binary cache can be reused by a project cache. Build and runtime closures are
different: the size report counts package outputs and their runtime dependencies,
including their shared union, rather than adding overlapping closures together.

## Verification and size accounting

The tools under `scripts/` run outside timed benchmarks. Build failures and
validation failures must remain visible in generated reports. Runtime closure
sizes describe uncompressed NAR data; an estimate of additional cache storage
must account for compression and paths already served by the Nixpkgs cache.

```sh
python3 scripts/measure.py --jobs 2
nix develop --command python3 scripts/validate.py --tester ../json2dir-tester
python3 scripts/cache_size.py
```

`measure.py` writes package output sizes, individual closures and their shared
union to `data/sizes.json`. Its report includes failed builds. `validate.py`
copies the tester into the ignored work directory and replaces only its command
manifests with packaged executables; it preserves each implementation's declared
suite restrictions and timeouts, runs all applicable cases, and writes
`data/validation.json`. The development shell provides Python
and the .NET 10 SDK from the same pinned Nixpkgs.
The report hashes the copied tester snapshot to identify uncommitted changes too.
The packaged commands start with an empty search path, so undeclared runtime
tools installed on the host cannot silently satisfy wrapper dependencies.
`cache_size.py` checks the official cache and compresses the actual NAR streams
for remaining paths using XZ. It writes `data/cache-size.json`; this measures
compressed data with the stated codec, rather than promising exact Cachix usage.
Pass `--previous <report>` to reuse XZ measurements for unchanged immutable store
paths while checking their current upstream cache availability again.

Explicit package names passed to `measure.py` may also name shared dependencies
from `pkgs/development/`. Measure those separately when estimating storage for
compiler binaries used to rebuild implementations; they are often absent from
the implementations' runtime closures.

GitHub Actions publishes package changes on `main` to the `json2dirpkgs` Cachix
cache. See [cache publishing](docs/cache.md) for credentials and build behavior.
