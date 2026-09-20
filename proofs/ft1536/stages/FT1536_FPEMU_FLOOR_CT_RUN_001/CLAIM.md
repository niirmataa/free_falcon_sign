# FPEMU_FLOOR_CT — dokładny kontrakt kandydata

Autor projektu: Niirmata. Kandydat zmienia tylko końcową selekcję w ciele
fpr_floor, zachowując sygnaturę i prefix. PATCH.diff jest pełnym diffem.
Pozostałe16 źródeł, Makefile/flags, fpr_lt/half/sampler/parametry/tablice są
byte-identical. Nie zastosowano asm barrier, attribute, nowego helpera lub
test-only zmiany optymalizacji.

## Teza centralna

W jawnym C99/GCC14.2/Linux x86_64 LP64/two's-complement modelu:

```
forall raw : Word64,
 Defined_LP64(floor_old,raw) and Defined_LP64(floor_candidate,raw) and
 result_long_bits(floor_candidate,raw)=result_long_bits(floor_old,raw).
```

Obejmuje wszystkie2^64 words, także raw NaN/Inf; nie jest dla nich tezą
o matematycznej floor. FloorCT.all_word64_equivalence i all_word64_defined
są kernelowymi integer/bit model proofs. SEMANTICS/SOURCE_MODEL_BINDING
rozliczają instrukcje C, casts, shifts, wrapping i granicę compiler proof.
Candidate model ma rzeczywiste dwa AND/OR i unsigned masks; nie jest aliasem old.

Na NumericCenter zachowano floorVal−eps0, source_floor_range/int safety,
floor(+0)=0, floor(-0)=−1. Nie zmieniono domeny lub zero-aware consumers ZERO.

## Zakres maszynowy i pomiarowy

Przy dokładnym pinned -W -Wall -O i Makefile macros analiza konkretnych
bajtów potwierdza fixed control/memory trace samej poprawionej operacji
w scalar wrapperze, official target_floor i wszystkich trzech production
inline sites BerExp/sampler/sampler_large. Register-source cmov/variable shifts
nie sterują instruction pointer ani adresem pamięci. Nie ma integer div.
To nie theorem czasów każdej instrukcji na wszystkich mikroarchitekturach
ani całego caller/Sign CT.

Prespecified trzy rundy A/B ukończono bez zmiany klas/progów/order/retry:
baseline floor9/9 signal, candidate9/9 NO_LEAKAGE_EVIDENCE_YET przy>31.9mln
samples/class, positive6/6 i negative6/6 controls zgodne. Wszystkie102 test
states odtworzono dokładnie z raw9771 batches. Host jest shared/exploratory.

Status łączny: FLOOR_CT_CANDIDATE_VALIDATED_FOR_PINNED_BUILD, zgodnie z takim
kwalifikowanym zakresem. Production_source_changed=false,
new_source_patch_integrated=false,owner_accepted=false. Full_backend_ct,
full_sign_ct,H3_range,global Reach,sampler law,security reduction pozostają false.
