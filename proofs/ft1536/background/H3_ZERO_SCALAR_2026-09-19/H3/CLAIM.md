# H3_RANGE — dokładny cel i uzyskany zakres

Cel pozostaje niezmieniony: dla każdego emitted-KeyGen output z K_seed[E],
każdego M0 reachable prefixu Sign, przy aktywnym wejściu przed sign:2864:

```
Reach_call_C(...,mu_bits,sigma_bits) ->
 -2147483283 <= floor(exact_value(mu_bits)) <=2147483281,
 source fpr_floor(mu) = mathematical floor, long->int is exact;
 every returned proposal z is in[-365,366] and s+z is a defined int32.
```

Równoważny żądany interfejs pre-floor to
−2147483283<=exact_value(mu)<2147483282. N1536/q18433/Phi/sigma768/B2093922385,
full ternary MODE1, Makefile FPEMU, M0 caller4096/nonce40 i parametryczna gra
pozostają bez zmian. Kwantyfikator nie został rozszerzony/zawężony do arbitrary
loader keys lub synthetic mu, ani ograniczony przyszłym Q<B.

**Wynik: PARTIAL_PROOF.** Globalne Reach→range/refinement pozostaje otwarte.
Nie wykazano kontrprzykładu w required emitted/reachable domain.

Nowe domknięte lokalne fakty:
- źródłowe comparatory unsigned64/128, wszystkie pięć banków CDF i first-match
  selector dają uniwersalnie k<=365 oraz z∈[−365,366];
- field-normalized fpr_floor ma dokładny dyadic-floor refinement dla e<=1053
  i wszystkich fraction bits, z jawnym wyłączeniem −0;
- C_mu i te przesłanki dają bezpieczny cast/s+z; proof pełnego typu nie
  ukrywa C_mu ani NotNegZero;
- source-order terminal residual lemma zachowuje signed errors i używa
  wcześniejszego residuum do NASTĘPNEGO centrum, bez kołowego future premise;
- actual visit layout3072, first leaf18431/coordinate1→0 oraz checked-cap
  poly_big_to_small zostały kernelowo rozliczone w ich lokalnych zakresach.

Nowe negatywne diagnozy mają osobny zakres:
1. Rzeczywiste `fpr_floor(-0)` daje−1, mathematical floor0; −0 przechodzi
   guardy. To obala wersję lokalnego refinementu opartą WYŁĄCZNIE na finite/C_mu,
   lecz nie dowodzi osiągalności tego stanu z emitted KeyGen. Sam s+z przy
   tym−1 nadal jest bezpieczny; nie nazywa się tego przykładem overflow.
2. FPEMU underflow i subnormal operations nie spełniają uniwersalnego modelu
   complete-IEEE/u|x|+eta. Potrzebny jest reachable-domain ledger.
3. Syntetyczny inner node z poprawnymi H4 widths i L=2^32 daje centrum
   12884901888 po dwóch bezpiecznych prior returns. To dowód niewystarczalności
   samych leaf premises, nie emitted/loader counterexample.

Operacyjna definicja Reach i jej wykonywalna projekcja są w REACHABILITY.md.
Nie ogłasza się ukończonego kernelowego modelu całego C/KeyGen/loadera.
Najbliższy brakujący lemat: `Reach_call_C(...) -> CenterClass(mu)`
(jawna definicja CenterClass w formal/GuardPrefix.lean). Wymaga zero/domain
invariant, internal subtractive-LDL bounds i machine-error transfer.

Piny: bootstrap manifest f9ea2788…, kandydat manifest2553358f…,
sign eee8d7dc…, verifier3fe78f8d…. `baseline_source_integrated=true`,
`source_changed=false`, `new_source_patch_integrated=false`,
`protocol_wrapper_integrated=false`, `owner_accepted=false`,
`security_reduction_proved=false`. Starsze raporty zachowują historyczne flagi.
