# check_conv_window.sage — L0 pre-check okna (b) (droga strukturalna splotu).
# Zasady: k=`floor` (ZZ `//`, NIGDY QQ `//` — lekcja check_tail_chain!),
# asserty wszędzie, te same formy co dowód (binLo/binUp/triangle/B/D literalnie
# jak w Lean: FT1536.Geometry, Run2.RadialBinningSandwich, Run2.CenteringTriangle).
# Uruchomienie: sage check_conv_window.sage   (z katalogu sage/)
from pathlib import Path
import json, hashlib, importlib.util

assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024

# ---- 1. Stale (LITERAŁY JAK W LEAN — asserts pinujące) ----
B  = ZZ(2093922385)          # FT1536.Geometry.B
q  = ZZ(18433)               # Geometry: pole/okres center
half = ZZ(9216)
sig = ZZ(768)                # skala gaussa
D  = 2 * sig^2               # = 1179648 = 1/c0
alpha = 1 / D                # waga exp(-alpha * E)
cut = ZZ(64) * D             # = 75497472 (cutoff szeregu jednoblokowego)
width = ZZ(16)               # szerokosc binu (bin_width)
period = width * 2^25        # CYKL mod 2^25*16 = 536870912
kblocks = ZZ(1535)           # liczba blokow w splotu "rest"
assert D == 1179648 and cut == 75497472 and period == 536870912

def binLo(x): return (x + 15) // 16      # RadialBinningSandwich.binLo (ZZ// = floor)
def binUp(x): return x // 16             # RadialBinningSandwich.binUp
for _x in [-33, -16, -15, -1, 0, 1, 15, 16, 31, B % 16]:
    assert binLo(_x) * 16 - 15 <= _x <= binLo(_x) * 16, _x   # binLo_spec
    assert binUp(_x) * 16 <= _x < binUp(_x) * 16 + 16, _x    # binUp-spec

def block(x, y): return x*x + x*y + y*y   # Geometry.block
def center(x): return (x + half) % q - half

def triangle(a, b):                        # CenteringTriangle.triangle
    return 9217 <= a and a <= 13824 and -9216 <= b and b <= 18432 - 2*a

def loT1(_Q, Qc): return binLo(B - Qc) * 16
def loT2(Q, _Qc): return (binUp(B - Q - 1 - 1535*15) + 1) * 16 - 1
def hiT1(_Q, Qc): return binLo(B - Qc - 1535*15) * 16
def hiT2(Q, _Qc): return (binUp(B - Q - 1) + 1) * 16 - 1

# ---- 2. Tozsamosci sektora (czysta arytmetyka, potem REUSE w dowodzie) ----
# Dla (a,b) w triangle: center(a) = a - 18433, center(b) = b,
# Qc - Q = 18433*delta z delta = 18433 - 2a - b w [1, 9215],
# okno lo wyrodnione DOKLADNIE dla delta == 1 (straż silnika lhi>=llo == delta>=2),
# szerokosc loWin = 18433*delta - 23010 (+/- binowanie), hiWin zawsze niepuste.
samples = []
for a in range(9217, 13825, 137):
    blo = -9216; bhi = 18432 - 2*a
    for b in list(range(blo, bhi + 1, 211)) + [blo, bhi]:
        if triangle(a, b): samples.append((a, b))
for a in [9217, 13824]:
    for b in [-9216, 18432 - 2*a, (18432 - 2*a - 9216) // 2]:
        if triangle(a, b): samples.append((a, b))
assert len(samples) > 100
for (a, b) in samples:
    assert center(a) == a - q and center(b) == b, (a, b)
    Q, Qc = block(a, b), block(center(a), center(b))
    delta = q - 2*a - b
    assert 1 <= delta <= 9215, (a, b, delta)
    assert Qc - Q == q * delta, (a, b, Q, Qc, delta)
    degen = not (loT1(Q, Qc) <= loT2(Q, Qc) + 1)
    assert degen == (delta == 1), (a, b, delta, degen)   # KONSTATACJA L0
    assert hiT1(Q, Qc) <= hiT2(Q, Qc) + 1                 # hiWin nigdy puste
print("GEOMETRIA_SEKTORA_PASS probek=%d" % len(samples))

# ---- 3. Momentu rozkladu jednoblokowego (theta; narzedzie jak arb_radial) ----
R5 = RealBallField(512); C5 = ComplexBallField(512)
alpha = R5(alpha)            # kula 512-bit (QQ nie ma .exp() — lekcja L0)
tau = C5(0, 1) * C5(alpha / R5.pi())
th  = C5(0).jacobi_theta(tau); th3 = C5(0).jacobi_theta(3 * tau)
G   = (th[2] * th3[2] + th[1] * th3[1]).real()      # masa jednoblokowa
Lb  = ZZ(65536); beta = 3 * alpha / 4; rr = (-beta * (2 * Lb + 1)).exp()
tailG = 4 * (1 + (2 * R5.pi()).sqrt() * sig) * (-beta * Lb^2).exp() / (1 - rr)
G   = G.add_error(tailG)
assert G.contains_exact(2 * R5.pi() / (R5(alpha) * R5(3).sqrt()))  # granica ciągła
mu_one = (1 / alpha)                       # E[Q] = 1/alpha = D (granica ciągła)
mu_rest = kblocks * mu_one
sig_rest = R5(kblocks).sqrt() / alpha     # sd = sqrt(k)*D (granica Gamma(1))
print("MOMENTY mu_rest=%s sd_rest=%s G=%s" % (mu_rest, sig_rest, G))
# Pozycje okien w jednostkach sd (diagnostyka P1 vs P2'):
for (a, b) in samples[::37]:
    Q, Qc = block(a, b), block(center(a), center(b))
    if loT1(Q, Qc) <= loT2(Q, Qc) + 1:
        z1 = (loT1(Q, Qc) - mu_rest) / sig_rest
        z2 = (loT2(Q, Qc) - mu_rest) / sig_rest
        assert -12 < z1 and z2 < 12      # okna w okolicach masy (nie 1e6 sd)
print("POZYCJE_OKIEN_PASS")

# ---- 4. Reprodukcja pinow silnika + margines certLo/certHi ----
here = Path('.').resolve()
so = here.parent / 'repro' / 'radial_engine.cpython-314-x86_64-linux-gnu.so'
assert so.exists(), so
spec = importlib.util.spec_from_file_location('radial_engine', so)
engine = importlib.util.module_from_spec(spec); spec.loader.exec_module(engine)
pin = json.loads((here.parent / 'repro' / 'arb_radial_result.json').read_text())
assert pin['mode'] == 'full' and ZZ(pin['bin_width']) == width
R1 = RealBallField(128)
fft = engine.BallRadial(25, 128)
fft.fill(int(cut), int(ceil(sqrt(QQ(4) * cut / 3))), int(width),
         R1((-alpha).exp()), R1(G))
fft.convolve(int(kblocks))
lower, upper = fft.triangle(int(width), int(kblocks), R1((-alpha).exp()), R1(G), R1)
assert str(lower) == pin['single_change_modular_lower'], (str(lower), pin['single_change_modular_lower'])
assert str(upper) == pin['single_change_modular_upper'], (str(upper), pin['single_change_modular_upper'])
print("PINY_SILNIKA_PASS")

engineLo = QQ(pin['lower_endpoint']); engineHi = QQ(pin['upper_endpoint'])
aliasCap = QQ(99099791888604981023) / 10^53     # RawRadialEnclosure.aliasCap
missCap  = QQ(215592228110355906518) / 10^58   # RawRadialEnclosure.missCap
assert R1(engineLo).overlaps(lower) and R1(engineHi).overlaps(upper)
# certLo: engineLo - aliasCap <= 4*768*engineTriangleLo, gdzie
# 4*768*engineTriangleLo jest w kuli `lower`. Wymagany alias-allowance:
need_lo = R1(engineLo) - R1(aliasCap) - R1(lower.upper())
need_hi = R1(upper.lower()) - (R1(engineHi) + R1(missCap))
print("MARGINES certLo: nadmiar-gorny-brzeg-kuli =", need_lo)
print("MARGINES certHi: nadmiar-dolny-brzeg-kuli =", need_hi)
assert aliasCap > 0 and missCap > 0
ratio = (R1(aliasCap) / abs(R1(engineLo))).upper()
print("aliasCap/engineLo <= %s (wymagany alias-allowance ~ zawiniete muszle)" % ratio)

# ---- 5. Werdykt ----
# Muszle zawiniecia: prog T ~ 1.9e9 = 3.5 okresu -> roznica cykl/liniowo
# = masy muszli k != k0 rozkladu 1535-sumy. Do obliczenia/ograniczenia
# metoda P2' (tilt Cramera + bound lokalny) lub (dla gornych) P1.
verdict = dict(status='L0_PASS', geometry_samples=len(samples),
               degenerate_iff_delta_eq_1=True, hi_window_always_open=True,
               mu_rest=str(mu_rest), sd_rest=str(sig_rest),
               alias_ratio_upper=str(ratio),
               route_certHi='P1_candidate_wide_windows',
               route_certLo='P2prime_tilt_plus_local',
               pinned_reproduction=True)
out = here / 'check_conv_window_result.json'
out.write_text(json.dumps(verdict, indent=1, sort_keys=True) + '\n')
print('CHECK_CONV_WINDOW', json.dumps(verdict, sort_keys=True))
print('L0_PASS')
