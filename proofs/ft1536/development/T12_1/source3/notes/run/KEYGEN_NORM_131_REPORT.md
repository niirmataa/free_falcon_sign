#131 — frozen reference omission forces zero success mass

2026-10-15. **PROVED_KERNEL_SCOPED_DIAGNOSIS / NOT_REVIEWED**.
Original owner program NOT COMPLETE. No positive whole-KeyGen witness or
numeric p_accept/p_K bound is claimed. This report concerns the FROZEN MODEL,
not the real C implementation and not its empirical success frequency.

Actual C bound initialization calls fpr_sqrt in falcon-keygen.c7958–7959.
FprPrefixCalls.lookup has no sqrt entry; its fallback C99Frontend.lookup also
has none. KeygenSearchExec.ScalarCall only separately handles fpr_rint.
`FprSqrtMissing131.no_call` proves the sqrt source-call relation uninhabited.
The actual parsed boundCode has the missing call on its mandatory path:
`bound_blocked`, `no_bound_execution`, `no_norm_execution` are kernel-closed.

`KeygenFrozenNoSuccess131` propagates this through the original constructors:
ternary/gates/sampled/attempt paths can only continue; no source loop reaches
normal exit; no whole trace emits a packet. Exports `no_packet` and
`unsuccessful` apply to every env/input/seed in the frozen game109.
`success_mass_zero` proves KeygenProbability110.successMass env input=0 for
EVERY env/input; `successful_law_none` proves its conditional successful law
is none. Consequently Z>0 for THIS exact110 definition is impossible without
changing the source interpretation. No lack of testing or loose bound is
being presented as this conclusion: it is a kernel theorem about that model.

This does NOT prove that C fails or that its success probability is zero.
Native113 seed9 success remains finite evidence;129 complete source f/g and
130 both source resultant gates remain valid, sealed and unchanged. Earlier
conditional whole-success contracts remain logically valid, but this missing
callee makes their success hypothesis unreachable in the frozen spine.
The old description of110 as fully actual source coverage must therefore be
qualified; it cannot be used as the completed real-C binding.

Final005 audit2/2;2 mathematical +2 audit modules=4/4,20 named declarations,
full DAG/kernel type/axiom checks, logs0/0; allowed axioms only standard
propext/Classical.choice/Quot.sound. Collection SHA
d89e3698f51d0005b9670000454b728ad8d55442ffeedb091de7517f8d6c9616.
Five jobs, two failed001/003 (name-inequality simplification and a finset lemma
spelling), both retained with causes. No source semantics or limits changed.
Entry verified36196pins from130 postseal
06a3f8d68c1cd417aa075a93d5eb2a4973fe42426e280e46f9eaf875fde9dcb6;
ENTRY1315e3a09f4f69bff69d67108d81ea692f008c28a8323b0f404f2fcf95bad604a96.

Required direction: explicit source-body sqrt closure and a versioned repair
of the affected whole-law spine, preserving old finite observations but not
claiming equality with110. Concrete scope is in KEYGEN_NORM_131_REPAIR_PROPOSAL.md.
No frozen file has been changed, no repair applied, no push/new worker/review
or schedule. Paper remains measured; five do_sign obligations unchanged.
