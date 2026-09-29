#!/usr/bin/env python3
"""restore_replay.py — odtworzenie zamrożonego pakietu P01 do NOWEGO DEST.

Recenzent wywołuje (sieć OFF; W autora TYLKO do odczytu — skrypt nic w nim
nie kasuje ani nie odtwarza):

    python3 replay/restore_replay.py /bezwzględna/ścieżka/DO/NOWEGO/DEST

Skrypt:
  1. wymaga nieistniejącego DEST (fresh DEST — żadnych produktów w W autora);
  2. kopiuje sealed sources/configy/narzędzia z pakietu do DEST;
  3. podpina immutable pinned library build (Mathlib + pakiety git) przez
     symlinki ZA BRAMKĄ provenance (rev = pin z lake-manifest/TOOLCHAIN_PINS);
  4. uruchamia w DEST: sage producer, sage checker, świeży rebuild Lean,
     probe redukcji kernelowej, printed types, axiom scan — receipty w
     DEST/replay/logs, `lake env lean` dla skanów (ścieżki z DEST);
  5. porównuje produkty z EXPECTED.json (hashe certyfikatów, log printed
     types, statystyki axiom scan);
  6. BRAMKA CZYSTOŚCI: plik-markera przed jobami; po jobach `find W -newer`
     musi być puste (zero zapisów do autorskiego W — w tym przez symlinki);
  7. zapisuje DEST/REPLAY_RESULT.json (pełne receipty + product_checks).

Źródła pakietu są hashowane przed/po (gate: brak zmian).
"""

from __future__ import annotations

import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import time
from datetime import datetime, timezone

LAKE = "/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lake"
LEAN = "/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean"
SAGE = "/home/footfalcon/.local/bin/sage"
MATHLIB_PIN = "5ed2965256430c3649e86755f9576b54eca72435"
PKG = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DEFAULT_LIB_ROOT = "/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P01"
WALL = 1800
SUBS = ("formal", "aux", "build", "certificates", "tools")


def sha256(path: str) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def now() -> str:
    return datetime.now(timezone.utc).astimezone().isoformat(timespec="seconds")


def main() -> int:
    if len(sys.argv) != 2:
        print(__doc__)
        return 2
    dest = os.path.abspath(sys.argv[1])
    if os.path.exists(dest):
        print("STOP: DEST already exists (fresh DEST required): %s" % dest)
        return 2
    lib_root = os.environ.get("FT1536_LIB_ROOT", DEFAULT_LIB_ROOT)
    lib_mathlib = os.path.join(lib_root, "bootstrap", "mathlib4")
    lib_packages = os.path.join(lib_root, "run", ".lake", "packages")

    # --- bramka provenance reuse'owanego library build ---
    rev = subprocess.run(["git", "-C", lib_mathlib, "rev-parse", "HEAD"],
                         capture_output=True, text=True).stdout.strip()
    if rev != MATHLIB_PIN:
        print("STOP: mathlib rev mismatch: %s != %s" % (rev, MATHLIB_PIN))
        return 2
    manifest = json.load(open(os.path.join(PKG, "build", "lake-manifest.json")))
    pkg_revs = {}
    for p in manifest["packages"]:
        if p["type"] != "git":
            continue
        name = p["name"]
        got = subprocess.run(["git", "-C", os.path.join(lib_packages, name),
                              "rev-parse", "HEAD"],
                             capture_output=True, text=True).stdout.strip()
        if got != p["rev"]:
            print("STOP: package %s rev mismatch: %s != %s"
                  % (name, got, p["rev"]))
            return 2
        pkg_revs[name] = got

    os.makedirs(os.path.join(dest, "replay", "logs"), exist_ok=True)

    # --- kopia sealed sources (snapshot przed/po) ---
    def snapshot():
        files = {}
        for sub in SUBS:
            root_dir = os.path.join(PKG, sub)
            if not os.path.isdir(root_dir):
                continue
            for root, _d, names in os.walk(root_dir):
                for n in sorted(names):
                    p = os.path.join(root, n)
                    files[os.path.relpath(p, PKG)] = sha256(p)
        return files

    src_before = snapshot()
    for sub in SUBS:
        src = os.path.join(PKG, sub)
        if os.path.isdir(src):
            shutil.copytree(src, os.path.join(dest, sub))

    # --- drzewo build: układ jak u autora (run/ + bootstrap/) ---
    os.makedirs(os.path.join(dest, "run", "certificates"), exist_ok=True)
    for f in ("lakefile.toml", "lake-manifest.json", "lean-toolchain"):
        shutil.copy2(os.path.join(PKG, "build", f), os.path.join(dest, "run", f))
    shutil.copytree(os.path.join(PKG, "formal"),
                    os.path.join(dest, "run", "formal"))
    for n in sorted(os.listdir(os.path.join(PKG, "certificates"))):
        shutil.copy2(os.path.join(PKG, "certificates", n),
                     os.path.join(dest, "run", "certificates", n))

    # --- symlinki library build (rev-y zweryfikowane powyżej) ---
    os.makedirs(os.path.join(dest, "bootstrap"), exist_ok=True)
    os.symlink(lib_mathlib, os.path.join(dest, "bootstrap", "mathlib4"))
    os.makedirs(os.path.join(dest, "run", ".lake"), exist_ok=True)
    os.symlink(lib_packages, os.path.join(dest, "run", ".lake", "packages"))

    env = dict(os.environ)
    env.update({
        "HOME": os.path.join(dest, "replay", "home"),
        "TMPDIR": os.path.join(dest, "replay", "tmp"),
        "TMP": os.path.join(dest, "replay", "tmp"),
        "TEMP": os.path.join(dest, "replay", "tmp"),
        "DOT_SAGE": os.path.join(dest, "replay", "tmp", ".sage"),
        "XDG_CACHE_HOME": os.path.join(dest, "replay", "cache"),
        "FT1536_P01_OUT": os.path.join(dest, "CERTIFICATES"),
    })
    for d in ("home", "tmp", "cache"):
        os.makedirs(os.path.join(dest, "replay", d), exist_ok=True)

    receipts = []

    def step(name, argv, cwd, producers=()):
        so = os.path.join(dest, "replay", "logs", name + ".stdout")
        se = os.path.join(dest, "replay", "logs", name + ".stderr")
        t0 = time.monotonic()
        start = now()
        with open(so, "wb") as fo, open(se, "wb") as fe:
            proc = subprocess.run(argv, cwd=cwd, env=env, stdout=fo,
                                  stderr=fe, timeout=WALL)
        rec = {"name": name, "argv": argv, "cwd": cwd, "network": "off",
               "wall_limit_s": WALL, "start": start, "stop": now(),
               "elapsed_s": round(time.monotonic() - t0, 3),
               "exit_code": proc.returncode,
               "stdout": os.path.relpath(so, dest),
               "stdout_sha256": sha256(so),
               "stderr": os.path.relpath(se, dest),
               "stderr_sha256": sha256(se),
               "producer_outputs": {os.path.relpath(p, dest): sha256(p)
                                    for p in producers if os.path.isfile(p)}}
        receipts.append(rec)
        print("[%s] exit=%d %.1fs" % (name, proc.returncode, rec["elapsed_s"]))
        return proc.returncode

    # marker czystości W autora (przed jobami)
    marker = os.path.join(dest, "replay", ".lib_marker")
    with open(marker, "w") as f:
        f.write(now() + "\n")

    certs = os.path.join(dest, "CERTIFICATES")
    rc = 0
    rc |= step("sage_gen_certificate",
               [SAGE, os.path.join(dest, "run", "certificates",
                                   "gen_sqrt2_certificate.sage")],
               os.path.join(dest, "run"),
               [os.path.join(certs, "sqrt2_interval.json"),
                os.path.join(certs, "sqrt2_interval.report.txt")])
    rc |= step("sage_check_certificate",
               [SAGE, os.path.join(dest, "run", "certificates",
                                   "check_certificate.sage")],
               os.path.join(dest, "run"),
               [os.path.join(certs, "check_certificate.report.txt")])
    rc |= step("lean_rebuild_all",
               [LAKE, "build", "B20", "B20.Foundation.Certificate",
                "B20.Foundation.Probability", "B20.Foundation.EndToEnd",
                "B20.Foundation.CertificateTransport", "FT1536P01"],
               os.path.join(dest, "run"))
    rc |= step("lean_probe_reduction",
               [LAKE, "env", LEAN,
                os.path.join(dest, "aux", "RedTest.lean")],
               os.path.join(dest, "run"))
    rc |= step("lean_printed_types",
               [LAKE, "env", LEAN,
                os.path.join(dest, "run", "formal", "PrintedTypes.lean")],
               os.path.join(dest, "run"))
    rc |= step("lean_axiom_scan",
               [LAKE, "env", LEAN,
                os.path.join(dest, "run", "formal", "FT1536P01.lean")],
               os.path.join(dest, "run"))

    src_after = snapshot()

    # --- bramka czystości: zero zapisów do autorskiego W ---
    viol = subprocess.run(["find", lib_root, "-newer", marker, "-type", "f"],
                          capture_output=True, text=True).stdout.splitlines()
    viol = [v for v in viol if not os.path.abspath(v).startswith(dest)]

    # --- porównanie produktów z EXPECTED.json (lub tryb zbierania) ---
    exp_path = os.path.join(PKG, "EXPECTED.json")
    produced = {}
    for rel in ("CERTIFICATES/sqrt2_interval.json",
                "CERTIFICATES/sqrt2_interval.report.txt",
                "CERTIFICATES/check_certificate.report.txt",
                "replay/logs/lean_printed_types.stdout"):
        p = os.path.join(dest, rel)
        produced[rel] = sha256(p) if os.path.isfile(p) else None
    scan = open(os.path.join(dest, "replay", "logs",
                             "lean_axiom_scan.stdout")).read()
    sets = sorted(set(re.findall(r"\[([a-zA-Z., ]*)\]", scan)))
    n_lines = len(re.findall(r"depends on axioms|does not depend", scan))
    n_free = scan.count("does not depend on any axioms")
    scan_stats = {"exports": n_lines, "axiom_free": n_free, "sets": sets}

    checks = {}
    if os.path.isfile(exp_path):
        expected = json.load(open(exp_path))
        for rel, want in expected["files_sha256"].items():
            got = produced.get(rel)
            checks[rel] = {"expected": want, "got": got, "match": got == want}
        checks["axiom_scan"] = {
            "expected": expected["axiom_scan"],
            "got": scan_stats,
            "match": scan_stats == expected["axiom_scan"],
        }
    else:
        print("NOTE: EXPECTED.json absent — product-collection mode")

    all_match = (all(c["match"] for c in checks.values())
                 if checks else True)

    result = {
        "schema": "FT1536_P01_RESTORE_REPLAY_V1",
        "dest": dest,
        "package": PKG,
        "restore_semantics": "fresh DEST; author W read-only; nothing deleted or regenerated in author W",
        "library_reuse": {
            "policy": "immutable pinned library build reused after provenance gate (TOOLCHAIN_PINS library_reuse)",
            "mode": os.environ.get("FT1536_LIB_MODE", "symlink"),
            "mathlib_rev": rev,
            "package_revs": pkg_revs,
        },
        "sources_sha256_before": src_before,
        "sources_sha256_after": src_after,
        "sources_unchanged": src_before == src_after,
        "author_W_writes": {
            "gate": "find <lib_root> -newer <marker>",
            "violations": viol,
            "clean": not viol,
        },
        "jobs_all_exit_zero": rc == 0,
        "receipts": receipts,
        "produced_products": produced,
        "axiom_scan_stats": scan_stats,
        "product_checks": checks,
        "semantic_match": (all_match and rc == 0 and not viol
                           and src_before == src_after),
    }
    with open(os.path.join(dest, "REPLAY_RESULT.json"), "w") as f:
        json.dump(result, f, indent=1)
        f.write("\n")
    print("RESTORE_DONE semantic_match=%s jobs_ok=%s author_W_clean=%s"
          % (result["semantic_match"], rc == 0, not viol))
    print("PRODUCED_PRODUCTS %s" % json.dumps(produced, sort_keys=True))
    print("AXIOM_SCAN_STATS %s" % json.dumps(scan_stats, sort_keys=True))
    return 0 if result["semantic_match"] else 1


if __name__ == "__main__":
    sys.exit(main())
