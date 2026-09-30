# check_fml_cmp.sage — rozstrzygnięcie: formuła Lean (transkrypcja 1:1) vs p2_qq Sage vs emitCap.
assert parent(1) is ZZ and parent(1/3) is QQ

c0 = QQ(1)/1179648
Dp = ZZ(4718592)
pi_lo = QQ(314159265358979323846)/10^20
sq3_hi = QQ(173205080756887729354)/10^20
E1inv = QQ(10)^9/2718281828
emitCap = QQ(11261106164085308753)/10^314
tau9217 = QQ(269732934410771771958)/10^45

def tayl(d):
    return 1 - d + d^2/2 - d^3/6 + d^4/24 + d^4/12

# --- formuła Lean (dokładna transkrypcja definicji z FinalTails/probów) ---
KyR = QQ(19251)/10
etaQ = 108*((QQ(1)/1179648)/(pi_lo^2))^3
Ky_lean = KyR*(1+etaQ)
Lint_lo_lean = (2*pi_lo/(c0*sq3_hi))*(1-QQ(1)/2^20)
EQ32768_lean = E1inv^682 * tayl(QQ(2)/3)
qQ32768_lean = E1inv^0 * tayl(QQ(196611)/4718592)
lhs_lean = 1536 * (Ky_lean * ((2*EQ32768_lean)/(1-qQ32768_lean)) / Lint_lo_lean)

# --- formuła Sage z check_tail_chain (PART II) ---
def x_tail_qq(L):
    a = QQ(3)*L^2
    k = a // Dp
    dE = QQ(a - k*Dp)/Dp
    E0 = E1inv^k * tayl(dE)
    bq = QQ(3)*(2*L+1)
    kq = bq // Dp
    dq = QQ(bq - kq*Dp)/Dp
    q = E1inv^kq * tayl(dq)
    return 2*E0/(1-q), E0, q

xt2, E02, q2 = x_tail_qq(32768)
Ky_bound = KyR*(1+108*(c0/pi_lo^2)^3)
Lint_lo = (2*pi_lo/(c0*sq3_hi))*(1-QQ(1)/2^20)
p2_sage = 1536*xt2*Ky_bound/Lint_lo

print('lhs_lean == p2_sage :', lhs_lean == p2_sage)
print('lhs_lean - p2_sage  :', lhs_lean - p2_sage)
print('lhs_lean <= emitCap :', lhs_lean <= emitCap, ' ratio:', RR(lhs_lean/emitCap))
print('p2_sage  <= emitCap :', p2_sage <= emitCap, ' ratio:', RR(p2_sage/emitCap))
print('E0 parts equal      :', EQ32768_lean == E02, ' q parts equal:', qQ32768_lean == q2)
print('Ky equal            :', Ky_lean == Ky_bound, ' Lint_lo equal:', Lint_lo_lean == Lint_lo)
print('CMP_DONE')
