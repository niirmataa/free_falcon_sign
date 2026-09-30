# check_cert_hi.sage — L0b pre-check kierunku certHi (droga b).
# Klasa diagnostyczna (dokładne literały + podwójna precyzja sum), decyzja
# P1/P2′ na liczbach PRZED dowodem. Zasady: floor na ZZ, asserty, te same
# formy co dowód (B/binLo/hiT1/triangle jak w Lean). Uruchomienie:
#   sage check_cert_hi.sage
from pathlib import Path
import json

assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024

R5 = RealBallField(512); C5 = ComplexBallField(512)

B = ZZ(2093922385); q = ZZ(18433); half = ZZ(9216)
sig = ZZ(768); D = 2 * sig^2                    # 1179648
alpha = RR(1) / RR(D)
width = ZZ(16)

def binLo(x): return (x + 15) // 16
def binUp(x): return x // 16
def block(x, y): return x*x + x*y + y*y
def center(x): return (x + half) % q - half

def hiT1(_Q, Qc): return binLo(B - Qc - 1535*15) * 16
def loT1(_Q, Qc): return binLo(B - Qc) * 16

# ---- 1. Literały silnika (piny RawRadialEnclosure) ----
here = Path('.').resolve()
engineHi = QQ(130388256047913744896577852830398542397) / QQ(10284403483257537763468557390983440656142099160209874159288064)
aliasCap = QQ(99099791888604981023) / QQ(10^53)
missCap = QQ(215592228110355906518) / QQ(10^58)
target_hi = R5(engineHi + missCap)                  # górna granica tezy certHi

# ---- 2. Geometria: maks/min Qc na trójkącie sektora (dokładnie po a) ----
Qc_max = ZZ(0); Qc_max_pt = None; Tmin = None
for a in range(9217, 13825):
    blo = ZZ(-9216); bhi = ZZ(18432 - 2*a)
    for b in (blo, bhi):
        Qc = block(center(a), center(b))
        if Qc > Qc_max:
            Qc_max = Qc; Qc_max_pt = (a, b)
assert center(9217) == 9217 - q and center(-9216) == -9216
# Qc(a,b) = block(a,b) + q*(q-2a-b), a q-2a-b maleje po a i b => Qc maks
# w rogu (9217, -9216): sprawdzone numerycznie wyżej (oba rogi po a).
Tmin = hiT1(ZZ(0), Qc_max)
print('Qc_max=%d w %s  Tmin=hiT1_min=%d' % (Qc_max, Qc_max_pt, Tmin))
assert Qc_max == block(9217 - q, -9216) and Qc_max_pt == (9217, -9216)

# ---- 3. mgf1(l) = blockSum(c0-l)/blockSum(c0) — theta, podwójna precyzja ----
def block_sum(s):
    # suma po całym A2: Theta2(s) = suma kwadratowa Gaussa (granica + ogon)
    # postać z gaussian_box (jacobi_theta) jak w close_radial_interval.
    # slotVal s d = exp(-s * Q) => masa = Theta2(s) na kratce A2
    tau = C5(0, 1) * C5(s / R5.pi())
    th = C5(0).jacobi_theta(tau); th3 = C5(0).jacobi_theta(3 * tau)
    g = (th[2] * th3[2] + th[1] * th3[1]).real()
    Lb = ZZ(65536); beta = R5(3) * s / 4; rr = (-beta * (2 * Lb + 1)).exp()
    tail = 4 * (1 + (2 * R5.pi()).sqrt() / (2 * s.sqrt())) * (-beta * Lb^2).exp() / (1 - rr)
    return g + tail   # górne domknięcie (diagnostyka)

Z = block_sum(R5(1) / R5(D))   # = blockNormalizer
def mgf1(l):
    return block_sum(R5(1)/R5(D) - l) / Z

def U(l):
    # gruby bound: gap(b) <= e^{-l*Tmin} * mgf1(l)^1535, sum w_b <= 1
    return R5(4 * 768) * (-(l * R5(Tmin))).exp() * mgf1(l)^1535

# ---- 4. Optymalizacja l >= 0 (siatka + lokalne) ----
best = None
for i in range(1, 400):
    l = R5(i) * R5(10)^(-7)
    u = U(l)
    if best is None or u < best[1]:
        best = (l, u)
l0, u0 = best
for k in range(-50, 51):
    l = l0 + R5(k) * R5(10)^(-9)
    if l <= 0: continue
    u = U(l)
    if u < best[1]:
        best = (l, u)
l_star, u_star = best
print('l*=%s  U(l*)=%s' % (l_star, u_star))
print('cel hi: 4*768*engineTriangleHi <= %s' % target_hi)

# ---- 5. Wymagana precyzja i werdykt kierunku ----
gap_ratio = u_star / target_hi
result = dict(status='L0B_PASS', Qc_max=int(Qc_max), Tmin=int(Tmin),
    l_star=str(l_star), U_coarse=str(u_star), target_hi=str(target_hi),
    coarse_ratio=str(gap_ratio),
    route=('P1_bounded_twist_suffices' if gap_ratio <= 1 else
           'P2prime_tilted_local_needed'))
(here / 'check_cert_hi_result.json').write_text(
    json.dumps(result, indent=1, sort_keys=True) + '\n')
print('CHECK_CERT_HI', json.dumps(result, sort_keys=True))
print('L0B_PASS')
