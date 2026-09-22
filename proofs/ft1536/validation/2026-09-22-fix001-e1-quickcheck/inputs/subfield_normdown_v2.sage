# E1 -- subfield norm-down v2: corrected dimension, rigorous real bounds.
#
# Run REQUIRED by owner rule 2026-09-22:
#
#     sage scripts/subfield_normdown_v2.sage
#
# (standard Sage preparser; exact domains ZZ/QQ; real bounds via rigorous
# RealBallField. Python Fraction is NOT used.)
#
# Corrections vs the reviewed subfield_normdown.sage (S06/E1):
#   1. the subfield RING DEGREE is n = N/2 and the subfield LATTICE DIMENSION
#      is 2n = N (the reviewed code fed n = N into the eq. 2.3 loop while
#      declaring degree N/2 -- wrong dimension);
#   2. control `beta <= declared lattice dimension` is enforced per row;
#   3. exact moments are split: raw second moment (RMS), coefficient mean,
#      centered variance, heuristic geometry and LIFT are separate fields;
#   4. old values are preserved alongside the corrected ones;
#   5. no universal "no subfield advantage" claim is made here: rows are data;
#      the conclusion is drawn per recomputed row.
#
# Moment model (unchanged and exact, QQ): for RAW iid ternary f,
#   E[f_a f_b f_c f_d] = v^2 (d_ab d_cd + d_ac d_bd + d_ad d_bc)
#                          + (mu4 - 3 v^2) d_ab d_ac d_ad,
#   v = mu4 = 2/3, and Tr(X^t) = c_m(t) (Ramanujan), s(i,j) = i + u*j mod 3N.
# Mean vector of N_u(f): (2/3) * sum_i X^{s(i,i)} (folded), computed exactly.

import json
import os

from sage.all import QQ, ZZ, RealBallField, gcd, moebius, euler_phi

RBF = RealBallField(256)

# sage file.sage copies the source to a temp dir, so __file__ is NOT the
# package path: all paths are CWD-based (run from the W root), per the
# durable-storage rule.
W = os.getcwd()
HERE = os.path.join(W, "scripts")
ART = os.path.join(W, "artifacts")
OLD = os.path.join(os.path.dirname(W),
                   "FT_FAMILY_SEC_ESTIMATE_2026-09-22_RUN_001",
                   "artifacts", "subfield_normdown.json")

Q = ZZ(18433)
NS = [768, 1536, 3072]
PI = RBF.pi()
E = RBF(1).exp()


def mobius_zz(n):
    n = ZZ(n)
    return ZZ(moebius(n))


def ramanujan(m, t):
    m = ZZ(m)
    t = ZZ(t)
    g = gcd(m, t)
    mg = m // g
    return ZZ(mobius_zz(mg)) * ZZ(euler_phi(m)) // ZZ(euler_phi(mg))


def order2_elements(m):
    return [ZZ(u) for u in range(1, m)
            if gcd(ZZ(u), ZZ(m)) == 1 and (u * u) % m == 1 and u != 1]


def diff_sum(m, k, N):
    """sum_{i,j<N} c_m(k*(i-j)) as ZZ (difference histogram)."""
    total = ZZ(0)
    for d in range(-(N - 1), N):
        total += (N - abs(d)) * ramanujan(m, (k * d) % m)
    return ZZ(total)


def fold_exponent(e, N):
    """Reduce X^e mod Phi_{3N} to sum of (coeff, exponent<N) using
    X^N = X^(N/2) - 1. Returns list of (sign, exp)."""
    e = ZZ(e)
    terms = [(ZZ(1), e)]
    out = []
    while terms:
        sgn, ex = terms.pop()
        ex = ZZ(ex) % (3 * N)          # X^{3N} = 1 on the group of powers
        if ex < 0:
            ex += 3 * N
        if ex < N:
            out.append((sgn, ex))
        else:
            # X^(N+t) = X^(t+N/2) - X^t
            t = ex - N
            terms.append((sgn, t + N // 2))
            terms.append((-sgn, t))
    # combine like terms
    acc = {}
    for sgn, ex in out:
        acc[ex] = acc.get(ex, ZZ(0)) + sgn
    return [(sgn, ex) for ex, sgn in sorted(acc.items()) if sgn != 0]


def mean_vector(N, u):
    """E[N_u(f)] coefficients as dict exp -> QQ (exact)."""
    m = 3 * N
    vec = {}
    for i in range(N):
        for sgn, ex in fold_exponent(i + u * i, N):
            vec[ex] = vec.get(ex, QQ(0)) + sgn * QQ(2) / 3
    return vec


def q_a2_of(vec, N):
    """Q_A2 of an exact coefficient vector (QQ-valued dict)."""
    a = [QQ(0)] * N
    for ex, v in vec.items():
        a[ex] += v
    return sum(a[i] ** 2 + a[i] * a[i + N // 2] + a[i + N // 2] ** 2
               for i in range(N // 2))


def solve_key_recovery(n, q, sigma_sq, dim_cap):
    """Eq. (2.3) loop with RBF-certified comparisons.
    n = RING DEGREE of the instance (subfield: N/2); dim_cap = lattice
    dimension (subfield: 2n = N). sigma_sq is the exact QQ variance; its
    square root is taken in RBF (rigorous). Returns (beta, certified) or
    (None, False) when no solution exists below the dimension cap."""
    nb = RBF(n)
    qb = RBF(q)
    sfg = RBF(sigma_sq).sqrt()
    for block in range(100, dim_cap + 1):
        b = RBF(block)
        lhs = ((1 - nb / b) * (b / (2 * PI * E)).log() + qb.log() / 2)
        rhs = ((3 * b / 4).log() / 2 + sfg.log())
        if lhs.lower() > rhs.upper():
            return block, True
    return None, False


def main():
    rows = []
    old_rows = {}
    if os.path.isfile(OLD):
        for r in json.load(open(OLD))["rows"]:
            old_rows[(int(r["N"]), int(r["u"]))] = r

    for N in NS:
        m = 3 * N
        v = QQ(2) / 3
        mu4 = QQ(2) / 3
        n_sub = ZZ(N) // 2            # subfield ring degree  (E1 fix)
        dim = 2 * n_sub               # subfield lattice dim  (E1 fix)
        assert dim == N
        full_beta, full_ok = solve_key_recovery(N, ZZ(Q), QQ(2) / 3,
                                                2 * N)
        for u in order2_elements(m):
            S = v * v * (ZZ(N) ** 3
                         + diff_sum(m, (1 - u) % m, N)
                         + diff_sum(m, (1 + u) % m, N)) \
                + (mu4 - 3 * v * v) * ZZ(N) ** 2
            eq_a2_raw = QQ(S) / N                  # raw second moment (RMS^2)
            mv = mean_vector(N, u)
            mean_q = q_a2_of(mv, N)               # Q_A2 of the mean vector
            centered_var = eq_a2_raw - mean_q     # exact split (E1 item 3)
            if centered_var < 0:
                centered_var = QQ(0)              # numerical identity guard
            sigma_sq_sub = eq_a2_raw / n_sub   # per-coordinate RMS: E[Q]/n_sub = 2*E[Q]/N
            beta_sub, ok = solve_key_recovery(n_sub, ZZ(Q), sigma_sq_sub,
                                              dim)
            beta_cap_ok = (beta_sub is not None) and (beta_sub <= dim)
            old = old_rows.get((int(N), int(u)), {})
            rows.append({
                "N": N, "m": m, "u": int(u),
                "subfield_degree_n": int(n_sub),
                "subfield_lattice_dimension": int(dim),
                "S_exact": str(S),
                "E_QA2_raw_exact": str(eq_a2_raw),
                "E_QA2_mean_part_exact": str(mean_q),
                "E_QA2_centered_var_exact": str(centered_var),
                "rms_subfield": str(RBF(eq_a2_raw).sqrt()),
                "sigma_sq_subfield_exact": str(sigma_sq_sub),
                "sigma_fg_subfield": str(RBF(sigma_sq_sub).sqrt()),
                "beta_full_dimension": full_beta,
                "beta_subfield_eq23": beta_sub,
                "beta_within_declared_dimension": bool(beta_cap_ok),
                "certified_crossing": bool(ok),
                "lift": "OPEN_HEURISTIC_ABD_2016_127_RELATIVE_NORM_LIFT",
                "old_reviewed_values": {
                    "beta_subfield_eq23_before_E1": old.get(
                        "beta_subfield_eq23"),
                    "sigma_fg_subfield_before_E1": old.get(
                        "sigma_fg_subfield"),
                    "dimension_used_before_E1": N,
                },
                "status": ("EXACT_MOMENTS_QQ;RBF_CROSSED;"
                           "LIFT_CONDITION_OPEN" if beta_sub is not None
                           else "EXACT_MOMENTS_QQ;NO_CROSSING_BELOW_DIM_CAP;"
                                "LIFT_CONDITION_OPEN"),
            })
            print("N=%4d u=%5d n_sub=%4d dim=%4d sigma'=%s beta_sub=%s"
                  " (old %s) cap_ok=%s"
                  % (N, u, n_sub, dim, str(RBF(sigma_sq_sub).sqrt())[:8], beta_sub,
                     old.get("beta_subfield_eq23"), beta_cap_ok), flush=True)

    os.makedirs(ART, exist_ok=True)
    with open(os.path.join(ART, "subfield_normdown_v2.json"), "w") as f:
        json.dump({
            "schema": "FT_FAMILY_SUBFIELD_NORMDOWN_V2_E1",
            "mode": "sage file.sage (preparser); ZZ/QQ exact; RBF(256) bounds",
            "model": "ABD ePrint 2016/127 index-2 norm-down; exact ternary "
                     "moments; heuristic geometry; lift OPEN",
            "rows": rows}, f, indent=2, sort_keys=True, default=str)
    print("rows:", len(rows),
          "old-lookups:", sum(1 for r in rows
                              if r["old_reviewed_values"][
                                  "beta_subfield_eq23_before_E1"] is not None))
    return 0


if True:  # sage file.sage executes in a namespace where __name__ != "__main__"
    main()
