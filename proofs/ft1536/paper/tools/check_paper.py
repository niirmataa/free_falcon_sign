"""Check draft structure, cited input bytes, display rows and TeX diagnostics.

This checks the publication artifact; it does not check mathematical validity.
"""
from datetime import datetime, timezone
import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess

from document_snapshot import sha256, snapshot_tex, verified_inputs

PAPER = Path(__file__).resolve().parents[1]
ROOT = PAPER.parents[2]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--receipt", type=Path, help="New immutable JSON receipt under paper/notes/")
    args = parser.parse_args()
    receipt = None
    if args.receipt:
        receipt = (PAPER / args.receipt).resolve()
        assert (PAPER / "notes").resolve() in receipt.parents, "Receipt must be under paper/notes/"
        assert not receipt.exists(), f"Receipt already exists: {receipt}"
    sources = (PAPER / "SOURCES.md").read_text()
    manifest = PAPER / "SOURCES.sha256"
    checked = verified_inputs()
    generated = PAPER / "build/snapshot.tex"
    assert generated.read_text() == snapshot_tex(checked), "Stale in-PDF snapshot; run make pdf"
    inventory = re.search(r"<!-- PINNED_INPUTS -->\s*```text\n(.*?)\n```", sources, re.S)
    assert set(checked) == set(inventory.group(1).splitlines()), "Inventory/manifest mismatch"
    review = json.loads((ROOT / "proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_002/REVIEW_RESULT_FINAL.json").read_text())
    for entry in review["sources"]:
        assert hashlib.sha256((ROOT / entry["path"]).read_bytes()).hexdigest() == entry["sha256"], entry["path"]
    assert review["review_kind"] == "AUTHOR_RECHECK" and not review["independent_of_author"]
    independent = json.loads((ROOT / "proofs/ft1536/work/FT1536_B2B5_COMPUTATIONAL_REVIEW_003/REVIEW_RESULT.json").read_text())
    assert independent["role"] == "INDEPENDENT_REVIEWER"
    assert independent["independent_of_author"] and independent["fresh_context"]
    assert independent["commit"] == review["commit"]
    assert independent["verdict"] == "PASS_SCOPED" and not independent["changes_required"]
    files = sorted(PAPER.glob("*.tex"))
    text = "\n".join(p.read_text() for p in files)
    sections = sorted(PAPER.glob("sec_*.tex"))
    annexes = sorted(PAPER.glob("annex_*.tex"))
    assert len(sections) == 11 and len(annexes) == 2
    assert all(len(re.findall(r"\\section\{", p.read_text())) == 1 for p in sections + annexes)
    main_tex = (PAPER / "main.tex").read_text()
    for p in sections + annexes:
        assert "\\input{" + p.stem + "}" in main_tex, p.name
    assert re.findall(r"\\input\{(sec_[^}]+)\}", main_tex) == [
        "sec_01_intro", "sec_03_model", "sec_02_parameters", "sec_04_main",
        "sec_05_reduction", "sec_06_sampler", "sec_07_binding", "sec_08_security",
        "sec_09_computational", "sec_10_related", "sec_11_limits",
    ], "Section order changed"
    assert main_tex.index(r"\bibliography{refs}") < main_tex.index(r"\appendix")
    references = set(re.findall(r"\\(?:eqref|ref)\{([^}]+)\}", text))
    for environment, body in re.findall(
        r"\\begin\{(theorem|lemma|corollary|proposition|definition|assumption|remark|target)\}"
        r"(.*?)\\end\{\1\}", text, re.S
    ):
        label = re.search(r"\\label\{([^}]+)\}", body)
        assert label and label.group(1) in references, f"Unreferenced {environment}: {body[:100]}"
    ids = {i.strip() for group in re.findall(r"\\src\{([^}]+)\}", text) for i in group.split(",")}
    declared = set(re.findall(r"^### (C\d+)\b", sources, re.M))
    assert ids == declared, f"Source ID mismatch: used-only={ids-declared}; mapped-only={declared-ids}"
    assert not re.search(r"\\todo\{DRAFT-", text), "Unwritten requested first draft"
    for key in ["B1-HONEST-HOP", "B1-LAWS", "B1-ATTEMPT-SHAPE", "S06-CERTIFICATE", "ORIGIN"]:
        assert "\\todo{" + key + "}" in text, key
    log = (PAPER / "build/main.log").read_text()
    bad = [line for line in log.splitlines()
           if re.search(r"(^!|Warning:|Overfull \\[hv]box|Underfull \\[hv]box|undefined)", line)]
    assert not bad, "TeX diagnostics:\n" + "\n".join(bad)
    bib_log = (PAPER / "build/main.blg").read_text()
    assert not re.search(r"Warning--|error message|I couldn't", bib_log)
    numbers = json.loads((PAPER / "build/numbers.json").read_text())
    security = (PAPER / "sec_08_security.tex").read_text()
    for row in numbers["costs"].values():
        assert row["lattice_display"] in security, row
        assert f'{row["beta_P1"]}/{row["beta_P2"]}' in security, row
    for relative, expected in numbers["inputs"].items():
        assert hashlib.sha256((ROOT / relative).read_bytes()).hexdigest() == expected, relative
    info = subprocess.check_output(["pdfinfo", str(PAPER / "build/main.pdf")], text=True)
    pages = int(re.search(r"^Pages:\s+(\d+)", info, re.M).group(1))
    pdf_text = subprocess.check_output(["pdftotext", "-layout", str(PAPER / "build/main.pdf"), "-"], text=True)
    assert "honesty ledger" in pdf_text
    for heading in ["What is fixed, proved, and still being analyzed", "Evidence and limitations",
                    "Artifact bindings", "Validation (not a proof)"]:
        assert heading in pdf_text, f"Missing benchmark feature: {heading}"
    pdf_compact = re.sub(r"\s+", "", pdf_text)
    metadata = json.loads((PAPER / "sources/DOCUMENT_SNAPSHOT.json").read_text())
    displayed = [metadata[key] for key in ["editorial_base_commit", "computational_commit", "b1_status_commit"]]
    displayed += [sha256(manifest), sha256(PAPER / "SOURCES.md")]
    displayed += [checked[item["path"]] for item in metadata["selected_inputs"]]
    assert all(pin in pdf_compact for pin in displayed), "Missing or stale rendered snapshot pin"
    manuscript = files + [PAPER / name for name in [
        "refs.bib", "Makefile", "SOURCES.md", "SOURCES.sha256", "README.md",
        "sources/DOCUMENT_SNAPSHOT.json", "sources/EXTERNAL_REFERENCES.md",
    ]] + sorted((PAPER / "tools").glob("*.py")) + sorted((PAPER / "tools").glob("*.sage"))
    result = {
        "utc": datetime.now(timezone.utc).isoformat(), "status": "PASS",
        "scope": "Document, exact-input and display-arithmetic checks only; no Lean/S06 replay",
        "source_pins": len(checked), "claim_ids": sorted(ids),
        "sections": len(sections), "annexes": len(annexes), "pages": pages,
        "tex_diagnostics": bad,
        "source_manifest_sha256": hashlib.sha256(manifest.read_bytes()).hexdigest(),
        "pdf_sha256": hashlib.sha256((PAPER / "build/main.pdf").read_bytes()).hexdigest(),
        "tex_sha256": {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in files},
        "manuscript_sha256": {str(p.relative_to(PAPER)): sha256(p) for p in manuscript},
        "snapshot_tex_sha256": sha256(generated),
        "rendered_snapshot_pins": len(displayed),
        "formal_environment_references": "PASS",
    }
    if receipt:
        artifacts = PAPER / "build/receipts" / receipt.stem
        artifacts.mkdir(parents=True, exist_ok=False)
        result["retained_build"] = {}
        for name in ["main.pdf", "main.log", "main.blg", "snapshot.tex"]:
            target = artifacts / name
            shutil.copyfile(PAPER / "build" / name, target)
            result["retained_build"][str(target.relative_to(PAPER))] = sha256(target)
        with receipt.open("x") as stream:
            stream.write(json.dumps(result, indent=2) + "\n")
    (PAPER / "build/CHECK.json").write_text(json.dumps(result, indent=2) + "\n")
    print(f"PASS: {len(checked)} source pins, {len(ids)} source IDs, 11 sections + 2 annexes, {pages} pages; clean TeX/BibTeX logs")


if __name__ == "__main__":
    main()
