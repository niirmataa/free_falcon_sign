# L_NTT_GLOBAL — niezmieniona teza docelowa

Autor projektu: Niirmata. FT1536 full ternary secret, uczciwe podpisywanie
`FALCON_COMP_STATIC`. Parametry: N=1536, ternary=1, logn=10, q=18433,
Phi=X^1536-X^768+1. Q, B i dziedzina wcześniejszego L_V nie są zmieniane.

Źródło `source/falcon-vrfy.c` ma SHA-256
`3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`.
Model: GCC 14.2.0, C99, Linux x86_64 LP64; bajty8, int/unsigned i uint32_t32,
uint16_t16, size_t64; legalne, wyrównane bufory i wymagane niealiasowanie.

Dla wszystkich canonical h,r,c w [0,18432]^1536, bez warunku KeyGen:

```
H := h; NTT(H); tomonty(H)
a := r; NTT(a); montymul_ntt(a,H); iNTT(a)
p := snapshot a; sub(a,c); d := snapshot a
```

Wymagany wynik: zdefiniowane wykonanie i canonical zakresy oraz
`p=canonical_q(h*r mod Phi)`, `d=canonical_q(h*r-c mod Phi)`.
H jest reprezentacją Montgomery wartości transformacji h; p,d są ordinary.
R_M=65536, Rt=10237, R2t=4564, Q0It=18431, Rinv=5184.

## Wynik tego wykonania

**PARTIAL_PROOF**, nie pełny L_NTT. Nowo domknięto globalny inverse
konkretnego wykonywalnego modelu oraz źródłowe prefiksy, zakresy i most do
kompozycji. `FORWARD_GLOBAL` i wynikające `forward_product` pozostają otwarte.
Dokładne kwantyfikatory sprawdzonych tez są w `logs/final/Audit.stdout`.

Model źródłowy jest rekurencją kolejnych zapisów `runSteps`; nie został
zdefiniowany jako idealna ewaluacja. `product` pozostaje oryginalną definicją
współczynnikową `Deps/Composition.lean`, z sumami i `remMonomial`.
Lift to `F(v)=forwardC(canonical v)`, `G(v)=inverseC(canonical v)`;
`liftForward_agrees`, `liftInverse_agrees` dowodzą zgodności na canonical wejściach.
Lift nie dodaje normalizacji do C.

`source_integrated=false`, `owner_accepted=false`, `full_L_V_proved=false`.
Podstawienie r=rho(s), pełne L_V, parser, centrowanie, norma i ścisły B nie
otrzymują dodatniego wyniku z tego częściowego etapu.
