#134 — corrected whole-source law after the missing sqrt repair

2026-10-15. PROVED_KERNEL_SCOPED_SOURCE_REVISION / NOT_REVIEWED.
Original three-point program ACTIVE / NOT COMPLETE. No complete seed9
source witness or unconditional positive Z/p_accept/p_K bound is claimed.
This explicit version replaces the incomplete110 interpretation for further
success-witness work; frozen110/111 and131's old-law Z=0 theorem stay intact.

The only source-relation change is133's bound initialization using132's
source-bound fpr_sqrt call. The downstream source path is explicitly
re-proved through sampled gates, bounded attempts, loop, solver/certificate,
encoding, emitted-byte contract and decoded key/public model. Unchanged
input/domain/data types and source interfaces are reused. Attempt cap,
return0 branches and encoding failures remain part of the game. No source
postcondition, independent-attempt law or measured success frequency is added.

New concrete definitions and principal consumers:
- KeygenByteGame134.evaluate: finite source execution or absence thereof,
  on the same fixed caller and uniform32-byte seed domain.
- KeygenProbability134.law/successMass/successfulLaw: normalized finite
  pushforward, explicit failure/no-return accounting and conditioning.
- KeygenSourceToFiber134.emitted_to_actual_fiber and actual_observed_fiber:
  emitted source material/certificate/fiber and byte observations.
- KeygenModelLaw134.pointwise/raw_binding/conditioned_binding and
  KeygenModelBinding134.identify/binding/package: decoded joint model binding.
- KeygenSuccessMass134.success_lower_of_witness: GIVEN an actual new source
  success, Z>=1/2^256. This is still a consumer, NOT its missing instantiation.
- KeygenFirstMass134.first_attempt_bound/quantitative: actual first-event
  monotonicity/product, with explicit acceptance/coding mass premises.
  No geometric renewal formula, IID or F04 signing marginal appears.

KeygenExecutionEmbedding134 gives structural ternary/gate/sample/attempt/
loop embedding; whole_out/whole_failure preserve complete source outcomes.
observed preserves emitted/failure observations, and old_some proves every
previously DEFINED109 seed result has the identical134 result. No assertion
that old none stays none, no equality of laws, and no converse embedding.
source_execution/of_source provide concrete witness APIs for the new game.

Dependency exporter002 reads actual elaborated types/bodies (diagnostic
metadata only).407affected reachable constants belong to220explicit source
declarations in57modules. Seven replacements were already proved in133;
54candidate modules carry213revised declarations, plus one necessary new
local-frame helper and13structural embedding declarations:227total across
55math modules. Every candidate was elaborated and kernel-checked; metadata
or mechanical name replacement is never substituted for those checks.
Recipe and exact original/current hashes in SOURCE_REVISION_PLAN.json;
initial and pre-open-fix plans retained. Generator leaves frozen files intact.

Final009 audit55/55 isolated processes,55math+55audit=110/110 coherent clean
modules,227named declarations; full DAG roundtrip and kernel-safe definition
rechecking at original declared types. Allowed propext/Classical.choice/
Quot.sound only, logs0/0. Collection 418179c4674e992594fe83a6adc89e8345f33638ff159c61ad3dd46557d0975f.
Nine jobs, four failed/mixed001/003/005/007 retained with causes: diagnostic
IO name, missing extended local-frame helper, ambiguous old/new namespace
opens, and dependent-case binder names. Successful003/005 prefixes retained.
Source commits8440bbc5,ccb8b5f4,292d7b39; no push or independent review.

ENTRYf36b1433097540eb8116f353f896bdbe9e2afca006d8ea6d0b974aa4ab52aa44
verified133post67dbc1567adab964708f3ad847575caf07ca6bfcc517a9a8e05180e94d12a421.
Next resume exact seed9 after both source resultants at
NormalizedSamples129.after, under new134. Full bound assignment, raw/GS,
public computation, solver, certificate and coding execution remain to be
constructed. No probability lower bound is obtained merely by defining134.
Paper stays measured; exactly five do_sign obligations unchanged; no new
worker/reviewer/relay/schedule. Continue until the owner program is resolved.
