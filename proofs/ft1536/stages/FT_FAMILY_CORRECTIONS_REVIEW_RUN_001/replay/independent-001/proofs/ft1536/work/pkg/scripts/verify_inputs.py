#!/usr/bin/env python3
"""S01 / FT_FAMILY_SCALING_CORRECTIONS_RUN_003 — weryfikacja wejść bootstrap.

Sprawdza (TASK §2):
  1. MANIFEST.sha256: hash pliku manifestu = pin TASK.
  2. Dokładny zbiór: 197 pozycji == wszystkie pliki regularne bootstrapu
     (z manifestem i ORIGINS.json/README.md zgodnie z listą), brak duplikatów,
     brak traversal (.., /, \\), brak symlinków w całym drzewie.
  3. Hash i rozmiar każdego członka.
  4. ORIGINS.json: 195 wpisów, base_commit = pin BASE, copy unikalne,
     hash/bytes zgodne, candidate_manifest_sha256 = pin CANDIDATE_R2/SHA256SUMS.
  5. Suma bajtów = 4967628 (TASK §2 deklaracja).
  6. source17: REVIEW/inputs/CANDIDATE.sha256 vs Extra/c repo (17 plików).
  7. CANDIDATE_R2/SHA256SUMS: normalizacja pojedynczego ./ TYLKO w checkerze,
     odrzucenie traversal i duplikatów, weryfikacja 42 członków.
  8. Piny pięciu plików z TASK §2.

Wyjście: raport na stdout; exit 0 = wszystkie kontrole PASS.
"""
import hashlib
import json
import os
import re
import sys

W = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
IN = os.path.join(W, "inputs", "bootstrap")
REPO = "/home/footfalcon/free_falcon_sign"
EXTRA_C = os.path.join(REPO, "Extra", "c")

PINS = {
    "MANIFEST.sha256": "6294e7829bb8b0254e3cfb2d8c1603712fa6f267aefa6a75aa629bb8a09a9e7e",
    "REVIEW/REPORT.md": "3b4160dca5d613a1c8b8ca3d97bc11257e6ca300face029ce199aaa0c5f8898e",
    "REVIEW/OUTPUTS.sha256": "0319da9743a81084ee32c2f276c92539b45c89110ae1168af407cdeb891ab99a",
    "CANDIDATE_R2/SHA256SUMS": "5ee71952862a0395e9c3d14873f953a9f9a61985d3ff24f2ccf4f34f0dfccd16",
    "REVIEW/inputs/CANDIDATE.sha256": "56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985",
    "T01/IID_RETRY_CERTIFICATE.json": "2a91dd43cc3c21486aa8968ebb0e4ae211a603a786e647a257d05174ef39ce2b",
}
BASE = "a2cdf31733ae1af82c5a523b44305e86a716551c"
TASK_MANIFEST_SHA = PINS["MANIFEST.sha256"]
ORIGINS_COUNT = 195
MEMBER_COUNT = 197
TOTAL_BYTES = 4967628
SOURCE17_COUNT = 17

failures = []


def check(name, ok, detail=""):
    print(("PASS " if ok else "FAIL ") + name + ((" :: " + detail) if detail else ""))
    if not ok:
        failures.append(name)


def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def parse_sumfile(path):
    """Pary (hash, nazwa) z pliku typu sha256sum. Zachowuje surowe nazwy."""
    out = []
    with open(path, "r", encoding="utf-8") as f:
        for ln, line in enumerate(f, 1):
            line = line.rstrip("\n")
            if not line.strip():
                continue
            m = re.match(r"^([0-9a-f]{64}) [ *](.+)$", line)
            if not m:
                failures.append("parse:%s:%d" % (path, ln))
                continue
            out.append((m.group(1), m.group(2)))
    return out


def safe_rel(name):
    """Ścieżka względna bez traversal/absolutu/backslashów."""
    if name != name.strip():
        return False
    if name.startswith("/") or name.startswith("\\") or "\\" in name:
        return False
    parts = name.split("/")
    if any(p in ("", ".", "..") for p in parts):
        return False
    return True


def walk_regular(root):
    """Wszystkie pliki regularne i symlinki pod root (względne, /)."""
    reg, links, dirs = [], [], []
    for dirpath, dirnames, filenames in os.walk(root):
        for d in dirnames:
            p = os.path.join(dirpath, d)
            if os.path.islink(p):
                links.append(os.path.relpath(p, root))
        for fn in filenames:
            p = os.path.join(dirpath, fn)
            rel = os.path.relpath(p, root).replace(os.sep, "/")
            if os.path.islink(p):
                links.append(rel)
            elif os.path.isfile(p):
                reg.append(rel)
            else:
                dirs.append(rel)
    return sorted(reg), sorted(links), dirs


print("=== S01 verify_inputs: bootstrap", IN)

# --- 1. hash manifestu + piny
for rel, pin in PINS.items():
    p = os.path.join(IN, rel)
    if not os.path.isfile(p):
        check("pin:" + rel, False, "brak pliku")
        continue
    check("pin:" + rel, sha256_file(p) == pin, sha256_file(p))

# --- 2/3. manifest: exact set, hashes, brak symlinków/traversal/duplikatów
man_path = os.path.join(IN, "MANIFEST.sha256")
members = parse_sumfile(man_path)
check("manifest:count==197", len(members) == MEMBER_COUNT, "n=%d" % len(members))
names = [n for _, n in members]
check("manifest:no-duplicates", len(set(names)) == len(names))
bad_names = [n for n in names if not safe_rel(n)]
check("manifest:safe-paths", not bad_names, ",".join(bad_names[:5]))

reg, links, other = walk_regular(IN)
check("tree:no-symlinks", not links, ",".join(links[:5]))
check("tree:no-special", not other, ",".join(other[:5]))
check("tree:exact-set==manifest",
      sorted(names) == [r for r in reg if r != "MANIFEST.sha256"] or
      sorted(names + ["MANIFEST.sha256"]) == reg or sorted(names) == reg,
      "reg=%d man=%d" % (len(reg), len(names)))
# rozstrzygnięcie: czy manifest zawiera samego siebie
self_listed = "MANIFEST.sha256" in names
print("INFO manifest self-listed:", self_listed)
missing = sorted(set(names) - set(reg))
extra = sorted(set(reg) - set(names) - {"MANIFEST.sha256"})
check("manifest:no-missing", not missing, ",".join(missing[:5]))
check("manifest:no-extra", not extra, ",".join(extra[:5]))

hash_bad = []
for h, n in members:
    p = os.path.join(IN, n)
    if not os.path.isfile(p) or os.path.islink(p):
        hash_bad.append(n + ":type")
        continue
    if sha256_file(p) != h:
        hash_bad.append(n + ":hash")
check("manifest:all-hashes", not hash_bad, ",".join(hash_bad[:5]))

total = sum(os.path.getsize(os.path.join(IN, n)) for n in names
            if os.path.isfile(os.path.join(IN, n)))
total_all = sum(os.path.getsize(os.path.join(IN, r)) for r in reg)
check("manifest:total-bytes==4967628",
      total == TOTAL_BYTES or total_all == TOTAL_BYTES,
      "members=%d all=%d" % (total, total_all))

# --- 4. ORIGINS.json
with open(os.path.join(IN, "ORIGINS.json"), "r", encoding="utf-8") as f:
    origins = json.load(f)
check("origins:base_commit", origins.get("base_commit") == BASE,
      str(origins.get("base_commit")))
check("origins:candidate_manifest_sha256",
      origins.get("candidate_manifest_sha256") == PINS["CANDIDATE_R2/SHA256SUMS"])
check("origins:candidate_status",
      origins.get("candidate_status") == "UNREVIEWED_WORK_SNAPSHOT_NOT_ACCEPTED",
      str(origins.get("candidate_status")))
files = origins.get("files", [])
check("origins:count==195", len(files) == ORIGINS_COUNT, "n=%d" % len(files))
copies = [f["copy"] for f in files]
check("origins:copies-unique", len(set(copies)) == len(copies))
check("origins:copies-safe", all(safe_rel(c) for c in copies))
o_bad = []
for f in files:
    p = os.path.join(IN, f["copy"])
    if not os.path.isfile(p) or os.path.islink(p):
        o_bad.append(f["copy"] + ":type")
        continue
    if sha256_file(p) != f["sha256"]:
        o_bad.append(f["copy"] + ":hash")
    if os.path.getsize(p) != f["bytes"]:
        o_bad.append(f["copy"] + ":bytes")
check("origins:all-hashes-bytes", not o_bad, ",".join(o_bad[:5]))

# --- 6. source17
cand = parse_sumfile(os.path.join(IN, "REVIEW", "inputs", "CANDIDATE.sha256"))
check("source17:count", len(cand) == SOURCE17_COUNT, "n=%d" % len(cand))
check("source17:names-safe", all(safe_rel(n) for _, n in cand))
s_bad = []
for h, n in cand:
    p = os.path.join(EXTRA_C, n)
    if not os.path.isfile(p):
        s_bad.append(n + ":missing")
    elif sha256_file(p) != h:
        s_bad.append(n + ":hash")
check("source17:extra_c-match", not s_bad, ",".join(s_bad[:5]))

# --- 7. CANDIDATE_R2/SHA256SUMS (normalizacja ./ tylko tutaj)
sums = parse_sumfile(os.path.join(IN, "CANDIDATE_R2", "SHA256SUMS"))
norm = []
dup_raw = len({n for _, n in sums}) != len(sums)
check("candidate_r2:sums-no-raw-duplicates", not dup_raw)
reject = []
for h, n in sums:
    nn = n[2:] if n.startswith("./") else n
    if not safe_rel(nn):
        reject.append(n)
        continue
    norm.append((h, nn))
check("candidate_r2:sums-safe-after-normalization", not reject, ",".join(reject[:5]))
norm_names = [n for _, n in norm]
check("candidate_r2:no-duplicates-after-normalization",
      len(set(norm_names)) == len(norm_names))
# eksakt: SHA256SUMS nie jest własnym członkiem;42 listed + brak innych plików
c2_root = os.path.join(IN, "CANDIDATE_R2")
c2_reg, c2_links, _ = walk_regular(c2_root)
check("candidate_r2:no-symlinks", not c2_links, ",".join(c2_links[:5]))
listed = set(norm_names)
ondisk = set(c2_reg) - {"SHA256SUMS"}
check("candidate_r2:exact-set", listed == ondisk,
      "missing=%s extra=%s" % (sorted(listed - ondisk)[:5], sorted(ondisk - listed)[:5]))
check("candidate_r2:42-members", len(norm_names) == 42, "n=%d" % len(norm_names))
c2_bad = []
for h, n in norm:
    p = os.path.join(c2_root, n)
    if not os.path.isfile(p) or os.path.islink(p):
        c2_bad.append(n + ":type")
    elif sha256_file(p) != h:
        c2_bad.append(n + ":hash")
check("candidate_r2:all-hashes", not c2_bad, ",".join(c2_bad[:5]))
# oryginalny manifest zachowany bez zmian (z ./)
with open(os.path.join(c2_root, "SHA256SUMS"), "rb") as f:
    raw = f.read()
n_dot = sum(1 for _, n in sums if n.startswith("./"))
check("candidate_r2:original-sums-has-dot-slash", n_dot > 0 and n_dot == len(sums),
      "entries z ./: %d/%d" % (n_dot, len(sums)))

print()
if failures:
    print("SUMMARY: %d checks failed: %s" % (len(failures), failures))
    sys.exit(1)
print("SUMMARY: 0 checks failed")
