# Exact adaptive VALUE / N / revealed-byte law

W całym pliku fix wymagane e i legal entry PAST, IID_BUFFER z countable product
uniform bytes. Countable additivity, existence of product measure, tower i
monotone convergence są jawną analityczną podstawą, nie nowymi aksjomatami Lean.
PAST ujawnia read words/positions/pointer i decyzje, NIE unread buffer lub
future blocks/real private PRNG state. Prefix/value projection i next-domain
facts pochodzą z SOURCE_ORDER/PREFIX_CLOSURE, a fresh-tail z pinned IID.

## 1. Stopping times i root a.s. return

Na stopping-time entry i (po dotychczasowych finite scalar returns) current
mu_i(h),sigma_i(h) są PAST_i-measurable. Domena zachodzi i unread tail jest
warunkowo IID. Odebrane prawo ma teraz A_h≥1/8 z GAUSS:

```
Pr(N_i=n,Y_i=y | PAST_i)=(1-A_h)^(n-1) w_h(y), n>=1.
```

Summing gives Pr(N_i>m|PAST_i)=(1-A_h)^m≤(7/8)^m, więc Ni<∞ a.s.
Indukcja: entry1 finite; jeśli entryi finite a.s., to conditional probability
nonreturn_i=0, a deterministic intercall prefix defined i finite, więc
entry(i+1) finite a.s. Skończony scheduler M3072 kończy się a.s. po ostatnim
finite return i bounded caller statements. Przecięcie skończenie wielu
probability-one events ma mass1. Nie zakładamy independence Ni lub Y_i.
Możliwa pointwise infinite rejection trace nie jest wykluczona; ma mass0 w IID.

Każdy scalar return jest stopping time względem getter filtration. Suma z
finite scheduler i final caller computation daje root stopping time.
Conditional IID fresh-tail przy i+1 wynika z odebranego stopping-time theorem,
także po ujawnieniu Ni,Yi,ptr i wszystkich read words. Po root to samo: remaining
unread suffix i future blocks są IID niezależnie od zakończonej PAST.
Ta teza nie obejmuje full-buffer conditioning lub real seeded PRNG.

## 2. Cylinder law i zero prefixes

Na Hi z PREFIX_CLOSURE definiujemy K_h(y)=w_h(y)/A_h. Przez projection K_h
nie zależy od Ni/pointer/rejected bytes poza h; full-PAST conditional law jest
to samo dla wszystkich ich realizacji. Tower względem sigma(Y_<i,e) daje to
samo K_h. Kolejna indukcja/tower:

```
P(Y_1=y1,...,Y_m=ym | entry PAST)=prod_i=1^m K_(e,y_<i)(yi), m<=M.
```

Jeśli tuple opuści H po raz pierwszy, jego cylinder mass wynosi0. Nie
obliczamy parametrów/operacji C po tym pierwszym zero atomie; zapis iloczynu
oznacza0 z early stop. K na undefined późniejszych tuples nie jest oceniane.
Na legalnych ścieżkach sumy kernelów1 i finite branching gwarantują mass1.
To ordered adaptive product, nie product unconditional marginals.

Pełne joint count/value law, dla n_i>=1 i legalnego y:

```
P(N=n,Y=y)=prod_i [(1-A_(h_i))^(n_i-1) w_(h_i)(yi)].
```

Nie ma resetu bufora między calls. Conditional kernel jest ptr-independent
w tej grze, a SOURCE_ORDER oddziela caller state od resource state; dlatego
sumowanie wszystkich zgodnych bytes/ptr nie zmienia tej formuły.
Dla y o positive P dzielenie przez P(Y=y) daje
`P(N=n|Y=y)=prod_i A_h(1-A_h)^(n_i-1)`.
Conditional on CAŁYM y liczby Ni faktoryzują się jako geom(A_h), lecz
unconditionally są na ogół zależne przez adaptacyjne A_h. Przy A_h=1 jedyne
positive Ni to1; konwencja0^0=1,0^n=0 dla n>0 nie wymaga conditioning na zero.

## 3. Pełne ujawnione proposal atoms

Alphabet V to33-byte raw strings: hi8,lo8,signbyte1,maskword8,thresholdword8.
Wszystkie8bits sign byte oraz masked-out bits pozostają w transcript.
Każdy atom ma massD^-1,D=2^264. Dla fixed legal h deterministyczny original
scalar transducer dzieli V na Reject_h i disjoint Accept_h(y). Zatem
|Accept_h(y)|/D=w_h(y), |Reject_h|/D=1-A_h. Żaden getter nie jest pominięty
przy cutoff lub niezerowej masce; każde completed proposal pobiera oba words.

Dla skończonej complete root revealed trace v_1,...,v_T, wraz ze wskazanym
segmentation n i y, sprawdzamy deterministycznie: w każdej scalar call pierwsze
n_i−1 atoms∈Reject_h, ostatni∈Accept_h(yi), wszystkie prefix domains legal.
Jeśli tak, **probability tego dokładnego read transcript = D^-T**; inaczej0.
Pierwsze osiągnięte returny ustalają segmentation, więc nie liczymy traces
dwukrotnie. Getter positions i ptr są deterministic z entryptr i tags/N.
Discarded bytes są wycałkowane z factor1, nie zgadnięte jako revealed zeros.

Sumowanie D^-T po compatible raw atoms daje dokładnie joint N/Y formula.
Ta formuła, atom predicate i literal BYTE_SCHEDULE identyfikują revealed-byte
law źródła; same normalized value PMFs nie dawałyby tej informacji.
Jeśli observer dodatkowo ujawnia discarded bytes, trzeba dopisać ich factor
256^-Ddiscard i jawny rozszerzony transcript. Nie nazywamy unread cells już
ujawnionymi tylko dlatego, że refill materializuje cały block.

## 4. Dokładne resources i stan

Funkcja F_p(n) iteruje source getters8,8,1,8,8 z p. Joint law dla każdej
deterministycznej pointer/refill/drop trajectory to joint N/Y mass pomnożona
przez indicator zgodności z F; sumowanie po N daje jej marginal.
Caller residual/memory trajectory jest V_e(Y), natomiast read transcript,
PRNG bytes i resources nie są funkcją samych Y. Oba aspekty są eksportowane
osobno. Ilościowe resources i ghost stopping events w RESOURCE_BOUND.
