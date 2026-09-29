"""Pin existing P02 materials for an owner-approved packaging supplement."""
from datetime import datetime, timezone
import importlib.util
import json
from pathlib import Path

W = Path(__file__).resolve().parent
REPO = W.parents[5]
ROOT = REPO / "proofs/ft1536"
P02 = ROOT / "work/B20_001/P02"
spec = importlib.util.spec_from_file_location("archive", ROOT / "tools/archive.py")
archive = importlib.util.module_from_spec(spec)
spec.loader.exec_module(archive)
plan = {}


def add(dest, source, expected=None):
    data = archive.checked_bytes(source, expected)
    digest = archive.digest(data)
    archive.require(dest not in plan or plan[dest]["sha256"] == digest, "Conflicting input")
    plan[dest] = {"copy": dest, "path": str(source),
                  "original": str(source.relative_to(REPO)), "sha256": digest, "bytes": len(data)}


def main():
    old_outputs = archive.manifest(archive.checked_bytes(P02 / "output/OUTPUTS.sha256",
        "4e8942ccaf46f0971688a0f0cc1d07c5831a46175e6ad2dde903c9f55b046a01"))
    for rel, digest in old_outputs.items():
        add("prior/output/" + rel, P02 / "output" / rel, digest)
    add("prior/output/OUTPUTS.sha256", P02 / "output/OUTPUTS.sha256")
    materialized = archive.manifest(archive.checked_bytes(P02 / "inputs/MATERIALIZED.sha256",
        "d70316d8450015aba6980a8c521f9979046b1983e6d6dcef5400f864abeef03b"))
    archive.require(archive.regular_files(P02 / "inputs") == set(materialized) | {"MATERIALIZED.sha256"},
                    "Original P02 input exact-set mismatch")
    for rel, digest in materialized.items():
        add("prior/inputs/" + rel, P02 / "inputs" / rel, digest)
    add("prior/inputs/MATERIALIZED.sha256", P02 / "inputs/MATERIALIZED.sha256")

    receipts = json.loads(archive.read(P02 / "output/EXECUTION_RECEIPTS.json"))["runs"]
    counts = []
    text_suffixes = {".json", ".sha256", ".stdout", ".stderr", ".log", ".txt", ".md",
                     ".sage", ".py", ".c", ".h", ".lean", ".ndjson", ".csv", ".git-tree", ".exit"}
    for row in receipts:
        root = P02 / "run" / row["id"]
        receipt = json.loads(archive.read(root / "receipt.json"))
        archive.require(receipt["sources_unchanged"] and receipt["source_before"] == receipt["source_after"],
                        "Changed source snapshot in recorded job")
        add(f"prior/run/{row['id']}/receipt.json", root / "receipt.json")
        add(f"prior/run/{row['id']}/job.py", root / "job.py")
        for rel, digest in receipt["source_before"].items():
            add(f"prior/run/{row['id']}/source/{rel}", root / "source" / rel, digest)
        for step in receipt["steps"]:
            for key in ("stdout", "stderr"):
                add(f"prior/run/{row['id']}/{step[key]}", root / step[key], step[key + "_sha256"])
        products = 0
        for rel, digest in receipt["products"].items():
            if Path(rel).suffix in text_suffixes:
                add(f"prior/run/{row['id']}/{rel}", root / rel, digest)
                products += 1
        counts.append({"run": row["id"], "recorded_exit_code": receipt["exit_code"],
                       "recorded_steps": len(receipt["steps"]), "source_files": len(receipt["source_before"]),
                       "raw_step_logs": 2 * len(receipt["steps"]), "text_products": products})
    add("prior/run/job.py", P02 / "run/job.py")
    for name in ("HANDOFF.md", "AGENTS.md"):
        add("prior/" + name, P02 / name)
    for name in ("AuditExports.lean", "AuditTerms.lean"):
        add("prior/current_audits/" + name, P02 / "src" / name)
    for name in ("PRECHECK.json", "OWNER_DECISION.md"):
        add("context/" + name, W / name)
    batch = ROOT / "batches/B20_001"
    for rel in ("tasks/P02/TASK.md", "tasks/P02/INPUT_CONTRACT.json", "reviews/V02/REVIEW_TASK.md",
                "reviews/V02/INPUT_CONTRACT.json", "TOOLCHAIN_PINS.json", "PACKAGE.sha256", "STATUS.json"):
        add("context/B20/" + rel, batch / rel)
    for name in ("AGENT_EXECUTION_AND_REVIEW_PROTOCOL.md", "B20_COORDINATOR_TOOLS.md"):
        add("context/" + name, REPO / "docs/onboarding" / name)
    add("context/SAGEMATH_POLICY.md", ROOT / "documents/FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22.md")
    t03 = ROOT / "stages/FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002_REVIEW_001"
    t03_rows = archive.manifest(archive.read(t03 / "REVIEW_OUTPUTS.sha256"))
    for name in ("REVIEW.md", "REVIEW_RESULT.json", "NEXT_INTERFACE.md"):
        add("context/T03_REVIEW/" + name, t03 / name, t03_rows[name])
    add("context/T03_REVIEW/REVIEW_OUTPUTS.sha256", t03 / "REVIEW_OUTPUTS.sha256",
        "a4118200de729562ad1e6396c0bb252a204d9a1ee0f7d7ce085db1fb11689956")

    rows = sorted(plan.values(), key=lambda row: row["copy"])
    raw = "".join(f"{row['sha256']}  {row['copy']}\n" for row in rows).encode()
    (W / "CLOSURE_INPUT_PLAN.json").write_text(json.dumps(rows, indent=2) + "\n")
    result = {"utc": datetime.now(timezone.utc).isoformat(), "scope": "owner-approved preparation only; no original freeze edits or replay",
              "files": len(rows), "bytes": sum(row["bytes"] for row in rows), "manifest_sha256": archive.digest(raw),
              "prior_output_members": len(old_outputs), "prior_input_members": len(materialized), "runs": counts,
              "extra_material_pinning": "Historical raw records originally outside OUTPUTS are pinned now, without claiming they were part of the old freeze."}
    (W / "CLOSURE_INPUT_EXPECTED.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        (W / "SUPPLEMENT_PREPARATION_STOP.json").write_text(json.dumps({"error": repr(error),
            "source_unchanged": True, "further_actions_stopped": True}, indent=2) + "\n")
        raise
