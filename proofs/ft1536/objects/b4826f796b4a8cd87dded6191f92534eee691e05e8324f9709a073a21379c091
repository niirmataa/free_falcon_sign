# ABD-style subfield norm-down rows (index-2), exact second moments.
#
# For each N in the family and each of the 7 order-2 automorphisms u of
# (Z/3N)^* (subgroups {1,u}), the relative norm N_u(f) = f * sigma_u(f) lands
# in the index-2 subfield of degree N/2. The reduced lattice problem has
# dimension N and target built from N_u(f), N_u(g). This script computes
# EXACTLY the second moment of the full-ring A2 norm of N_u(f) for RAW iid
# ternary f:
#
#   E[Q_A2(N_u(f))] = S_u / N with (v = 2/3, mu4 = 2/3 for ternary)
#   S_u = v^2 * ( N^3 + sum_{i,j} c_m((1-u)(i-j)) + sum_{i,i'} c_m((1+u)(i-i')) )
#         + (mu4 - 3 v^2) * N^2 ,
#
# derived from E[f_a f_b f_c f_d] = v^2 (d_ab d_cd + d_ac d_bd + d_ad d_bc)
# + (mu4 - 3v^2) d_ab d_ac d_ad and Tr(X^t) = c_m(t) (Ramanujan), with
# s(i,j) = i + u*j. Double sums collapse to O(N) via difference histograms.
#
# The attack model is the ABD norm-down: subfield key-recovery at dimension N
# with target std sigma_fg' = sqrt(2*E[Q_A2(N_u(f))] / N) per coefficient of
# the subfield pair, solved with the Falcon eq. (2.3) loop. The LIFT step
# (solution must be a relative norm) is a stated heuristic, per ABD 2016/127.
#
# Replay:  sage scripts/subfield_normdown.sage  (plain Python, no preparser)

import json
import math
import os
import sys
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
W = os.path.dirname(HERE)
ART = os.path.join(W, "artifacts")

Q = 18433
NS = [768, 1536, 3072]


def mobius(n):
    if n == 1:
        return 1
    p = 0
    x = n
    d = 2
    while d * d <= x:
        if x % d == 0:
            x //= d
            p += 1
            if x % d == 0:
                return 0
        d += 1
    if x > 1:
        p += 1
    return -1 if p % 2 else 1


def phi(n):
    r, x, d = n, n, 2
    while d * d <= x:
        if x % d == 0:
            while x % d == 0:
                x //= d
            r -= r // d
        d += 1
    if x > 1:
        r -= r // x
    return r


def ramanujan(m, t):
    g = math.gcd(m, t)
    mg = m // g
    return mobius(mg) * phi(m) // phi(mg)


def order2_elements(m):
    return [u for u in range(1, m)
            if math.gcd(u, m) == 1 and (u * u) % m == 1 and u != 1]


def diff_sum(m, k, N):
    """sum_{i,j<N} c_m(k*(i-j))  via difference histogram (O(N))."""
    total = 0
    for d in range(-(N - 1), N):
        total += (N - abs(d)) * ramanujan(m, (k * d) % m)
    return total


def solve_key_recovery(n, q, sigma_fg):
    PI = math.pi
    e = math.e
    for block in range(100, 2 * n + 1):
        b = block
        log_left = ((1 - n / b) * math.log(b / (2 * PI * e))
                    + math.log(q) / 2)
        log_right = math.log(3 * b / 4) / 2 + math.log(sigma_fg)
        if log_left > log_right:
            return block
    raise RuntimeError("block not found")


def main():
    rows = []
    for N in NS:
        m = 3 * N
        v = Fraction(2, 3)
        mu4 = Fraction(2, 3)
        full_beta = solve_key_recovery(N, Q, math.sqrt(2.0 / 3.0))
        for u in order2_elements(m):
            S = v * v * (N ** 3
                         + diff_sum(m, (1 - u) % m, N)
                         + diff_sum(m, (1 + u) % m, N)) \
                + (mu4 - 3 * v * v) * N ** 2
            eq_a2 = S / N                       # E[Q_A2^{(N)}(N_u(f))]
            sigma_fg_sub = math.sqrt(float(2 * eq_a2) / N)
            try:
                sub_beta = solve_key_recovery(N, Q, sigma_fg_sub)
                sub_status = ("EXACT_MOMENT_PLUS_EQ_2_3_LOOP;"
                              "LIFT_CONDITION_OPEN")
            except RuntimeError:
                sub_beta = None
                sub_status = ("TARGET_TOO_LONG_NO_SUBFIELD_ADVANTAGE:"
                              "eq_2_3_condition_never_met_below_2N;"
                              "LIFT_CONDITION_OPEN")
            rows.append({
                "N": N, "m": m, "u": u,
                "S_exact": str(S), "E_QA2_norm_exact": str(eq_a2),
                "sigma_fg_subfield": sigma_fg_sub,
                "subfield_degree": N // 2,
                "subfield_lattice_dimension": N,
                "beta_full_dimension": full_beta,
                "beta_subfield_eq23": sub_beta,
                "lift": "OPEN_HEURISTIC_ABD_2016_127_RELATIVE_NORM_LIFT",
                "status": sub_status,
            })
            print("N=%4d u=%5d E[Q_A2(N_u(f))]=%s sigma_fg'=%.4f"
                  " beta_sub=%s (full %4d)"
                  % (N, u, str(eq_a2)[:12], sigma_fg_sub,
                     str(sub_beta), full_beta), flush=True)
    os.makedirs(ART, exist_ok=True)
    with open(os.path.join(ART, "subfield_normdown.json"), "w") as f:
        json.dump({"schema": "FT_FAMILY_SUBFIELD_NORMDOWN_V1",
                   "model": "ABD ePrint 2016/127 index-2 norm-down; "
                            "exact ternary second moments; lift heuristic",
                   "rows": rows}, f, indent=2, sort_keys=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
