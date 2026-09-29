"""Resolve the review's declared INPUTS against its actual pinned input root."""
from pathlib import Path
import hashlib
import json

W = Path(__file__).resolve().parent
REPO = W.parents[3]
REVIEW_W = REPO / "proofs/ft1536/work/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002_REVIEW_001"
OUTPUT = REVIEW_W / "output"
rows = {}


def add(rel, source, expected=None):
    data = source.read_bytes()
    digest = hashlib.sha256(data).hexdigest()
    assert expected is None or digest == expected, source
    assert rel not in rows or rows[rel]["sha256"] == digest, rel
    rows[rel] = {"copy": rel, "path": str(source),
                 "original": str(source.relative_to(REPO)),
                 "sha256": digest, "bytes": len(data)}


add("REVIEW_OUTPUTS.sha256", OUTPUT / "REVIEW_OUTPUTS.sha256",
    "a4118200de729562ad1e6396c0bb252a204d9a1ee0f7d7ce085db1fb11689956")
for line in (OUTPUT / "REVIEW_OUTPUTS.sha256").read_text().splitlines():
    digest, rel = line.split("  ", 1)
    add(rel, OUTPUT / rel, digest)
for line in (OUTPUT / "INPUTS.sha256").read_text().splitlines():
    digest, rel = line.split("  ", 1)
    add(rel, REVIEW_W / "inputs" / rel, digest)
plan = sorted(rows.values(), key=lambda row: row["copy"])
(W / "REVIEW_IMPORT_PLAN.json").write_text(json.dumps(plan, indent=2) + "\n")
record = {"scope": "byte-identical review outputs plus the already-pinned relative input origins; frozen sources/manifests unchanged",
          "files": len(plan), "bytes": sum(row["bytes"] for row in plan),
          "review_output_files_including_manifest": 116,
          "declared_input_copies": 1946,
          "manifest_sha256": hashlib.sha256("".join(
              f"{row['sha256']}  {row['copy']}\n" for row in plan).encode()).hexdigest()}
(W / "REVIEW_IMPORT_LAYOUT.json").write_text(json.dumps(record, indent=2) + "\n")
print(json.dumps(record, indent=2))
