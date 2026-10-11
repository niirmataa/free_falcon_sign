#!/usr/bin/env python3
"""Pin the F04/F05 review scope; verify retained bytes without rebuilding Lean.

Python only checks files, imports and recorded compiler output. It supplies no
mathematical proof and does not replace REVIEW_001 or final_clean_002.
"""
import argparse
import hashlib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[6]
BASE = ROOT / "proofs/ft1536/development/T12_1/run2"
REVIEW = ROOT / "proofs/ft1536/work/FT1536_F04_ROM_A_REVIEW_001"
EVIDENCE = BASE / "notes/F04_ROM_VARIANT_A_SCOPE_002"
STANDARD = {"propext", "Classical.choice", "Quot.sound"}
NATIVE = "select_bits_equiv._native.bv_decide.ax_1_5"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_json(path):
    return json.loads(path.read_text())


def pin(path):
    return {"path": path.relative_to(ROOT).as_posix(), "sha256": digest(path)}


def imports(text):
    # Remove nested Lean block comments and line comments before reading imports.
    result, depth, index = [], 0, 0
    while index < len(text):
        pair = text[index:index + 2]
        if pair == "/-":
            depth += 1
            result.append(" ")
            index += 2
        elif pair == "-/" and depth:
            depth -= 1
            result.append(" ")
            index += 2
        elif not depth and pair == "--":
            end = text.find("\n", index)
            index = len(text) if end < 0 else end
        else:
            result.append(text[index] if not depth or text[index] == "\n" else " ")
            index += 1
    assert depth == 0, "Unclosed Lean comment"
    return [module for line in re.findall(r"^import\s+([^\n]+)", "".join(result), re.M)
            for module in line.split()]


def axiom_entries(text):
    entries = []
    for declaration, values in re.findall(
            r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]", text):
        entries.append({"declaration": declaration,
                        "axioms": [value.strip() for value in values.split(",") if value.strip()]})
    return entries


def collect():
    preserved = EVIDENCE / "PRESERVED_INPUTS.sha256"
    preserved_count = 0
    for line in preserved.read_text().splitlines():
        expected, name = line.split("  ", 1)
        assert digest(ROOT / name) == expected, ("Preserved bytes changed", name)
        preserved_count += 1
    copies = read_json(EVIDENCE / "COPIES.json")
    for row in copies:
        copy = EVIDENCE / row["copy"]
        assert digest(copy) == row["sha256"], copy
        if not row["copy"].startswith("PREVIOUS_"):
            assert digest(ROOT / row["original"]) == row["sha256"], row["original"]
        else:
            assert (ROOT / row["original"]).read_bytes().startswith(copy.read_bytes()), row

    pair_path = BASE / "notes/F04_ROM_VARIANT_A_001.json"
    pair = read_json(pair_path)
    author_path = BASE / pair["build"]["final_receipt"]
    assert digest(author_path) == pair["build"]["final_receipt_sha256"]
    assert digest(author_path) == "e37814b7b768a414f4bd6a18eca34e7441d4a2ff3986b6c3cf8cc6b63107caae"
    author = read_json(author_path)
    reviewer_path = REVIEW / "REPLAY_RECEIPT.json"
    reviewer = read_json(reviewer_path)
    assert digest(REVIEW / "REVIEW.md") == "42e5e11fb7dc8b35c71312705733f3ab16e9055bacd099b48cf6cc3c7727f8d7"
    assert len(author["steps"]) == len(reviewer["steps"]) == 167
    assert author["incremental"] is False and reviewer["fresh_project_cache"] is True

    modules, edges, full_entries = [], [], []
    for number, (a, r) in enumerate(zip(author["steps"], reviewer["steps"]), 1):
        module = a["module"]
        assert module == r["module"] and number == r["author_step"]
        source = ROOT / a["source"]
        assert a["source"] == r["original"]
        assert digest(source) == a["source_sha256"] == r["sha256"], module
        assert digest(REVIEW / r["snapshot"]) == r["sha256"], module
        author_snapshot = author_path.parent / f'{number:03d}_{module.replace(".", "_")}.source.lean'
        assert digest(author_snapshot) == r["sha256"], module
        assert a["exit"] == r["exit"] == 0, module
        assert digest(author_path.parent / a["log"]) == a["log_sha256"], module
        log_path = REVIEW / r["log"]
        assert digest(log_path) == r["log_sha256"], module
        entries = axiom_entries(log_path.read_text())
        full_entries.extend({"module": module, **entry} for entry in entries)
        deps = imports(source.read_text())
        edges.extend([module, dep] for dep in deps)
        modules.append({"number": number, "module": module, "source": pin(source),
                        "imports": deps, "author_log_sha256": a["log_sha256"],
                        "review_log": pin(log_path), "recorded_exit": r["exit"],
                        "printed_axiom_entries": len(entries)})

    assert modules[165]["module"] == "SelectBitPreserve"
    assert len(full_entries) == 573
    accepted = [row for row in modules if row["module"] != "SelectBitPreserve"]
    accepted_names = {row["module"] for row in accepted}
    all_names = {row["module"] for row in modules}
    selected_entries = [row for row in full_entries if row["module"] in accepted_names]
    assert len(accepted) == 166 and len(selected_entries) == 569
    assert all(set(row["axioms"]) <= STANDARD for row in selected_entries)
    nonstandard = [row for row in full_entries if not set(row["axioms"]) <= STANDARD]
    assert len(nonstandard) == 3
    assert all(row["module"] == "SelectBitPreserve" and
               set(row["axioms"]) - STANDARD == {NATIVE} for row in nonstandard)
    accepted_edges = [edge for edge in edges if edge[0] in accepted_names]
    assert not [edge for edge in edges if edge[1] == "SelectBitPreserve"]
    assert not [edge for edge in accepted_edges if edge[1] in all_names - accepted_names]
    # Check reverse imports in the full local/archive source mapping as well.
    mapping = {}
    for row in read_json(BASE / "ARCHIVED_DEPENDENCIES.json")["files"]:
        target = row["target"]
        if target.startswith("formal/") and target.endswith(".lean"):
            module = target[7:-5].replace("/", ".")
            mapping[module] = ROOT / row["stage"]
    for path in (BASE / "formal").rglob("*.lean"):
        mapping[path.relative_to(BASE / "formal").with_suffix("").as_posix().replace("/", ".")] = path
    reverse = sorted(module for module, path in mapping.items()
                     if "SelectBitPreserve" in imports(path.read_text()))
    assert not reverse
    external = sorted({dep for _, dep in accepted_edges if dep not in accepted_names})
    assert all(dep.startswith(("Mathlib.", "Std.")) for dep in external), external

    focused = read_json(EVIDENCE / "REVIEW_001.REVIEWER_AXIOMS.json")["declarations"]
    assert len(focused) == 21 and all(set(row["axioms"]) <= STANDARD for row in focused)
    required = set(pair["consumers_repaired"] + pair["f05_delivered"] + [
        "FT1536.HacGlue.romChallengeAt", "FT1536.JointDecomp.samplerLaw_marginal_uniform",
        "FT1536.AssemblyComp.advMT_ge_of_public_sim_stream_win"])
    assert required <= {row["declaration"] for row in focused}
    theta = next(row for row in accepted if row["module"] == "ThetaBox")
    assert theta["number"] == 156
    source = ROOT / theta["source"]["path"]
    test = EVIDENCE / "ThetaBoxLinterEnabled.lean.txt"
    option = b"set_option linter.constructorNameAsVariable false in"
    assert source.read_bytes().count(option) == 1
    assert source.read_bytes().replace(option, option.replace(b"false", b"true")) == test.read_bytes()
    extra = read_json(EVIDENCE / "REVIEW_001.EXTRA_CHECKS_RECEIPT.json")
    test_step = next(row for row in extra if row["name"] == "theta_linter_enabled")
    assert test_step["exit"] == 1 and digest(test) == test_step["source_sha256"]
    test_log = EVIDENCE / "theta_linter_enabled.log"
    assert digest(test_log) == test_step["log_sha256"]
    diagnostic = "linter Lean.Linter.constructorNameAsVariable failed: maximum recursion depth has been reached"
    assert diagnostic in test_log.read_text()

    return {
        "schema": "FT1536_F04_SCOPE_RECEIPT_V2", "scope_id": "F04_ROM_VARIANT_A_SCOPE_002",
        "status": "SCOPE_CORRECTED_AWAITING_TARGETED_RECHECK",
        "scope_kind": "Deliberately broad import-closed review scope, not a minimal export dependency closure",
        "input_commit": reviewer["input_commit"], "mathematical_sources_changed": False,
        "fresh_lean_replay_in_this_correction": False,
        "historical_review_verdict": "CHANGES_REQUIRED (REVIEW_001 unchanged)",
        "author_final_clean_002": pin(author_path), "review_replay": pin(reviewer_path),
        "review_report": pin(REVIEW / "REVIEW.md"),
        "toolchain": {key: reviewer[key] for key in ["lean_version", "lean_sha256", "mathlib_head"]},
        "accepted_module_count": 166, "accepted_module_numbers": [row["number"] for row in accepted],
        "modules": accepted, "imports": accepted_edges, "external_imports": external,
        "axiom_evidence": {
            "allowed_axioms": sorted(STANDARD), "standard_only_for_recorded_scope_audits": True,
            "printed_axiom_entries_in_166_modules": 569,
            "nonstandard_printed_entries_in_166_modules": [],
            "focused_review_declarations": focused,
            "boundary": "Recorded #print axioms and focused review audits; not an enumeration of the entire Lean environment",
        },
        "excluded_diagnostic": {"module": modules[165], "reverse_importers_in_all_mapped_sources": reverse,
                                "mapped_source_count": len(mapping), "extra_axiom": NATIVE,
                                "nonstandard_entries": nonstandard, "excluded_deliberately": True},
        "theta_linter_exception": {
            "module_number": 156, "source": theta["source"], "line": 166,
            "option": "linter.constructorNameAsVariable false", "scope": "blockSum_eq_boxSum only",
            "kind": "Historical tooling exception; no proof or kernel check disabled",
            "test_source": pin(test), "test_log": pin(test_log), "recorded_exit": 1,
            "diagnostic": diagnostic, "fresh_test_in_this_correction": False,
        },
        "preservation": {"manifest": pin(preserved), "verified_files": preserved_count,
                         "copies": copies, "previous_notes_checkpoint_kept_as_exact_prefixes": True},
        "checker": pin(Path(__file__).resolve()),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write-receipt", action="store_true", help="create new receipt exclusively")
    args = parser.parse_args()
    receipt = collect()
    target = EVIDENCE / "RECEIPT.json"
    if args.write_receipt:
        with target.open("x") as stream:
            json.dump(receipt, stream, indent=2, ensure_ascii=False)
            stream.write("\n")
    else:
        assert read_json(target) == receipt, "Receipt differs from recomputed evidence"
    print(f'PASS scope: {receipt["accepted_module_count"]} modules; 569 printed axiom entries; '
          f'{receipt["preservation"]["verified_files"]} retained files unchanged; no Lean replay')


if __name__ == "__main__":
    main()
