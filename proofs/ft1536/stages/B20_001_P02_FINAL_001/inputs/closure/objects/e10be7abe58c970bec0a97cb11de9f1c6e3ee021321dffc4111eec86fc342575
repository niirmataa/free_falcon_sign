# L_V — przypięty kandydat L_RHO

Autor projektu: Niirmata. FT1536 full ternary secret; uczciwy Sign używa
FALCON_COMP_STATIC, Verify obsługuje NONE i STATIC.
N=1536, q=18433, ternary=1, logn=10, Phi=X^1536−X^768+1,
B=2093922385, sigma_sign=768.

```
Q0(a) = Σ(i=0..767) [a_i²+a_i*a_(i+768)+a_(i+768)²]
Q(a,b) = Q0(a)+Q0(b)
center_q(t) = u if u<=9216 else u−18433, u=t mod18433
Ext0(h,c,b) = (center_q(c−h*s(b)), s(b)).
```

s(b) jest signed int16 faktycznie zapisanym przez parser, także poza
centered domain. Iloczyn jest odziedziczonym, niezależnym współczynnikowym
product/remMonomial modulo Phi i q.

**Wynik: L_V_PROVED_FOR_PINNED_MODEL** dla falcon-vrfy.c o SHA-256
`3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`.

## Kwantyfikatory i kontekst

Dla wszystkich canonical h,c oraz wszystkich skończonych ciągów bajtów b
o długości reprezentowalnej przez size_t64, w legalnym lifecycle API i przy
legalnych obiektach pamięci:

```
V_CAND(h,c,b)=1 ⇒
 s(b) i Ext0 są zdefiniowane,
 z1+h*z2=c modulo(q,Phi),
 Q(z1,z2)<2093922385, (z1,z2)=Ext0(h,c,b).
```

To teza mocniejsza od ograniczenia h do successful-output support KeyGen.
Nie zakłada poprawnego kodowania b, centered s, uczciwego Sign ani cap2049.
Model LegalBytes ma jedynie limit API `length<2^64`. Jawne canonical c jest
dziedziną tego lematu zamiast preimage HashToPoint, zgodnie ze zleceniem.

Raw Verify otrzymuje przygotowane H=NTT(h)/tomonty. Model V_CAND wykonuje
guards, prawdziwą maszynę dekodera i rawVerify. rawVerify wykonuje pipeline,
sekwencyjne centrowanie i model int64 falcon_is_short; nie jest zdefiniowane
wprost przez Q(Ext0)<B.

V_KEY_BYTES dodatkowo używa loadFT. Jest to jawna projekcja loadera na
profil FT1536: pozostałe poprawne profile nie są przedstawiane jako błędy C.
L_V_LOADED wyprowadza canonical h i prepared H z udanego załadowania PK.
PK może zawierać nieczytane końcowe bajty; decoder zwraca len, nie2880.

## Model platformy i eksporty

GCC14.2.0/C99/Linux x86_64 LP64; uint32 wrap, int32/int64, signed16 narrowing
GCC przez niskie16 bitów, odpowiadające typy short/unsigned short i ich aliasing.
Nie jest to gwarancja identycznego narrowing na każdej implementacji C99.
Pełne typy i termy: logs/final/BridgeTypes.stdout. Kluczowe tezy:
RAW_VERIFIER_SOUND, L_V_BYTES, L_V_LOADED, L_V_SOURCE.

`full_L_V_proved=true` dotyczy WYŁĄCZNIE tego pinu kandydata.
`source_integrated=false`, `owner_accepted=false`.
Nie zmienia to kontrprzykładu dla oryginalnego S17, zakresów T2C3/T5 ani
statusu samplerów, rozkładów, EUF-CMA, MT-ISIS, H2P lub transferów strat.
