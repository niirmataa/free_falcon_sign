# FT1536 CENTERING_CLOSURE — niezależna kontrola arytmetyki domknięcia przedziału
# centrowania (delta) i marż mostka T5 dla wszystkich dopuszczonych kluczy.
# Wykonanie (z katalogu CENTERING_CLOSURE): sage sage/check_closure.sage
#
# Zakres (dokładne QQ tam, gdzie to możliwe; RealBallField512 dla transcendentnych —
# rozdział udokumentowany, kernel po stronie formal/CenteringClosure.lean):
#   1. dokładne końce przedziału (honest_lower/upper_rational z przypiętego rekordu)
#      leżą w otwartym przedziale trzech cyfr znaczących i dają roszczenie 1.27e-24;
#   2. surowy przedział (display) leży w [rawLo, rawHi];
#   3. marża T5 (konserwatywny kontrakt H3): g00 < 1/64 i source-to-leaf floor > 991
#      — dokładne QQ, powtórzone niezależnie od ich t5_conservative_margin.sage;
#   4. tau = (1+a)^1536-1 < 2^-40 (dokładne QQ);
#   5. prefaktory mostka (lower/upper_multiplier z budżetami tau/reject/box-tail)
#      spinają rawBad z delta: lb*rawLo > 1265/10^27 i ub*rawHi < 127/10^26 —
#      to jest arytmetyczne domknięcie roszczenia 1.27e-24 DLA WSZYSTKICH kluczy,
#      przy jednej mianowanej przesłance analitycznej (transport mostka).
from pathlib import Path
import json, hashlib
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10==1024

# Ścieżki z CWD: sage preparser wykonuje tymczasową kopję skryptu, więc __file__
# nie wskazuje na źródło. Udokumentowane wykonanie: katalog CENTERING_CLOSURE.
HERE = Path.cwd()
PIN = HERE / 'centering_interval_closure.PINNED.json'
expected_pin = '5ac5c576ab08f7b0c9eebf85ce25139f5766d178c49aa60529746548c73f4e58'
assert hashlib.sha256(PIN.read_bytes()).hexdigest() == expected_pin
rec = json.loads(PIN.read_text())

# ---- 1. dokładne końce przedziału (QQ) ----
lo = QQ(rec['honest_lower_rational']); hi = QQ(rec['honest_upper_rational'])
rawLo = QQ(1266068)/10^30; rawHi = QQ(1267826)/10^30
assert 0 < lo < hi
assert QQ(1265)/10^27 < lo and hi < QQ(1275)/10^27   # trzy cyfry znaczące: 1.27
assert QQ(126)/10^26 < lo and hi < QQ(127)/10^26     # roszczenie 1.27e-24 ma zapas
assert rec['scope'] == 'all successfully emitted keys of the pinned FT1536 KeyGen via T5; finite-box G16 only'
assert rec['no_key_subset_discarded'] is True and rec['complete_new_kernel_source_binding'] is False

# ---- 2. surowy przedział (display) w [rawLo, rawHi] ----
def dec_qq(s):
    # dokładna konwersja notacji naukowej "Me±K" do QQ (ręczny pars zapisu)
    mant, ex = s.strip().split('e')
    sign = 1
    if mant.startswith('-'): sign = -1; mant = mant[1:]
    if mant.startswith('+'): mant = mant[1:]
    ip, fp = (mant.split('.') + [''])[:2]
    digits = (ip + fp) or '0'
    return sign * QQ(ZZ(digits)) / 10^len(fp) * 10^ZZ(ex)

def ball_qq(display):
    # format Arb: "[<midpoint> +/- <radius>]"; midpoint drukowany identyfikująco
    s = display.strip('[]')
    mid_s, rad_s = [t.strip() for t in s.split('+/-')]
    mid, rad = dec_qq(mid_s), dec_qq(rad_s)
    guard = QQ(1)/10^100   # margines błędu dziesiętnego druku (ulp ≫ 1e-124)
    return mid - rad - guard, mid + rad + guard
rl_lo, rl_hi = ball_qq(rec['raw_lower'])
ru_lo, ru_hi = ball_qq(rec['raw_upper'])
assert rawLo < rl_lo and ru_hi < rawHi
assert rl_hi < ru_lo                     # raw_lower < raw_upper

# ---- 3. marża T5 (dokładne QQ, niezależna powtórka) ----
u = QQ(1)/2^48; eps = QQ(1)/2^50; tiny = QQ(1)/2^900
def cmul(m,e,ce):
    return 2*m*ce + 2*e*(1+ce) + 5*u*(m+e)*(1+ce) + 5*tiny
m = QQ(2); err = eps
for j in range(8):
    me = cmul(m,err,eps)
    err = err + me + u*(3*m+err+me) + tiny
    m *= 3
assert m == 2*3^8
b1 = cmul(m,err,eps); b2 = cmul(2*m,b1,eps)
square = cmul(QQ(1),eps,eps)
c1 = cmul(m,err,square); c2 = cmul(2*m,c1,eps)
bc = b2 + c2 + u*(4*m+b2+c2) + tiny
err = err + bc + u*(5*m+err+bc) + tiny
N = ZZ(1536)
sq = 2*N*err + err^2 + u*(N+err)^2 + tiny
norm = 2*sq + u*(2*(N+err)^2*(1+u)) + tiny
g00 = 2*norm + u*(4*(N+err)^2*(1+u)^2) + tiny
assert g00 < QQ(1)/64
word = ZZ(0x4090000053700377)
exponent = (word >> 52) & 0x7ff; frac = word % 2^52
assert exponent == 1033
machine = (2^52 + frac)*QQ(2)^(exponent-1023-52)
minus = 1-u; plus = 1+u
lo0 = minus^20/plus^11; hi0 = plus^20/minus^11
bridge = min((QQ(31)/32)/hi0, (QQ(32)/33)*lo0/plus)
leaf_floor = machine*bridge
assert leaf_floor > 991

# ---- 4. tau (dokładne QQ) ----
y = QQ(1)/2^65
a = 6*y/(1-y)^2
tau = (1+a)^1536 - 1
assert tau < QQ(1)/2^40
assert 2*1536*a <= 1    # warunek pomocniczego lematu (1+a)^n <= 1+2na

# ---- 5. prefaktory mostka z budżetami (dokładne QQ) ----
tauB = QQ(1)/2^40; rejB = QQ(1)/2^24; boxB = QQ(1)/10^1000
lb = (1-boxB)/(1+tauB)
ub = (1+tauB)/((1-tauB)*(1-boxB)*(1-rejB))
assert lb*rawLo > QQ(1265)/10^27
assert ub*rawHi < QQ(127)/10^26

# ---- 5b. transcendentne marginesy (RealBallField512 — zwierciadło ich skryptów) ----
R = RealBallField(512)
d = 2*N; q = ZZ(18433); sigma = ZZ(768); B = ZZ(2093922385)
kappa = 8*R.pi()^2*sigma^2/(3*q^2)
assert kappa*991 > 65*R(2).log()
tr = R(tau); C = (1+tr)/(1-tr)
ratio = QQ(B)/(d*sigma^2)
chernoff = C*(R(ratio).log()*(d/2) + (d-R(B)/sigma^2)/2).exp()
box_tail = 2*d*C*(-R(3)*65536^2/(8*sigma^2)).exp()
reject = chernoff/(1-box_tail)
assert reject < QQ(1)/2^24
assert box_tail < R(boxB)

result = dict(
    schema='FT1536_CENTERING_CLOSURE_ARITHMETIC_V1',
    pin_sha256=expected_pin,
    honest_lower_rational=str(lo), honest_upper_rational=str(hi),
    raw_enclosure=[str(rawLo), str(rawHi)],
    t5_g00=str(g00), t5_g00_lt_1_over_64=True,
    machine_word=hex(int(word)), machine_rational=str(machine), frac=str(frac),
    t5_bridge=str(bridge), t5_leaf_floor=str(leaf_floor), t5_leaf_floor_gt_991=True,
    tau=str(tau), tau_lt_2_pow_minus_40=True,
    bridge_lb=str(lb), bridge_ub=str(ub),
    bridge_lb_rawLo_gt_1265e_27=True, bridge_ub_rawHi_lt_127e_26=True,
    honest_interval_in_3digit_bracket=True,
    transcendental_mirror=dict(kappa991_gt_65ln2=True, reject_lt_2_pow_minus_24=True,
        box_tail_lt_box_budget=True),
    domain='all successfully emitted keys of the pinned FT1536 KeyGen via T5; finite-box G16 only',
    remaining_named_premise='bridge transport (T5 dual theta + Poisson all-center coset comparison + MGF transport + cap16 + flat/reject) and source-domain leaf-gate binding',
)
out = HERE / 'closure_numbers.json'
out.write_text(json.dumps(result, indent=2, sort_keys=True) + '\n')
print('CLOSURE_ARITHMETIC_PASS', json.dumps(result, sort_keys=True))
