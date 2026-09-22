# CLAIM — FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001

**PARTIAL_PROOF** dla one-root tranche T03, wymagana domena (emitted/same-STATIC
normalized key, canonical c, legal completed positive-source-support H).

1. **PROVED — niezależna referencja i mapping.** v_ref = [c,0] − Z(Y)B w
   Z[X]/(X^1536−X^768+1)^2 jest zdefiniowana wyłącznie z exact danych
   (c, f, g, F, G, Y); Z(Y) = signed permutation 3072 integer returns wynikająca
   z literalnej kolejności wywołań i konwencji merge; w exact skeleton
   (actual L jako fixed constants) residua = t − Z(Y) dokładnie (kernel + exact
   instancje).
2. **PROVED — integrality i kongruencja.** v_ref ∈ Z[X]/Phi^2 oraz
   v_ref1 + h·v_ref2 = c mod (q, Phi) dla h = g f^{-1} tego klucza — dla całej
   required domeny i każdego completed H.
3. **PROVED — rounding-gap lemma (warunkowy).** nearest-even rint: |t−v|< 1/2
   ⟹ w = v; tie = 1/2 rozliczony parzystością, oba znaki; kernel czysty.
4. **OPEN — uniform source error (B) i equality actual wide rint (C-applic).**
   Złożony outward bound luki |pre_rint − v_ref| = 6086.4 ≥ 1/2 dla pinned
   constants; minimalny missing type i progi liczbowe podane (SOURCE_ERROR §3).
   Nie jest to kontrprzykład równości (brak witnessa w required domenie).
5. **WARUNKOWY consumer (D).** recovery ∧ joint Safe16 ⟹ stored pair = v_ref
   ⟹ kongruencja stored pair; Safe16 i center/norm compatibility dla Verify
   pozostają jawnymi zobowiązaniami (lokalny kontrprzykład monotonicity
   center_q w COUNTERMODELS).

Silnik rachunku: SageMath 10.9 przez `sage lemma.sage` (zasada 2026-09-22);
port z `.py` udokumentowany w checks/sage/PORT_PY_TO_SAGE.md/.json.

Nie twierdzi: whole Sign, Sign→Verify, retry composition, real PRNG, security,
Safe16, M0 eta_pre, integralności stored/narrowed pair bez recovery.

source_changed=false; production_source_changed=false;
new_source_patch_integrated=false; owner_accepted=false.
