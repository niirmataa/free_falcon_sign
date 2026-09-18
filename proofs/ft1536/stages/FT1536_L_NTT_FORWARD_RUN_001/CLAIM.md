# L_NTT dla przypiętego kandydata FT1536

Autor projektu: Niirmata. Profil: full ternary secret / FALCON_COMP_STATIC.
N=1536, q=18433, ternary=1, logn=10, Phi=X^1536−X^768+1.
R_M=65536, Rt=10237, R2t=4564, Q0It=18431, Rinv=5184.
Q i B pozostają parametrami wcześniejszego L_V, bez zmiany ich definicji.

Źródło: `source/falcon-vrfy.c`, SHA-256
`3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42`.
Manifest17 plików: `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a`.
Model: GCC14.2.0/C99/Linux x86_64 LP64, bajty8, int/uint32_t32,
int16_t/uint16_t16, size_t64; legalne, wyrównane i wymagane rozłączne bufory.
Konsumowany C→model binding jest zachowany z poprzedniego checkpointu.

## Teza i wynik

Dla WSZYSTKICH h,r,c w [0,18432]^1536, bez warunku KeyGen:

```
H := h; mq_NTT(H,10,1); mq_poly_tomonty(H,10,1)
a := r; mq_NTT(a,10,1); mq_poly_montymul_ntt(a,H,10,1)
mq_iNTT(a,10,1); p := snapshot a
mq_poly_sub(a,c,10,1); d := snapshot a
```

otrzymujemy zdefiniowane wykonanie w przypiętym modelu, utrzymanie zakresów,
`p=canonical_q(h*r mod Phi)` oraz `d=canonical_q(h*r-c mod Phi)`.
H reprezentuje Montgomery wartości transformacji h; p,d są ordinary coefficients.

**L_NTT_PROVED_FOR_PINNED_MODEL.** Główna formalna instancja:

```
FT1536Forward.L_NTT :
  ∀ h r c, CanonVec h → CanonVec r → CanonVec c →
  pipelineC h r c = (product h r, subtract (product h r) c).
```

`forwardC`, `inverseC`, `pipelineC`, `productCoefficient`, `remMonomial` i
`product` są dokładnie konsumowanymi definicjami. `product` nie został
zdefiniowany przez NTT. Nowa teza nie zawiera przesłanki o poprawności
forward, inverse, iloczynu, globalnym inwariancie lub zgodności modeli.

## Forward i dziedziny

`FORWARD_GLOBAL` dowodzi dla każdego canonical v, b<512, j<3:
`forwardC(v)[3b+j]=Σ(k=0..1535) v[k]*(ordinary(gmAt(512+b))*14648^j)^k modq`.
Suma `sumN` ma dokładnie indeksy0..n−1; udowodniono jej zgodność z
List.ofFn/foldl użytym przez oryginalny iloczyn.

Matematyczne interfejsy to niezmienione lifty
`F(v)=forwardC(canonical v)`, `G(v)=inverseC(canonical v)`.
Nowe `forward_product` jest dowiedzione dla wszystkich wektorów całkowitych.
Canonicalizacja w lifcie nie dodaje operacji do źródłowego C.

## L_RHO i zakres

Dla `∀i, -32768≤s[i]≤32767`, `rhoVec` używa dokładnie modelu `rhoWord`
kandydata L_RHO. `L_NTT_rho` daje
`pipelineC h (rhoVec s) c=(product h s,subtract(product h s)c)`
przy canonical h,c. Osobne wnioski obejmują p,d i wszystkie zakresy.

Pełny typ i proof term L_NTT oraz L_NTT_rho: `logs/final/AuditTypes.stdout`.
`source_integrated=false`, `owner_accepted=false`, `full_L_V_proved=false`.
Parser, centrowanie C, dokładność Q, ścisły próg B i bezpieczeństwo schematu
nie są tezą tego arytmetycznego checkpointu.
