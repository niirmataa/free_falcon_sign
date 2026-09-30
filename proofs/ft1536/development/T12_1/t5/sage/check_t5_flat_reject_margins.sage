# Checker T5-FLAT-REJECT: niezalezne sprawdzenie nowych faktow liczbowych
# modulow Run2/T5GateBudget i Run2/T5KeyGenQuant oraz cap ogona proposal
# boxa dla transportu infinite->box (obowiazek analityczny T5CosetScale).
# Dokladne QQ/ZZ + kule Arb512, bez RDF i bez RNG.
from pathlib import Path
import json
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024

R = RealBallField(512)
C = ComplexBallField(512)

# --- 1. Lancuch marginesow T5GateBudget (dokladne QQ) ---
# gateRowDev = 2*gateRatio/(1-gateRatio), gateRatio = 2^-50.
gateRatio = QQ(1)/QQ(2)^50
gateRowDev = 2*gateRatio/(1-gateRatio)
ok_dev_eq = gateRowDev == QQ(2)/(QQ(2)^50 - 1)
ok_dev_le = gateRowDev <= QQ(1)/QQ(2)^48
y = ZZ(3072) * gateRowDev
ok_y = y < 1
productLo = 1 - y
productHi = 1/(1-y)
flatBudget = QQ(1)/QQ(2)^36
rejectBudget = QQ(1)/QQ(2)^24
ok_lo = (1-flatBudget)*productHi <= productLo
ok_hi = productHi <= (1+flatBudget)*productLo
ok_ratio = productHi/productLo <= QQ(17)/16

# --- 2. Koszty bramki: lowerBits/upperBits (dokladne ZZ) ---
lowerBits = ZZ(0x4090000053700377)
upperBits = ZZ(0x4114444d1a037d50)

def positive_normal_value(w):
    e = w // 2^52
    m = w % 2^52
    return QQ(2^52 + m) * QQ(2)^(ZZ(e) - 1075)

vlo = positive_normal_value(lowerBits)
vhi = positive_normal_value(upperBits)
ok_lower = vlo >= 1024
ok_upper = vhi <= 332054
# Combined leaf floor consumed by T5GateBudget.gateCoefficientCap.
ok_leaf_floor = QQ(18433^2) / QQ(332054) >= 1023
ok_gate_band = vlo < vhi

# --- 3. Margines logarytmiczny drogi skalarnej (Arb512) ---
# 50*ln 2 < pi/cap z cap = 18433^2/(1023*2*pi*768^2),
# tj. 50*ln2*18433^2 < 2*pi^2*1023*768^2.
lhs = 50 * R(2).log()
rhs = 2 * R.pi()^2 * 1023 * 768^2 / 18433^2
ok_log = bool(lhs < rhs)

# --- 4. Ogony wspolrzedne poza proposal boxem (Arb512) ---
# Blok A2 o wadze exp(-(x^2+x*y+y^2)/1179648) = gaussian_box(768^2);
# dokladnie te same formuly co run/sage/check_tail_obligations.sage.
sig = ZZ(768)

def gaussian_box(sigma2):
    a = R(1)/(2*sigma2); tau = C(0,1)*C(a/R.pi())
    ts = C(0).jacobi_theta(tau); tt = C(0).jacobi_theta(3*tau)
    g = (ts[2]*tt[2]+ts[1]*tt[1]).real()
    L = ZZ(65536); beta = 3*a/4; r = (-beta*(2*L+1)).exp()
    tail = 4*(1+(2*R.pi()*sigma2).sqrt())*(-beta*L^2).exp()/(1-r)
    return g.add_error(tail)

G = gaussian_box(R(sig^2))
shift = 1+(2*R.pi()).sqrt()*sig

def coordinate_tail(L):
    beta = R(3)/(8*sig^2); r = (-beta*(2*L+1)).exp()
    return 2*shift/G*(-beta*L^2).exp()/(1-r)

# Poza boxem |x| >= 65536 dla jakies z 3072 wspolrzednych; koszt jest
# (1+2^-40)-owy transfer marginalny po stronie analitycznej (obligation).
box_tail = 3072 * coordinate_tail(65536)
boxTailCap = QQ(1)/QQ(2)^2800
ok_box = bool(box_tail <= R(boxTailCap))

assert ok_dev_eq and ok_dev_le and ok_y, (gateRowDev, y)
assert ok_lo and ok_hi and ok_ratio, (productLo, productHi)
assert ok_lower and ok_upper and ok_leaf_floor and ok_gate_band, (vlo, vhi)
assert ok_log, (lhs, rhs)
assert ok_box, box_tail

out = dict(
    status='PASS',
    gateRatio=str(gateRatio), gateRowDev=str(gateRowDev),
    productLo=str(productLo), productHi=str(productHi),
    flatBudget=str(flatBudget), rejectBudget=str(rejectBudget),
    lowerValue=str(vlo), upperValue=str(vhi),
    leafFloor=str(QQ(18433^2)/QQ(332054)),
    logMarginLhs=str(lhs), logMarginRhs=str(rhs),
    coordinateTail65536=str(coordinate_tail(65536)),
    boxTail=str(box_tail), boxTailCap=str(boxTailCap),
    checks=dict(
        gateRowDev_exact=ok_dev_eq, gateRowDev_le_2minus48=ok_dev_le,
        product_deviation_below_1=ok_y,
        flat_lower_factor=ok_lo, flat_upper_factor=ok_hi,
        tilted_ratio_le_17_16=ok_ratio,
        gate_lower_ge_1024=ok_lower, gate_upper_le_332054=ok_upper,
        combined_leaf_floor_ge_1023=ok_leaf_floor,
        gate_band_ordered=ok_gate_band,
        scalar_log_margin=ok_log, box_tail_le_cap=ok_box),
    kernel_targets=('Run2/T5GateBudget gate_log_margin product_sandwich '
        'flat_factor_margins scale_tilt_ratio; Run2/T5KeyGenQuant '
        'accepted_value_upper gate_full_floor; Run2/T5CosetScale transport'),
    arithmetic='RealBallField(512) + exact ZZ/QQ comparisons, no RNG',
)
Path('t5_flat_reject_margins_result.json').write_text(json.dumps(out, indent=2)+'\n')
print('T5_FLAT_REJECT_MARGINS_PASS', json.dumps(out['checks'], sort_keys=True))
