#!/usr/bin/env python3
# FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 -- bootstrap input verification.
# Checks: manifest hash, exact member set, per-file SHA-256, no symlinks,
# no path escapes, ORIGINS coverage, CANDIDATE source-17 pin, TASK table pins.
# Read-only on inputs/bootstrap. All writes stay under W (log via stdout).
import hashlib, json, os, sys

W = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
IN = os.path.join(W, "inputs", "bootstrap")
MANIFEST = os.path.join(IN, "MANIFEST.sha256")

def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()

fail = []
def check(cond, msg):
    print(("PASS " if cond else "FAIL ") + msg)
    if not cond:
        fail.append(msg)

# 1. Manifest self-hash.
mh = sha256_file(MANIFEST)
check(mh == "c9695c8032faa84f03e254370e5420254d8b96951e95d75e605fe382107a0e2b",
      "MANIFEST.sha256 self hash = c9695c80...a0e2b (got %s)" % mh)

# 2. Parse manifest.
entries = {}
order_ok = True
with open(MANIFEST, "r", encoding="utf-8") as f:
    lines = f.read().splitlines()
check(len(lines) == 1275, "manifest line count == 1275 (got %d)" % len(lines))
prev = None
for i, ln in enumerate(lines, 1):
    if len(ln) < 67 or ln[64:66] != "  ":
        fail.append("bad manifest line %d" % i)
        continue
    h, rel = ln[:64], ln[66:]
    if not all(c in "0123456789abcdef" for c in h):
        fail.append("bad hash on line %d" % i)
    if rel in entries:
        fail.append("duplicate entry %s" % rel)
    entries[rel] = h
    if prev is not None and rel < prev:
        order_ok = False
    prev = rel
check(order_ok, "manifest entries lexicographically sorted")

# 3. Path safety: relative, no '..', no absolute, no backslash, normalised.
bad_paths = [r for r in entries if r.startswith("/") or ".." in r.split("/")
             or "\\" in r or r != os.path.normpath(r)]
check(not bad_paths, "no absolute/..-/backslash/non-normalised paths (%d bad)" % len(bad_paths))

# 4. Exact set + hashes + no symlinks.
disk = {}
symlinks = []
nonregular = []
for root, dirs, files in os.walk(IN, followlinks=False):
    for d in dirs:
        p = os.path.join(root, d)
        if os.path.islink(p):
            symlinks.append(os.path.relpath(p, IN))
    for fn in files:
        p = os.path.join(root, fn)
        rel = os.path.relpath(p, IN)
        if rel == "MANIFEST.sha256":
            continue
        if os.path.islink(p):
            symlinks.append(rel)
            continue
        if not os.path.isfile(p):
            nonregular.append(rel)
            continue
        disk[rel] = p
check(not symlinks, "no symlinks in bootstrap (%d found)" % len(symlinks))
check(not nonregular, "all members regular files (%d bad)" % len(nonregular))

missing = sorted(set(entries) - set(disk))
extra = sorted(set(disk) - set(entries))
check(not missing, "all %d manifest members present (%d missing)" % (len(entries), len(missing)))
check(not extra, "no unlisted files beyond MANIFEST.sha256 (%d extra)" % len(extra))
check(len(entries) == 1275, "member count == 1275")

mismatch = []
for rel, want in sorted(entries.items()):
    got = sha256_file(disk[rel])
    if got != want:
        mismatch.append((rel, want, got))
check(not mismatch, "all member SHA-256 match (%d mismatch)" % len(mismatch))
for rel, want, got in mismatch[:20]:
    print("  MISMATCH %s want %s got %s" % (rel, want, got))

# 5. ORIGINS coverage (leader verifies Git provenance; we check structural coverage).
with open(os.path.join(IN, "ORIGINS.json"), "r", encoding="utf-8") as f:
    origins = json.load(f)
check(origins.get("base_commit") == "1aed8adebb68105e1517ab441046a0bbc6c424e7",
      "ORIGINS base_commit == BASE 1aed8ad")
ofile = origins["files"]
okeys = [e["copy"] for e in ofile]
check(len(okeys) == len(set(okeys)), "ORIGINS copies unique")
o_bad = [e["copy"] for e in ofile
         if entries.get(e["copy"]) not in (None, e["sha256"])
         or (e["copy"] in entries and entries[e["copy"]] != e["sha256"])]
check(not o_bad, "ORIGINS sha256 agree with manifest (%d bad)" % len(o_bad))
o_size = [e["copy"] for e in ofile
          if e["copy"] in entries and os.path.getsize(disk[e["copy"]]) != e["bytes"]]
check(not o_size, "ORIGINS byte sizes agree on disk (%d bad)" % len(o_size))
n_git = sum(1 for e in ofile if e.get("original", "").startswith("git:"))
print("INFO ORIGINS entries: %d ; git origins: %d ; manifest members: %d"
      % (len(ofile), n_git, len(entries)))
covered = sorted(set(entries) - set(okeys))
print("INFO manifest members without ORIGINS entry: %d %s" % (len(covered), covered[:5]))
with_origin = sorted(set(okeys) - set(entries))
print("INFO ORIGINS entries not in manifest: %d %s" % (len(with_origin), with_origin[:5]))

# 6. CANDIDATE source-17 pin.
cand = os.path.join(IN, "CANDIDATE.sha256")
check(sha256_file(cand) == "56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985",
      "CANDIDATE.sha256 pin 56974571...a0985")
srcdir = os.path.join(IN, "source")
src_disk = sorted(os.listdir(srcdir))
cand_entries = {}
with open(cand, "r", encoding="utf-8") as f:
    for ln in f.read().splitlines():
        if ln.strip():
            cand_entries[ln[66:]] = ln[:64]
check(len(cand_entries) == 17, "CANDIDATE lists 17 source files (got %d)" % len(cand_entries))
check(sorted(cand_entries) == src_disk,
      "CANDIDATE names == source/ dir listing")
src_bad = [r for r, h in cand_entries.items()
           if sha256_file(os.path.join(srcdir, r)) != h]
check(not src_bad, "source/17 hashes match CANDIDATE (%d bad)" % len(src_bad))

# 7. TASK table pins.
table = {
    "TARGETS/TARGET_FORMULAS.md": "f0caf16017e5edaaed3b2fab2a98094fc2636936aa515d60b6f196cf44d560d9",
    "POST/NEXT_INTERFACE.md": "2dd40096ff0b3f5153169ba824ada28619e36607188d3b612a9f90a095d44aca",
    "H6P/H6P_REFERENCE_BAD_EVENT_CERTIFICATE.json": "89dacd3248ffb4ca9cab106faae6723a3c12a99802243209f70a67d92092b278",
    "JOINT/ORDERED_JOINT_CERTIFICATE.json": "2461bfa9d86f246117634bd453716fd076c669aedbe5300894993a0c78921768",
    "POST/SOURCE_POSTPROCESSING_CERTIFICATE.json": "157bde62850b24c4f2505d19b5adc0cd82cbe875c7db6874c6ec857cbf2344ef",
    "LV/CLAIM.md": "e10be7abe58c970bec0a97cb11de9f1c6e3ee021321dffc4111eec86fc342575",
}
for rel, want in sorted(table.items()):
    p = os.path.join(IN, rel)
    ok = os.path.isfile(p) and sha256_file(p) == want
    check(ok, "TASK pin %s = %s..." % (rel, want[:12]))

print()
print("SUMMARY: %d checks failed" % len(fail))
sys.exit(1 if fail else 0)
