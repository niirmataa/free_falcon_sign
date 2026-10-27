#!/usr/bin/env python3
"""WP-026 — deterministyczny SBOM wyprowadzany wprost z Cargo.lock.

Dlaczego nie `cargo metadata`: pełne resolve chce pobrać manifesty
wszystkich wpisów locka (również opcjonalnych backendów nieużywanych
na tym targecie, np. `fiat-crypto`), co pada przy `--frozen` offline.
Cargo.lock jest źródłem prawdy dla zablokowanego inwentarza: nazwa,
wersja, źródło (registry/path) i checksum — bez sieci i bez resolve.

Licencje są świadomie POZA tym plikiem: sprawdza je `cargo deny check
--offline` (osobny krok CI). Wersja toolchaina też jest poza SBOM —
rejestruje ją dowód WP-026 i `rust-toolchain.toml`.

Wejście:  ścieżka do Cargo.lock i (opcjonalnie) Cargo.toml workspace'u.
Wyjście: tekst posortowany (name, version) — stabilny dla tego samego
          locka, więc można przypiąć w repo i porównywać w CI.

Uruchomienie:
    python3 ci/sbom_from_lock.py Cargo.lock Cargo.toml
"""

from __future__ import annotations

import sys
import tomllib
from pathlib import Path


def main() -> int:
    if len(sys.argv) < 2:
        print("użycie: sbom_from_lock.py CARGO_LOCK [WORKSPACE_TOML]", file=sys.stderr)
        return 2
    lock_path = Path(sys.argv[1])
    with lock_path.open("rb") as f:
        lock = tomllib.load(f)

    members = 0
    if len(sys.argv) > 2 and Path(sys.argv[2]).is_file():
        with open(sys.argv[2], "rb") as f:
            ws = tomllib.load(f)
        members = len(ws.get("workspace", {}).get("members", []))

    lines = [
        "# SBOM THRESHOLD_P2_001 (WP-026) — wyprowadzony wprost z Cargo.lock.",
        "# Regeneracja: ci/repro_build.sh --update; porównanie w CI.",
        "# Licencje: cargo deny check --offline (osobny krok CI).",
        "# Format: name | version | source | checksum",
    ]
    pkgs = []
    for pkg in lock.get("package", []):
        source = "path" if "source" not in pkg else pkg["source"]
        checksum = pkg.get("checksum", "-")
        pkgs.append(f"{pkg['name']} | {pkg['version']} | {source} | {checksum}")
    for line in sorted(pkgs):
        lines.append(line)
    lines.append(f"# packages: {len(pkgs)}; workspace_members_manifestowane: {members}")

    sys.stdout.write("\n".join(lines) + "\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
