# Emitted support → jawne P_key

Źródła: bootstrap/source, manifest2553358f…; BASE9a76ecfd72d83e131d79299f0249bca1efdf9468.
Emitted_C zachowuje dokładną operacyjną definicję H3/REACHABILITY: jeden
successful finite defined execution source KeyGen w M0, seed w support
uniform32-byte service, sukces mandatory gate ORAZ obu serializerów. Nie
wykonano KeyGen, nie wybrano klucza i nie odczytano sekretów.

## 1. Support i checked coefficients

Aktywne Makefile: TRUE_TERNARY_SECRET=1, MODE=1. W sample_true_ternary_secret
4758–4780 do v[u] zapisuje się x−1 wyłącznie po x<3; stąd f,g∈{-1,0,1}.
Nie zamieniamy prawa zaakceptowanych kluczy na niezależne K_iid: użyta jest
tylko ta deterministyczna własność supportu. Końcowe solve_NTRU7342–7346
wymaga obu poly_big_to_small. W4493–4507 każde zapisane z przechodzi
−2047≤z≤2047; int16 cast jest dokładny. Przebudowany H3.checked_key_coefficients
formalizuje checked-loop, a nowy RootBounds podstawowy test signed range.

## 2. Dlaczego końcowe modularne sprawdzenie daje exact NTRU

Nie zakładamy niezawodności całej approximate Babai reduction. Source
solve_NTRU7348–7396 sprawdza już finalne f,g,F,G po obu caps. PRIMES3[0]
to p=2147355649, g=1907584673. emitted_certificate.py dowodzi primality p,
primitive order9216 g i primitive order4608 g². Użyta domena pełnego N1536
ma1536 różnych pierwiastków Phi modulo p.

Source modp_set/add/sub/Montgomery dają dokładne operacje na F_p:
- dla |x|<p signed conversion wybiera x albo x+p, w uint32;
- dla canonical a,b<p suma/różnica i pojedyncza korekta zostają w[0,p);
- R=2^31, p0i*p≡−1 modR. z=ab<2^62, w=(z*p0i modR)*p<2^62,
  z+w<2^63. Unsigned wrap w z*p0i nie zmienia low31 bits. Iloraz
  (z+w)/R jest całkowity,<2p, a source final subtraction daje ab/R modp.
  Nie ma signed overflow ani błędnej niekanonicznej dziedziny.

Forward gm tabeli mkgm3 jest odtworzony dla wszystkich1024 slots, włącznie
z REV10 i ostatnim square g przy logn10/full1. Odwrotne igm obliczane obok
nie są używane w tym końcowym forward check. Symboliczny NTT checker śledzi
wszystkie1536 niezależnych współczynników i2359296 wag. First pass to
a0+a1*w oraz a0+a1*(1−w)=a0+a1*w^5. Dalej rzeczywiste square butterflies
i cubic branch order. Każda waga jest g_root^(root_exponent*index).
Pojedyncze publiczne C wywołanie table/NTT dla X potwierdza raw tables i
physical root map; nie uruchamia key generation. Wniosek dla wszystkich
polinomów pochodzi z liniowości source modulo p i sprawdzenia WSZYSTKICH wag.

Check z7390=r mnoży oba produkty i q przez ten sam R^-1. Jego sukces daje
fG−gF=q we wszystkich1536 roots. Polynomial remainder stopnia<1536 jest
więc zerowy modulo p. Każdy convolution coefficient ma modulus≤2N*2047;
redukcja X^(N+u) daje −X^u+X^(u+768) dla u<768, a −X^(u−768) inaczej.
Każdy remainder coefficient dostaje najwyżej3 convolution coefficients.
Zatem |remainder(fG−gF−q)_i|≤6N*2047+18433=18883585<p. Modulo-p equality
wyznacza jedyny integer0. To usuwa NTRU premise dla emitted coefficients
bez assumption o jakości source final quotient. Bounds/certificate nie
przypisują temu etapowi pełnego kernelowego kompilatora/KeyGen refinement.

## 3. Te same wektory po source decode

Keygen8145–8160 zapisuje header (ter<<7)+(comp<<5)+logn, bit G-absent=0,
oraz cztery wektory w kolejności f,g,F,G. M0 comp=STATIC. W enc289–379
każdy signed value koduje sign,8 low bits, floor(|x|/256) zer i stop1,
na końcu zero padding. |x|≤2047 daje co najwyżej7 unary zeros: nie ma
wrapu uint32 lub narrowing poza signed16. Decoder462–546 odczytuje dokładnie
te same pola, odtwarza |x|=lo+256*ne i sign; canonical zero ma sign0.
Bitstream induction po1536 coefficients i byte padding daje dokładny
roundtrip. Pomyślne encodery nie emitują partial private key. Public encoder
też musi odnieść sukces, aby Emitted_C zachodziło.

Signer3150–3268 sprawdza format/rozmiar, dekoduje wszystkie cztery wektory
(G jest obecne), wymaga końca wejścia i uruchamia exact validator1103–1144
przed load_skey. Jego convolution/reduction jest tą samą Phi algebraiczną;
signed64 bound jest znacznie poniżej2^63. Z caps i już dowiedzionego NTRU
emitted vectors przechodzą te algebraiczne testy. Allocation/API failure
nie tworzy root call i nie jest nowym warunkowaniem K_seed[E].

## 4. Mandatory machine Gate00_C i identyczność z loaderem

Keygen8110 wymaga ft_keygen_leaf_certificate. W7690–7741 konwersje/FFT3,
negacje f,F i obliczenia wszystkich trzech Gram arrays są identyczne
instrukcja-po-instrukcji z loaderem1186–1248, z logn10/full1, tymi samymi
tablicami i tym samym backendem. smallints_to_fpr obu miejsc wykonuje
ten sam fpr_of(t[u]). Nie porównujemy tylko nazw idealnych norm.

Gate najpierw wykonuje ffLDL_fft3_keygen, potem7746–7755 sprawdza każdy
g00 real slot: sign0, exponent≠2047, magnitude≠0 oraz !fpr_lt(x,1/2).
Na positive finite word porządek raw bits jest porządkiem dokładnych val,
więc test daje x≥1/2 (i wyklucza subnormal). Gdy test nie przechodzi,
bad|=1 nie może zostać wyzerowane; corrective fallback1 nie tworzy sukcesu.
Przy return bad==0 żaden fallback nie zmienił g00. Dalszy stable leaf test
jest zachowany w Emitted, lecz jego leaf bounds nie są tu konsumowane.

ROOT_FRAME wyprowadza, że poprzedzająca ten test rekurencja nie zapisała
do root Gram. To wiąże oryginalny computed g00 z gate. Determinizm tych
samych konwersji/FFT/Gram na tych samych decoded vectors przenosi Gate00_C
do RootSlice loadera. Source numerical correctness wcześniejszych subtrees
nie jest postulowane: Emitted dotyczy defined successful prefixu KeyGen,
a binding root call w Sign jest osobnym conditional frame statement.

## 5. Pełna implikacja i granica translacji

```
forall E, sk, pk,
 Emitted_C(E,sk,pk) ->
 forall f,g,F,G, SourceDecodeSameSTATIC(sk)=(f,g,F,G) ->
 P_key(f,g,F,G).
```

Dziedziny: legalny M0 environment E, skończone bytes sk/pk, cztery vectors
Int^1536. SourceDecodeSameSTATIC jest uczciwym roundtripem wyżej, nie
arbitrary-loader law. Standardowe legal buffers, lifetimes/disjointness,
fixed GCC integer semantics i defined source execution należą do jawnego
C/model bindingu. Nie pozostaje numerical premise dotyczące emitted key,
FFT errors, małego L ani positivity d11. Argument jest source-analytic,
wsparty nowym modularnym/all-coefficient certyfikatem, nie pełnym proof
entire C/assembler/compiler w Lean.
