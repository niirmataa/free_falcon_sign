#!/usr/bin/env python3
"""FT family: exact ffLDL_fft3 layout recurrences (the parametric task).

Source binding (Extra/c, manifest 56974571..., snapshot 683b71b):
  falcon-keygen.c  ffLDL_inner_fft3_keygen / ffLDL_depth1_fft3_keygen /
                   ffLDL_fft3_keygen   (tree fill, `s` word accounting)
  falcon-sign.c    load_skey            (sk/tmp layout comment and checks)
  REPORT of FT1536_H3_RAW_ASSEMBLY_RUN_001 (frozen instance numbers)

Recurrences (all words are 8-byte `fpr` slots):
  inner tree at logn k (2^k-degree nodes, 2-way splits, base k = 1):
      S(1) = 4                  (2 L-words + 2 leaf words)
      S(k) = 2^k + 2*S(k-1)     =>  S(k) = (k+1)*2^k
  depth1 node at logn j (3x3 LDL, 3 inner children of logn j-1):
      D(j) = 3*2^j + 3*S(j-1)
  top node at logn ell (trisection, 2 depth1 children of logn ell-1):
      T(ell) = 3*2^(ell-1) + 2*D(ell-1) = (ell+2)*N,   N = 3*2^(ell-1)
  basis 4N words, raw leaves N words, internal L (ell+1)N words.
  sk = 4N + T = (ell+6)N words  (source comment: 3*(logn+6)*2^(logn-1)).
  tmp allocated 7N words (source comment: "seven polynomials").
  ffLDL scratch beyond the four Gram words (from gxx at 3N):
      W(ell) = 7*2^(ell-1) - 2   (derived; RAW_ASSEMBLY records 3584 = 7*2^9,
      a 2-word base-case convention difference, see output).

Checks against the frozen N = 1536 instance (ell = 10):
  tree 18432, basis 6144, sk 24576, tmp 10752, leaves 1536, internal L 16896,
  depth1 block 1536, k-block 2304, inner7 1024, inner8 node head 256.

Scope: this is a conditional layout analysis of the *unchanged* source
structure. It is not an implementation or correctness proof for FT768/FT3072.

Output: results/layout.json and results/layout.csv.
"""
import csv
import json
import os

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "..", "results")
os.makedirs(OUT, exist_ok=True)


def S(k):
    return (k + 1) << k


def S_rec(k):
    if k == 1:
        return 4
    return (1 << k) + 2 * S_rec(k - 1)


def D(j):
    return 3 * (1 << j) + 3 * S(j - 1)


def T(ell):
    return 3 * (1 << (ell - 1)) + 2 * D(ell - 1)


def W_inner_rec(r):
    """Scratch of ffLDL_inner at logn r, from its tmp base:
    W(1) = 2; W(r) = max(2^r + W(r-1), 2^(r+1)).
    The max covers BOTH consumers of the t2 base: the child recursion and the
    node's own d11 store of 2^r words through t2 (LDL_dim2_fft3)."""
    if r <= 1:
        return 2 if r == 1 else 0
    return max((1 << r) + W_inner_rec(r - 1), 1 << (r + 1))


def W_inner(r):
    """Closed form: 2^(r+1) for r >= 2, 2 for r = 1 (kernel: FTLayout)."""
    return 2 if r == 1 else (1 << (r + 1))


def D_tmp(j):
    """Scratch of depth1 at logn j: t2 base at 3*2^j; from there the child
    recursion W(j-1) and LDL_dim3's tmp store of 2^j words both apply."""
    n = 1 << j
    return 3 * n + max(n, W_inner(j - 1))


def W(ell):
    """Scratch of the top node at logn ell, from its tmp base: t3 base at
    3*2^(ell-1); from there the depth1 recursion and the full=1 d11 store of
    3*2^(ell-1) words both apply."""
    tn = 1 << (ell - 1)
    return 3 * tn + max(3 * tn, D_tmp(ell - 1))


def profile(ell):
    N = 3 << (ell - 1)
    return {
        "logn_ell": ell,
        "N": N,
        "basis_words": 4 * N,
        "tree_words": T(ell),
        "tree_formula": f"(ell+2)*N = {ell + 2}*{N}",
        "sk_words": 4 * N + T(ell),
        "sk_formula": f"(ell+6)*N = {ell + 6}*{N}",
        "tmp_words": 7 * N,
        "leaf_words": N,
        "internal_L_words": T(ell) - N,
        "depth1_block_words": 3 * (1 << (ell - 1)),
        "k_block_words": S(ell - 2),
        "inner7_words": S(ell - 3),
        "inner8_head_words": 1 << (ell - 2),
        "ffldl_scratch_from_gxx": W(ell),
        "tree_bytes": 8 * T(ell),
        "sk_bytes": 8 * (4 * N + T(ell)),
        "tmp_bytes": 8 * 7 * N,
    }


def main():
    out = []
    rep = {"recurrences": {
        "S(1)": 4, "S(k)": "2^k + 2*S(k-1) = (k+1)*2^k",
        "D(j)": "3*2^j + 3*S(j-1)",
        "T(ell)": "3*2^(ell-1) + 2*D(ell-1) = (ell+2)*N",
        "W_inner(r)": "max(2^r + W_inner(r-1), 2^(r+1)), W_inner(1) = 2",
        "W_inner_closed": "2^(r+1) for r >= 2",
        "D_tmp(j)": "3*2^j + max(2^j, W_inner(j-1))",
        "W_top(ell)": "3*2^(ell-1) + max(3*2^(ell-1), D_tmp(ell-1))"
                      " = 7*2^(ell-1)",
    }}

    def log(s):
        print(s)
        out.append(s)

    log("=== check_layout.py ===")

    # recurrence self-checks
    ok_closed = all(S(k) == S_rec(k) for k in range(1, 14))
    ok_T = all(T(e) == (e + 2) * (3 << (e - 1)) for e in range(3, 21))
    ok_W = all(W_inner(r) == W_inner_rec(r) for r in range(1, 14))
    ok_Wtop = all(W(e) == 7 * (1 << (e - 1)) for e in range(3, 21))
    log(f"S(k) closed form == recursion for k=1..13: {ok_closed}")
    log(f"T(ell) == (ell+2)*N for ell=3..20: {ok_T}")
    log(f"W_inner closed form == max-recursion for r=1..13: {ok_W}")
    log(f"W_top(ell) == 7*2^(ell-1) for ell=3..20: {ok_Wtop}")
    rep["closed_form_checks"] = {"S": ok_closed, "T": ok_T,
                                 "W_inner": ok_W, "W_top": ok_Wtop}

    rows = []
    for ell in (9, 10, 11):
        p = profile(ell)
        rows.append(p)
        log(f"\nlogn = {ell}, N = {p['N']}:")
        log(f"  basis {p['basis_words']} w | tree {p['tree_words']} w"
            f" ({p['tree_formula']}) | sk {p['sk_words']} w ({p['sk_formula']})")
        log(f"  tmp {p['tmp_words']} w | leaves {p['leaf_words']} w |"
            f" internal L {p['internal_L_words']} w")
        log(f"  depth1 block {p['depth1_block_words']} w | k-block"
            f" {p['k_block_words']} w | inner7 {p['inner7_words']} w |"
            f" inner8 head {p['inner8_head_words']} w")
        log(f"  ffLDL scratch from gxx: {p['ffldl_scratch_from_gxx']} w")
        log(f"  bytes: tree {p['tree_bytes']} ({p['tree_bytes'] // 1024} KiB),"
            f" sk {p['sk_bytes']} ({p['sk_bytes'] // 1024} KiB),"
            f" tmp {p['tmp_bytes']} ({p['tmp_bytes'] // 1024} KiB)")

    frozen = {
        "tree_words": 18432, "basis_words": 6144, "sk_words": 24576,
        "tmp_words": 10752, "leaf_words": 1536, "internal_L_words": 16896,
        "depth1_block_words": 1536, "k_block_words": 2304,
        "inner7_words": 1024, "inner8_head_words": 256,
        "ffldl_scratch_from_gxx": 3584, "high_water": 8192,
    }
    p10 = profile(10)
    checks = {
        "tree": p10["tree_words"] == frozen["tree_words"],
        "basis": p10["basis_words"] == frozen["basis_words"],
        "sk": p10["sk_words"] == frozen["sk_words"],
        "tmp": p10["tmp_words"] == frozen["tmp_words"],
        "leaves": p10["leaf_words"] == frozen["leaf_words"],
        "internal_L": p10["internal_L_words"] == frozen["internal_L_words"],
        "depth1_block": p10["depth1_block_words"] == frozen["depth1_block_words"],
        "k_block": p10["k_block_words"] == frozen["k_block_words"],
        "inner7": p10["inner7_words"] == frozen["inner7_words"],
        "inner8_head": p10["inner8_head_words"] == frozen["inner8_head_words"],
        "scratch_exact": p10["ffldl_scratch_from_gxx"]
            == frozen["ffldl_scratch_from_gxx"],
        "high_water_exact": 3 * 1536 + p10["ffldl_scratch_from_gxx"]
            == frozen["high_water"],
    }
    log(f"\nfrozen N=1536 instance checks: {checks}")
    log(f"  derived scratch {p10['ffldl_scratch_from_gxx']} == frozen 3584"
        f" (exact); high-water 3N + W = {3 * 1536 + p10['ffldl_scratch_from_gxx']}"
        f" == frozen 8192 (exact)")

    rep["frozen_instance"] = frozen
    rep["frozen_checks"] = checks
    rep["rows"] = rows

    with open(os.path.join(OUT, "layout.json"), "w") as f:
        json.dump(rep, f, indent=2, sort_keys=True)
    with open(os.path.join(OUT, "layout.csv"), "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)
    log(f"Wrote layout.json and layout.csv")


if __name__ == "__main__":
    main()
