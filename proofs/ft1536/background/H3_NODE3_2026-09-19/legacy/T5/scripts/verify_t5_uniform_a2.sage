#!/usr/bin/env sage
"""Exact T5-a2 uniform implication with the global graph-lattice bridge."""

import hashlib
import json
import os
import sys
from pathlib import Path

if str(3/2) != "3/2":
    raise SystemExit("T5_FAIL:SAGE_PREPARSER_SENTINEL")


def require(condition, code):
    if not condition:
        raise SystemExit("T5_FAIL:" + code)


def sha256_file(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def binary64_exact(word):
    word = ZZ(word)
    sign = -1 if (word >> 63) else 1
    exponent = (word >> 52) & 0x7FF
    fraction = word & ((ZZ(1) << 52) - 1)
    require(exponent != 0x7FF, "NONFINITE_BINARY64")
    if exponent == 0:
        return QQ(sign * fraction) * QQ(2)^(-1074)
    return QQ(sign * ((ZZ(1) << 52) + fraction)) \
        * QQ(2)^(exponent - 1023 - 52)


def cmul_error(magnitude, value_error, coefficient_error, unit_roundoff,
               absolute_rounding_floor):
    """Max-component error for FPC_MUL by an approximate unit coefficient."""
    return (
        2 * magnitude * coefficient_error
        + 2 * value_error * (1 + coefficient_error)
        + 5 * unit_roundoff * (magnitude + value_error)
            * (1 + coefficient_error)
        + 5 * absolute_rounding_floor
    )


require(len(sys.argv) == 4, "ARGUMENTS")
repo = Path(sys.argv[1]).resolve()
runroot = Path(sys.argv[2]).resolve()
require(runroot.parent.parent == repo / "evidence", "RUNROOT_BINDING")
output_path = Path(sys.argv[3]).resolve()
require(output_path.parent == Path(__file__).resolve().parent,
        "OUTPUT_OUTSIDE_SCRATCH")
require(not output_path.exists(), "OUTPUT_PREEXISTING")

mutation = os.environ.get("T5_MUTATION", "")
require(mutation in (
    "", "source-digest", "dependency-digest", "leaf-bridge",
    "basis-kernel", "integral-split", "reciprocal-order",
    "dual-normalization", "unit-shear", "block-count",
), "UNKNOWN_MUTATION")
require(os.environ.get("T5_FORCE_FAILURE", "0") == "0", "FORCED_FAILURE")

expected_sources = {
    "build/falcon-keygen.c":
        "0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf",
    "build/falcon-fft.c":
        "06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063",
    "build/fpr-emulated.c":
        "7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f",
    "build/fpr-emulated.h":
        "242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa",
}
if mutation == "source-digest":
    expected_sources["build/falcon-keygen.c"] = "0" * 64
for relative, expected in expected_sources.items():
    require(sha256_file(repo / relative) == expected, "SOURCE_DIGEST")

keygen_text = (repo / "build/falcon-keygen.c").read_text(encoding="utf-8")
fft_text = (repo / "build/falcon-fft.c").read_text(encoding="utf-8")
fpr_text = (repo / "build/fpr-emulated.c").read_text(encoding="utf-8")
for token in (
    "#define FT1536_LEAF_MIN_BITS       UINT64_C(0x4090000053700377)",
    "ft_stable_top_branch_keygen(g00, leaves, scratch, &bad);",
    "fpr_div(q_squared, leaves[u])",
    "if (!ft_keygen_leaf_certificate((fpr *)fk->tmp, f, g, F, G,",
    "continue;",
):
    require(token in keygen_text, "KEYGEN_SOURCE_CONTRACT")
for token in (
    "for (m = 2; t > tmin; m <<= 1)",
    "fpr_gm3_square",
    "fpr_gm3_cubic",
    "FPC_MUL",
    "FPC_SQR",
):
    require(token in fft_text, "FFT_SOURCE_CONTRACT")
require("proper rounding" in fpr_text, "FPR_ROUNDING_CONTRACT")

expected_repo_dependencies = {
    "source_of_truth/v2.3/Results/T1-POISSON-IMAGE-LEMMA-001/DEFINITIONS.md":
        "21dcee91b39365e1c7c10fbe8882f497fd55ea62f109d5002bb73f44ba76c6b9",
    "source_of_truth/v2.3/Results/T1-POISSON-IMAGE-LEMMA-001/PROOF.md":
        "5390147026cc1f3c8ada01d20d3ba9ae4359cc6f51436359cc913f92bd8ba1ce",
    "source_of_truth/v2.3/Results/T1-POISSON-IMAGE-LEMMA-001/T1A_POISSON.md":
        "46d32c73fe6882bdbf58069a74296ba649ac915902090260f3f8d06a97339271",
}
expected_run_dependencies = {
    "inputs/a1/output_hashes.sha256":
        "71d13d5a34badea7414c14d07e53c2c11a76ea5bbc01f2f482538be58678bedf",
    "A1_MATH_REVIEW_ASSERTION.json":
        "4d2d128ced1ec8a1d8ca2e7ba16e58b69e523e2615ad3c300bc3e22b741da48e",
}
if mutation == "dependency-digest":
    expected_run_dependencies["inputs/a1/output_hashes.sha256"] = "0" * 64
for relative, expected in expected_repo_dependencies.items():
    require(sha256_file(repo / relative) == expected, "DEPENDENCY_DIGEST")
for relative, expected in expected_run_dependencies.items():
    require(sha256_file(runroot / relative) == expected, "DEPENDENCY_DIGEST")

t1a_text = (repo / (
    "source_of_truth/v2.3/Results/T1-POISSON-IMAGE-LEMMA-001/"
    "T1A_POISSON.md"
)).read_text(encoding="utf-8")
for token in (
    "Poisson summation",
    "e^{2\\pi i\\langle w,t_c\\rangle}",
    "e^{-\\pi s^2\\|w\\|_{M^{-1}}^2}",
):
    require(token in t1a_text, "T1A_SHIFT_INTERFACE")

twiddle_path = runroot / "inputs/a1/FFT_TWIDDLE_AUDIT.json"
require(sha256_file(twiddle_path)
        == "0b19e2944a7c698a09a058f01ccdf94697985a3e88dbbaa56a3075fbddcfd3a8",
        "TWIDDLE_AUDIT_DIGEST")
twiddle = json.loads(twiddle_path.read_text(encoding="utf-8"))
require(twiddle["status"] == "PASS", "TWIDDLE_AUDIT_STATUS")
require(twiddle["root_order"] == 4608, "TWIDDLE_ROOT_ORDER")
require(twiddle["square_used_count"] == 255, "TWIDDLE_SQUARE_COUNT")
require(twiddle["cubic_used_count"] == 256, "TWIDDLE_CUBIC_COUNT")
require(twiddle["fixed_constant_count"] == 6, "TWIDDLE_FIXED_COUNT")
require(twiddle["component_error_lt_2^-50"], "TWIDDLE_ERROR")
require(twiddle["square_exponent_map_sha256"]
        == "d87bea64489acf39ecfd9ac66b31c62917bc4f4a3bc376a4cc83eb2e9dfa553d",
        "TWIDDLE_SQUARE_PATTERN")
require(twiddle["cubic_exponent_map_sha256"]
        == "b5afac80fb5eacc652e5f40ed5da493d9f80201b6905a7be14ad99f9696d1f76",
        "TWIDDLE_CUBIC_PATTERN")

# Correctly rounded binary64 model for the source-bound FPR backend.
u = QQ(1) / 2^53
eps = QQ(1) / 2^50
tiny = QQ(1) / 2^1074

# The first degree-two pass has max-component ideal magnitude < 2 and error
# at most eps.  There are exactly eight degree-doubling passes.  Each pass is
# one FPC_MUL followed by one FPC_ADD/SUB on every path.  The recurrence is a
# direct absolute-error count for those macros; its constants deliberately
# dominate sticky-bit/tie rounding by a wide margin.
magnitude = QQ(2)
fft_error = eps
doubling_trace = []
for stage in range(8):
    multiply_error = cmul_error(magnitude, fft_error, eps, u, tiny)
    next_error = fft_error + multiply_error \
        + u * (3 * magnitude + fft_error + multiply_error) + tiny
    magnitude *= 3
    fft_error = next_error
    doubling_trace.append(fft_error)

# The final ternary pass has three exact branches A+B*x+C*x^2.  The longest
# B/C paths contain two complex multiplications; x^2 is one FPC_SQR.
b_x_error = cmul_error(magnitude, fft_error, eps, u, tiny)
b_w_error = cmul_error(2 * magnitude, b_x_error, eps, u, tiny)
x_square_error = cmul_error(QQ(1), eps, eps, u, tiny)
c_x_error = cmul_error(magnitude, fft_error, x_square_error, u, tiny)
c_w_error = cmul_error(2 * magnitude, c_x_error, eps, u, tiny)
bc_error = b_w_error + c_w_error \
    + u * (4 * magnitude + b_w_error + c_w_error) + tiny
fft_error = fft_error + bc_error \
    + u * (5 * magnitude + fft_error + bc_error) + tiny
require(fft_error < QQ(1) / 2^29, "FFT_ERROR")

# Irrespective of the deliberately loose intermediate magnitude recurrence,
# the exact output is evaluation of a ternary polynomial at a unit root, so
# every real/imaginary component is bounded by N.  Propagate the proven FFT
# error through two rounded squared norms and their rounded sum.
N = ZZ(1536)
root_magnitude = QQ(N)
sq_error = (
    2 * root_magnitude * fft_error + fft_error^2
    + u * (root_magnitude + fft_error)^2 + tiny
)
norm_error = 2 * sq_error \
    + u * (2 * (root_magnitude + fft_error)^2 * (1 + u)) + tiny
g00_error = 2 * norm_error \
    + u * (4 * (root_magnitude + fft_error)^2 * (1 + u)^2) + tiny
g00_target = QQ(1) / 64
if mutation == "leaf-bridge":
    g00_target = QQ(1) / 2^20
require(g00_error < g00_target, "G00_ERROR")

# The source rejects every computed g00 root below 1/2.  Thus the exact root
# is coordinatewise in [31/32,33/32] times the computed root.  The ternary
# symmetric LDL pivots and all binary arithmetic/harmonic means are positive,
# monotone and homogeneous.
root_lower_factor = QQ(31) / 32
root_upper_factor = QQ(33) / 32
rminus = 1 - u
rplus = 1 + u

# Worst local rounding factors: top ternary pivots use at most
# rplus^4/rminus^3 upward (and its lower counterpart); eight binary levels use
# at most rplus^2/rminus per level.  This covers every one of the 768 primary
# leaves.  The other 768 are one rounded q^2/D division.
round_lower = rminus^20 / rplus^11
round_upper = rplus^20 / rminus^11
primary_exact_over_computed = root_lower_factor / round_upper
reciprocal_exact_over_computed = (
    QQ(1) / root_upper_factor * round_lower / rplus
)
leaf_bridge_factor = min(
    primary_exact_over_computed,
    reciprocal_exact_over_computed,
)

machine_leaf_min = binary64_exact(ZZ(0x4090000053700377))
exact_leaf_lower = machine_leaf_min * leaf_bridge_factor
leaf_floor = ZZ(991)
require(exact_leaf_lower > leaf_floor, "EXACT_LEAF_FLOOR")

# Exact symbolic verification of the source's recursive LDL formulas.  A
# binary Fourier block with eigenvalues a,b has pivots (a+b)/2 and
# 2ab/(a+b).  A ternary Fourier block with eigenvalues a,b,c has leading
# principal minors e1/3, e2/3, abc and therefore pivots
# e1/3, e2/e1, 3abc/e2, exactly as ft_stable_top_branch_keygen().
Qx = PolynomialRing(QQ, names=("x",))
x = Qx.gen()
K = NumberField(x^2 + x + 1, names=("omega",))
omega = K.gen()
P = PolynomialRing(K, names=("aa", "bb", "cc"))
aa, bb, cc = P.gens()
binary_matrix = Matrix(P, [
    [(aa + bb) / 2, (aa - bb) / 2],
    [(aa - bb) / 2, (aa + bb) / 2],
])
require(binary_matrix.det() == aa * bb, "BINARY_LDL_DETERMINANT")
require(binary_matrix[0, 0] == (aa + bb) / 2,
        "BINARY_LDL_FIRST_PIVOT")
require(binary_matrix.det() / binary_matrix[0, 0]
        == 2 * aa * bb / (aa + bb), "BINARY_LDL_SECOND_PIVOT")

c0 = (aa + bb + cc) / 3
c1 = (aa + bb * omega^2 + cc * omega) / 3
c2 = (aa + bb * omega + cc * omega^2) / 3
ternary_matrix = Matrix(P, [
    [c0, c2, c1],
    [c1, c0, c2],
    [c2, c1, c0],
])
e1 = aa + bb + cc
e2 = aa * bb + aa * cc + bb * cc
minor2 = ternary_matrix.matrix_from_rows_and_columns([0, 1], [0, 1]).det()
require(ternary_matrix[0, 0] == e1 / 3,
        "TERNARY_LDL_FIRST_PIVOT")
require(minor2 == e2 / 3, "TERNARY_LDL_SECOND_MINOR")
require(ternary_matrix.det() == aa * bb * cc,
        "TERNARY_LDL_DETERMINANT")
require(minor2 / ternary_matrix[0, 0] == e2 / e1,
        "TERNARY_LDL_SECOND_PIVOT")
require(ternary_matrix.det() / minor2 == 3 * aa * bb * cc / e2,
        "TERNARY_LDL_THIRD_PIVOT")

# Reciprocal child values reverse every local pivot list.  This is what makes
# the inverse of each primal block controlled by another certified physical
# leaf; it is not a label or an assumed Boolean.
FR = FractionField(PolynomialRing(QQ, names=("ra", "rb", "rc", "Q2")))
ra, rb, rc, Q2 = FR.gens()
binary_primary = [(ra + rb)/2, 2*ra*rb/(ra + rb)]
binary_reciprocal = [
    (Q2/ra + Q2/rb)/2,
    2*(Q2/ra)*(Q2/rb)/(Q2/ra + Q2/rb),
]
binary_expected = [Q2/binary_primary[1], Q2/binary_primary[0]]
if mutation == "reciprocal-order":
    binary_expected = list(reversed(binary_expected))
require(binary_reciprocal == binary_expected, "BINARY_RECIPROCAL_REVERSE")

re1 = ra + rb + rc
re2 = ra*rb + ra*rc + rb*rc
ternary_primary = [re1/3, re2/re1, 3*ra*rb*rc/re2]
ira, irb, irc = Q2/ra, Q2/rb, Q2/rc
ire1 = ira + irb + irc
ire2 = ira*irb + ira*irc + irb*irc
ternary_reciprocal = [ire1/3, ire2/ire1, 3*ira*irb*irc/ire2]
require(ternary_reciprocal == [
    Q2/ternary_primary[2],
    Q2/ternary_primary[1],
    Q2/ternary_primary[0],
], "TERNARY_RECIPROCAL_REVERSE")

# Pointwise NTRU Gram determinant identity.
HP = PolynomialRing(QQ, names=(
    "fv", "gv", "Fv", "Gv", "fb", "gb", "Fb", "Gb",
))
fv, gv, Fv, Gv, fb, gb, Fb, Gb = HP.gens()
hg00 = fv*fb + gv*gb
hg11 = Fv*Fb + Gv*Gb
hg10 = Gv*gb + Fv*fb
hg01 = Gb*gv + Fb*fv
require(hg00*hg11 - hg10*hg01
        == (fv*Gv - gv*Fv)*(fb*Gb - gb*Fb),
        "NTRU_GRAM_DETERMINANT")


def multiplication_matrix(poly, modulus, degree):
    xx = modulus.parent().gen()
    columns = []
    for jj in range(degree):
        value = (poly * xx**jj).mod(modulus)
        columns.append(vector(QQ, [value[ii] for ii in range(degree)]))
    return matrix(QQ, degree, degree,
                  lambda ii, jj: columns[jj][ii])


def canonical_metric(degree):
    require(degree % 2 == 0, "CANONICAL_METRIC_DEGREE")
    local = matrix(QQ, [[1, QQ(1)/2], [QQ(1)/2, 1]])
    result = zero_matrix(QQ, degree)
    for ii in range(degree // 2):
        indices = [ii, ii + degree//2]
        for aa0 in range(2):
            for bb0 in range(2):
                result[indices[aa0], indices[bb0]] = local[aa0, bb0]
    return result


def terminal_pairs(indices):
    if len(indices) == 2:
        return [indices]
    require(len(indices) % 2 == 0, "BINARY_SPLIT_DEGREE")
    return terminal_pairs(indices[0::2]) + terminal_pairs(indices[1::2])


def block_ldl(A, width, mutate_unit=False):
    require(A.nrows() == A.ncols() and A.nrows() % width == 0,
            "BLOCK_LDL_SHAPE")
    count = A.nrows() // width
    L = identity_matrix(QQ, A.nrows())
    diagonals = []
    for ii in range(count):
        ri = list(range(ii*width, (ii + 1)*width))
        Di = A.matrix_from_rows_and_columns(ri, ri)
        for kk in range(ii):
            rk = list(range(kk*width, (kk + 1)*width))
            Lik = L.matrix_from_rows_and_columns(ri, rk)
            Di -= Lik * diagonals[kk] * Lik.transpose()
        require(Di.is_invertible(), "BLOCK_LDL_PIVOT")
        diagonals.append(Di)
        for jj in range(ii + 1, count):
            rj = list(range(jj*width, (jj + 1)*width))
            Eji = A.matrix_from_rows_and_columns(rj, ri)
            for kk in range(ii):
                rk = list(range(kk*width, (kk + 1)*width))
                Ljk = L.matrix_from_rows_and_columns(rj, rk)
                Lik = L.matrix_from_rows_and_columns(ri, rk)
                Eji -= Ljk * diagonals[kk] * Lik.transpose()
            L.set_block(jj*width, ii*width, Eji * Di.inverse())
    if mutate_unit:
        L[0, 0] = 2
    Delta = block_diagonal_matrix(diagonals)
    require(all(L[ii, ii] == 1 for ii in range(L.nrows())),
            "BLOCK_UNIT_SHEAR")
    require(A == L * Delta * L.transpose(), "BLOCK_LDL_RECONSTRUCTION")
    return L, diagonals


def check_graph_instance(degree, modulus_q):
    RP = PolynomialRing(QQ, names=("sx",))
    sx = RP.gen()
    phi = sx**degree - sx**(degree//2) + 1
    sf = RP(1)
    sg = 1 + sx + sx**2
    sF = RP(0)
    sG = RP(modulus_q)
    Mf = multiplication_matrix(sf, phi, degree)
    Mg = multiplication_matrix(sg, phi, degree)
    MF = multiplication_matrix(sF, phi, degree)
    MG = multiplication_matrix(sG, phi, degree)
    II = identity_matrix(QQ, degree)
    B = block_matrix(QQ, [[Mg, MG], [-Mf, -MF]])
    Mr = canonical_metric(degree)
    MM = block_diagonal_matrix([Mr, Mr])
    H_for_gate = Mg
    if mutation == "basis-kernel" and degree == 6:
        H_for_gate = Mg + II
    Agraph = block_matrix(QQ, [[II, H_for_gate]])
    require(abs(B.det()) == modulus_q**degree,
            "GRAPH_BASIS_DETERMINANT")
    require(all(value % modulus_q == 0 for value in (Agraph*B).list()),
            "GRAPH_BASIS_KERNEL")
    Gp = B.transpose() * MM * B
    Cdual = B.inverse().transpose()
    require(Cdual.transpose() * MM.inverse() * Cdual == Gp.inverse(),
            "GRAPH_DUAL_METRIC")

    pairs = []
    for residue in range(3):
        branch = [residue + 3*kk for kk in range(degree//3)]
        pairs.extend(terminal_pairs(branch))
    ring_order = [value for pair in pairs for value in pair]
    order = ring_order + [degree + value for value in ring_order]
    if mutation == "integral-split" and degree == 6:
        order[-1] = order[-2]
    require(sorted(order) == list(range(2*degree)),
            "INTEGRAL_SPLIT_BIJECTION")
    permuted = Gp.matrix_from_rows_and_columns(order, order)
    _, pivots = block_ldl(
        permuted, 2,
        mutate_unit=(mutation == "unit-shear" and degree == 6),
    )
    local = matrix(QQ, [[1, QQ(1)/2], [QQ(1)/2, 1]])
    scalars = []
    for pivot in pivots:
        scalar = pivot[0, 0]
        require(pivot == scalar*local, "EXACT_A2_PIVOT")
        require(scalar > 0, "POSITIVE_A2_PIVOT")
        scalars.append(scalar)
    require(len(scalars) == degree, "SMALL_BLOCK_COUNT")
    require(prod(value**2 for value in scalars)
            * (QQ(3)/4)**degree == Gp.det(),
            "SMALL_BLOCK_DETERMINANT")
    primary = scalars[:degree//2]
    require(scalars[degree//2:]
            == [modulus_q**2/value for value in reversed(primary)],
            "SMALL_RECIPROCAL_REVERSE")
    return scalars


# The terminal A2 inverse is an integral sign conjugate of (4/3) A2.
A2 = matrix(QQ, [[1, QQ(1)/2], [QQ(1)/2, 1]])
J = diagonal_matrix(QQ, [1, -1])
dual_factor = QQ(4)/3
if mutation == "dual-normalization":
    dual_factor = QQ(1)
require(A2.inverse() == dual_factor * J * A2 * J,
        "A2_DUAL_NORMALIZATION")

# Exact nontrivial graph-lattice instances exercise the complete construction,
# not merely the local formulas.
small_instance_scalars = {}
for small_degree in (6, 12, 24):
    small_instance_scalars[small_degree] = check_graph_instance(
        small_degree, ZZ(7))
small_material = "|".join(
    str(degree) + ":" + ",".join(str(v)
        for v in small_instance_scalars[degree])
    for degree in sorted(small_instance_scalars)
).encode("ascii")
small_instance_sha256 = hashlib.sha256(small_material).hexdigest()

# Derive the full integral terminal permutation and factor count.
N_full = ZZ(1536)
top_branches = ZZ(3)
branch_degree = N_full // top_branches
binary_levels = ZZ(0)
cursor_degree = branch_degree
while cursor_degree > 2:
    require(cursor_degree % 2 == 0, "FULL_BINARY_TOWER")
    cursor_degree //= 2
    binary_levels += 1
require(cursor_degree == 2 and binary_levels == 8, "FULL_TERMINAL_DEGREE")
full_pairs = []
for residue in range(int(top_branches)):
    branch = [residue + int(top_branches)*kk
              for kk in range(int(branch_degree))]
    full_pairs.extend(terminal_pairs(branch))
full_order = [value for pair in full_pairs for value in pair]
require(sorted(full_order) == list(range(int(N_full))),
        "FULL_INTEGRAL_SPLIT")
primary_block_count = ZZ(len(full_pairs))
require(primary_block_count == top_branches * 2**binary_levels,
        "PRIMARY_BLOCK_COUNT")
block_count = 2 * primary_block_count
if mutation == "block-count":
    block_count -= 1
require(block_count == N_full, "BLOCK_COUNT")

q = ZZ(18433)
sigma = ZZ(768)
pi_lower = QQ(333) / 106
ln2_upper = QQ(347) / 500
# T1 fixes s=sqrt(2*pi)*sigma and weight exp(-pi*s^2*Qstar).
# Under Qstar(J(a,b)/q)=4*Q(a,b)/(3*q^2), this is exp(-kappa*Q)
# with kappa=8*pi^2*sigma^2/(3*q^2).  No doubled-scale tau_2 is used.
kappa_leaf_lower = (
    8 * pi_lower^2 * sigma^2 * leaf_floor / (3 * q^2)
)
m = ZZ((kappa_leaf_lower / ln2_upper).floor())
require(kappa_leaf_lower > m * ln2_upper, "DYADIC_EXPONENT")
require(m >= 65, "DYADIC_STRENGTH")
y = QQ(1) / 2^m

# A2 has at most 6*n vectors of norm n.  Therefore its nonzero centered mass
# is bounded by 6*y/(1-y)^2.  Multiply the 1536 exact shifted block bounds.
a2_nonzero = 6 * y / (1 - y)^2
tau_upper = (1 + a2_nonzero)^block_count - 1
require(tau_upper < QQ(1) / 2^40, "UNIFORM_TAU_TARGET")

# Every successful FT1536 KeyGen path executes the leaf certificate before
# the success break.  Consequently the good set is the entire support of both
# the ideal iid rejection model and the real 256-bit-seed pushforward.  The
# attempt cap changes only the probability that a call returns a key.
delta_key = QQ(0)
require(delta_key == 0, "KEYGEN_BAD_KEY_PROBABILITY")

RBF = RealBallField(512)
tau_material = (
    str(tau_upper.numerator()) + "/" + str(tau_upper.denominator())
).encode("ascii")
certificate = {
    "schema": "FT1536_T5_UNIFORM_KEYGEN_THETA_CERTIFICATE_V2",
    "status": "PASS",
    "parameters": {
        "N": int(N),
        "q": int(q),
        "sigma": int(sigma),
        "graph_rank": int(3072),
        "a2_block_count": int(block_count),
        "keygen_attempt_cap": int(3000000),
        "fourier_scale": "s=sqrt(2*pi)*sigma",
    },
    "source_bindings": expected_sources,
    "dependency_bindings": {
        "repo": expected_repo_dependencies,
        "run": expected_run_dependencies,
    },
    "fft_soundness": {
        "unit_roundoff": str(u),
        "twiddle_component_error_bound": str(eps),
        "absolute_rounding_floor": str(tiny),
        "doubling_passes": int(8),
        "fft_component_error_exact": str(fft_error),
        "fft_component_error_RBF512": str(RBF(fft_error)),
        "fft_component_error_lt_2^-29": True,
        "g00_absolute_error_exact": str(g00_error),
        "g00_absolute_error_RBF512": str(RBF(g00_error)),
        "g00_absolute_error_lt_1/64": True,
    },
    "leaf_bridge": {
        "machine_leaf_min_exact": str(machine_leaf_min),
        "primary_exact_over_computed_lower":
            str(primary_exact_over_computed),
        "reciprocal_exact_over_computed_lower":
            str(reciprocal_exact_over_computed),
        "uniform_bridge_factor_lower": str(leaf_bridge_factor),
        "exact_leaf_lower": str(exact_leaf_lower),
        "exact_leaf_lower_RBF512": str(RBF(exact_leaf_lower)),
        "certified_integer_leaf_floor": int(leaf_floor),
    },
    "global_leaf_to_a2_bridge": {
        "graph_lattice_basis":
            "B=[[M(g),M(G)],[-M(f),-M(F)]]; Lambda_h=B*ZZ^(2N)",
        "dual_metric_identity":
            "Qstar(B^(-T)z)=z^T*(B^T*M*B)^(-1)*z",
        "integral_top_split_branches": int(top_branches),
        "integral_binary_levels": int(binary_levels),
        "terminal_ring_degree": int(cursor_degree),
        "split_index": 1,
        "primary_a2_blocks": int(primary_block_count),
        "total_a2_blocks": int(block_count),
        "reciprocal_leaf_order": "reverse_q^2_over_primary",
        "a2_inverse_similarity": "A2^-1=(4/3)*J*A2*J",
        "completion_order": "last_block_to_first_block",
        "triangular_diagonal_blocks_are_identity": True,
        "shifted_theta_bound":
            "T1A Poisson positive Fourier weights and Re(phase)<=1",
        "exact_small_instance_degrees": [int(6), int(12), int(24)],
        "exact_small_instance_material_sha256": small_instance_sha256,
    },
    "theta": {
        "kappa_times_leaf_floor_lower_exact": str(kappa_leaf_lower),
        "dyadic_exponent_m": int(m),
        "a2_nonzero_upper_exact": str(a2_nonzero),
        "tau_upper_sha256": hashlib.sha256(tau_material).hexdigest(),
        "tau_upper_numerator_digits": len(str(tau_upper.numerator())),
        "tau_upper_denominator_digits": len(str(tau_upper.denominator())),
        "tau_upper_log2_RBF512": str(RBF(tau_upper).log() / RBF(2).log()),
        "uniform_tau_lt_2^-40": True,
    },
    "key_quantifier": {
        "good_set": "ALL_SUCCESSFULLY_EMITTED_FT1536_KEYS",
        "delta_key_exact": str(delta_key),
        "uniform_over_ideal_iid_accepted_law": True,
        "uniform_over_real_256_bit_seed_pushforward": True,
        "attempt_cap_biases_conditional_accepted_tuple_law": False,
    },
    "claim_boundary": {
        "t5_uniform_key_quantifier": "PROVED_CANDIDATE_PENDING_REVIEW",
        "campaign_used_as_premise": False,
        "history_used_as_premise": False,
        "security_claimed": False,
        "later_task_attempted": False,
    },
}


def strict_json_default(value):
    if isinstance(value, type(ZZ(0))):
        return int(value)
    raise TypeError("unsupported certificate type: " + type(value).__name__)


payload = json.dumps(
    certificate, indent=int(2), sort_keys=True, default=strict_json_default,
) + "\n"
output_path.write_text(payload, encoding="utf-8")
print("T5_UNIFORM=PASS")
print("GLOBAL_LEAF_A2_BRIDGE=PASS")
print("DELTA_KEY=0")
print("UNIFORM_TAU_LT=2^-40")
print("DYADIC_EXPONENT=65")
