# source3 — żywy rejestr luk STABLE_TOP_001

Zakres: przypięte `ft_stable_top_branch_keygen`, falcon-keygen.c7516–7542,
SHA256 `0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf`.
Konsumowana zależność: STABLE_BINARY_004 PROVED_KERNEL_SCOPED / NOT_REVIEWED.

Domknięty pierwszy obowiązek: `FprOfThree.source_exists/source_exact`,
source fpr_of(3) z C M0 fpr_scaled i norm/FPR, dokładne słowo
`0x4008000000000000`. Kernelowe source binding + bridge, Sage exact
cross-check; pozostaje NOT_REVIEWED.

Otwarte typy/cel:
- trzy source-bound binary256 z zachowaniem Legal następnej gałęzi;
- ∀ legal before, ∃ reference execution; reference execution→ten sam
  operational heap/metadata/trace; source frame/roots/sticky/no-fallback.

Parser całego helpera, niezależne Step/Body/Loop, exact Expr bridge i
pętla u=3*v256 razy mają kernelowe eksporty `StableTopSyntax.pinned_source`,
`StableTopBodyBridge.loop_complete`, `StableTopLoop.loop_exists/filled_all`.
`StableTopMemory.Legal` wymaga reads tylko dla roots i bad; zapisy pętli
wyprowadzają pełną inicjalizację leaves. `StableTopEffects`/`StableTopAtoms`
przenoszą Legal, byte frame, sticky oraz clear→good checks w pętli.

Warunki pamięciowe nie przyjmują positivity roots, Gram, exact leaves ani
delty. Leaves i scratch nie wymagają initial reads. Pełny certificate,
reverse reciprocal, real-error FPEMU, FFT/exact Gram, KeyGen, T5, M6 oraz
C Sign pozostają dalszymi obowiązkami. Aktualny etap nie zmienia parametrów C.
