# Dokładny następny obowiązek

**Nie brakuje samego rozwiązania nierówności Phi. Brakuje formalnego
połączenia programu interaktywnego z prawami i zasobami.**

Następny wykonawca powinien dokończyć ten sam T12.1/T07–T14, w nowym runie
po odbiorze, konsumując przypięte eksporty tego pakietu.

## Brakujący główny typ (specyfikacja, nie deklaracja z aksjomatem)

```
forall beta muKey (A : ClassicalAdversary beta)
       (S : PublicSamplerCode) (cost : BitMachineCostCertificate S),
  LocalFullJointLawCertificate muKey Sigma_math S beta e ->
  exists B : MTAdversary (publicMarginal muKey) (beta.QH+1),
    ImplementsPublicReduction B A S /\
    Resources B <= resourceBound beta cost /\
    AdvEUF Sigma_math muKey A <=
      min 1 (collision beta + phi ((1+e)^beta.Qs-1) (AdvMT B))
```

Typy `ClassicalAdversary`, `MTAdversary`, `ImplementsPublicReduction`,
`Resources` nie zostały zdefiniowane w tym pakiecie. Nie można zastąpić ich
rekordem zakładającym ostatnią nierówność. Wymagane są programy, interpreter
i certyfikaty lokalne o konkretnych prawach, a następnie dowód.

## Konkretne brakujące lemmy

1. Bounded classical adversary, prywatne coins i dowolne Bytes* H queries;
   jedna lazy tablica, Sign query bez reentrancy, ordinary freshness.
   Połącz List-byte framing z parami nazw używanymi przez ROM.State.
2. Jednorazowe muKey, latent sk/public h projection, challenge targets IID
   uniform i niezależne od klucza. `hash_nonanticipating` jest lokalnym
   lematem kodu, nie jeszcze probabilistycznym lazy-sampling equivalence.
3. Zidentyfikuj conditional kernels pełnych zatrzymanych gier dla KAŻDEJ
   potrzebnej historii. Udowodnij, że kroki wspólne i padding można ułożyć
   w najwyżej Q_s płatnych przejść bez utraty obserwacji. Obecny
   `constant_adaptive_chi2` ma wykładnik n przejść, nie magicznie Q_s.
4. Włącz `fresh_nonce_conflict` i `adaptive_average` do stopped interpreter;
   wyprowadź per-call bound z rzeczywistych rozmiarów tabeli. Następnie
   `accumulated_conflicts` daje dokładną sumę. Nie zakładaj per-call ryzyka
   jako certyfikatu całej gry; udowodnij z uniform nonce przed A.
5. Sprzęgnij grę honest i honest-stopped; połącz indexed_extraction z
   distribution of returned MT witness. Formalizuj T=Q_H+1 listę zamiast
   nieskończonej funkcji targets; dowód licznika uzasadnia taki restriction.
6. Zrealizuj bit-cost publicznego samplera albo przyjmij kompletny lokalny
   certyfikat implementacji i prawa jako jawny parametr lematu warunkowego.
   Parametr `run` nie ma obecnie certyfikatu kosztu ani generatora Fin-coins.
7. Instancja Sigma_math: accepted conditional law vs D^B po Emit, image law,
   e_img/e_sign po pełnych historiach. Małość tych wielkości jest osobna od
   formalnego lematu warunkowego. Empty cosets oraz POST_ABORT muszą zostać.

## Już gotowe punkty zaczepienia

- `MathSign.full_reply_law`, `cap_mixture`, `success_vs_capped_second`;
- `PublicSimulation.boundedGaussian_support`, `full_norm_support_in_box`;
- `Divergence.joint_chi2_finite`, `image_conditional_bound`,
  `stopped_adaptive_chi2`, `stopped_transcript_event_bound`;
- `EventTransfer.event_quadratic`, `phi_bound`, `phi_mono` i brzegi;
- `ROM.reachable_invariants`, `reachable_unique`, `final_hash_index`,
  `target_count_le_QH_add_one`, `Reduction.indexed_extraction`;
- `PublicSimulation.simSign_invariants`, `simSign_table_growth`;
- `Reduction.finite_trace_bound`, `hardness_substitution`.

Ich pełne aktualne typy są w formal_types.txt. Nie konsumować samych nazw
jako szerszych twierdzeń. Specyfikacja finite-box G16 świadomie wymaga
osobnego przejścia do full M0 i później C/real PRNG/H2P.
