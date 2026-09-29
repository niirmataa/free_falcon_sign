# Actual stable sequence, width bounds i continuation

## 1. Operacyjna sekwencja

R(p) to1536-word recomputed source selfadj FFT root array z f/g, z real
prefixem768. First source Gate00 scan i fallback są częścią computation.
Stable_C(R) wykonuje literalnie signer760–894 (lub odpowiadający keygen core):
top triples3u+k → trzy contiguous256-word blocks → binary n256..1
left/right → primary P[0..767] → reverse reciprocal D[1535-u]=div(of(q²),P[u])
→ pełny positive/inclusive range scan. Nie reassociujemy sum/products ani
div3 i nie zastępujemy raw subtractive tree leaves tymi stable values.

Z source code każdy loop/call ma finite bound. Repeated binary rank n
dzieli się przez2 do1, dokładnie8 levels. Memory reads są uzasadnione w
MEMORY_FRAME. Poniżej domains są wyprowadzane PRZED użyciem, niezależnie
od narrow gate outcome.

## 2. All-P_key broad definedness

Bitowy bridge do ROOT g00 i P_key Gate00 dają real input r∈[1/2,2^23),
positive normal. Nie wywodzimy stąd narrow scan. U=2^-48,eta=2^-900.
Każdy wymagany ideal value w positive arithmetic ma lower znacznie większe
od2^-112; U+2^112 eta<β=2U. Dlatego source local relative factor mieści się
w1±β, po wcześniejszym sprawdzeniu skalarnych operand/div domains.

Dla exact a,b,c∈[m,M], m>0, wielkości e1/3,e2/e1,3abc/e2 należą do[m,M]:
pierwsza jest mean, trzecia harmonic mean, a e2−m e1 po ai=m+xi jest
mΣxi+Σxi xj≥0; upper wynika z2ab≤M(a+b), analogicznie dla par.
Source expressions mają factors:

| Wyjście | lower / upper względem exact |
|---|---|
|div((a+b)+c,3)|(1−β)^3 / (1+β)^3|
|div((ab+ac)+bc,(a+b)+c)|(1−β)^4/(1+β)^2 / (1+β)^4/(1−β)^2|
|div(mul(3,(ab)c),(ab+ac)+bc)|(1−β)^4/(1+β)^3 / (1+β)^4/(1−β)^3|

Te factors są zawarte w1±γ, γ=2^-40. Wszystkie positive wrappers są więc
identity: e1≥1.5(1−β)^2, products≥.25(1−β), e2>.5, abc>.125(1−β)^2;
nie ma underflow/zero. Upper products ab/ac/bc<2^47, e2<2^48, 3abc<2^72.
To domyka scalar2^100 i nowy div[2^-16,2^80] PRZED quotient computations.

Binary pair ma exact mean i harmonic mean w[m,M]. Source positive sum/product
mają factors1±β. Half(sum) i double(product) są exact w osiągniętej normal
domenie (exponents daleko od0/2047). Harmonic factor jest między
(1−β)^2/(1+β) i (1+β)^2/(1−β), również wewnątrz1±γ. Po top i ośmiu levels:

```
(1/2)*(1−γ)^9 < primary < 2^23*(1+γ)^9,
1/4 < primary < 2^24.
```

Source sums<2^26, products/doubles<2^50; all inputs<2^100 i divisors<2^48.
Reverse source div(of339775489,primary) jest positive normal i mieści się
w(1/4,2^31). Pełna D sequence ma więc tę broad enclosure. Exact QQ checks
wszystkich factors/outward inequalities są w width_bounds.py. Nie użyto
samej dodatniości RAW leaves jako narrow-gate proofu.

Range scan może dać false bez zmiany D. W fixed logn10 helper zawsze
inicjalizuje leaves_out, po czym oryginalny suffix wykonuje normalize także
przy stable_ok=false. Sqrt/div/scale domains z SQRT_DIV_CONTRACT uzasadniają
każdy read i operation. Returns/leaf map nie zależą od acceptance.

## 3. Emitted narrow acceptance i exact stored words

EMITTED_STABLE_BINDING wyprowadza z istniejącego mandatory success i bitowego
coupling D_min≤val(D[i])≤D_max we wszystkich1536 pozycjach oraz stable_ok=true.
Wartości endpoints są niezależnie odkodowane dyadic w WIDTH_BOUNDS.

Stored word sequence jest DOKŁADNIE:

```
S0[i] = div_C(of_C(768), sqrt_C(D[i])), i=0..1535,
tree[RAW_LEAF_MAP[i]] = S0[i].
```

Oba etapy są źródłowymi transducers, nie RN primitives z legacy/H4. C i
niezależny model mają tę samą literalną kolejność; kernel map wiąże leaf
positions z raw builder trace. Leaf count1536 i tree return18432 wynikają
z recursion/partition, nie są samodzielnym dowodem exact sequence.

Przy |sqrt_C(D)/√D−1|≤U i source div error U|ratio|+eta otrzymujemy exact
QQ square enclosures:

```
768²/D_max * ((1−U)/(1+U))² − 2^-800 < val(S0)²
val(S0)² < 768²/D_min * ((1+U)/(1−U))² + 2^-800.
```

Tiny term majoruje wszystkie eta cross terms, bo widths<4096. Mocne bounds:
**1.7763 < val(S0)² < 575.9999** (dokładniejsze rational endpoints w JSON,
około1.7763039737838013… i575.9998209624986462…). W szczególności scoped H4
1.7203≤val(S0)²<595.19 jest odtworzony nowym source proofem.

## 4. Paired transform i literal dss

Source IW1I=3ff279a74590331c; jego exact dyadic value i real square są
przypięte. S1=mul_C(IW1I,S0), nie przechowywany drugi leaf. Nowy mul error
daje **2.3684 < val(S1)² < 767.9999**, więc paired variance<768 z marginesem.
Nie wyprowadzano tego z luźnego595.19 i idealnego4/3.

Następnie każda z S0/S1 konsumuje source
`dss=inv_C(mul_C(sqr_C(S),of_C(2)))`. Actual denominator ma positive normal
range, source error jest rozliczony w jego kolejności. WIDTH_BOUNDS daje
positive finite dss z dolnym boundem>1/1536, a last coefficient ma payload
3f45555555555555 i jest nieco MNIEJSZY od1/1536. Positive-word comparator
jest poprawny w tej domenie, więc ostatni ge ustawia found w fixed selector.

Actual sampler structural map odwiedza stored leaves w odwrotnej fizycznej
kolejności; w każdym terminal case paired width jest użyte najpierw, potem
stored width.1536 stored words dają3072 scalar width uses. To sigma-only
consumer, bez uruchamiania PRNG/samplera lub dowodu wcześniejszego mu prefixu.

## 5. Internal load_skey corollary

RAW daje defined terminating prefix i legal cut state dla emitted/same decoded
p. Sections1–4 dają defined suffix, stable_ok=true, initialized pointer,
leaf_count1536/tree_words18432, preserved basis/internal L i wymagane width
facts. Literal return conjunction1266–1268 jest więc1. Jest to sukces
wewnętrznego load_skey przy legalnych allocations, nie nieomylność malloc
lub sukces całego publicznego private-key API. Dla all-P_key bez emitted
corollary return pozostaje dokładnie unresolved narrow gate Boolean.
