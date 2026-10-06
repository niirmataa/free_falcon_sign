"""Check draft structure, cited input bytes, display rows and TeX diagnostics.

This checks the publication artifact; it does not check mathematical validity.
"""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import subprocess

PAPER = Path(__file__).resolve().parents[1]
ROOT = PAPER.parents[2]


def main():
    sources = (PAPER / "SOURCES.md").read_text()
    manifest = PAPER / "SOURCES.sha256"
    checked = []
    for line in manifest.read_text().splitlines():
        if not line or line.startswith("#"):
            continue
        expected, relative = line.split("  ", 1)
        path = ROOT / relative
        assert path.is_file(), f"Missing cited input: {relative}"
        actual = hashlib.sha256(path.read_bytes()).hexdigest()
        assert actual == expected, f"Changed cited input: {relative}: {actual} != {expected}"
        checked.append(relative)
    assert len(checked) == len(set(checked)), "Duplicate source pins"
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
    result = {
        "utc": datetime.now(timezone.utc).isoformat(), "status": "PASS",
        "scope": "Document, exact-input and display-arithmetic checks only; no Lean/S06 replay",
        "source_pins": len(checked), "claim_ids": sorted(ids),
        "sections": len(sections), "annexes": len(annexes), "pages": pages,
        "tex_diagnostics": bad,
        "source_manifest_sha256": hashlib.sha256(manifest.read_bytes()).hexdigest(),
        "pdf_sha256": hashlib.sha256((PAPER / "build/main.pdf").read_bytes()).hexdigest(),
        "tex_sha256": {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in files},
    }
    (PAPER / "build/CHECK.json").write_text(json.dumps(result, indent=2) + "\n")
    print(f"PASS: {len(checked)} source pins, {len(ids)} source IDs, 11 sections + 2 annexes, {pages} pages; clean TeX/BibTeX logs")


if __name__ == "__main__":
    main()
