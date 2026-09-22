#!/usr/bin/env python3
"""Extract the FT1536 build inputs FROM THE ACTIVE SOURCE BUILD Extra/c.

The estimator campaign is bound to the code of Extra/c (the current build of
this repository, 17-file manifest provenance/ft1536-candidate.sha256,
manifest 56974571...), not to secondary documents. This script records, for
every consumed constant: file:line, the verbatim source line, the parsed
value and the SHA-256 of the containing file. It also re-verifies the full
17-file manifest.

Emits: inputs/family/build_inputs.json

Replay:  python3 scripts/extract_build_inputs.py
"""
import hashlib
import json
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
W = os.path.dirname(HERE)
REPO = os.path.abspath(os.path.join(W, "..", "..", "..", ".."))
SRC = os.path.join(REPO, "Extra", "c")
MANIFEST = os.path.join(REPO, "provenance", "ft1536-candidate.sha256")
OUT = os.path.join(W, "inputs", "family", "build_inputs.json")

BINDINGS = [
    # (id, file, regex over a single line, value parser)
    ("norm_bound2", "internal.h",
     r"#define\s+FALCON_FT1536_NORM_BOUND2\s+\(\(int64_t\)(\d+)\)", int),
    ("signing_sigma", "falcon-sign.c",
     r"#define\s+FT1536_SIGNING_SIGMA\s+\(\(int64_t\)(\d+)\)", int),
    ("sign_max_attempts", "falcon-sign.c",
     r"#define\s+SIGN_MAX_ATTEMPTS\s+(\d+)", int),
    ("keygen_max_attempts", "falcon-keygen.c",
     r"#define\s+TERNARY_KEYGEN_MAX_ATTEMPTS\s+(\d+)", int),
    ("q_guard", "falcon-sign.c",
     r'if \(logn != 10 \|\| n != 1536 \|\| q != (\d+)\)', int),
    ("q_relation_literal", "falcon-sign.c",
     r"relation\[0\] -= (\d+);", int),
    ("mkn", "falcon-sign.c",
     r"#define\s+MKN\(logn, ter\)", None),
    ("instance_lock", "falcon-sign.c",
     r"if \(logn != 10 \|\| n != 1536 \|\| q != 18433\)", None),
    ("margin_formula_comment", "falcon-enc.c",
     r"floor\(1\.075\^2 \* 2\*N \* 768\^2\)", None),
    ("sig001_open_comment", "falcon-enc.c",
     r"SIG-001 and the final norm/security", None),
    ("adaptive_cdf_bank", "falcon-sign.c",
     r"FT_ADAPTIVE_CDF_LEVELS != 5 \|\| FT_ADAPTIVE_CDF_TABLE_LEN != 512", None),
    ("proposal_variances_comment", "falcon-sign.c",
     r"nominal sigma0\^2 in \{ 5, 20, 80, 320, 768 \}", None),
    ("metric_pairing_loop", "falcon-enc.c",
     r"s \+= \(int32_t\)s1\[u\] \* \(int32_t\)s1\[u \+ hn\];", None),
    ("metric_square_loop", "falcon-enc.c",
     r"z = s1\[u\];", None),
]

CONTEXT = {
    "norm_bound2": 1, "signing_sigma": 2, "sign_max_attempts": 2,
    "keygen_max_attempts": 1, "q_guard": 1, "q_relation_literal": 1,
    "margin_formula_comment": 2, "sig001_open_comment": 1,
}


def sha256(path):
    with open(path, "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def main():
    result = {
        "schema": "FT_FAMILY_BUILD_INPUTS_V1",
        "source_build": "Extra/c (active build of this repository)",
        "manifest_file": "provenance/ft1536-candidate.sha256",
        "manifest_entries": [],
        "bindings": {},
    }
    # full 17-file manifest verification
    ok_all = True
    for ln in open(MANIFEST):
        ln = ln.strip()
        if not ln:
            continue
        want, rel = ln.split()
        p = os.path.join(SRC, rel)
        have = sha256(p) if os.path.isfile(p) else None
        ok = have == want
        ok_all &= ok
        result["manifest_entries"].append({"file": rel, "sha256": want,
                                           "verified": ok})
    result["manifest_all_verified"] = bool(ok_all)

    for bid, rel, pattern, parser in BINDINGS:
        p = os.path.join(SRC, rel)
        lines = open(p, encoding="utf-8", errors="replace").read().splitlines()
        found = None
        for i, line in enumerate(lines, 1):
            m = re.search(pattern, line)
            if m:
                found = {"file": "Extra/c/" + rel, "line": i,
                         "verbatim": line.strip(),
                         "file_sha256": sha256(p),
                         "value": parser(m.group(1)) if parser else True}
                break
        ctx = CONTEXT.get(bid)
        if found and ctx:
            lo = max(0, found["line"] - 1 - ctx)
            hi = min(len(lines), found["line"] + ctx)
            found["context"] = [l.rstrip() for l in lines[lo:hi]]
        result["bindings"][bid] = found or {"error": "PATTERN_NOT_FOUND",
                                            "file": "Extra/c/" + rel,
                                            "pattern": pattern}

    missing = [k for k, v in result["bindings"].items()
               if "error" in v]
    result["all_bindings_found"] = not missing
    result["missing_bindings"] = missing

    # cross-consistency of the parsed q values
    q_guard = result["bindings"]["q_guard"].get("value")
    q_rel = result["bindings"]["q_relation_literal"].get("value")
    result["q_consistent"] = (q_guard == q_rel == 18433)

    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w") as f:
        json.dump(result, f, indent=2, sort_keys=True)
    print(json.dumps({
        "manifest_all_verified": result["manifest_all_verified"],
        "all_bindings_found": result["all_bindings_found"],
        "missing": missing,
        "q_consistent": result["q_consistent"],
        "norm_bound2": result["bindings"]["norm_bound2"].get("value"),
        "signing_sigma": result["bindings"]["signing_sigma"].get("value"),
    }, indent=2))
    return 0 if result["all_bindings_found"] and ok_all else 1


if __name__ == "__main__":
    raise SystemExit(main())
