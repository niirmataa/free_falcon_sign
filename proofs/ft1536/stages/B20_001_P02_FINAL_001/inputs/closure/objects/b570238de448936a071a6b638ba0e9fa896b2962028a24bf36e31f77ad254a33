# Adaptive directed second moment i TV — source instance

P=P_VALUE, Q∈{Q_stop,Q_S} na wspólnej Ω z REFERENCE_PROCESSES. Ta sama required
entry PAST; historyh wyznacza te same actual source mu_h,sigma_h. Source closure
jest wyprowadzone w PREFIX_CLOSURE. Na live nodes stosujemy odebrane
epsilon=2^-36,kappa=2^-60,A≥1/8; GAUSS reference to G naZ z input words.

## 1. Local conditioning identity

K jest supported onS, G>0 everywhere, t=G(S^c)<1. Z definicji chi2:

```
1+chi2(K||G_S)=Σ_S K(y)^2/[G(y)/(1-t)]
             =(1-t)[1+chi2(K||G)].
```

Stąd chi2(K||G_S)=(1-t)chi2(K||G)−t≤kappa. Lewa strona nonnegative z
Cauchy–Schwarz/probability normalization, więc nie traktujemy niezależnie
arbitrary t i d, które mogłyby dać ujemną divergence. Actual weights spełniają
identity. Analogicznie overlap min(K,G_S)≥min(K,G) naS daje
TV(K,G_S)≤TV(K,G)≤epsilon. Nie potrzeba dodaćtau doepsilon dla tej referencji.

## 2. Chain theorem z adaptive same-prefix likelihood

Po i krokach: live prefix h∈Hi lub absorbing Exit. P_i,Q_i są prawami tego
cutu. P_i≪Q_i; na live h definiujemy L_i(h)=P_i(h)/Q_i(h), a na Exit0.
L0=1. Na childh·y,zawsze z TYM SAMYM h:

```
L_i(hy)=L_(i-1)(h)*K_h(y)/q_h(y),
q_h=G_h dla Q_stop; q_h=G_h/(1-t_h) naS dla Q_S.
```

Absorbing EXIT ma L0 dalej. Conditional on liveh podQ:
E[L_i²|h]=L_(i-1)(h)² Σ_S K_h(y)²/q_h(y)
≤(1+kappa)L_(i-1)(h)². Po EXIT obie strony0. Tower/indukcja daje
E_Q[L_M²]≤(1+kappa)^M. Ponieważ P jest znormalizowane, E_Q[L_M]=1;
**chi2(P||Q)=E_Q[L_M²]−1≤(1+kappa)^M−1**.

Sumy są finite na live support, countable na EXIT; nonnegative sums wolno
przestawiać. Nie ma założenia independent marginals lub stałych parameters.
Exit contribution jest JUŻ w chi2: w równoważnej formie E_Q[(L−1)²] daje
Q(EXIT), mimo że second-moment numerator ma0 na tych atoms. Dodanie osobnego
tau ponownie do tej samej forward divergence byłoby podwójnym kosztem.

## 3. Actual numeric instance

M=3072 z source recursion; kappa=1/2^60, M*kappa=3/2^50<1.
Binomial C(M,j)≤M^j i geometric series dają
(1+kappa)^M≤1/[1−M*kappa]. Dlatego

```
Delta_exact=(1+2^-60)^3072−1,
Delta_exact≤3/(2^50−3)<2^-48.
TV(P,Q)≤sqrt(Delta_exact)/2 <2^-25.
```

Cauchy–Schwarz na E_Q|L−1|/2 uzasadniaTV. JOINT_COMPARISON.json zachowuje
exact symbolic expression i conservative rational/power-of-two bound;
nie zaokrąglono massive integer expansion przez binary64.

Oddzielny adaptive coupling bound: do pierwszej różnicy wspólnyh ma local
TV≤epsilon; sequential maximal coupling/union dajeTV≤M*epsilon=3/2^26.
To poprawny, lecz luźniejszy bound. Dotyczy teżQ_S przez overlap inequality;
dlaQ_stop wyjście supportu jest już mismatchem. Główny export używa2^-25,
nie sumy tego boundu i exit loss. TV(Q_S,Q_stop)<2^-50 pozostaje osobnym exportem.

## 4. Reverse directions, wyprowadzone osobno

Q_stop(EXIT)>0,P(EXIT)=0, więc chi2(Q_stop||P)=∞. Ten wniosek nie przenosi
się naQ_S: finite common supportHM daje obustronną absolute continuity.
Z 33-byte alphabet i positive source witness w PREFIX_CLOSURE:
K_h(y)≥2^-264 dla każdego y∈S. Zatem
Σ_S G_S(y)²/K_h(y)≤2^264 Σ_S G_S(y)²≤2^264.
Ta sama chain induction w ODWRÓCONYM kierunku daje
**chi2(Q_S||P)≤2^(264*3072)−1=2^811008−1**.

To jawnie wyprowadzona uniform majoranta, bardzo luźna i nieużyteczna do
małego cryptographic lossu. Nie jest postulatem reverse-kappa ani efektem
przeniesienia∞ między referencjami. Zachowujemy ją jako informację o support
i ograniczeniu metody. Nie twierdzimy, że actual reverse divergence jest duża.

## 5. Pushforward i event transfer

Dla deterministycznej measurablePhi zachowującej Exit: TV(PhiP,PhiQ)≤TV(P,Q).
Likelihood output equalsE_Q[L|Phi], więc Jensen daje forward chi2 contraction.
Na dyskretnych fibers to Cauchy–Schwarz `(Σp)^2/(Σq)≤Σp²/q`, także przy
countably many EXIT atoms. Wszystkie denominatory zero mająPmass0.

Dla eventB, q=Q(B), p=P(B), E_Q(L−1)=0:
`p−q=E_Q[(L−1)(1_B−q)]`; Cauchy daje
`|p−q|≤sqrt(Delta_exact*q*(1−q))` oraz zwykłe≤2^-25.
Warunki q=0 lub1 nie wymagają division i są objęte tym samym wzorem.
POSTPROCESSING_PUSHFORWARD/H6P_INTERFACE określają typedB i pozostały obowiązek
reference probability. Common resource lift zachowuje metrics dokładnie z
REFERENCE_PROCESSES; innych byte/resource laws nie utożsamiamy z value law.
