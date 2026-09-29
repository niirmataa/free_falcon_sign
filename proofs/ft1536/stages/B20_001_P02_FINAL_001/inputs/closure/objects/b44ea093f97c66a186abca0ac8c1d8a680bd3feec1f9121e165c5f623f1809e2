# Reach_call_C — source execution, bez założenia C_mu

## 1. Definicja required-domain

Źródła są dokładnie bootstrap/source o manifeście2553358f… z BASEf5266765…,
GCC14.2/C99/LP64, Makefile FPEMU/MODE1, profil M0. Poniższa definicja jest
operacyjną definicją matematyczną po instrukcjach C. Nie jest deklaracją,
że w tym pakiecie zweryfikowano kompletny interpreter C albo kompilator.
Kernelowe modele i sprawdzalna projekcja ffSampling są opisane osobno w§4.

Stan maszyny zawiera: pamięć typowaną i bity fpr, pc/stack, indeksy pętli,
keygen/sign contexts, rng/sc, PRNG buffer/ptr, tree i tmp, aktualny fault,
parametry M0 environment E oraz skończony publiczny oracle history.
Semantyka C zachowuje unsigned modulo2^w, GCC signed shifts/narrowing,
legalne obiekty/aliasing/lifecycle. Nieokreślona operacja kończy ścieżkę STUCK;
nie jest usuwana lub zamieniana na source abort.

```
Emitted_C(E,sk,pk) := exists successful finite execution of ONE source
  falcon_keygen_new(10,1); max-sized buffers; capped KeyGen_make(STATIC),
  with a seed in support of the M0 uniform32-byte service,
  returning1 AFTER both byte encoders and emitting exactly sk,pk.

Reach_call_C(E,sk,pk,tau,a,j,S,mu,sigma) :=
  Emitted_C(E,sk,pk) AND there exists a finite, defined C execution prefix
  of the M0 fresh Sign context with that SAME sk, consistent with tau,
  a canonical target c, the actual private SHAKE/PRNG expansion, attempt a,
  and j prior sampler invocations, ending at sampler_large:2864 in state S;
  S.mu_bits=mu, S.sigma_bits=sigma, fault==NONE;
  source guards at2850/2856 have passed.
```

a∈1..16. tau może zawierać wcześniejsze abort queries. Legalny canonical c
jest pełną domeną targetu z M0; do dowodu można użyć nadzbioru wszystkich c.
Każdy wewnętrzny random prefix musi pochodzić z rzeczywistego wykonania;
uniwersalny support CDF dla dowolnych128-bit słów jest BEZPIECZNYM nadzbiorem,
nie twierdzeniem, że każde takie słowo wystąpi z każdego finite seed.

Definicja NIE zawiera bounded mu, NotNegZero, normality, Q<B, Babai quotient,
multiplier bound ani założenia o bezpieczeństwie przyszłych wywołań. Wymaga
wyłącznie rzeczywistych earlier defined steps. Dzięki temu cel dotyczy także
próby, która później odrzuci normę albo dss/gap/exponent. Wykluczenie takich
prób przez przyszły wynik byłoby zmianą dziedziny.

## 2. Konkretny stan początkowy i emitted-key binding

sample_true_ternary_secret MODE1 daje f,g∈{−1,0,1}. solve_NTRU musi przejść
oba poly_big_to_small, keygen:7342–7346. Jego checked output ma |F|,|G|<=2047;
OrderedResidual.checked_key_coefficients formalizuje dokładny test/return
tej lokalnej pętli. Source make:8097 wymaga solve success, potem mandatory
leaf gate8110, następnie serializacji. To źródłowe uzasadnienie capu,
nie obserwacja klucza. Całego emitted predicate nie zastąpiono samym capem.

Sign set_private_key czyta te same byte strings, dekoduje f,g,F,G, waliduje
ternary i NTRU, następnie load_skey. Porażka loadera oznacza brak Reach tej
query, ale nie nowe warunkowanie K_seed ani wycięcie inconvenient emitted keys.
Bezpośrednie wywoływanie loadera z synthetic/sheared key nie dowodzi Emitted_C.

load_skey1159–1268:
`B00=FFT(g), B01=-FFT(f), B10=FFT(G), B11=-FFT(F)` w source FPEMU,
następnie g00/g10/g11 przez rzeczywiste mulselfadj/muladj/add. Source
ffLDL_fft3 oblicza odejmowaniami wewnętrzne L i pivots. Stable builder i
normalize NADPISUJĄ tylko1536 terminalnych widths.16896 z18432 tree words
pozostają wewnętrznymi wynikami pierwotnego, subtractive circuit.
Normalizowane liście mają gate H4, lecz gate nie jest testem tych16896 słów.

do_sign1849–1897 zaczyna od literalnych c_i→fpr, FFT3(c), then
`T1 = mulconst(mul(FFT(c),B01), neg(inverse_of(q)))`,
`T0 = mulconst(mul(FFT(c),B11), inverse_of(q))`.
Nie podstawia się idealnych −cF/q i cf/q bez ledgeru błędów tych instrukcji.

## 3. Rzeczywisty ordered transition system

Oznacz F_add/sub/mul/half oraz Split/Merge konkretne funkcje z pinu,
nie arytmetykę realną. Stan programu przechodzi następująco:

### Inner(logn=0)

1. Read r1=t1, r0=t0, sigma=tree[0]. Oblicz paired=F_mul(IW1I,sigma).
2. Wywołaj sampler(r1,paired), z właściwym fault. Dopiero po return y1:
   r1=F_sub(r1,F_of(y1)); rx=F_half(r1).
3. c0=F_add(r0,rx); wywołaj sampler(c0,sigma).
4. Po y0: w=F_sub(c0,F_of(y0)); z0=F_sub(w,rx); z1=r1.

### Inner(logn>0)

SplitDeep(t1), RIGHT subtree(tree1), MergeDeep→z1.
tmp=F_add(F_mul(z1,L),t0). SplitDeep(tmp), LEFT subtree(tree0), MergeDeep→z0.
Na końcu RECOMPUTE F_mul(z1,L), then z0=F_sub(z0,correction).

### Depth1(3x3)

Wywołania w kolejności2,1,0. Po z2 center1=t1+z2*L21. Merge1 oraz odjęcie
z2*L21 dają residuum z1. Center0=t0+z1*L10+z2*L20, w dokładnej kolejności
source additions. Po Merge0 odejmowane są osobno obie ponownie obliczone korekty.

### Top

SplitTop(t1), right Depth1, MergeTop→z1, tmp=t0+z1*L; left Depth1, merge→z0,
then recompute product and subtract. To są RESIDUA, nie sampled coordinates.
Exact Schur cancellation t0+t1*L nie usuwa termu(r1−t1)*L w rzeczywistym center.

Layout jest pełny N1536/logn10:3072 sampler invocations, po2 na1536 leaves.
Pierwsza para odczytuje tree[18431], najpierw coordinate1 z paired sigma,
potem coordinate0. Listę visits wyprowadza OrderedResidual.innerVisits/
depthVisits/topVisits; liczbę i pierwszą parę sprawdza kernel.

## 4. Co jest wykonywalne/sprawdzone, a co pozostaje otwarte

scripts/order_model.py jest wykonywalną projekcją powyższych source loops,
z tablicami twiddle z przypiętego fpr-emulated.h i każdą zmianą bufora w
kolejności kodu. Dla lokalnych kontroli używa niezależnych dokładnych dyadics
oraz RN-even na ograniczonej normalnej domenie; source half i signed-zero
są obsługiwane jawnie. Nie jest uniwersalnym backendem FPEMU na wszystkich bitach.

checks/order.c wywołuje ORYGINALNE ffSampling*/normalize z synthetic targets,
artificial tree i jawnym scripted callback. Baseline/minusL/fault/noop dają
3072 calls każda, a terminal_negzero2; wszystkie request bits, sigmas,
returns i final buffers zgadzają się z modelem normal i sanitizer. To pełne
kontrole source dataflow, ale nie dowód emitted membership tych arrays ani
rzeczywistego PRNG prefixu. `fault` callback symuluje sticky behavior; oddzielny
test oryginalnego sampler_large z fault!=0 potwierdza immediate return0.

Formalne GuardPrefix.admitCall odtwarza źródłowe guardy bez zakresu. Globalny
Reach_call_C z§1 nie jest utożsamiony z admitCall lub z dowolną synthetic
projekcją. Nie ma tu ukończonego kernelowego refinement całego C/KeyGen/loadera.
To jawna część pozostałego globalnego obowiązku, nie ukryte założenie full proof.

## 5. Indukcja bez koła i dokładny frontier

Nowe OrderedResidual lemmas operują na exact dyadics skalowanych wspólnym D.
scalar_residual: z poprawnego PREVIOUS floor i z∈[−365,366] wynika error bound
366D+E. next_terminal_center używa tylko już znanego right residual i błędów
half/add do ograniczenia NASTĘPNEGO c0; nie przyjmuje jego przyszłego return.
terminal_right_then_left daje końcowe549 przy zerowych błędach, z jawnymi
E_sub/E_half/E_add dla machine path. Nie ogłasza się stąd boundu root residual.

Globalna indukcja musi najpierw ustalić root inputs i source internal L/pivot
certificates, potem sprawdzić pierwszy center, dopiero użyć jego zwrotu do
kolejnego. Po sticky fault wszystkie późniejsze calls wracają przed floor;
ich0 nie jest próbką blisko centrum. Nie wolno dalej używać Gaussian residual
lemma dla tych zwrotów; trzeba śledzić osobny continuation branch. Source
generate zwraca0 po do_sign z fault, zamiast ponawiać próbę jak po norm reject.

**Nadal brakujący najbliższy typ:**

```
forall E,sk,pk,tau,a,j,S,mu,sigma,
  Reach_call_C(E,sk,pk,tau,a,j,S,mu,sigma) -> CenterClass(mu).
```

CenterClass z GuardPrefix.lean wymaga64-bit word, exponent<=1053,
NotNegZero oraz matematycznego floor w dokładnym wymaganym przedziale.
Jest to cel do wyprowadzenia z Reach, NIE składnik definicji Reach.
Local complete_local_lift już daje z niego floor refinement i s+z safety.

Do zamknięcia potrzebne są osobno:
1. reachable FPR-class/zero invariant (albo publiczny required-domain
   dowód osiągalności−0 i wtedy odpowiednio sklasyfikowany wynik negatywny);
2. uniform machine/exact certificate każdego internal subtractive LDL
   divisor/L i split/merge od emitted support; terminal H4 to za mało;
3. ordered residual/center certificate z tym ledgerem błędów, obejmujący
   także pre-dss calls oraz norm-rejected attempts.

Status całego zadania: PARTIAL_PROOF. Nowe lokalne dowody, diagnostyka i
operacyjne Reach nie rozstrzygają powyższego uniwersalnego implikacyjnego celu.
