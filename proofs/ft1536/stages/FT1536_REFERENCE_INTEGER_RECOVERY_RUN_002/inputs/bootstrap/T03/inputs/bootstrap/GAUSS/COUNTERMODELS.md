# Zachowane kontrmodele i ich rzeczywista przynależność

## 1. Nominalny remainder interval jest za wąski

Refutowana teza: każdy scalar-derived rB≤literal binary64(log2).
Exact witness (pierwszy z3 w artifacts/witnesses.json):

```
mu     = 3fe944a55eca5136
sigma  = 3ff5555555555555
leaf D = 4114400000000000  (331776=576^2)
k=4,b=0, bank0
U128=12248323354020575669426441721766499104
x_C    = 4013687a9f1af2b1
e      = 6
rB     = 3fe62e42fefa39f0
log2_C = 3fe62e42fefa39ef
```

Sigma powstaje przez ORYGINALNE source leaf lines987–990:
div_C(of_C(768),sqrt_C(D)). D spełnia single-leaf stable gate. μ jest w
NumericCenter, source dss/first-bank/k/b i correction dają dokładnie pokazany x.
Original C normal i ASan/UBSan potwierdzają sqrt/sigma,cały scalar expression,
BerExp words oraz rB. Independent Gaussian intervals całego kernelu dla tych
punktów są w artifacts/gaussian/kernel_098.json..kernel_100.json (mapa
artifacts/kernel_examples.json jest autorytatywna).

Klasa: **D_env, scalar-derived, normalizer-derived standalone gated leaf**.
Brak proofu, że D jest leaf rzeczywiście wyemitowanego klucza lub μ,k,b są
historią takiego Sign: **Emitted/D_cert membership OPEN**. Nie jest to atak
lub required-domain bug claim. To prawdziwy kontrmodel za wąskiej premise,
naprawionej w dowodzie przez rozszerzenie accuracy domain, bez zmiany C.

## 2. Ujemne extended expm input — duży błąd continuation

Dla rB raw bcd0000000000000 (=−2^-50), source unsigned trunc/shift daje theta
blisko1. Original expm_scaled(rB)/2^63 jest blisko0.367879; independent exp(-rB)
blisko1. Certified gap **>3/5** (pełna enclosure w artifacts/mutations.json).

Klasa: **EXTENDED_EXPM_INPUT_ONLY**. Nie jest to BernExp x ani scalar-derived
remainder, a nowy full reduction certificate wyklucza rB<0 dla source x∈[0,273].
Nie wywoływano BerExp na ujemnym x (który miałby inną, nieudowodnioną shift
domain). Ten negatywny wynik obala blanket transfer expm accuracy na ujemne
arguments, nie obala głównego Gaussian boundu i nie uzasadnia patcha programu.

## 3. Reverse chi-square

Dla każdego D_cert/D_env entry y=s_C+367 jest mathematical integer z
G(y)>0,K_C(y)=0. To exact support obstruction do finite chi2(G||K_C), także
gdy Gaussian tail jest bardzo mały. Nie należy go ukrywać przez odwrotny
kierunek metryki lub niejawne conditioning G na S.

## 4. Mutacje i ograniczenie falsyfikowalności

Wykonano12 wykrytych model mutations, no-op i dodatkowy przypadek równoważności:
usunięcie saturation min(Z,2^55) NIE zmienia source wyników w nowo dowiedzionym
zakresie Z≤2^55. Zachowano status EQUIVALENT_ON_PROVED_SOURCE_RANGE zamiast
udawać wykrycie. Extended comparator Z=2^55+1 nadal obala generic pomijanie
saturation, ale jest niemożliwy dla literalnej Horner recurrence.
Inne mutations: signed-zero shift,nominal coefficient/transfer,quantization,
ideal exp/cutoff,remainder clamp,normalizer,tail i reverse chi2. Pełne
baseline/changed values i scopes w artifacts/mutations/*.json.
