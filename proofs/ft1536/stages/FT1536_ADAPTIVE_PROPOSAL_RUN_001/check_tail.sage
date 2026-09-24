# FT1536 truncated Gaussian G_S: rigorous tail cost per adaptive level.
# Run: sage check_tail.sage  (SageMath preparser mode, Sage 10.9)
#
# Goal: bound t_sigma = G(S_sigma^c), S_sigma = {|y - s| <= maxK_sigma},
# uniformly over center offset rho = m - s in [0,1] (frozen REFERENCE_LAWS:
# rho_true in [0,1]; raw-0 edge keeps rho_true = 1 after s-1 shift).
# Conservative distance: |y - m| >= maxK_sigma - 1 =: Kp outside S.
#
# Method (all real bounds rigorous via RealBallField / Arb):
#   Z = sum_y exp(-(y-m)^2/(2v)) >= exp(-1/(8v))      [nearest integer, dist<=1/2]
#   U = 2 * (sum_{j=0..J} exp(-(Kp+j)^2/(2v)) + remainder),
#     remainder <= term_J * r/(1-r), r = exp(-(2*(Kp+J)+1)/(2v)) < 1.
#   t_sigma <= U.upper() / Z.lower().
# Cross-checks: t_sigma <= frozen ERROR_LEDGER tail_upper and <= 2^-36.
#
# Exact inputs (ZZ/QQ); floats/balls only for rigorous real bounds.

from sage.all import ZZ, QQ, RealBallField

RBF = RealBallField(256)

levels = [ZZ(5), ZZ(20), ZZ(80), ZZ(320), ZZ(768)]
maxK = {ZZ(5): ZZ(29), ZZ(20): ZZ(59), ZZ(80): ZZ(118), ZZ(320): ZZ(235), ZZ(768): ZZ(365)}
variance = {ZZ(5): ZZ(5), ZZ(20): ZZ(20), ZZ(80): ZZ(80), ZZ(320): ZZ(320), ZZ(768): ZZ(768)}

# Frozen pin: ERROR_LEDGER.json conditioning_losses.tail_upper (exact QQ).
frozen_tail_upper = QQ("25108406941893570520985316636436632133419632284097977125243/115792089237316195423570985008687907853269984665640564039457584007913129639936")
# Frozen pin: metrics TV upper 1/2^36.
tv_main = QQ(1) / QQ(2) ** 36

J = 60  # explicit terms per tail side; remainder geometrically majorized

results = {}
for s in levels:
    v = variance[s]
    K = maxK[s]
    Kp = int(K - 1)  # conservative for rho in [0,1]; Kp >= 28 everywhere
    assert Kp >= 28, (s, Kp)
    two_v = RBF(2) * RBF(int(v))

    def ball_term(d):
        return (-(RBF(d) ** 2) / two_v).exp()

    terms = [ball_term(Kp + j) for j in range(J + 1)]
    partial = sum(terms)
    r = (-(RBF(2 * (Kp + J) + 1)) / two_v).exp()
    assert r.upper() < 1, (s, r)
    one = RBF(1)
    remainder = terms[-1] * r / (one - r)
    U = 2 * (partial + remainder)
    Zball = (-(one / (RBF(8) * RBF(int(v))))).exp()
    assert Zball.lower() > 0, (s, Zball)
    t_ub_ball = (U / Zball).upper()
    # Exact rational comparison: QQ(float) is the exact binary value of the
    # rounded-up endpoint, padded once more upward for safety.
    t_ub = QQ(t_ub_ball) * (QQ(2) ** 10 / (QQ(2) ** 10 - QQ(1))) + QQ(1) / QQ(2) ** 200
    assert t_ub <= frozen_tail_upper, (s, t_ub, frozen_tail_upper)
    assert t_ub <= tv_main, (s, t_ub, tv_main)
    results[int(s)] = t_ub
    print("level sigma0^2=%d K=%d Kp=%d t_ub<=%s (~2^%s)" % (
        int(s), int(K), Kp, t_ub, float(t_ub.log(2)) if t_ub > 0 else "-inf"))

worst = max(results.values())
print("FROZEN_TAIL_UPPER:", frozen_tail_upper)
print("TV_MAIN:", tv_main)
print("WORST_T_UB:", worst)
print("TAIL_CHECK_PASS")
