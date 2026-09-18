#!/usr/bin/env python3
"""Copy selected immutable command streams to stable review artifact names."""
import hashlib
import json
from pathlib import Path

W = Path(__file__).resolve().parents[1]
records = [json.loads(x) for x in (W / "COMMANDS.log").read_text().splitlines()]
mapping = {
    0: ("stdout", "replay/manifest_audit.json"),
    2: ("stdout", "replay/independent_check.json"),
    3: ("stderr", "replay/build_normal.stderr"),
    4: ("stderr", "replay/build_sanitize.stderr"),
    5: ("stdout", "replay/c_normal.json"),
    6: ("stderr", "replay/c_sanitize_lsan_environment_failure.stderr"),
    7: ("stdout", "replay/c_sanitize_no_lsan.json"),
    8: ("stdout", "replay/independent_sage.json"),
    9: ("stdout", "formal/lean_binding.json"),
    10: ("stdout", "formal/lean_output.txt"),
    11: ("stdout", "replay/source_identity.json"),
}
out = {}
for index, (stream, destination) in mapping.items():
    source = W / records[index][stream]
    target = W / destination
    data = source.read_bytes()
    target.write_bytes(data)
    out[destination] = hashlib.sha256(data).hexdigest()
print(json.dumps(out, indent=2, sort_keys=True))
