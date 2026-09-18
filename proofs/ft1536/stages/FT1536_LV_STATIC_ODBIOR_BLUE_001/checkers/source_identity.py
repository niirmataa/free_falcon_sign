#!/usr/bin/env python3
"""Verify the pinned Git object, 17 source files, and public input origins."""
import hashlib
import json
import os
from pathlib import Path
import stat
import subprocess
import sys

if len(sys.argv) != 5:
    raise SystemExit("usage: source_identity.py H RUN_INPUTS_SHA COPY_REFERENCE COPY_INPUTS")
H, run_inputs, copy_ref, copy_inputs = map(Path, sys.argv[1:])
commit = "d641ab1037c2fa1dd4a22c258854d79d67b9b46b"
git_path = "evidence/_work/PO-01-BASELINE-001-20260803-a1/source_hashes.sha256"
expected_manifest_hash = "03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589"
env = dict(os.environ, GIT_OPTIONAL_LOCKS="0")
errors = []

probe = subprocess.run(["git", "-C", str(H), "cat-file", "-e", commit + "^{commit}"], env=env)
if probe.returncode:
    errors.append("pinned commit object unavailable")
shown = subprocess.run(["git", "-C", str(H), "show", commit + ":" + git_path],
                       env=env, capture_output=True)
if shown.returncode:
    errors.append("pinned source manifest unavailable")
manifest_blob = shown.stdout
manifest_hash = hashlib.sha256(manifest_blob).hexdigest()
if manifest_hash != expected_manifest_hash:
    errors.append("pinned source manifest digest mismatch")

source_entries = {}
for raw in manifest_blob.decode("utf-8").splitlines():
    digest, name = raw.split(None, 1)
    name = Path(name).name
    if name in source_entries:
        errors.append("duplicate source basename: " + name)
    source_entries[name] = digest
for name, digest in source_entries.items():
    for label, path in (("H/build", H / "build" / name), ("W/reference", copy_ref / name)):
        try:
            st = path.lstat()
        except FileNotFoundError:
            errors.append(f"missing {label}/{name}")
            continue
        if not stat.S_ISREG(st.st_mode) or path.is_symlink():
            errors.append(f"non-regular {label}/{name}")
            continue
        if hashlib.sha256(path.read_bytes()).hexdigest() != digest:
            errors.append(f"hash mismatch {label}/{name}")

input_entries = []
for raw in run_inputs.read_text(encoding="utf-8").splitlines():
    digest, name = raw.split("  ", 1)
    path = Path(name)
    input_entries.append((digest, path))
    try:
        st = path.lstat()
    except FileNotFoundError:
        errors.append("missing original public input: " + name)
        continue
    if not stat.S_ISREG(st.st_mode) or path.is_symlink():
        errors.append("non-regular original public input: " + name)
    elif hashlib.sha256(path.read_bytes()).hexdigest() != digest:
        errors.append("original public input hash mismatch: " + name)

copies = {
    "canonical_public_key.bin": "57c49fb228013b0bfc4907c754d747dca93c1049d2945ccd6cd686e9f95afc6f",
    "canonical_public_h.txt": "ce1aef69b5998e6f214bc6a45cf6abc36fb1753d595ef1d7b0e6c1cecd9d17f2",
    "KEY_COMMITMENT.json": "014358887337670f599c442bb3b838aa6084931efeba17a00eb72fda014e9523",
    "OUTPUTS.sha256": "51107bef5786b102d1b6a2ac8d35926fe7d47eeb9cfd3dd7d647cb679bbc5d15",
}
for name, digest in copies.items():
    if hashlib.sha256((copy_inputs / name).read_bytes()).hexdigest() != digest:
        errors.append("copied public key evidence mismatch: " + name)

head = subprocess.run(["git", "-C", str(H), "rev-parse", "HEAD"], env=env,
                      capture_output=True, text=True, check=True).stdout.strip()
out = {
    "schema": "DAYBREAK_SOURCE_IDENTITY_V1",
    "pinned_commit": commit,
    "current_H_head": head,
    "current_head_is_pin": head == commit,
    "pinned_manifest_path": git_path,
    "pinned_manifest_sha256": manifest_hash,
    "source_entries": len(source_entries),
    "source_H_build_matches": not any("H/build" in e for e in errors),
    "source_W_copy_matches": not any("W/reference" in e for e in errors),
    "original_public_input_entries": len(input_entries),
    "original_public_inputs_match": not any("original public input" in e for e in errors),
    "public_key_evidence_copies_match": not any("copied public" in e for e in errors),
    "errors": errors,
    "ok": not errors,
}
print(json.dumps(out, indent=2, sort_keys=True))
raise SystemExit(0 if not errors else 1)
