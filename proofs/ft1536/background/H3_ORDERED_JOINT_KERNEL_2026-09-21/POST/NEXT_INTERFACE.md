# Eksport do SOURCE_SAMPLER_LAW/H6P i kompozycji

Status PARTIAL_PROOF, operational subclaim
H3_SOURCE_POSTPROCESSING_DEFINED_FOR_EMITTED_PINNED_MODEL.

## Deterministyczny consumer

```
∀ actual legal emitted/same-STATIC/normalized/canonical finite H,
  ffSampling_return(H) ⇒
    suffix_terminates_defined(H) ∧
    ∀i, w1_i=RN_even(val(iFFT_C(F0)_i)) ∧
        w2_i=RN_even(val(iFFT_C(F1)_i)) ∧ |w1_i|,|w2_i|≤4572095 ∧
        s1_i=narrow16(w1_i) ∧ s2_i=narrow16(w2_i).
  Safe16(w1,w2) ⇔ (s1=w1 ∧ s2=w2).
  source_norm_accepts ⇔ Q(s1,s2)<2093922385.
  accepted stored norm + M0 caller ⇒ payload=0xaa||Encode8(s2),len≤3160,
    source_decode(body)=(s2,body_length), untouched output suffix.
```

Przesłanki nie zawierają Safe16, future acceptance lub termination samplera.
F0/F1 są literal mapą POSTPROCESSING_MAP. Fault scope i frame są pinned,
nie arbitrary faulted tails. Caller może norm-retry,nonreturn albo return0;
completed attempt flag nie zmienia tego source zachowania.

## Pozostały typ

Niech Ω będzie rzeczywistą probabilistyczną grą M0 z JEDNYM K_seed[E],
warunkowanym sukcesem całego capped KeyGen i obu serializerów, p_K raz.
Dla attempt j<16 C_j oznacza osiągnięty legal completed suffix; z samej tej
historii definiujemy joint Bad_j dla OBU w vectors. WholeCallBad=∃j<16,C_j∧Bad_j.
Przyszła praca ma wyprowadzić law actual PRNG/proposal/BerExp/rejection i either:
uniwersalną negację event w required domain albo uzasadniony joint probability
statement we właściwej grze. Żadnego η_pre, conditioning loss lub independence
nie zadeklarowano. Marginal center bounds i M0 capacity tego nie zastępują.

Reference bridge osobno: zdefiniować niezależny exact integer lattice pair
przez canonical target/ordered sample history/sign conventions; dowieść
integrality, source error/tie gap,congruence i relacji stored norm/center.
Do tego czasu reference_integer_recovery_proved=false i Sign_to_Verify=false.

Dalsza retry/ROM-QROM/reduction composition musi zachować raw source bytes,
norm/cap/fault/nonreturn outcomes i M0 observation contract oraz odebrane
H1R/FFO/R5T/M7 scopes. Nie przechodzić do K_iid, modyfikacji verifier domain,
nowych gates/clippingu lub ideal Gaussian bez source-law proofu. Security,
whole Sign termination i CT pozostają nieudowodnione. Handoff kończy ten etap;
nocny RUN_002 prowadzącego nie jest uruchamiany przez ten pakiet.
