# Actual innovations → oba source pre-rint vectors

SOURCE_NOISE_MAP.json ma pełny ordered3072-call/leaf map,1532 lower-node
descriptors i768 physical root labels. Caller order: root1→0,cubic2→1→0,
binary1→0,terminal paired mu1→stored UPDATED mu0. Layout/tree/basis są immutable
z JOINT/POST. sigma_i pochodzi z konkretnego leaf word; paired jest literal
mul_C(IW1I,sigma). Te quantities są fixed przez e, nie przez przyszłe Y.

## Terminal i d=0

Definiujemy xi_i=val(ACTUAL mu_i(h_i))−Y_i, z real Gaussian mean parameter,
nie center Ghat i nie hypothetical independent output coordinate.
Na leaf: r1_C=xi1+eps1;rx_C=r1_C/2+epsh;returned r0_C=
xi0+eps0−rx_C+epssub. Źródłowy update mu0=add_C(old_t0,rx_C) jest już w
definicji xi0; jego błąd nie znika, lecz wpływa na ADAPTACYJNY mean parameter
następnego reference draw. Nie używamy mean-zero, aby go anulować.

Niech T(x0,x1)=(x0−x1/2,x1). Wtedy actual terminal pair jest dokładnie
T(xi0+eta0,xi1+eta1),eta0=eps0−epsh+epssub,eta1=eps1.
Wszystkie subtraction/Half errors są jawnie bounded w ERROR_LEDGER.
Ideal returned-part reconstruction bazuje na Txi i ma **d_e,r=0**.

## Operator exact-real z actual L/basis

Po każdym child return exact reference MERGE jest coefficient interleaving
p0(X²)+X p1(X²); terminal n2 używa w1=exp(iπ/3). Full cubic merge to
p0(X³)+X p1(X³)+X² p2(X³). Physical packed roots mają numeratory
1+6rev8(j)+1536h,slot3j+h,order4608; lower degree2^k ma
1+6rev_(k−1)(j),order3*2^k. To te same order/twiddle reference co upstream.
Rounded source twiddle errors pozostają w source reconstruction defect.

Binary returned map: r1=Merge(child1),r0=Merge(child0)−r1*L_actual.
Cubic: r2=Merge(child2),r1=Merge(child1)−r2*L21,
r0=Merge(child0)−r1*L10−r2*L20. Root: y=TopMerge(right),u=TopMerge(left),
x=u−y*Lroot. Basis output: F0=x*b00+y*b10,F1=x*b01+y*b11,
[b00,b01,b10,b11]=[g,-f,G,-F] to ACTUAL rounded FFT words.
Mathematical inverse evaluation I na physical roots daje real3072 coefficients.

Wszystkie powyższe operations są liniowe w terminal innovations, z fixed
actual L/basis i ideal phase constants. Dla każdego r,i definiujemy jawnie
a_e,r,i jako output coordinate r operatora zastosowanego do innovation unit i.
To complete factorized definition wszystkich9,437,184 entries, nie assumed
matrix. linear_noise.py implementuje forward oraz niezależny transposed operator;
SAGE direct-root evaluation sprawdza fizyczny order. Nie trzeba przechowywać
dense matrix, aby theorem obejmował KAŻDY row.

Otrzymujemy, na każdej legalnej live historii:
`val(t_e,r)=Σ_i a_e,r,i*xi_i+delta_e,r(history)`,|delta|≤E.
TARGETS wiąże canonical input i frame; jego wcześniejsze target errors są
zawarte w actual mu histories, nie dodatkowym deterministic signature drift.
Nie jest to odzyskanie integer lattice/reference signature. Map dotyczy
returned RESIDUALS, nie samych sampled integers; bez hm-minus lub binary negacji.

## Źródłowe errors i kontrola

ERROR_LEDGER rozdziela terminal→innovation error,obustronny actual-source-L
reconstruction defect,root CM/sub,rounded basis image,post CM/add i source iFFT.
Nie zakładamy rounded linearity ani dokładnej cancellation source add/sub.
Recomputed products mają equal-word/frame z upstream; każda sub ma własny error.

Original C sampling+suffix/rint slices normal/ASan/UBSan porównano w pełnych
snapshots obu vectors. Dwa LOCAL synthetic trees: constant dyadic basis z
nonzero rounded root L i osobny nonzero-complex tree wszystkich poziomów.
Nie są emitted keys. Oracle kontroluje3072 coefficients każdego przypadku,
36 selected complete adjoint rows,impulse responses i closed-form variance
constant-basis example. Są kontrolą bindingu, nie uniform V/E proofem.
