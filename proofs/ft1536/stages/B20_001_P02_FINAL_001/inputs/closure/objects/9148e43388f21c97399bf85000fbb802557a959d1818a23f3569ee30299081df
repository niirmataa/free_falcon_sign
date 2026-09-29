# Dokładna teza H3_RAW_ASSEMBLY

Autor projektu: Niirmata. Pin źródeł56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985.
GCC14.2/C99/Linux x86_64 LP64, fixed q18433/logn10/ter1, portable FPEMU.

```
forall p,memory,
 P_key(p) -> LegalRawExpansionBuffers(memory,p) ->
 TerminatesDefinedAtRawPrefix_CANDIDATE(p,memory) and
 BasisWords = SourceFFT_B_CANDIDATE(p) and
 RawTreeWords = AssembleActualSourceSnapshots(
   RootSlice(p),Node3Slices(p),Node2Slices(p),RemainingInner7Trees(p)) and
 RawTreeLength=18432 and
 All16896InternalWordsFinite and All1536RawLeavesPositiveFinite and
 CorrectSourceOrderAndFrame(memory).
```

P_key jest niezmienione: cztery Int^1536 vectors, ternary f/g, F/G caps2047,
exact NTRU w Phi i actual Gate00_C. Legal buffers i momenty snapshots są
zdefiniowane w MEMORY_LAYOUT/COMPOSITION. Żaden completed prefix, positivity
przyszłych pivots lub domain samplera nie jest dodaną przesłanką.

Następnie dla legalnego E i abstrakcyjnych finite bytes sk/pk:
Emitted_CANDIDATE(E,sk,pk), SourceDecodeSameSTATIC(sk)=p i Legal buffers
implikują ten sam wniosek przez odziedziczone pełne emitted→P_key binding
i nowy source transport. Jeden K_seed[E] i istniejący p_K pozostają.

Status: **H3_RAW_ASSEMBLY_PROVED_FOR_PINNED_MODEL**.
Proof kind: MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF.
Wszystkie przesłanki actual numerical/totality instancji są rozliczone;
raw_prefix_fully_kernelized=false i C_compiler_verified=false. Kernelowe
generic composition/counts nie są samodzielnym uzasadnieniem tego statusu;
COMPOSITION zamyka ich actual source/domain/frame instancję.

Cut jest po powrocie ffLDL_fft3 w1253, PRZED stable rebuild/normalize.
Raw leaves są source subtractive pivots, nie stored normalized widths.
normalized_expansion_proved,full_private_loader_proved,H3_range_proved,
global_reachability_proved,sampler_law_proved,security_reduction_proved,
full_sign_ct_proved pozostają false. Nie używa się niekwalifikowanego
full_internal_tree_proved dla post-normalize loadera.

source_changed=false,production_source_changed=false,
new_source_patch_integrated=false,owner_accepted=false.
