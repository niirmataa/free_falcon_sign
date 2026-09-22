#!/usr/bin/env python3
"""Verify the vendored lattice-estimator against its IMPORT_RECORD.json.

Checks (exact, no sampling):
  1. every recorded file exists with the recorded sha256 and size;
  2. no unrecorded regular files in the tree (exclusions per the record);
  3. the recomputed tree listing hash equals tree_listing_sha256;
  4. the recorded upstream commit string is present.
Optionally, with --upstream PATH, additionally diff the estimator/ package
against a fresh upstream checkout.

Output: artifacts/vendor_verification.json
"""
import hashlib
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
W = os.path.dirname(HERE)
VENDOR = os.path.join(W, "inputs", "tools", "vendor", "lattice-estimator")
OUT = os.path.join(W, "artifacts")


def sha256(path):
    with open(path, "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def main():
    upstream = None
    if len(sys.argv) == 3 and sys.argv[1] == "--upstream":
        upstream = sys.argv[2]

    rec_path = os.path.join(VENDOR, "IMPORT_RECORD.json")
    rec = json.load(open(rec_path))
    checks = []
    ok_all = True

    recorded = {item["path"]: item for item in rec["files"]}
    for rel, item in sorted(recorded.items()):
        p = os.path.join(VENDOR, rel)
        exists = os.path.isfile(p)
        h = sha256(p) if exists else None
        size = os.path.getsize(p) if exists else None
        ok = exists and h == item["sha256"] and size == item["size"]
        ok_all &= ok
        checks.append({"path": rel, "ok": ok, "sha256": h, "size": size})

    present = set()
    for root, dirs, files in os.walk(VENDOR):
        dirs[:] = [d for d in dirs if d not in (".git", "__pycache__")]
        for fn in files:
            if fn.endswith(".pyc"):
                continue
            rel = os.path.relpath(os.path.join(root, fn), VENDOR)
            if rel == "IMPORT_RECORD.json":
                continue
            present.add(rel)
    extras = sorted(present - set(recorded))
    missing = sorted(set(recorded) - present)
    ok_all &= not extras and not missing

    listing = "\n".join(sorted(
        f"{rel} {recorded[rel]['sha256']} {recorded[rel]['size']}"
        for rel in recorded))
    tree_hash = hashlib.sha256(listing.encode()).hexdigest()
    tree_ok = tree_hash == rec["tree_listing_sha256"]
    ok_all &= tree_ok

    upstream_check = None
    if upstream:
        diff_files = []
        for rel in sorted(recorded):
            if not rel.startswith("estimator/"):
                continue
            a = os.path.join(VENDOR, rel)
            b = os.path.join(upstream, rel)
            if not os.path.isfile(b) or sha256(a) != sha256(b):
                diff_files.append(rel)
        upstream_check = {"path": upstream,
                          "estimator_files_compared":
                              len([r for r in recorded if r.startswith("estimator/")]),
                          "differing": diff_files}
        ok_all &= not diff_files

    result = {
        "vendor": VENDOR,
        "upstream_commit": rec["upstream_commit"],
        "upstream_commit_date": rec.get("upstream_commit_date"),
        "import_date": rec.get("import_date"),
        "files_recorded": len(recorded),
        "files_present": len(present),
        "extras": extras,
        "missing": missing,
        "tree_listing_sha256_recomputed": tree_hash,
        "tree_listing_sha256_recorded": rec["tree_listing_sha256"],
        "tree_ok": tree_ok,
        "upstream_cross_check": upstream_check,
        "all_checks_passed": bool(ok_all),
    }
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "vendor_verification.json"), "w") as f:
        json.dump({**result, "file_checks": checks}, f, indent=2, sort_keys=True)
    print(json.dumps({k: v for k, v in result.items() if k != "file_checks"},
                     indent=2, sort_keys=True))
    return 0 if ok_all else 1


if __name__ == "__main__":
    sys.exit(main())
