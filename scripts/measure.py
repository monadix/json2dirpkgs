#!/usr/bin/env python3
"""Build selected packages and measure their outputs and deduplicated runtime closures."""

import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
import datetime
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def normalize_info(info):
    # Nix versions expose path-info either as an array or as an object keyed by path.
    if isinstance(info, dict):
        return {path: dict(value, path=path) for path, value in info.items()}
    return {item["path"]: item for item in info}


def summarize(packages):
    union = {}
    outputs = {}
    for item in packages:
        for path, info in item.get("closure", {}).items():
            union[path] = info
        for path in item.get("outputs", []):
            if path in item.get("closure", {}):
                outputs[path] = item["closure"][path]
    return {
        "packageOutputNarBytes": sum(p["narSize"] for p in outputs.values()),
        "runtimeUnionNarBytes": sum(p["narSize"] for p in union.values()),
        "runtimeUnionPaths": len(union),
        "successfulPackages": sum(p["status"] == "built" for p in packages),
        "failedPackages": sum(p["status"] != "built" for p in packages),
    }, union


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("names", nargs="*")
    parser.add_argument("--jobs", type=int, default=2)
    parser.add_argument("--out", type=Path, default=ROOT / "data/sizes.json")
    args = parser.parse_args()
    if args.jobs < 1:
        parser.error("--jobs must be positive")
    selection = json.loads((ROOT / "data/selection.json").read_text())
    selected = {p["name"]: p for p in selection["implementations"]}
    dependencies = {p.stem for p in (ROOT / "pkgs/development").glob("*.nix")}
    names = args.names or sorted(selected)
    if set(names) - (selected.keys() | dependencies) or len(names) != len(set(names)):
        parser.error("unknown or duplicate package")
    logs = ROOT / ".work/build-logs"
    logs.mkdir(parents=True, exist_ok=True)

    def build(name):
        log = logs / (name + ".log")
        print("build " + name, flush=True)
        with log.open("w") as stderr:
            result = subprocess.run(
                ["nix", "build", f"{ROOT}#{name}", "--no-link", "--print-out-paths"],
                text=True, stdout=subprocess.PIPE, stderr=stderr,
            )
        pin = ROOT / "sources" / (name + ".json")
        item = {"name": name, "kind": "implementation" if name in selected else "shared-dependency",
                "status": "build-failed", "log": str(log.relative_to(ROOT)),
                "source": json.loads(pin.read_text()) if pin.exists() else None}
        if result.returncode:
            item["reason"] = log.read_text()[-4000:]
            return item
        paths = result.stdout.splitlines()
        if not paths or any(not path.startswith("/nix/store/") for path in paths):
            item["reason"] = "build returned no valid store paths"
            return item
        try:
            closure = normalize_info(json.loads(subprocess.check_output(
                ["nix", "path-info", "--recursive", "--json", *paths], text=True)))
        except (subprocess.CalledProcessError, ValueError) as error:
            item["status"] = "measurement-failed"
            item["reason"] = str(error)
            return item
        item.update(status="built", outputs=paths, closure=closure,
                    outputNarBytes=sum(closure[p]["narSize"] for p in paths),
                    closureNarBytes=sum(p["narSize"] for p in closure.values()))
        print("built " + name, flush=True)
        return item

    report = {"schemaVersion": 1, "created": datetime.datetime.now(datetime.timezone.utc).isoformat(),
              "system": "x86_64-linux", "nixpkgs": json.loads((ROOT / "flake.lock").read_text())["nodes"]["nixpkgs"]["locked"],
              "requestedPackages": names, "complete": False, "units": "uncompressed NAR bytes",
              "packages": []}
    args.out.parent.mkdir(parents=True, exist_ok=True)

    def checkpoint():
        report["summary"], report["runtimeUnion"] = summarize(report["packages"])
        temporary = args.out.with_suffix(".tmp")
        temporary.write_text(json.dumps(report, indent=2) + "\n")
        temporary.replace(args.out)

    checkpoint()
    with ThreadPoolExecutor(max_workers=args.jobs) as executor:
        futures = [executor.submit(build, name) for name in names]
        for future in as_completed(futures):
            report["packages"].append(future.result())
            report["packages"].sort(key=lambda item: item["name"])
            checkpoint()
    report["complete"] = True
    checkpoint()
    print(json.dumps(report["summary"], indent=2))
    return int(report["summary"]["failedPackages"] != 0)


if __name__ == "__main__":
    raise SystemExit(main())
