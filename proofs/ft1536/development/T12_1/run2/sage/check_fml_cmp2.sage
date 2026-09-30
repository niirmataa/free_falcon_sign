# check_fml_cmp2.sage — weryfikacja NAPRAWIONEGO łańcucha (tayl7 dla delta=2/3).
# Uzasadnienie: tayl4(2/3)=43/81 > e^{-2/3} o 3.4% przebija budżet emitCap (0.051%);
# tayl7 = S_7 + delta^7/4410 przebija e^{-2/3} o ~0.005% (Real.exp_bound, n=7).
assert parent(1) is ZZ and parent(1/3) is QQ

c0 = QQ(1)/1179648
Dp = ZZ(4718592)
pi_lo = QQ(314159265358979323846)/10^20
sq3_hi = QQ(173205080756887729354)/10^20
E1inv = QQ(10)^9/2718281828
emitCap = QQ(11261106164085308753)/10^314
tau9217 = QQ(269732934410771771958)/10^45

def tayl4(d):
    return 1 - d + d^2/2 - d^3/6 + d^4/24 + d^4/12

def tayl7(d):
    # S_7 (rzad 0..6) + reszta |x|^7*(7+1)/(7!*7) = delta^7/4410
    return (1 - d + d^2/2 - d^3/6 + d^4/24 - d^5/120 + d^6/720) + d^7/4410

Ky_r = QQ(19251)/10
eta_r = QQ(108)*(c0/pi_lo^2)^3
Ky_bound = Ky_r*(1+eta_r)
Lint_lo = (2*pi_lo/(c0*sq3_hi))*(1-QQ(1)/2^20)

# --- emit (L=32768): E0 = E1inv^682 * tayl7(2/3), q = E1inv^0 * tayl7(196611/4718592)
E02 = E1inv^682 * tayl7(QQ(2)/3)
q2 = E1inv^0 * tayl7(QQ(196611)/4718592)
xt2 = 2*E02/(1-q2)
p2_fix = 1536*xt2*Ky_bound/Lint_lo
print('p2_fix/emitCap =', RR(p2_fix/emitCap))
assert p2_fix <= emitCap, 'emit-lancuch NAPRAWIONY nie miesci sie'
print('EMIT_FIXED_PASS')

# --- coord (L=9217): bez zmian (tayl4), potwierdzenie
E01 = E1inv^54 * tayl4(QQ(55299)/4718592)
q1 = E1inv^0 * tayl4(QQ(55305)/4718592)
xt1 = 2*E01/(1-q1)
p1_fix = xt1*Ky_bound/Lint_lo
print('p1_fix/tau9217 =', RR(p1_fix/tau9217))
assert p1_fix <= tau9217, 'coord-lancuch nie miesci sie'
print('COORD_PASS')

# --- kontrola przebic granic: tayl4(2/3)/e^{-2/3} vs tayl7(2/3)/e^{-2/3}
R = RealBallField(256)
print('tayl4(2/3) / e^{-2/3} =', RR(tayl4(QQ(2)/3)/((-R(2)/3).exp())))
print('tayl7(2/3) / e^{-2/3} =', RR(tayl7(QQ(2)/3)/((-R(2)/3).exp())))
print('tayl7(2/3) >= e^{-2/3} :', tayl7(QQ(2)/3) >= R((-R(2)/3).exp()))
print('CMP2_DONE')
