# Deterministic model rows for the FT family -- Falcon v1.2 equations (2.3)
# and (2.4), in the style of S20-SEC-ESTIMATE-001 (Decimal(110) arithmetic,
# pinned coefficients, exact A2 metric transport for the FT forgery rows).
#
# Scope (binding: ATTACK_PROBLEMS.md of FT_FAMILY_SCALING_2026-09-22_RUN_002):
#   P1 key recovery  = Falcon eq. (2.3) loop, RAW iid ternary sigma_fg=sqrt(2/3),
#                      coefficient metric (root_det = sqrt(q)).
#   P2 forgery       = Falcon eq. (2.4) loop, inhomogeneous target-coset
#                      embedding, Q_A2 metric (root_det = sqrt(q*sqrt(3/4))),
#                      radius = sqrt(B_N - 1) (strict bound).
#   Falcon-512/1024 reference rows use the official v1.2 constants and are
#   validated against the published block sizes (936/952 at n=1024).
#
# FT768/FT3072 forgery rows exist per sigma variant and are labelled
# ALTERNATIVE_PROPOSAL; B_1536 is the kernel-pinned strict bound.
#
# Replay:  sage scripts/sec_estimate.sage     (plain Python, no preparser)

from __future__ import print_function

import csv
import hashlib
import json
import sys
from decimal import Decimal, ROUND_FLOOR, getcontext
from pathlib import Path

getcontext().prec = 110
D = Decimal
PI = D("3.141592653589793238462643383279502884197169399375105820974944592307"
      "81640628620899862803482534211706798214808651328230664709384460955058")
E = D(1).exp()
LN2 = D(2).ln()

TASK_DIR = Path(__file__).resolve().parent.parent
ART = TASK_DIR / "artifacts"
INPUTS = TASK_DIR / "inputs" / "family" / "parameters_family.json"


def require(cond, msg):
    if not cond:
        raise RuntimeError(msg)


def log2(x):
    x = D(x)
    require(x > 0, "log2 domain")
    return x.ln() / LN2


def pow2(x):
    return (D(x) * LN2).exp()


def sqrt(x):
    return D(x).sqrt()


def text(x, digits=40):
    return format(D(x), ".%dE" % digits)


def falcon_delta(block):
    """Implicit DBKZ delta of the Falcon equations."""
    b = D(block)
    return ((b / (D(2) * PI * E)).ln() / (D(2) * b)).exp()


def estimator_delta(block):
    """Pinned lattice-estimator/Chen root-Hermite formula for beta > 40."""
    b = D(block)
    inside = b / (D(2) * PI * E) * (PI * b) ** (D(1) / b)
    return (inside.ln() / (D(2) * (b - D(1)))).exp()


def dimensions_for_free(block):
    b = D(block)
    x = b * (D(4) / D(3)).ln() / (b / (D(2) * PI * E)).ln()
    return int(x.to_integral_value())


def solve_key_recovery(n, q, sigma_fg):
    for block in range(100, 2 * n + 1):
        b = D(block)
        log_left = ((D(1) - D(n) / b) * (b / (D(2) * PI * E)).ln()
                    + D(q).ln() / D(2))
        log_right = (D(3) * b / D(4)).ln() / D(2) + D(sigma_fg).ln()
        if log_left > log_right:
            return block
    raise RuntimeError("key-recovery block size not found")


def solve_forgery(n, root_det, radius):
    target = D(radius).ln()
    for block in range(100, 2 * n + 2):
        b = D(block)
        lhs = D(n) / b * (b / (D(2) * PI * E)).ln() + D(root_det).ln()
        if lhs <= target:
            return block
    raise RuntimeError("forgery block size not found")


def enum_cn12_bits(block, lattice_dimension, config):
    b = D(block)
    dim = D(lattice_dimension)
    exponent = (D(config["beta_log_beta_coefficient"]) * b * b.ln()
                + D(config["beta_coefficient"]) * b
                + D(config["constant"])
                + log2(D(config["node_cycles"])))
    repeat = (D(config["svp_repeat_dimension_factor"]) * dim
              if block < lattice_dimension else D(1))
    enum_log2 = exponent + log2(repeat)
    lll_log2 = D(3) * log2(dim)
    hi = max(enum_log2, lll_log2)
    lo = min(enum_log2, lll_log2)
    if hi - lo > D(200):
        return hi
    return hi + log2(D(1) + pow2(lo - hi))


def cost_rows(block, lattice_dimension, configs):
    return {
        "lambda_sieve_0.292": D(configs["sieve_0.292"]["coefficient"]) * D(block),
        "lambda_bdgl_0.265": D(configs["bdgl_0.265"]["coefficient"]) * D(block),
        "lambda_enum_CN12": enum_cn12_bits(block, lattice_dimension,
                                           configs["enum_CN12"]),
    }


def falcon_sigma(n, q, mult):
    """Official v1.2 key sigma_fg = 1.17*sqrt(q/(2n))."""
    return D(mult) * sqrt(D(q) / (D(2) * n))


def falcon_signing_sigma(n, q):
    """Official v1.2 sigma = smooth(eps, 2n) * gs_norm, gs_norm = 1.17*sqrt(q).
    eps = 1/sqrt(target_bitsec * 2^64), target_bitsec = max(2, n >> 2)."""
    target_bitsec = max(2, n >> 2)
    eps = D(1) / sqrt(D(target_bitsec) * D(2) ** 64)
    smooth = sqrt((D(2) * D(2) * D(n) * (D(1) + D(1) / eps)).ln() / PI) \
        / sqrt(D(2) * PI)
    gs = D("1.17") * sqrt(D(q))
    return smooth * gs


def falcon_radius_and_bound(n, q):
    """Official v1.2: max_sig_norm = floor(1.1*sqrt(2n)*sigma),
    sq_max_sig_norm = floor(max formula ** 2)."""
    sigma = falcon_signing_sigma(n, q)
    aux = D("1.1") * sqrt(D(2) * n) * sigma
    radius = int(aux.to_integral_value(rounding=ROUND_FLOOR))
    bound2 = int((aux ** 2).to_integral_value(rounding=ROUND_FLOOR))
    return radius, bound2


def ft_sigma_variant(variant, N):
    if "sigma" in variant:
        return D(variant["sigma"])
    require(variant["sigma_expr"] == "768*sqrt(N/1536)",
            "unknown sigma expression")
    return D(768) * sqrt(D(N) / D(1536))


def ft_bound(N, sigma):
    num = D(43 * 43) * D(2 * N) * sigma * sigma
    return int((num / D(1600)).to_integral_value(rounding=ROUND_FLOOR))


def main():
    inputs = json.loads(INPUTS.read_text(encoding="utf-8"))
    fam = inputs["family"]
    configs = inputs["cost_models"]
    # Binding to the active source build Extra/c: re-verified at run time.
    sys.path.insert(0, str(TASK_DIR / "scripts"))
    from build_binding import load_build
    build = load_build(TASK_DIR)
    require(int(fam["q"]) == build["q"], "q mismatch vs Extra/c build")
    require(int(fam["signing_sigma_baseline"]) == build["sigma_sign"],
            "sigma mismatch vs Extra/c build")
    for sch in fam["schemes"]:
        if sch.get("strict_bound_pinned"):
            require(int(sch["strict_bound_squared"]) == build["B"],
                    "pinned B mismatch vs Extra/c FALCON_FT1536_NORM_BOUND2")
    require(configs["sieve_0.292"]["coefficient"] == "0.292"
            and configs["bdgl_0.265"]["coefficient"] == "0.265",
            "Core-SVP coefficients changed")
    require(D(fam["margin_decimal"]) == D(43) / D(40), "margin mismatch")
    rows = []

    # ---- Falcon reference rows (official v1.2 constants) -----------------
    for tag, ref in sorted(inputs["falcon_anchors"].items()):
        n = int(ref["ring_degree"])
        q = int(ref["q"])
        d = int(ref["ambient_dimension"])
        require(d == 2 * n, "Falcon dimension convention mismatch")
        sigma_fg = falcon_sigma(n, q, ref["key_gs_multiplier"])
        kr = solve_key_recovery(n, q, sigma_fg)
        radius, bound2 = falcon_radius_and_bound(n, q)
        if "equation_2_4_radius" in ref:
            require(radius == int(ref["equation_2_4_radius"]),
                    "%s eq.2.4 radius mismatch: %d" % (tag, radius))
            require(bound2 == int(ref["bound_squared"]),
                    "%s bound^2 mismatch: %d" % (tag, bound2))
        fg = solve_forgery(n, sqrt(q), radius)
        anchors = ref.get("validation_anchors")
        if anchors:
            require(kr == anchors["keyrec_block"], "%s keyrec anchor" % tag)
            require(fg == anchors["forgery_block"], "%s forgery anchor" % tag)
        row = {
            "scheme": tag, "family": "falcon_reference", "attack": "key_recovery",
            "n": n, "d": d, "q": q, "variant": "official_v1.2",
            "sigma_fg": text(sigma_fg), "radius": "",
            "block": kr, "block_d4f": kr - dimensions_for_free(kr),
            "delta_falcon": text(falcon_delta(kr)),
            "delta_estimator": text(estimator_delta(kr)),
            "status": "FALCON_V1_2_EQ_2_3", "anchors_checked": bool(anchors),
        }
        row.update({k: text(v) for k, v in
                    cost_rows(kr, d, configs).items()})
        rows.append(row)
        row = {
            "scheme": tag, "family": "falcon_reference", "attack": "forgery",
            "n": n, "d": d, "q": q, "variant": "official_v1.2",
            "sigma_fg": "", "radius": str(radius),
            "block": fg, "block_d4f": fg - dimensions_for_free(fg),
            "delta_falcon": text(falcon_delta(fg)),
            "delta_estimator": text(estimator_delta(fg)),
            "status": "FALCON_V1_2_PARAMETERS_PY_EQ_2_4_RADIUS_FLOOR",
            "anchors_checked": bool(anchors),
        }
        row.update({k: text(v) for k, v in cost_rows(fg, d, configs).items()})
        rows.append(row)

    # ---- FT family rows --------------------------------------------------
    q = int(fam["q"])
    var_num = D(fam["key_sigma_variance"]["num"])
    var_den = D(fam["key_sigma_variance"]["den"])
    sigma_fg = sqrt(var_num / var_den)
    metric_det = D(fam["metric_block_det"]["num"]) / D(fam["metric_block_det"]["den"])
    root_det_a2 = sqrt(D(q) * sqrt(metric_det))
    require(root_det_a2 == sqrt(q) * D(3) ** D("0.25") / D(2) ** D("0.5")
            or abs(root_det_a2 / (sqrt(q) * (D(3) / D(4)) ** D("0.25")) - 1)
            < D("1e-100"),
            "A2 metric root transport mismatch")

    for sch in fam["schemes"]:
        N = int(sch["N"])
        d = 2 * N
        kr = solve_key_recovery(N, q, sigma_fg)
        row = {
            "scheme": sch["tag"], "family": "FT", "attack": "key_recovery",
            "n": N, "d": d, "q": q, "variant": "RAW_iid_ternary",
            "sigma_fg": text(sigma_fg), "radius": "",
            "block": kr, "block_d4f": kr - dimensions_for_free(kr),
            "delta_falcon": text(falcon_delta(kr)),
            "delta_estimator": text(estimator_delta(kr)),
            "status": "HEURISTIC_RAW_IID_TERNARY_EQ_2_3;"
                      "ACCEPTED_KEY_CONDITIONING_OPEN",
            "anchors_checked": False,
        }
        row.update({k: text(v) for k, v in cost_rows(kr, d, configs).items()})
        rows.append(row)

        for vname, variant in sorted(sch["sigma_variants"].items()):
            sigma = ft_sigma_variant(variant, N)
            if sch.get("strict_bound_pinned"):
                B = int(sch["strict_bound_squared"])
                require(B == ft_bound(N, sigma),
                        "pinned bound mismatch for %s" % sch["tag"])
                status = "PINNED_BOUND_KERNEL_A2_TRANSPORT_EQ_2_4_HEURISTIC"
            else:
                B = ft_bound(N, sigma)
                status = ("ALTERNATIVE_PROPOSAL_%s_A2_TRANSPORT_EQ_2_4_HEURISTIC"
                          % vname)
            radius = sqrt(D(B - 1))
            fg = solve_forgery(N, root_det_a2, radius)
            row = {
                "scheme": sch["tag"], "family": "FT", "attack": "forgery",
                "n": N, "d": d, "q": q, "variant": vname,
                "sigma_fg": text(sigma), "radius": text(radius),
                "B": B, "block": fg, "block_d4f": fg - dimensions_for_free(fg),
                "delta_falcon": text(falcon_delta(fg)),
                "delta_estimator": text(estimator_delta(fg)),
                "status": status, "anchors_checked": False,
            }
            row.update({k: text(v) for k, v in
                        cost_rows(fg, d, configs).items()})
            rows.append(row)

    ART.mkdir(parents=True, exist_ok=True)
    with open(ART / "model_eq234.json", "w") as f:
        json.dump({"schema": "FT_FAMILY_MODEL_EQ234_V1",
                   "inputs_sha256": hashlib.sha256(
                       INPUTS.read_bytes()).hexdigest(),
                   "rows": rows}, f, indent=2, sort_keys=True)
    fields = sorted({k for r in rows for k in r})
    with open(ART / "model_eq234.csv", "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        w.writerows(rows)
    print("model_eq234 rows:", len(rows))
    for r in rows:
        print("%-12s %-13s %-22s beta=%5s (d4f %5s) %s"
              % (r["scheme"], r["attack"], r["variant"], r["block"],
                 r["block_d4f"], r["status"][:34]))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
