#!/usr/bin/env python3
"""Measure compressed cache additions after excluding paths served by cache.nixos.org."""

import argparse
from concurrent.futures import ThreadPoolExecutor
import datetime
import json
import lzma
from pathlib import Path
import subprocess
from urllib.error import HTTPError
from urllib.request import Request, urlopen

ROOT = Path(__file__).resolve().parents[1]
METHOD = "Actual NAR streams compressed with XZ preset 6; excludes cache.nixos.org hits. Cachix encoding may differ."


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--sizes", type=Path, default=ROOT / "data/sizes.json")
    parser.add_argument("--out", type=Path, default=ROOT / "data/cache-size.json")
    parser.add_argument("--previous", type=Path,
                        help="reuse measured XZ sizes for unchanged store paths; cache availability is checked again")
    parser.add_argument("--jobs", type=int, default=4)
    args = parser.parse_args()
    if args.jobs < 1:
        parser.error("--jobs must be positive")
    sizes = json.loads(args.sizes.read_text())
    previous = json.loads(args.previous.read_text()) if args.previous else {}
    previous_paths = previous.get("paths", {})
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.unlink(missing_ok=True)

    def inspect(pair):
        path, info = pair
        store_hash = Path(path).name.split("-", 1)[0]
        request = Request(f"https://cache.nixos.org/{store_hash}.narinfo",
                          headers={"User-Agent": "json2dirpkgs-size-accounting"})
        try:
            with urlopen(request, timeout=30) as response:
                text = response.read().decode()
            fields = dict(line.split(": ", 1) for line in text.splitlines() if ": " in line)
            if fields.get("StorePath") != path:
                raise ValueError("cache returned a different store path")
            return path, {"status": "upstream-cache", "narBytes": info["narSize"],
                          "upstreamCompressedBytes": int(fields["FileSize"])}
        except HTTPError as error:
            if error.code != 404:
                return path, {"status": "lookup-failed", "reason": str(error)}
        except (OSError, ValueError, KeyError) as error:
            return path, {"status": "lookup-failed", "reason": str(error)}
        # Store paths are immutable. Reuse only the same codec's measured NAR
        # size, after checking current upstream availability above.
        measured = previous_paths.get(path, {})
        if (previous.get("method") == METHOD and measured.get("status") == "additional"
                and measured.get("narBytes") == info["narSize"]
                and isinstance(measured.get("xzNarBytes"), int)
                and measured["xzNarBytes"] > 0):
            return path, measured
        # Compress the actual NAR stream without retaining its potentially large data.
        process = subprocess.Popen(["nix", "nar", "dump-path", path], stdout=subprocess.PIPE)
        compressor = lzma.LZMACompressor(format=lzma.FORMAT_XZ, preset=6)
        compressed = 0
        assert process.stdout is not None
        try:
            while chunk := process.stdout.read(1024 * 1024):
                compressed += len(compressor.compress(chunk))
            compressed += len(compressor.flush())
        finally:
            process.stdout.close()
        if process.wait():
            return path, {"status": "compression-failed"}
        return path, {"status": "additional", "narBytes": info["narSize"],
                      "xzNarBytes": compressed}

    with ThreadPoolExecutor(max_workers=args.jobs) as executor:
        paths = dict(executor.map(inspect, sizes["runtimeUnion"].items()))
    report = {"schemaVersion": 1, "created": datetime.datetime.now(datetime.timezone.utc).isoformat(),
              "system": sizes["system"], "nixpkgs": sizes["nixpkgs"], "packages": sizes["requestedPackages"],
              "complete": sizes["complete"] and not sizes["summary"]["failedPackages"]
                          and all(v["status"] in ("upstream-cache", "additional") for v in paths.values()),
              "method": METHOD,
              "previousMeasurement": previous.get("created") if args.previous else None,
              "additionalNarBytes": sum(p.get("narBytes", 0) for p in paths.values() if p["status"] == "additional"),
              "additionalXzNarBytes": sum(p.get("xzNarBytes", 0) for p in paths.values()),
              "upstreamPaths": sum(p["status"] == "upstream-cache" for p in paths.values()),
              "additionalPaths": sum(p["status"] == "additional" for p in paths.values()),
              "unknownPaths": sum(p["status"] not in ("upstream-cache", "additional") for p in paths.values()),
              "paths": paths}
    args.out.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({k: v for k, v in report.items() if k != "paths"}, indent=2))
    return int(not report["complete"])


if __name__ == "__main__":
    raise SystemExit(main())
