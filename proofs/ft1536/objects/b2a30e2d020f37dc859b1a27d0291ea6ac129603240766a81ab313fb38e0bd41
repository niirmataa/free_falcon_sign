#!/usr/bin/env python3
"""Readonly materialization of P02's pinned archives; no proof execution."""
from pathlib import Path, PurePosixPath
import datetime
import hashlib
import json
import re
import subprocess

REPO = Path(__file__).resolve().parents[6]
W = Path(__file__).resolve().parents[1]
BATCH = REPO / "proofs/ft1536/batches/B20_001"
ARCHIVE = REPO / "proofs/ft1536"
DEST = W / "inputs"


def sha(data):
    return hashlib.sha256(data).hexdigest()


def read(path, expected=None):
    assert path.is_file() and not path.is_symlink(), path
    data = path.read_bytes()
    if expected is not None:
        assert sha(data) == expected, (path, expected, sha(data))
    return data


def write(rel, data):
    path = DEST / rel
    assert not path.exists(), path
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)
    path.chmod(0o444)


def manifest(data):
    rows = []
    seen = set()
    for line in data.decode().splitlines():
        digest, rel = line.split("  ", 1)
        assert re.fullmatch(r"[0-9a-f]{64}", digest)
        p = PurePosixPath(rel)
        assert not p.is_absolute() and ".." not in p.parts and rel not in seen, rel
        seen.add(rel)
        rows.append((digest, rel))
    return rows


def main():
    assert not any(DEST.iterdir()), "inputs must be empty"
    task = read(BATCH / "tasks/P02/TASK.md", "9954a8b1b2a73a4f3e475ab45bb7bfe8b9a646b109a8989659a61aa933e5ef1f")
    package = read(BATCH / "PACKAGE.sha256", "e5921b01b4f03f189627c8a0ed8e78e3716e5efe5f2eaa36cfb80d34631633b2")
    for digest, rel in manifest(package):
        read(BATCH / rel, digest)
    contract_raw = read(BATCH / "tasks/P02/INPUT_CONTRACT.json")
    contract = json.loads(contract_raw)
    status_raw = read(BATCH / "STATUS.json")
    status = json.loads(status_raw)["tasks"]
    p01 = status["P01"]
    assert p01["status"] == "REVIEWED" and p01["review_verdict"] == "PASS_SCOPED_REVIEW"
    assert p01["final_report_sha256"] == "e7431aa06716e2960a86fd60bebea2ea213e770dd3f61b39a00292ac80ddd888"
    assert p01["final_outputs_sha256"] == "ebd4cff87995d34d318fa86512aef266a3c3c05f6147c81b8bac307cb2553386"
    specs = dict(contract["fixed_base_inputs"])
    specs["P01"] = {"stage": p01["stage"], "report": "REPORT.md", "report_sha256": p01["final_report_sha256"], "outputs_sha256": p01["final_outputs_sha256"]}
    specs["V01"] = {"stage": p01["review_stage"], "report": "REVIEW.md", "report_sha256": p01["review_report_sha256"], "outputs_sha256": p01["review_outputs_sha256"], "manifest": "REVIEW_OUTPUTS.sha256"}
    objects = {}
    provenance = {}
    for alias, spec in specs.items():
        stage = ARCHIVE / "stages" / spec["stage"]
        report = read(stage / spec["report"], spec["report_sha256"])
        name = spec.get("manifest", "OUTPUTS.sha256")
        data = read(stage / name, spec["outputs_sha256"])
        rows = manifest(data)
        actual = {str(p.relative_to(stage)) for p in stage.rglob("*") if p.is_file()}
        assert actual == {rel for _, rel in rows} | {name}, (alias, "exact set")
        assert not any(p.is_symlink() for p in stage.rglob("*")), alias
        for digest, rel in rows:
            write(f"stages/{alias}/outputs/{rel}", read(stage / rel, digest))
        write(f"stages/{alias}/outputs/{name}", data)
        catalog_raw = read(ARCHIVE / "catalog" / (spec["stage"] + ".json"))
        catalog = json.loads(catalog_raw)
        assert catalog["manifest_sha256"] == spec["outputs_sha256"]
        assert catalog["report_sha256"] == spec["report_sha256"]
        write(f"stages/{alias}/catalog.json", catalog_raw)
        for row in catalog["inputs"]:
            digest = row["sha256"]
            assert row["object"] == "objects/" + digest, row
            if digest not in objects:
                payload = read(ARCHIVE / row["object"], digest)
                write("closure/objects/" + digest, payload)
                objects[digest] = len(payload)
        provenance[alias] = {**spec, "catalog_sha256": sha(catalog_raw), "output_files": len(rows), "catalog_inputs": len(catalog["inputs"])}
    candidate = read(Path(json.loads(read(BATCH / "BASE_INPUTS.json"))["source17_manifest_path"]), "56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985")
    for digest, rel in manifest(candidate):
        write("source17/" + rel, read(ARCHIVE / "objects" / digest, digest))
    write("source17/CANDIDATE.sha256", candidate)
    docs = {
        "TASK.md": task, "INPUT_CONTRACT.json": contract_raw,
        "PACKAGE.sha256": package, "STATUS_at_binding.json": status_raw,
        "TOOLCHAIN_PINS.json": read(BATCH / "TOOLCHAIN_PINS.json"),
        "EXECUTION_PROTOCOL.md": read(REPO / "docs/onboarding/AGENT_EXECUTION_AND_REVIEW_PROTOCOL.md"),
        "SAGEMATH_RULE.md": read(ARCHIVE / "documents/FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22.md"),
    }
    for name, raw in docs.items():
        write("task/" + name, raw)
    binding = {
        "schema": "B20_P02_BOUND_INPUTS_V1", "task_id": contract["task_id"],
        "utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
        "source_base": "ef62824a10a69962dc8347410ee3f424bfa2b12e",
        "head": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=REPO, text=True).strip(),
        "model": "openai/gpt-6-astra-fast", "session": "ses_f33f9f0afffeLad43JuCwKBDk2", "context": "fresh owner-started P02",
        "p01_author_head": p01["head"], "p01_review_scope": p01["review_scope"],
        "stages": provenance, "closure_storage": "deduplicated readonly bytes at closure/objects/<sha>; exact original mappings retained in stage catalogs",
        "closure_objects": len(objects), "closure_bytes": sum(objects.values()),
        "source17_manifest_sha256": sha(candidate), "owner_accepted": False,
    }
    write("BOUND_INPUTS.json", (json.dumps(binding, indent=2, ensure_ascii=False) + "\n").encode())
    lines = [f"{sha(p.read_bytes())}  {p.relative_to(DEST)}\n" for p in sorted(DEST.rglob("*")) if p.is_file()]
    write("MATERIALIZED.sha256", "".join(lines).encode())
    for p in sorted(DEST.rglob("*"), reverse=True):
        if p.is_dir():
            p.chmod(0o555)
    DEST.chmod(0o555)
    print(json.dumps({"binding_sha256": sha((DEST / "BOUND_INPUTS.json").read_bytes()), "files": len(lines), "closure_objects": len(objects), "closure_bytes": sum(objects.values())}, indent=2))


if __name__ == "__main__":
    main()
