# H3_INITIAL_TARGETS — dokładny zakres

Autor projektu: Niirmata. Source pin56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985.
GCC14.2/C99/Linux LP64, fixed q18433/logn10/ter1, active FPEMU.

```
forall E,sk,pk,p,c,memory,
 Emitted_CANDIDATE(E,sk,pk) -> SameSTATICDecode(sk)=p ->
 NormalizedExpansionCertificate(p,memory) -> CanonicalChallenge(c) ->
 LegalTargetBuffers(memory,c) ->
 DefinedTerminatingAtTargetCut_CANDIDATE(p,c,memory) and
 ExactSourceTargetWords(t0,t1,ni) and UniformInitialTargetDomainsAndErrors
 and NormalizedKeyPreserved and TargetPrefixFrame(memory).
```

Canonical c to WSZYSTKIE0..18432 values,1536 uint16/integer entries; nie
centered residues, uniform challenge lub future norm-accepted Sign.
Cut: po1892, bezpośrednio przed ffSampling_fft3:1897. Exact formulas i dwie
independent reference layers są w TARGET_FORMULAS/ERROR_LEDGER. Source
rounding-only errors<2^-13/2^-24; pełne ideal errors<1/4 i2^-13.

Status: **H3_INITIAL_TARGETS_PROVED_FOR_EMITTED_PINNED_MODEL**.
Proof kind: MIXED_KERNEL_AND_UNIVERSAL_ANALYTICAL_SOURCE_PROOF;
initial_targets_fully_kernelized=false,C_compiler_verified=false.
Actual numerical/operation/frame instancję domknięto jawnie; nie tylko
generic composition theorem lub finite controls.

Caller binding obejmuje legal entries i canonicality po defined H2P return.
Obejmuje też legalny entry po norm-rejected attempt bez przyszłego Q<B;
propagation przez nieudowodniony sampler/postprocessing pozostaje osobne.
Initial targets nie są scalar mu. ORDERED_REACH→NumericCenter, global H3
range, whole sampler/Sign termination/law, security i CT całości są open.
ZERO_SCALAR nie służy do uzasadnienia swojej własnej premise.

source_changed=false,production_source_changed=false,
new_source_patch_integrated=false,owner_accepted=false. K_seed/M0 bez zmian.
