#!/usr/bin/env python3
"""Bind every Lean block literal and theorem target to witness vectors."""
import json
from pathlib import Path
import re
import sys

if len(sys.argv) != 3:
    raise SystemExit("usage: check_lean_binding.py WitnessBlocks.lean witness.json")
lean_path, witness_path = map(Path, sys.argv[1:])
src = lean_path.read_text(encoding="utf-8")
w = json.loads(witness_path.read_text(encoding="utf-8"))
errors = []
for forbidden in ("sorry", "admit", "axiom ", "unsafe", "native_decide"):
    if re.search(r"\b" + re.escape(forbidden.strip()) + r"\b", src):
        errors.append("forbidden token: " + forbidden.strip())

pairs = []
block_sizes = []
for i in range(12):
    m = re.search(rf"def block_{i} .*? := \[(.*?)\]\s*\n\s*theorem block_{i}_norm", src, re.S)
    if not m:
        errors.append(f"missing block_{i}")
        continue
    block = [(int(a), int(b)) for a, b in re.findall(r"\((-?\d+),\s*(-?\d+)\)", m.group(1))]
    block_sizes.append(len(block))
    pairs.extend(block)
expected_pairs = list(zip(w["z1"][:768], w["z1"][768:]))
if pairs != expected_pairs:
    errors.append("Lean pair literals do not equal witness z1 offset-768 pairs")

required_fragments = [
    "theorem pair_counts : firstPairs.length = 768",
    "theorem first_total : energy firstPairs = 42658711057",
    "theorem second_total : energy secondPairs = 400000000",
    "theorem full_extractor_norm : energy firstPairs + energy secondPairs = 43058711057",
    "theorem machine_pair_short : energy machinePairs + energy secondPairs < 2093922385",
    "theorem extractor_pair_not_short : ¬ energy firstPairs + energy secondPairs < 2093922385",
    "theorem extractor_excess : energy firstPairs + energy secondPairs - 2093922385 = 40964788672",
    "theorem pre_ntt_word : ((-20000 : Int) + 18433) % 65536 = 63969",
    "theorem distinct_residues : (-20000 : Int) % 18433 = 16866 ∧ (63969 : Int) % 18433 = 8670",
]
for fragment in required_fragments:
    if fragment not in src:
        errors.append("missing target fragment: " + fragment)

theorem_names = re.findall(r"^theorem\s+([A-Za-z0-9_]+)", src, re.M)
printed = re.findall(r"^#print axioms\s+([A-Za-z0-9_]+)", src, re.M)
if theorem_names != printed:
    errors.append("#print axioms list does not exactly cover theorem declarations in order")
out = {
    "schema": "DAYBREAK_LEAN_BINDING_V1",
    "block_sizes": block_sizes,
    "literal_pairs": len(pairs),
    "theorems": len(theorem_names),
    "axiom_queries": len(printed),
    "all_pairs_match_witness_z1": pairs == expected_pairs,
    "errors": errors,
    "ok": not errors,
}
print(json.dumps(out, indent=2, sort_keys=True))
raise SystemExit(0 if not errors else 1)
