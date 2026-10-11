#!/usr/bin/env python3
"""Targeted, read-only F04 scope/evidence checks; never invokes Lean.

This is a separate recheck implementation. It neither imports nor runs the
scope author's check_f04_scope_002.py. Output is created exclusively.
"""
import argparse
import hashlib
import json
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[6]
BASE = ROOT / "proofs/ft1536/development/T12_1/run2"
SCOPE = BASE / "notes/F04_ROM_VARIANT_A_SCOPE_002"
OLD = ROOT / "proofs/ft1536/work/FT1536_F04_ROM_A_REVIEW_001"
STANDARD = {"propext", "Classical.choice", "Quot.sound"}
AXIOM = "select_bits_equiv._native.bv_decide.ax_1_5"
INPUTS = {}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def read(path):
    data = path.read_bytes()
    INPUTS[path.relative_to(ROOT).as_posix()] = sha(data)
    return data


def obj(path):
    return json.loads(read(path))


def git(*args):
    return subprocess.check_output(["git", "--no-optional-locks", *args], cwd=ROOT)


def pinned(row):
    data = read(ROOT / row["path"])
    assert sha(data) == row["sha256"], row["path"]
    return data


def manifest(path, root):
    lines = read(path).decode().splitlines()
    for line in lines:
        expected, filename = line.split("  ", 1)
        assert sha(read(root / filename)) == expected, filename
    return len(lines)


def import_names(data):
    text = data.decode()
    # Drop line/block comments, iterating innermost blocks to handle nesting.
    previous = None
    while previous != text:
        previous = text
        text = re.sub(r"/-((?:(?!/-|-/)[\s\S])*)-/", lambda m: "\n" * m[0].count("\n"), text)
    text = re.sub(r"--[^\n]*", "", text)
    return [name for line in text.splitlines() if line.startswith("import ")
            for name in line[len("import "):].split()]


def run():
    target = SCOPE / "RECEIPT.json"
    receipt = obj(target)
    assert sha(read(target)) == "675e96ee8a3398688f83a1a2d5f9297369d285aac2da67557fef12f48a0427e9"
    numbers = list(range(1, 166)) + [167]
    rows = receipt["modules"]
    assert receipt["accepted_module_count"] == len(rows) == 166
    assert receipt["accepted_module_numbers"] == [r["number"] for r in rows] == numbers
    names = {r["module"] for r in rows}
    assert len(names) == 166 and "SelectBitPreserve" not in names
    all_rows = sorted(rows + [receipt["excluded_diagnostic"]["module"]], key=lambda r: r["number"])
    assert [r["number"] for r in all_rows] == list(range(1, 168))

    author = obj(ROOT / receipt["author_final_clean_002"]["path"])
    reviewer = obj(ROOT / receipt["review_replay"]["path"])
    assert len(author["steps"]) == len(reviewer["steps"]) == 167
    edges, printed, axiom_free, source_checks = [], [], [], []
    commit = receipt["input_commit"]
    for row, a, r in zip(all_rows, author["steps"], reviewer["steps"]):
        number, name = row["number"], row["module"]
        assert name == a["module"] == r["module"] and number == r["author_step"]
        source = pinned(row["source"])
        git_source = git("show", commit + ":" + row["source"]["path"])
        assert source == git_source
        expected = row["source"]["sha256"]
        assert expected == a["source_sha256"] == r["sha256"]
        assert sha(read(OLD / r["snapshot"])) == expected
        assert a["exit"] == r["exit"] == 0
        source_checks.append({"number": number, "module": name, "sha256": expected,
                              "matches_original_review_git_commit": True})
        deps = import_names(source)
        assert deps == row["imports"]
        if name in names:
            edges.extend([[name, dep] for dep in deps])
        log = pinned(row["review_log"]).decode()
        assert row["review_log"]["sha256"] == r["log_sha256"]
        entries = re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]", log)
        axiom_free.extend({"module": name, "declaration": declaration} for declaration in
                          re.findall(r"'([^']+)' does not depend on any axioms", log))
        assert len(entries) == row["printed_axiom_entries"]
        for declaration, values in entries:
            axioms = {value.strip() for value in values.split(",") if value.strip()}
            if name in names:
                assert axioms <= STANDARD, (name, declaration, axioms)
            printed.append({"module": name, "declaration": declaration, "axioms": sorted(axioms)})
    assert edges == receipt["imports"]
    external = {dep for _, dep in edges if dep not in names}
    assert sorted(external) == receipt["external_imports"]
    assert all(dep.startswith("Mathlib.") for dep in external)
    assert not any(dep == "SelectBitPreserve" for _, dep in edges)
    # Independently reconstruct the full source map and its reverse imports.
    source_map = {}
    for row in obj(BASE / "ARCHIVED_DEPENDENCIES.json")["files"]:
        if row["target"].startswith("formal/") and row["target"].endswith(".lean"):
            source_map[row["target"][7:-5].replace("/", ".")] = ROOT / row["stage"]
    for path in (BASE / "formal").rglob("*.lean"):
        source_map[path.relative_to(BASE / "formal").with_suffix("").as_posix().replace("/", ".")] = path
    reverse = [name for name, path in source_map.items() if "SelectBitPreserve" in import_names(read(path))]
    assert not reverse
    scoped_prints = [p for p in printed if p["module"] in names]
    assert len(printed) == 573 and len(scoped_prints) == 569
    assert len(axiom_free) == 12 and all(p["module"] in names for p in axiom_free)
    extra = [p for p in printed if not set(p["axioms"]) <= STANDARD]
    assert len(extra) == 3 and all(p["module"] == "SelectBitPreserve" and AXIOM in p["axioms"] for p in extra)
    focused = obj(OLD / "evidence/REVIEWER_AXIOMS.json")["declarations"]
    assert len(focused) == 21 and all(set(p["axioms"]) <= STANDARD for p in focused)
    assert focused == receipt["axiom_evidence"]["focused_review_declarations"]
    listed = re.findall(r"^\| (\d+) \| `([^`]+)` \| `([0-9a-f]+)` \|$", read(SCOPE / "MODULES.md").decode(), re.M)
    assert [(int(n), m, h) for n, m, h in listed] == [(r["number"],r["module"],r["source"]["sha256"]) for r in rows]

    theta = receipt["theta_linter_exception"]
    theta_source = pinned(theta["source"])
    false = b"set_option linter.constructorNameAsVariable false in"
    assert theta_source.count(false) == 1
    assert theta_source.splitlines()[165] == false
    assert pinned(theta["test_source"]) == theta_source.replace(false, false.replace(b"false", b"true"))
    assert theta_source == git("show", "832a9953^:" + theta["source"]["path"])
    theta_log = pinned(theta["test_log"])
    assert theta["diagnostic"].encode() in theta_log
    extra_checks = obj(OLD / "EXTRA_CHECKS_RECEIPT.json")
    theta_step = next(p for p in extra_checks if p["name"] == "theta_linter_enabled")
    assert theta_step["exit"] == theta["recorded_exit"] == 1
    assert theta_step["source_sha256"] == theta["test_source"]["sha256"]
    assert theta_step["log_sha256"] == theta["test_log"]["sha256"]
    assert theta_step["seconds"] < 30 and theta_step["command"][-2:] == ["30", "0"]

    changed_math = git("diff", commit, "HEAD", "--name-only", "--", str(BASE.relative_to(ROOT) / "formal"),
                       str(BASE.relative_to(ROOT) / "sage")).decode().splitlines()
    assert not changed_math and receipt["mathematical_sources_changed"] is False
    correction_paths = git("diff-tree", "--no-commit-id", "--name-only", "-r", "3fe2fa53").decode().splitlines()
    assert not any(p.endswith((".lean", ".sage")) for p in correction_paths)
    for copied in receipt["preservation"]["copies"]:
        original = read(ROOT / copied["original"])
        copy = read(SCOPE / copied["copy"])
        assert sha(copy) == copied["sha256"]
        if copied["copy"].startswith("PREVIOUS_"):
            assert copy == git("show", commit + ":" + copied["original"])
            assert original.startswith(copy)
        else:
            assert original == copy
    assert sha(read(OLD / "REVIEW.md")) == "42e5e11fb7dc8b35c71312705733f3ab16e9055bacd099b48cf6cc3c7727f8d7"
    old_result = obj(OLD / "REVIEW_RESULT.json")
    assert sha(read(OLD / "REVIEW_RESULT.json")) == "e03a89139fe403e40768420bde53aa321ec0ea2489a929b1ec8f40828cca164a"
    assert old_result["verdict"] == "CHANGES_REQUIRED"
    assert "CHANGES_REQUIRED" in receipt["historical_review_verdict"]
    historical = {"preserved_input_files": manifest(ROOT / receipt["preservation"]["manifest"]["path"], ROOT),
                  "review_outputs": manifest(OLD / "REVIEW_OUTPUTS.sha256", OLD),
                  "review_inputs": manifest(OLD / "INPUTS.sha256", OLD),
                  "review_external_inputs": manifest(OLD / "INPUTS.external.sha256", ROOT)}
    assert historical["preserved_input_files"] == 3813
    for key, expected in [("author_final_clean_002", old_result["author_receipt_sha256"]),
                          ("review_replay", old_result["fresh_replay"]["receipt_sha256"])]:
        assert sha(pinned(receipt[key])) == expected

    return {"schema": "FT1536_F04_TARGETED_RECHECK_V1", "checked_head": git("rev-parse", "HEAD").decode().strip(),
            "target_receipt": {"path": str(target.relative_to(ROOT)), "sha256": sha(read(target))},
            "controls": {letter: "PASS" for letter in "abcde"},
            "accepted_numbers": numbers, "accepted_modules": len(rows), "import_edges": len(edges),
            "external_modules": len(external), "mapped_sources": len(source_map), "reverse_importers": reverse,
            "standard_only_prints": len(scoped_prints), "focused_declarations": len(focused),
            "dependency_list_results_in_166_modules": len(scoped_prints),
            "additional_axiom_free_results": axiom_free,
            "all_print_axioms_results_in_166_modules": len(scoped_prints) + len(axiom_free),
            "count_convention": "Receipt569 counts depends-on-axioms records; 12 axiom-free records are additional, hence 581 total #print axioms results",
            "axiom_evidence_boundary": receipt["axiom_evidence"]["boundary"],
            "excluded_extra_axiom": AXIOM, "excluded_extra_axiom_entries": extra,
            "theta_test": theta, "mathematical_sources_changed": False, "source_checks": source_checks,
            "changed_math_paths_since_review": changed_math, "correction_paths": correction_paths,
            "historical_verdict": old_result["verdict"], "historical_manifests": historical,
            "author_final_clean_002": receipt["author_final_clean_002"], "review_replay": receipt["review_replay"],
            "fresh_full_replay": False, "lean_invocations": 0,
            "checker_sha256": sha(Path(__file__).read_bytes()), "inputs": INPUTS}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output", type=Path, help="new JSON output file; must not exist")
    args = parser.parse_args()
    result = run()
    with args.output.open("x") as stream:
        json.dump(result, stream, indent=2, ensure_ascii=False)
        stream.write("\n")
    print("PASS (a)-(e): scope166, immutable mathematical sources/history, pinned replay receipts; Lean invocations=0")
