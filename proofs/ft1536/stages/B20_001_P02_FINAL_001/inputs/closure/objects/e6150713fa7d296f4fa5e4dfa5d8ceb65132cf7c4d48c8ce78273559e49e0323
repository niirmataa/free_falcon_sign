# Raw source L / stable D — kontrolowany most metryk

Ten dowód jest uniwersalnym analitycznym source argumentem z exact QQ
certyfikatem i kernelowymi algebra/order lemmas. Nie zakłada raw L=ideal LDL,
exact determinantq zaokrąglonej FFT basis ani pożądanej energii z1.

## 1. Obiekty, normalizacja i orientacja

Dla degree n=1536 lub2^k i real positive spectrum r na n/2 physical roots
definiujemy real coefficient Gram
`Q_r(v)=(1/(n/2))*sum_j r_j*|eval_j(v)|²`, z conjugate extension.
Dla n2 jest to r*(v0²+v0v1+v1²)=r*A2, nie zwykła suma dwóch squares.
Source packed roots/twiddles i integralne permutacje są tymi z ROOT/NODE3/
TOWER. Exact split p=p0(X^d)+X p1(X^d)+... to coefficient permutation.
Phase matrices U spełniają U U*=d I; normalizacja1/d daje exact Hermitian
child matrix z eigenvalues parent r. Same mapy są ponownie sprawdzane przez
generic pivot/reciprocal identities i independent reconstruction oracle.

Raw complex diagonal v może mieć imaginary defects. Q_Re(v) jest PROOF
OBJECTEM, nie zmianą source data. Actual raw L i real pivots definiują
lokalnie Hrec=L_C diag(d_C) L_C*, gdzie L_C jest lower triangular, diagonal1.
Sampler zwraca row z spełniającą w exact reconstruction u=z L_C. Zatem
`z Hrec z*=sum_i d_i |u_i|²`. Conjugation/orientation zgadza się z source
mul(z1,L), nie muladj. Całe drzewo definiuje dokładny real linear transform
T_C od root coefficient residual do terminal pairs, z idealnymi splits/merges
i ACTUAL L values. `S_raw=T_C^T diag(raw_real_leaf*A2) T_C`.
`S_stable` używa tego SAMEGO T_C, ale source stable D w tych samych positions.
Te definicje nie identyfikują żadnego z nich z actual Gram bez poniższego proofu.

## 2. Nowy local reconstruction defect z rzeczywistego kodu

Binary actual H=[[h,conj(c)],[c,h]], h>0, |c|<h. TOWER daje source L
error<=2U do c/h, real D error<=64U*h do h-|c|²/h. W Hrec offdiagonal error
<=2U*h, dolna diagonal error<=64U*h+(4U+4U²)h. Row norm i Hermitian operator
norm są <**128U*h**. Hrec jest positive, ponieważ real raw pivots są dodatnie.

Cubic actual H ma real diagonal h i lower b,c,b; |b|,|c|<=h. Source L10/L20
error<=2U, |L21_C|<4, 0<d1<=(1+64U)h. Zamiast luźnego błędu L21 do innego
idealnego drzewa rozwijamy RECONSTRUCTED Hrec bezpośrednio:
- H10/H20 errors<=2U*h;
- H11 error<128U*h;
- H21=h L20 conj(L10)+d1 L21. Source numerator przed ostatnim division jest
  w64U*h od b-c conj(b)/h. Po pomnożeniu równania ostatniego div przez d1
  nie zostaje condition-number mnożący L21 error: cross error<128U*h;
- H22=h|L20|²+d1|L21|²+d2. Literalny d2 jest q2_C−mul(norm_C(L21),d1).
  Norm roundoff dotyczy TEGO SAMEGO L21_C. W reconstructed diagonal te same
  składniki d1|L21_C|² anulują się algebraicznie; pozostają source operation
  errors i h|L20|²−Re(L20 conj(c)). Ostatni składnik jest
  Re(L20 conj(hL20−c)), więc<=4U*h. Reszta ma bound<512U*h.

Nie anulujemy zaokrąglonych source add/sub; ich błędy są jawnie zachowane.
metric_bounds.py rozlicza dokładne rational coefficient budgets, z h>=1/16
i128eta allowance po normalizacji. Cały Hermitian operator defect jest
<**2048U*h**. To nowe, ciaśniejsze lemma niż upstream65536U*h pivot error
do dokładnego H; współczynniki dotyczą różnych porównań.

## 3. Imaginary/split defect i lokalne względne factors

Dla parent spectrum v z Re in[m,M],|Im|<=I oraz source split error<=delta,
exact split Re(v) ma min eigen>=m. Binary H różni się entrywise od tej
macierzy przez complex input imaginary i roundoff: opnorm<=2(I+delta).
Cubic ma opnorm<=3(I+delta). Nie pomijamy I nawet gdy reference jest realna.

Definiujemy rho=d(I+delta)/m i lambda=m-d(I+delta)>0, d2 lub3.
Source factor residual wyżej daje eps_L=128U*hmax/lambda (binary) albo
2048U*hmax/lambda (cubic). Stąd:

```
(1-rho)(1-eps_L) * SplitGram(Re(v)) <= Hrec
Hrec <= (1+rho)(1+eps_L) * SplitGram(Re(v)).
```

To Loewner inequalities dla WSZYSTKICH vectors, z row-norm bound i
lambda-min bound; nie test wybranych quadratic vectors. Wszystkie m/I/delta/
hmax pochodzą z actual local records TOWER i ROOT/NODE3 refinements.
Sprawdzono6 S8 +1524 lower records i oba cubic roots, każdy denominator oraz
rho/eps<1. Nie zmieniono historycznych records lub ich źródeł.

## 4. Indukcja metryki i pivotów — dwie różne aplikacje

Po pierwsze congruence preserves Loewner order, także dla nieunitarnego L.
Jeżeli child reconstructed metric leży między l G_child i u G_child,
to lokalny parent po congruence ma te same l/u względem Hrec. Mnożąc przez
local factors dostajemy, po dziewięciu stages(cubic+8 binary),
`l_b Q_parent <= S_raw <= u_b Q_parent`.
Parallel blocks biorą minimum l i maximum u; code zapisuje wszystkie stages.
To nie mnożenie norm L i nie gubi korelacji triangular factorization.

Po drugie positive-matrix Schur complement jest monotonic i homogeneous:
każdy pivot to minimum quadratic form przy ustalonej ostatniej współrzędnej1;
ocena w minimizerze drugiej macierzy daje odpowiednią nierówność. Zatem te
same local factors transportują RAW real child pivots do exact pivots tego
samego reference spectrum, indukcyjnie do wszystkich terminal leaves.
Kernel minimum_comparison formalizuje używany algebraic/order krok; actual
real-matrix instancja jest tutaj jawna, nie nową key premise.

## 5. Root real spectrum i stable weights

A0 to source g00. Rounded FFT value Gram ma a,c,j i v=fhat Ghat−ghat Fhat.
ROOT daje |v−q|<=dc, |A0−a|<=8U*a i
`|Re(Droot_C)-|v|²/a|<=256U*j`. Dokładny root certificate yields:

```
0.7502305014... < Re(Droot_C)/(q²/A0) < 1.2497694994... .
```

Rational endpoints są w metric_bounds.json. Nie przyjęto rounded det=q.
Exact positive split pivots dla A0 to source-order mean/harmonic/cubic
e1/3,e2/e1,3abc/e2. Są monotone w każdym positive operand i homogeneous
degree1 (exact symbolic derivatives/Euler check). NORMALIZED source positive
step factors1±g,g=2^-40 składają się do(1±g)^9 względem TYCH exact pivots.
Reverse reciprocal identity daje exact pivots q²/A0 jako reversed q²/list;
source last div dodaje factor1±2U. Map jest fizyczną RAW leaf order, nie
dowolną permutacją. Exact identities sprawdzono ponownie, bez legacy>991/RN.

Z monotonic pivot induction oraz powyższego root ratio wynika
`raw_leaf_i <= r_b * stable_D_i` dla każdego i (oraz dodatni lower ratio).
Ponieważ S_raw/S_stable mają ten sam T_C, dostajemy
`S_raw <= r_b S_stable`. Łącząc z lower metric factor:

```
Q_Re(Droot_C) <= (r_1/l_1) S_stable < 6 S_stable.
```

Wartość6 jest CEIL obliczonego exact rational factor, nie dobrana do żądanego
center margin. Wszystkie products/leaf ratios są jawne; branch0 analogicznie
daje integer factor2. Żadna raw/stable identity nie została założona.

## 6. Weryfikacja i granica

Niezależne exact Hermitian checks sprawdziły lokalne128U/2048U*h defects
dla19968 frequency instances, wszystkich levels1..8/cubic, na publicznych
source-built trees. RBF exact-L reconstruction sprawdza cały right energy
vs terminal stable weights. Nonzero defect witnesses odrzucają identity
bez błędu. Są kontrolą bindingu; uniform inequalities wynikają z§2–5,
nie maksimum fixture. GCC/C heap/full real-matrix theorem nie są w całości
kernelized. Mixed scope jest jawny w certyfikacie i audytach.
