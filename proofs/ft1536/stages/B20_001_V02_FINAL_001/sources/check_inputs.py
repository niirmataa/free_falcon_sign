"""V02 independent exact-set and byte verification; organization, not math."""
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import subprocess
import sys
from datetime import datetime, timezone

W = Path(__file__).resolve().parents[1]
R = W.parents[4]
IN = W / "inputs"
O = IN / "subject"
AUTHOR = R / "proofs/ft1536/work/FT1536_P02_FREEZE_CLOSURE_RUN_001/output"
SHA = {
    "report": "ce3cad727ce44894cf633085f87b001cca742a7fe3a0a6dc2c750d6f5ac051e5",
    "outputs": "af60f1b43843160ded4b977bbdc4ae42d5547a42937ec254f40be8b755f4e44e",
    "manifest": "6b07625125728ce3f8888c067e164e94b9c358e493f9ede74bee028abdc711e6",
    "bound": "15d1ee66a28743982854bc680ab7c81bf711506686dde8ab940f887a530a0923",
    "static": "b0a57afa260c403a11901ef29676104729306c02ecd856b07170ec261ab76045",
    "predecessor": "4e8942ccaf46f0971688a0f0cc1d07c5831a46175e6ad2dde903c9f55b046a01",
}


def sha(path):
    h = hashlib.sha256()
    with path.open("rb") as f:
        for block in iter(lambda: f.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def manifest(path):
    rows = {}
    for line in path.read_text().splitlines():
        digest, sep, name = line.partition("  ")
        parts = PurePosixPath(name).parts
        assert sep and len(digest) == 64 and all(c in "0123456789abcdef" for c in digest)
        assert name and name == str(PurePosixPath(name)) and name not in rows
        assert not name.startswith("/") and not any(p in (".", "..") for p in parts)
        rows[name] = digest
    return rows


def validate(root, rows, except_paths=()):
    actual = set()
    for base, dirs, files in os.walk(root, followlinks=False):
        for name in dirs + files:
            p = Path(base) / name
            assert not p.is_symlink(), p
        for name in files:
            p = Path(base) / name
            rel = p.relative_to(root).as_posix()
            assert p.is_file() and rel not in actual, rel
            actual.add(rel)
    assert actual == set(rows) | set(except_paths), (len(actual), len(rows), list(actual ^ (set(rows) | set(except_paths)))[:5])
    total = 0
    for rel, digest in rows.items():
        p = root / rel
        assert sha(p) == digest, rel
        total += p.stat().st_size
    return total


def main():
    start = datetime.now(timezone.utc)
    assert sha(O / "REPORT.md") == sha(AUTHOR / "REPORT.md") == SHA["report"]
    assert sha(O / "OUTPUTS.sha256") == sha(AUTHOR / "OUTPUTS.sha256") == SHA["outputs"]
    assert sha(IN / "MANIFEST.sha256") == SHA["manifest"]
    assert sha(IN / "BOUND_INPUTS.json") == SHA["bound"]
    assert sha(O / "INPUTS.sha256") == SHA["static"]
    assert sha(O / "predecessor/OUTPUTS.sha256") == SHA["predecessor"]
    task = R / "proofs/ft1536/batches/B20_001/reviews/V02/REVIEW_TASK.md"
    assert sha(task) == "cfd4d2eb1e4806a6772b6013ad34a6d9d086b906a4bf9cd96f81dc1e0fa4a382"
    assert sha(R / "proofs/ft1536/batches/B20_001/tasks/P02/TASK.md") == "9954a8b1b2a73a4f3e475ab45bb7bfe8b9a646b109a8989659a61aa933e5ef1f"
    assert sha(R / "proofs/ft1536/documents/FT1536_ODBIOR_B20_V02_P02_V2_2026-09-29.md") == "d821b504bf4073f161d452b0c4923b857c59d25464e3994e5a701e4d45da9f3e"
    head = subprocess.check_output(["git", "rev-parse", "41216bb8d61004bb941a8d1b276f43346df11ce8^{commit}"], cwd=R, text=True).strip()
    assert head == "41216bb8d61004bb941a8d1b276f43346df11ce8"
    author_rows = manifest(O / "OUTPUTS.sha256")
    assert len(author_rows) == 30612
    subject_bytes = validate(O, author_rows, ("OUTPUTS.sha256",))
    author_bytes = validate(AUTHOR, author_rows, ("OUTPUTS.sha256",))
    in_rows = manifest(IN / "MANIFEST.sha256")
    assert len(in_rows) == 30626
    in_bytes = validate(IN, in_rows, ("MANIFEST.sha256", "ORIGINS.json", "BOUND_INPUTS.json"))
    assert {k[8:]: v for k, v in in_rows.items() if k.startswith("subject/")} == author_rows | {"OUTPUTS.sha256": SHA["outputs"]}
    static = manifest(O / "INPUTS.sha256")
    assert len(static) == 29751 and all(author_rows.get(k) == v for k, v in static.items())
    prior = manifest(O / "predecessor/OUTPUTS.sha256")
    assert len(prior) == 68 and all(author_rows.get("predecessor/" + k) == v for k, v in prior.items())
    limits = json.loads((O / "OVERWRITTEN_LOGS.json").read_text())
    assert limits["count"] == len(limits["rows"]) == 6
    for item in limits["rows"]:
        assert author_rows[item["overwritten_path"]] == item["overwritten_hash"]
        assert author_rows[item["byte_identical_origin"]] == author_rows[item["replacement_path"]] == item["expected_hash"]
    info = json.loads((O / "RESULT.json").read_text())
    assert info["status"] == "PARTIAL_PROOF" and info["complete_for_review"] is True
    assert info["new_package_head"] == head and info["owner_accepted"] is False
    report = dict(status="PASS", started_utc=start.isoformat(), stopped_utc=datetime.now(timezone.utc).isoformat(),
                  head=head, pins=SHA, input_members=len(in_rows), input_bytes=in_bytes,
                  subject_members=len(author_rows), subject_bytes=subject_bytes,
                  author_members=len(author_rows), author_bytes=author_bytes,
                  static_members=len(static), predecessor_members=len(prior), historical_overwrites=len(limits["rows"]),
                  old_final_head="UNRECORDED", author_unchanged=True)
    label = os.environ.get("V02_VERIFY_LABEL", "initial")
    assert label in ("initial", "after", "final")
    out = W / ("run/input_verification_" + label + ".json")
    out.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        print(f"INTEGRITY_FAILURE {exc!r}", file=sys.stderr)
        raise
