#!/usr/bin/env python3
"""Pre-freeze consistency checks for the Daybreak report bundle."""
import hashlib
import json
from pathlib import Path

W = Path(__file__).resolve().parents[1]
errors = []
result = json.loads((W / "DAYBREAK_RESULT.json").read_text())
independent = json.loads((W / "computations/independent-001/result.json").read_text())
sage = json.loads((W / "replay/independent_sage.json").read_text())
manifest = json.loads((W / "replay/manifest_audit.json").read_text())
source = json.loads((W / "replay/source_identity.json").read_text())
lean = json.loads((W / "formal/lean_binding.json").read_text())
for name, obj in (("independent", independent), ("sage", sage),
                  ("manifest", manifest), ("source", source), ("lean", lean)):
    if not obj.get("ok"):
        errors.append(name + " receipt is not PASS")
expected = (43058711057, 42658711057, 400000000, 40964788672)
got = (independent["ext_norm"], independent["ext_first_norm"],
       independent["machine_norm"], independent["excess"])
if got != expected:
    errors.append("independent numerical tuple mismatch")
if result["witness"]["Ext0_norm"] != expected[0]:
    errors.append("DAYBREAK_RESULT numerical mismatch")
report = (W / "DAYBREAK_REVIEW.md").read_text()
for token in ("CONFIRMED_COUNTEREXAMPLE_REQUIRED_DOMAIN", "43058711057",
              "40964788672", "LeakSanitizer", "T2C3/T5"):
    if token not in report:
        errors.append("report missing token: " + token)
if hashlib.sha256((W / "formal/WitnessBlocks.lean").read_bytes()).hexdigest() != \
        "f166ae8569868ec8eda7a816e7ffdaa1ebacfa4c98acafde565f869b75da7215":
    errors.append("Lean certificate input hash mismatch")
out = {"schema": "DAYBREAK_FINAL_AUDIT_V1", "errors": errors, "ok": not errors}
print(json.dumps(out, indent=2, sort_keys=True))
raise SystemExit(0 if not errors else 1)
