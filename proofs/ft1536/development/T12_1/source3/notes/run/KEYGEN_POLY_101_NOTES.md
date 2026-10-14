# 101 — actual polynomial and scaled-bigint helper closure

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**; whole task
**ACTIVE / NOT COMPLETE**. Parent POSTSEAL100:
`6c162fc55ee4283c166d7331480d263e154f72fe3207a6a7e32fe7b8593f5203`.

Finite defined execution is unique for actual zint_get_top, both scaled
bigint leaves, polynomial max-bitlength and big-to-FP conversion, quadratic
subtraction and NTT-assisted subtraction. Every source part passes its
concrete arity checker, and existing source parser witnesses are retained.
The backward pointer argument keeps its two actual operations. The nested
scaled store executes the actual extraction and fixed FPEMU function.
No expected arithmetic answer or callee postcondition is assumed. The
NTT helper theorem uses the actual body; its caller binding is composed
at the intermediate call table in the next stage.

Final replay keygen_poly101_004: six modules including full audit of 54
mathematical declarations, logs0/0, standard axioms only. Four jobs include
two failed elaborations: a folded-chain change mismatch and missing
exposure of the already proved FprPrefixCalls deterministic table to the
automation. Both retained with causes and original sources/logs; no source
semantics or resource weakening. Author self-review, not independent review.

Next: concrete intermediate source arities and call, deepest/root solver,
certificate/codecs and complete capped loop. Fixed caller/entropy boundary,
nonreturn, actual producer/law/model binding and normalization/positivity
where required remain open. Five do_sign obligations unchanged. No push,
migration, production C edit, reviewer, stages import or actual-C e2 claim.
