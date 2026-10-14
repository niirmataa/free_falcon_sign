# 121 — actual get_rng_u64 and complete MODE1 source computation

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**. The continuous three-point
program remains ACTIVE / NOT COMPLETE. This is not the complete chosen-seed
KeyGen witness, Z>0, a numerical acceptance bound or a conditional coding bound.

`KeygenRngCompute121.draw_sound` constructs the ORIGINAL
`KeygenRngSource.Call`: checked freshness, allocation of the actual uint64
temporary, actual120 shake_extract, Load64 of those same bytes, and disposal
restoring the original object. The source FALCON_LE_U path declares uint64_t r,
so this aligned read is distinct from the bytewise dec64le helper. A fresh
block identifier is checked against memory; no random-word oracle is used.

The scalar normal fragment constructs original modular-source executions.
Physical16-bit writes use original Store16 with allocation, width, writability,
two byte stores and frame. MODE1 tail computation executes cast/mask, shift,
rbits decrement, comparison, rejection or coefficient store and break. Refill
uses the actual RNG call and the declared rb type, then assigns rbits64.
Inner and outer loops preserve rejection chronology and the x lexical scope.
The complete prologue resets rb/rbits on each function call.

`KeygenSamplerLoops121.run_sound` yields original KeygenSamplerSource.Exec;
`KeygenSamplerInvoke121.invoke_sound` supplies actual parameter Bind/Call;
`KeygenSamplerContext121.invoke_sound` additionally checks the real fk pointer
and object legality, resolving the embedded RNG at its source layout. Caller
fields other than heap are restored. Fuel None remains only absence of a
checked finite witness, never a proof of nonreturn or source failure.

Six closed kernel controls exercise two consecutive two-coordinate calls.
The first prebuffered word11 rejects low bits3, then produces[1,-1]; the next
call discards unused local bits and reads word1 at the SAME SHAKE cursor8,
producing[0,-1] and cursor16. The temporary is fresh again after disposal.
Both calls have original source witnesses. This deliberately small control
is not the1536-coordinate selected-seed sample, and supplies no probability
claim or independence assumption. It checks the sensitive per-call reset/
shared-stream boundary explicitly.

Nine mathematical modules plus audit form a coherent10/10 clean closure.
Final keygen_sampler121_009 checks50 named declarations, full term/type DAG
roundtrips and only propext/Classical.choice/Quot.sound, logs0/0. Nine jobs,
five failed/mixed, retained with causes: a rewrite targeting the wrong heap
projection, an already-eliminated skip equality, a reserved local keyword,
one dependent build queued before its failed prerequisite was inspected,
and argument order in the existing Bind theorem. The failed dependent import
was a scheduling mistake, not loss/change of a frozen artifact. The first
patch for the last issue also failed its text context and was retried by an
exact source/JSON edit. No limits, lint or proof checks were weakened.

Entry verified29262pins from120. Parent postseal:
f75e98b4654ae3111275aee1dfd56cade8596aa8a5a0c299c88597d734f94793.
121 ENTRY_PINS:e144af2f5afcd022c1f412e67ca3c57464b0fb051ca572f333946975fc74de2d.
No new numerical/Sage experiment was needed for these source proofs and
kernel controls. Next: concrete selected-seed refills and full f/g execution,
with normalized state certificates, then the complete canonical caller/domain,
public seeding/readiness, gates/solver and final packets. All remain named
obligations in the original program; the exact order can follow dependencies.
No IID, F04 substitution, measured-paper change, production edit, push,
schedule, migration or independent review; five do_sign items unchanged.
Continue after postseal.
