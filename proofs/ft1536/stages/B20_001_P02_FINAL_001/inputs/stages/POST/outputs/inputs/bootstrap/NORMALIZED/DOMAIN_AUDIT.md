# Typed domains — P_key, emitted acceptance i width consumer

Autor projektu: Niirmata. Źródła candidate56974571…; P_key i M0 są niezmienione.
P_key: cztery Int^1536 vectors, ternary f/g, |F|/|G|≤2047, exact NTRU modulo
Phi oraz actual Gate00_C na computed g00. Narrow stable scan NIE jest nową
składową tej definicji. review/NEXT_SCOPE jest konsumowany w pełnym zakresie.

## A. All-P_key computational theorem — PROVED

```
forall p,m,
 P_key(p) -> RawPrefixCertificate(p,m) -> LegalSuffixBuffers(m,p,logn=10) ->
 DefinedTerminating(stable_helper; sigma=of(768); normalize; return_expression)
 and OutputPointerInitialized and ExactStableAndStoredSequence
 and leaf_count=1536 and tree_words=18432 and InternalLAndBasisPreserved.
```

Return value w tym typie jest dokładnie stable gate result. Nie zastępujemy
go true. NORMALIZATION/SQRT_DIV_CONTRACT zamykają domains PRZED instrukcjami.
Strong broad source bounds: primary∈(1/4,2^24), full stable D∈(1/4,2^31),
positive normal, sqrt source value∈(1/4,2^16), stored width∈(1/128,4096).
Wszystkie operations mają scalar cap2^100; największy stable intermediate
<2^72, największy divisor<2^48. Potrzebny nowy div contract obejmuje
[2^-16,2^80]. Nie zastosowano dawnego[1/16,2^35] do dużego e2.

Przy P_key nie ma invalid-positive fallback. Narrow range scan może nadać
bad=1, ale wtedy nadal przypisuje leaves_out i wykonuje się normalize.
Early return przed pointer assignment wymaga złego logn/n/hn; fixed profile
wyklucza ten case. Nie twierdzimy totality suffixu dla arbitrary logn.

## B. All-P_key narrow acceptance — OPEN, nie obalone

Pierwszy brakujący silniejszy typ:

```
forall p,P_key(p) -> forall i:Fin1536,
  0x4090000053700377 <= bits(SourceStableLeaves(p)[i])
  and bits(SourceStableLeaves(p)[i]) <= 0x4114444d1a037d50.
```

all_P_key_stable_gate_acceptance_proved=false. Szerokie positive bounds
nie domykają tego typu. Nie wyszukiwano kluczy/kontrprzykładu P_key i nie
ogłasza się fałszywości tej tezy. Synthetic out-of-range leaves/roots nie
są P_key/emitted witnesses ani counterexamples wymaganej domeny.

## C. Source-derived EmittedStableCertificate — PROVED

```
Emitted_CANDIDATE(E,sk,pk) and SourceDecodeSameSTATIC(sk)=p ->
  defined final successful attempt's ft_keygen_leaf_certificate returned1
  and its actual stable1536 words passed every positive/range check.
```

To fakt o istniejącym success event, wyprowadzony z failure-continue przed
break i obu serializerów. EMITTED_STABLE_BINDING daje bitowe root/helper/
scan coupling do signera. Nie dodano premise o desired normalized widths,
nowego conditioning, K_iid, abortu lub epsilon.

## D. Główna teza emitted — PROVED

A+C+RAW emitted corollary dają actual suffix defined/terminating, stable_ok,
leaf_count1536/tree_words18432, exact1536 stored widths, zachowanie16896
internal L i6144 basis words oraz internal load_skey return1 przy legalnych
allocations. Private-key API/malloc success nie jest tym twierdzeniem.

## E. Sigma-only width consumer — PROVED

Dla każdego actual emitted stored S0 oraz S1=mul_C(IW1I,S0), literalne
`inv_C(mul_C(sqr_C(S),of_C(2)))` jest positive finite i nie mniejsze od
ostatniego source bank coefficient3f45555555555555. Selector's Boolean found
jest więc true, jeżeli ten fragment jest wykonywany na tych widths.
To nie proof earlier floor(mu)/residual, NumericCenter/Reach, PRNG/rejection
termination lub całego sampler prefixu.1536 stored leaves i3072 scalar
uses są odrębnymi liczbami/mapami.

## Proof boundary

Mixed kernel/universal analytical source proof. Integer sqrt54 invariant,
extended pack-value lemma, sign/square/sort/flags, map/frame i scoped
consumers są kernel checked. Pełne analytic error contracts, C/ABI/heap
translation i instancja source Emitted/control flow są jawne w dokumentach;
nie są zweryfikowanym GCC lub complete-IEEE premise. Finite controls nie
zastępują tych uniwersalnych dowodów. Wszystkie scope flags są osobne.
