# First-difference index for the Lean kernel proof (diagnostic checker).
# Run: sage check_first_diff.sage
# Reads W/mutation_vectors.json (plain ints), recomputes fmulq(h_wrong, f)
# vs modq(g) with the frozen algorithm, prints the first index where the
# mod-q representatives differ. A small index means `decide` on list
# inequality short-circuits early.

import json

WDIR = "/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_MUTATION_WRONG_H_2026-09-24"
N = int(1536)
Q = int(18433)

with open(WDIR + "/mutation_vectors.json") as fh:
    vecs = json.load(fh)

def reduce_raw(c):
    out = c[:N] + [0] * max(0, N - len(c))
    out = out[:N]
    h = N // 2
    for k in range(N, min(len(c), 3 * h)):
        out[k - h] += c[k]
        out[k - N] -= c[k]
    for k in range(3 * h, len(c)):
        out[k - 3 * h] -= c[k]
    return out

def mul(a, b):
    n = len(a)
    raw = [0] * (2 * n - 1)
    for i, ai in enumerate(a):
        if ai:
            for j, bj in enumerate(b):
                if bj:
                    raw[i + j] += ai * bj
    return reduce_raw(raw)

def modq(a):
    return [x % Q for x in a]

def fmulq(a, b):
    return modq(mul(modq(a), modq(b)))

L = fmulq(vecs["h_wrong"], vecs["f"])
R = modq(vecs["g"])
assert len(L) == len(R) == N
diffs = [i for i in range(N) if L[i] != R[i]]
print("num_diffs=%d first=%s" % (len(diffs), diffs[0] if diffs else None))
if diffs:
    i = diffs[0]
    print("L[i]=%d R[i]=%d" % (L[i], R[i]))
print("FIRST_DIFF_PASS")
