# check_tail_chain.sage — pre-check lancuchow stalych dla ogonow (FinalTails).
# Wykonanie: sage check_tail_chain.sage (z katalogu CENTERING_CLOSURE).
# Czesc I:  kule RealBallField(512) — niezalezny widok wartosci rzeczywistych.
# Czesc II: dokladna dekompozycja QQ (literaly dla Lean; finalne porownania
#           w kernelu tez sa QQ) — weryfikacja calego lancucha do konca.
#
# NAPRAWA 2026-09-29 (po wykryciu bledu w FinalTails §10):
#   (a) `k = a // Dp` na QQ zwraca ILORAZ DOKLADNY (np. 2048/3), nie czesc
#       calkowita — przez co dE = 0 i weryfikowano E1inv^(k+dE) (wartosc
#       dokladna) zamiast granicy gornej E1inv^k * taylor(dE). Marze PART II
#       byly wiec mierzone na wartosciach dokladnych, nie na lancuchu
#       dowodowym. k/kq/dE/dq liczone teraz na ZZ (wykrycie: check_fml_cmp.sage).
#   (b) taylor4 przy delta = 2/3 przebija e^{-2/3} o 3.4% — przy marginesie
#       emitCap = 0.051% lancuch emitowy wychodzi POZA emitCap o 3.3%.
#       Zgodnie z FinalTails.EQ32768 para 32768 uzywa taylor7 (przebicie
#       ~0.005%); fakt (b) jest ponizej assertowany w obie strony.
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10==1024
R = RealBallField(512)

c0 = QQ(1)/1179648
Dp = ZZ(4718592)
Lint = (2*R.pi()*(QQ(1)/c0)/R(3).sqrt())*(1-QQ(1)/2^20)
assert Lint > R(4279000), Lint

Ky = (R.pi()/c0).sqrt()*(1+8*(-4*R.pi()^2/c0).exp())
assert Ky < R(1926), Ky

def x_tail(L):
    E0 = (-R(3)*L^2/Dp).exp()
    r = (-R(3)*(2*L+1)/Dp).exp()
    return 2*E0/(1-r)

num1 = Ky*x_tail(9217)
p1 = num1/Lint
tau9217 = QQ(269732934410771771958)/10^45
assert p1 < R(tau9217), (p1, R(tau9217))

p2 = 1536*x_tail(32768)*Ky/Lint
emitCap = QQ(11261106164085308753)/10^314
assert p2 < R(emitCap), (p2, R(emitCap))
print('PART_I_BALL_PASS')

# ===== Czesc II: dokladna dekompozycja QQ (literaly dla Lean) =====
pi_lo = QQ(314159265358979323846)/10^20      # Real.pi_gt_d20
pi_hi = QQ(314159265358979323847)/10^20      # Real.pi_lt_d20
sq3_hi = QQ(173205080756887729354)/10^20     # wymaga sq3_hi^2 >= 3
assert sq3_hi^2 >= 3, 'sq3_hi za male'

# exp(-1) <= E1inv := 10^9/2718281828 (z Real.exp_one_gt_d9)
E1inv = QQ(10)^9/2718281828

def taylor4(d):
    # gorna granica e^{-d} = 1 - d + d^2/2 - d^3/6 + d^4/24 + d^4/12
    # (szereg + reszta |x|^4/4! * 5/(5-|x|) <= d^4/12 dla d <= 1)
    return 1 - d + d^2/2 - d^3/6 + d^4/24 + d^4/12

def taylor7(d):
    # gorna granica e^{-d} = S_7 + d^7/4410 (Real.exp_bound, n = 7);
    # dla d = 2/3 przebicie ~0.005% (taylor4 daje 3.4% — za duzo dla emitCap).
    return (1 - d + d^2/2 - d^3/6 + d^4/24 - d^5/120 + d^6/720) + d^7/4410

# --- stala Ky: Ky_r^2 >= pi_hi/c0, eta108 = 4*exp(-pi^2/c0) <= 108*(c0/pi_lo^2)^3
# (z Real.exp_bound-pochodnej: exp(-X) <= 27/X^3, X = pi^2/c0 >= pi_lo^2/c0;
#  forma 4*exp(-pi^2/c0) = poprawka z S0_bounds — UWAGA: 4e^{-a} > 8e^{-4a},
#  wczesniejsze Ky na 8e^{-4pi^2/c0} technicznie nie gorne dla S0 — tu naprawione)
Ky_r = QQ(19251)/10
assert Ky_r^2 >= pi_hi/c0, 'Ky_r za male'
eta_r = QQ(108)*(c0/pi_lo^2)^3
assert eta_r < QQ(1)/10^15
Ky_bound = Ky_r*(1+eta_r)
assert Ky_bound < 1926

# --- ogon x: E0(L) <= E1inv^k * tay(dE), 1/(1-q) <= 1/(1-tay(dq)) ---
# UWAGA (NAPRAWA (a)): k i kq MUSZA byc czesciami calkowitymi — operator //
# na QQ zwraca iloraz dokladny, dlatego liczymy je na ZZ.
def x_tail_qq(L, tay):
    a = ZZ(3)*L^2
    k = a // Dp                      # czesc calkowita wykladnika (ZZ)
    dE = QQ(a - k*Dp)/Dp             # reszta w [0,1)
    E0 = E1inv^k * tay(dE)
    bq = ZZ(3)*(2*L+1)
    kq = bq // Dp
    dq = QQ(bq - kq*Dp)/Dp
    q = E1inv^kq * tay(dq)
    assert q < 1
    return 2*E0/(1-q), E0, q

# L = 9217 (dE = 55299/4718592 ~ 0.0117): taylor4 wystarcza (zgodnie z
# FinalTails — tamten lancuch Lean dowiodl na tayl).
xt1, E01, q1 = x_tail_qq(9217, taylor4)
# L = 32768 (dE = 2/3): w dowodzie tayl7 (FinalTails.EQ32768/qQ32768).
xt2, E02, q2 = x_tail_qq(32768, taylor7)
# Kontrola faktu (b): ten sam lancuch na taylor4 wychodzi poza emitCap.
xt2_t4, _, _ = x_tail_qq(32768, taylor4)

# --- Lint_dol: (2*pi_lo/(c0*sq3_hi))*(1-2^-20) ---
Lint_lo = (2*pi_lo/(c0*sq3_hi))*(1-QQ(1)/2^20)

p1_qq = Ky_bound*xt1/Lint_lo
p2_qq = 1536*xt2*Ky_bound/Lint_lo
p2_qq_t4 = 1536*xt2_t4*Ky_bound/Lint_lo
print('p1_qq =', N(p1_qq, 30), 'tau9217 =', N(tau9217, 30))
print('p2_qq =', N(p2_qq, 30), 'emitCap =', N(emitCap, 30))
print('ratio p1/tau =', N(p1_qq/tau9217, 30))
print('ratio p2/emitCap =', N(p2_qq/emitCap, 30))
print('ratio p2_taylor4/emitCap =', N(p2_qq_t4/emitCap, 30))
assert p2_qq_t4 > emitCap, 'taylor4(2/3) niespodziewanie miesci sie — sprawdz definicje'
assert p1_qq <= tau9217, 'LANCUCH-1 nie miesci sie'
assert p2_qq <= emitCap, 'LANCUCH-2 nie miesci sie'
print('PART_II_QQ_PASS')

# Literaly do wklejenia w Lean (sprawdzone powyzej; k/dE na ZZ):
result = dict(
    pi_lo=str(pi_lo), pi_hi=str(pi_hi), sq3_hi=str(sq3_hi),
    E1inv=str(E1inv), Ky_r=str(Ky_r), eta_form='108*(c0/pi_lo^2)^3',
    k9217=(ZZ(3)*9217^2)//Dp, dE9217=str(QQ((ZZ(3)*9217^2) % Dp)/Dp),
    kq9217=(ZZ(3)*18435)//Dp, dq9217=str(QQ((ZZ(3)*18435) % Dp)/Dp),
    k32768=(ZZ(3)*32768^2)//Dp, dE32768=str(QQ((ZZ(3)*32768^2) % Dp)/Dp),
    kq32768=(ZZ(3)*65537)//Dp, dq32768=str(QQ((ZZ(3)*65537) % Dp)/Dp),
    margin1=str(R(p1_qq/tau9217).upper().exact_rational()),
    margin2=str(R(p2_qq/emitCap).upper().exact_rational()),
)
print(result)
print('TAIL_CHAIN_PASS')
