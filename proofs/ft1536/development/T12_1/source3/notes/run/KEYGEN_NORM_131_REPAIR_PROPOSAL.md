#131 — proposed source-coverage repair and explicit law revision

The frozen law110 cannot meet Z>0: KeygenFrozenNoSuccess131.success_mass_zero
proves Z=0 for every input in that model. This is caused by missing fpr_sqrt
execution, not by the real C success probability. No repair is applied here.

1. Bind the active pinned non-ASM fpr_sqrt body and its header/callees. Execute
   its integer algorithm with original UB guards; no mathematical-sqrt oracle,
   constant-return axiom or observed-output premise. Check the actual sqrt(8)
   use and audit the reachable FPR call-name closure for further omissions.
2. Add a NEW versioned source-call closure containing that body. Preserve all
   frozen definitions/pins. Prove injection of every previously defined call
   and determinism of the extended closure; do not claim old/new laws equal.
3. Version the affected Search/Norm, caller gates, attempt/loop and whole-trace
   spine. Reprove source framing, uniqueness and failure classification on
   that spine. Reuse untouched seeding, sampler, resultant, NTT/certificate
   and codec bodies only through justified interfaces.
4. Define a NEW whole-seed pushforward replacing the incomplete110/111 source
   interpretation, with the same32-byte uniform input, cap and coding-error
   cases. Prove preservation of every OLD FINITE execution/observation. Old
   none mass may become defined in the extension, so equality of laws would
   be false in general. Rebind decoded key/public joint law and conditioning.
5. Resume the concrete seed9 source witness and all three success-mass points
   against the explicitly named corrected law. Transfer generic counting/
   monotonicity lemmas; reprove source-specialized consumers where necessary.
   No IID/F04/geometric renewal or measurement-to-theorem promotion.

This changes the formal source interpretation and the numbered law target;
it is not a silent checker optimization. The old zero theorem and all prior
prefix proofs remain archived and valid in their stated scopes. The paper
stays measured, and exactly five do_sign obligations remain unchanged.
