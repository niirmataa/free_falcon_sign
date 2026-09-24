# FT1536 hole census: proposal tables have no interior holes (exact ZZ).
# Run: sage census_holes.sage  (SageMath preparser mode, Sage 10.9)
#
# Parses bank0..4 from the frozen
#   stages/FT1536_H3_SCALAR_GAUSSIAN_COMPARISON_RUN_001/formal/CDF.lean
# and asserts, with exact integers:
#   * length 512 each; nonzero counts [29, 59, 118, 235, 365]
#     (cross-checks frozen bankN_max theorems);
#   * PREFIX property: all nonzero entries precede all zero entries,
#     i.e. ZERO interior holes -- support per level is the contiguous
#     window k = 0..Kmax, matching AdaptiveProposal maxK.
# Consequence: inside D_j, table holes contribute nothing; the remaining
# support gap of K_C inside the window is the e>=64 BerExp cutoff only,
# bounded in the frozen ERROR_LEDGER (unnormalized_cutoff_tail) and left
# open for per-(k,b) census pending POST e_C domains.

import re

CDF = "/home/footfalcon/free_falcon_sign/proofs/ft1536/stages/FT1536_H3_SCALAR_GAUSSIAN_COMPARISON_RUN_001/formal/CDF.lean"
with open(CDF) as fh:
    src = fh.read()

banks = {}
for m in re.finditer(r"def (bank\d) : List Nat := \[(.*?)\]", src, re.DOTALL):
    name, body = m.group(1), m.group(2)
    banks[name] = [int(t) for t in body.replace("\n", "").split(",") if t.strip() != ""]

assert sorted(banks.keys()) == ["bank0", "bank1", "bank2", "bank3", "bank4"], sorted(banks.keys())
expected_nonzero = {"bank0": 29, "bank1": 59, "bank2": 118, "bank3": 235, "bank4": 365}
expected_maxK = [29, 59, 118, 235, 365]

for idx, name in enumerate(["bank0", "bank1", "bank2", "bank3", "bank4"]):
    L = banks[name]
    assert len(L) == 512, (name, len(L))
    nz = sum(1 for t in L if t != 0)
    assert nz == expected_nonzero[name], (name, nz)
    first_zero = next((i for i, t in enumerate(L) if t == 0), len(L))
    assert first_zero == nz, (name, first_zero, nz)
    assert all(t != 0 for t in L[:nz]), (name, "prefix head")
    assert all(t == 0 for t in L[nz:]), (name, "prefix tail")
    interior = [i for i in range(len(L)) if L[i] == 0 and any(t != 0 for t in L[i:])]
    assert interior == [], (name, interior)
    assert nz == expected_maxK[idx], (name, nz)
    print("%s: len=512 nonzero=%d window k=0..%d interior_holes=0" % (name, nz, nz - 1))

print("HOLE_CENSUS_PASS")
