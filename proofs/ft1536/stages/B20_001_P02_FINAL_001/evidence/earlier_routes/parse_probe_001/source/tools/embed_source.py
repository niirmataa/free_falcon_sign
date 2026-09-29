#!/usr/bin/env python3
"""Transport the entire pinned UTF-8 C header as lossless Lean line literals."""
from pathlib import Path
import hashlib
import json
import os

source = Path(os.environ["P02_INPUTS"]) / "source17/fpr-emulated.h"
raw = source.read_bytes()
expected = "6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f"
assert hashlib.sha256(raw).hexdigest() == expected
lines = raw.decode("utf-8").splitlines(keepends=True)
literals = [json.dumps(line, ensure_ascii=False) for line in lines]
assert "".join(json.loads(line) for line in literals).encode("utf-8") == raw
dest = Path(os.environ["P02_DEST"]) / "build/PinnedHeader.lean"
dest.write_text("-- Generated lossless transport; source SHA256 " + expected + "\n"
                + "set_option maxRecDepth 16384\nset_option maxHeartbeats 2000000\n"
                + "namespace B20.Pinned\ndef headerLines : List String := [\n  "
                + ",\n  ".join(literals) + "\n]\nend B20.Pinned\n")
(dest.parent / "SOURCE_TRANSPORT.json").write_text(json.dumps({
    "source_sha256": expected, "source_bytes": len(raw), "lines": len(lines),
    "lean_sha256": hashlib.sha256(dest.read_bytes()).hexdigest(),
    "decode_reencode_exact": True,
    "formal_selection": "B20.C.slice followed by B20.C.parseFunction; no generated AST is trusted",
}, indent=2) + "\n")
print("lossless header transport", len(raw), "bytes;", len(lines), "lines")
