"""Exact display arithmetic for paper v0.1; not a hardness certificate."""
import hashlib
import json
import os
from pathlib import Path
import re
import sys
import zipfile

# This file must be run by Sage's standard preparser.
assert 2^8 == 256
root = Path(os.environ["FT1536_REPO_ROOT"])
output = Path(sys.argv[1])
s06 = root / "proofs/ft1536/stages/FT_FAMILY_SEC_ESTIMATE_REVIEW_RUN_001/REVIEW.md"
probe = root / "proofs/ft1536/work/FT1536_FG_PROBE_P_ACCEPT_001/out/RECEIPT.json"
falcon = root / "proofs/ft1536/stages/FT_FAMILY_SEC_ESTIMATE_REVIEW_RUN_001/inputs/campaign/inputs/falcon/falcon-round3.zip"
review = s06.read_text()
receipt = json.loads(probe.read_text())
assert "CHANGES_REQUIRED" in review
assert "0.292β/0.265β" in review

def decimal(q, digits):
    """Round a nonnegative exact rational for display, with no floats."""
    q = QQ(q)
    assert q >= 0
    scale = ZZ(10)^digits
    n = ZZ(floor(q * scale + QQ(1)/2))
    return str(n // scale) + "." + str(n % scale).zfill(int(digits))

rows = {}
for name in ["FT768", "FT1536", "FT3072"]:
    match = re.search(r"\| " + name + r" \| (\d+) \| (\d+)", review)
    assert match, name
    rows[name] = [ZZ(match.group(1)), ZZ(match.group(2))]
for name, pattern in [
    ("Falcon-512", r"Falcon512:(\d+)/(\d+)"),
    ("Falcon-1024", r"Falcon1024:(\d+)/(\d+)"),
]:
    match = re.search(pattern, review)
    assert match, name
    rows[name] = [ZZ(match.group(1)), ZZ(match.group(2))]

costs = {}
for name, betas in rows.items():
    beta = min(betas)
    classical = QQ(292)/1000 * beta
    quantum = QQ(265)/1000 * beta
    costs[name] = {
        "beta_P1": int(betas[0]), "beta_P2": int(betas[1]),
        "lattice_classical_exact": str(classical),
        "lattice_quantum_exact": str(quantum),
        "lattice_display": decimal(classical, 3) + "/" + decimal(quantum, 3),
        "symmetric_convention": "256/128",
        "minimum_classical_exact": str(min(classical, QQ(256))),
        "minimum_quantum_exact": str(min(quantum, QQ(256)/2)),
    }

measurement = receipt["runs"][1]["result"]
match = re.search(r"attempts=(\d+) successes=(\d+)", measurement)
assert match
attempts, successes = ZZ(match.group(1)), ZZ(match.group(2))
p = QQ(successes)/attempts
assert decimal(p, 5) == str(receipt["measured_constants"]["p_accept"])
assert decimal(1/p, 3) == str(receipt["measured_constants"]["inv_p_accept"])
rejects = sum(ZZ(re.search(name + r"=(\d+)", measurement).group(1))
              for name in ["resultant_f", "resultant_g", "norm", "gs", "public", "solve"])
assert rejects + successes == attempts

member = "falcon-round3/Extra/c/falcon.h"
with zipfile.ZipFile(falcon) as archive:
    header = archive.read(member)
assert re.search(rb"512\s+809\s+666\s+651\.59", header)
# Literal FALCON_SIG_PADDED_SIZE macro at logn=9, not the FT1536 codec.
size = (44 + 3*(256 >> 1) + 2*(128 >> 1) + 3*(64 >> 1)
        + 2*(16 >> 1) - 2*(2 >> 1) - 8*(1 >> 1))
assert size == 666
lift_block = 2*ZZ(47103)^2
assert lift_block == 4437385218
assert lift_block > 2093922385

result = {
    "scope": "Exact display arithmetic only; S06 remains CHANGES_REQUIRED; no new kernel or security theorem.",
    "preparser": "sage .sage; caret exponentiation checked",
    "costs": costs,
    "measurement": {"attempts": int(attempts), "successes": int(successes),
        "rejects": int(rejects), "p_exact": str(p), "p_display": decimal(p, 5),
        "inverse_exact": str(1/p), "inverse_display": decimal(1/p, 3)},
    "falcon_padded_512_bytes": int(size),
    "falcon_header_member": member,
    "falcon_header_sha256": hashlib.sha256(header).hexdigest(),
    "lift_block": int(lift_block),
    "inputs": {str(path.relative_to(root)): hashlib.sha256(path.read_bytes()).hexdigest()
               for path in [s06, probe, falcon]},
}
output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
print(json.dumps(result, indent=2, sort_keys=True))
