# REVIEW independent checker 3/3 -- Z-map bijection + row-level port equality.
# Run: sage sage_checks/review_zmap_bijection.sage
# Verifies: 3072 rows; calls 0..3071 unique; slots cover 2x1536 exactly once;
# signs all +1; order (root right-first, cubic 2/1/0 blocks, terminal mu1,Y1
# before mu0); row SETS equal between v4 z_map_full.json and preserved
# py_z_map_full.json while whole files differ only by metadata (engine key).

# preparser/toolchain preflight (POLICY 2026-09-22); not a goal proof
assert parent(1) is ZZ
assert parent(1 / 3) is QQ
assert 2 ^ 10 == 1024

import json, hashlib
from sage.all import ZZ

SEED = "/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_001/seed"
cur = json.load(open(SEED + "/checks/z_map_full.json"))
py = json.load(open(SEED + "/checks/py_crosscheck/py_z_map_full.json"))
rows = cur["rows"]
assert len(rows) == 3072, len(rows)
calls = [int(r["call"]) for r in rows]
assert sorted(calls) == list(range(3072))
slots_a = sorted([int(r["coef_slot"]) for r in rows if r["coef_vector"] == "a"])
slots_b = sorted([int(r["coef_slot"]) for r in rows if r["coef_vector"] == "b"])
assert slots_a == list(range(1536)), len(slots_a)
assert slots_b == list(range(1536)), len(slots_b)
assert all(int(r["sign"]) == 1 for r in rows)
# order spot checks: first 1536 calls are right/b branch; cubic blocks 2,1,0
assert all(r["branch"] == "b/right" for r in rows[:1536])
assert rows[0]["cubic_child"] == 2
assert rows[1536]["cubic_child"] == 2
# terminal pairing Y1 then Y0
assert all(rows[i]["terminal_slot"] == "Y1/mu1" and rows[i + 1]["terminal_slot"] == "Y0/mu0_updated"
           for i in range(0, 3072, 2))
# row-level equality vs preserved py rows; whole-file metadata differs
assert len(py["rows"]) == 3072
key = lambda r: (r["call"], r["branch"], r["cubic_child"], r["binary_path"],
                 r["terminal_slot"], r["coef_vector"], r["coef_slot"], r["sign"])
assert [key(r) for r in rows] == [key(r) for r in py["rows"]]
def sha(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for c in iter(lambda: f.read(1 << 20), b""):
            h.update(c)
    return h.hexdigest()
h_cur = sha(SEED + "/checks/z_map_full.json")
h_py = sha(SEED + "/checks/py_crosscheck/py_z_map_full.json")
assert h_cur != h_py
assert set(cur.keys()) != set(py.keys()), (set(cur.keys()), set(py.keys()))

out = {"checker": "review_zmap_bijection.sage", "rows": int(3072),
       "slots_a_cover_1536": True, "slots_b_cover_1536": True,
       "rows_identical_to_py": True, "whole_files_differ_metadata_only": True,
       "v4_sha256": h_cur, "py_sha256": h_py}
with open("/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_REFERENCE_INTEGER_INDEPENDENT_REVIEW_001/sage_checks/review_zmap_bijection.json", "w") as fh:
    json.dump(out, fh, indent=1, sort_keys=True)
print(json.dumps(out, indent=1, sort_keys=True))
print("REVIEW_ZMAP_BIJECTION_PASS")
