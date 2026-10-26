#!/usr/bin/env python3
"""WP-023 — differential Rust vs silnik FT1536 (ternary logn=10).

Skrypt buduje harness C (funkcje silnika z `Extra/c`) oraz przykład Rust,
uruchamia oba na tym samym deterministycznym zestawie przypadków i
porównuje pliki bajt po bajcie.

Wszystkie artefakty trafiają wyłącznie do `impl/.build/engine_diff/`.
Nic nie jest wysyłane do sieci; Cargo działa z `--offline`.
"""

from __future__ import annotations

import argparse
import hashlib
import os
import struct
import subprocess
import sys
from pathlib import Path

MAGIC = b"FTDIF01\0"
HEADER = struct.Struct("<8sIIIIIQ")  # magic, version, n, q, cases, kinds, seed
KINDS = ("hash_to_point", "ntt", "intt", "mul")
ENGINE_FILES = (
    "falcon-vrfy.c",
    "falcon-enc.c",
    "shake.c",
    "shake.h",
    "internal.h",
    "falcon.h",
    "fpr-emulated.h",
)


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def run(cmd: list[str], cwd: Path, env: dict[str, str] | None = None) -> None:
    print("+", " ".join(cmd), flush=True)
    subprocess.run(cmd, cwd=cwd, check=True, env=env)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--cases", type=int, default=2500, help="przypadki na kategorię")
    ap.add_argument("--skip-rust-build", action="store_true", help="użyj istniejącego rust.bin")
    args = ap.parse_args()
    if not 1 <= args.cases <= 100_000:
        ap.error("--cases musi być w 1..=100000")

    script = Path(__file__).resolve()
    repo = script.parents[7]
    impl = script.parents[2]
    engine_dir = repo / "Extra" / "c"
    build = impl / ".build" / "engine_diff"
    build.mkdir(parents=True, exist_ok=True)

    missing = [name for name in ENGINE_FILES if not (engine_dir / name).is_file()]
    if missing:
        print(f"BŁĄD: brak plików silnika w {engine_dir}: {missing}", file=sys.stderr)
        return 2

    cc = os.environ.get("CC", "cc")
    probe_c = build / "probe_engine"
    engine_bin = build / "engine.bin"
    rust_bin = build / "rust.bin"
    summary = build / "run_summary.txt"

    cflags = [
        "-std=c99",
        "-O2",
        "-W",
        "-Wall",
        '-DFPR_IMPL="fpr-emulated.h"',
        "-DFT1536_CANDIDATE_PROFILE=1",
        "-DCLEANSE=1",
        "-DTRUE_TERNARY_SECRET=1",
        "-DTRUE_TERNARY_SECRET_MODE=1",
        f"-I{engine_dir}",
        "-ffunction-sections",
        "-fdata-sections",
    ]

    print("== WP-023 differential: Rust vs silnik ==", flush=True)
    print(f"repo:   {repo}", flush=True)
    print(f"engine: {engine_dir}", flush=True)
    print(f"cases:  {args.cases} × {len(KINDS)} kategorii", flush=True)

    run(
        [
            cc,
            *cflags,
            str(script.parent / "probe_engine.c"),
            str(engine_dir / "shake.c"),
            str(engine_dir / "falcon-enc.c"),
            "-Wl,--gc-sections",
            "-o",
            str(probe_c),
        ],
        cwd=build,
    )
    run([str(probe_c), str(engine_bin), str(args.cases)], cwd=build)

    if not args.skip_rust_build:
        env = dict(os.environ)
        env.setdefault("CARGO_NET_OFFLINE", "true")
        run(
            [
                "cargo",
                "run",
                "--quiet",
                "-p",
                "ft-threshold-core",
                "--example",
                "engine_diff_probe",
                "--offline",
                "--",
                "--out",
                str(rust_bin),
                "--cases",
                str(args.cases),
            ],
            cwd=impl,
            env=env,
        )
    if not rust_bin.is_file():
        print(f"BŁĄD: brak {rust_bin}", file=sys.stderr)
        return 2

    engine_bytes = engine_bin.read_bytes()
    rust_bytes = rust_bin.read_bytes()
    expected_len = HEADER.size + args.cases * len(KINDS) * 32
    if len(engine_bytes) != expected_len or len(rust_bytes) != expected_len:
        print(
            f"BŁĄD: rozmiar plików niezgodny z nagłówkiem "
            f"(oczekiwano {expected_len}, engine={len(engine_bytes)}, rust={len(rust_bytes)})",
            file=sys.stderr,
        )
        return 2

    header = HEADER.unpack_from(engine_bytes, 0)
    if header[0] != MAGIC or header[1] != 1:
        print(f"BŁĄD: zły nagłówek engine: {header!r}", file=sys.stderr)
        return 2
    if header[2] != 1536 or header[3] != 18433 or header[4] != args.cases or header[5] != len(KINDS):
        print(f"BŁĄD: nieoczekiwane parametry w nagłówku: {header!r}", file=sys.stderr)
        return 2
    if HEADER.unpack_from(rust_bytes, 0) != header:
        print("BŁĄD: nagłówki engine i Rust różnią się", file=sys.stderr)
        return 2

    engine_digest = hashlib.sha256(engine_bytes).hexdigest()
    rust_digest = hashlib.sha256(rust_bytes).hexdigest()

    mismatches = 0
    first = None
    for off in range(HEADER.size, expected_len):
        if engine_bytes[off] != rust_bytes[off]:
            mismatches += 1
            if first is None:
                first = off

    lines = []
    lines.append("WP-023 differential Rust vs silnik FT1536 (ternary logn=10)")
    lines.append(f"cases_per_kind: {args.cases}")
    lines.append(f"kinds: {', '.join(KINDS)}")
    lines.append(f"seed: 0x{header[6]:016x}")
    lines.append("engine_sources:")
    for name in ENGINE_FILES:
        lines.append(f"  {name}: {sha256_file(engine_dir / name)}")
    lines.append(f"engine_bin_sha256: {engine_digest}")
    lines.append(f"rust_bin_sha256:   {rust_digest}")
    lines.append(f"bytes_compared: {expected_len}")
    lines.append(f"digests_compared: {args.cases * len(KINDS)}")
    lines.append(f"mismatched_bytes: {mismatches}")

    if mismatches:
        assert first is not None
        rel = first - HEADER.size
        kind_idx = rel // (args.cases * 32)
        within = rel % (args.cases * 32)
        case_idx, byte_idx = divmod(within, 32)
        kind = KINDS[kind_idx]
        e = engine_bytes[first : first + 32].hex()
        r = rust_bytes[first : first + 32].hex()
        lines.append(
            f"first_mismatch: kind={kind} case={case_idx} digest_byte={byte_idx}"
        )
        lines.append(f"engine_digest: {e}")
        lines.append(f"rust_digest:   {r}")
        print("\n".join(lines), flush=True)
        status = 1
    else:
        lines.append("result: PASS (0 rozjazdów, pełna zgodność bajtowa)")
        print("\n".join(lines), flush=True)
        status = 0

    summary.write_text("\n".join(lines) + "\n", encoding="utf-8")
    # Celowo nie usuwamy binariów: są dowodem wykonania w .build/.
    return status


if __name__ == "__main__":
    sys.exit(main())
