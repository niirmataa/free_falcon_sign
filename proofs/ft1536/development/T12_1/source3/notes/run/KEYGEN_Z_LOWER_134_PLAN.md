# Z_LOWER_134 — analytic Z > 0 and bounds window (plan)

2026-10-17. Owner window "ANALITYCZNE Z > 0 I BOUNDY (zamiast kernelowego
swiadka)". Base: HEAD after the 159/159B batch, `KEYGEN_SUCCESS_BIG_TODO.md`
and the corrected law 134. Budget: 3 windows for the whole task, hard
anti-loop rule: on growth STOP with a re-scope; stop-and-report only at a
real integrity wall. Kernel proofs only (no shortcuts), no interpreters, no
premium strengthening, standard axioms, Sage with the standard preparser on
exact ZZ/QQ, small local commits without push, postseal per step, failures
retained with causes.

Goal: prove P(first attempt succeeds) >= epsilon > 0 for the real KeyGen
analytically from the sampler law, then via the proved first-attempt
inclusion (a996e1e6, `KeygenFirstMass134`) get Z >= epsilon > 0 for
`KeygenProbability134`, consumed by `KeygenSuccessMass134` /
`KeygenModelBinding134.package` (positive_iff_witness). Kernel witness
G(seed*) remains a separate track, after the thesis.

Steps:

1. MODE1 coefficient law for f,g from the sampler execution/sources
   (per-coefficient marginal; NOT F04, which is a different family -
   its audited theorem is signing-challenge uniformity). If the sampler
   deviates from the assumed distribution, compute the deviation explicitly
   and bound it; do not skip it.
2. Acceptance-region probability: bounds 1/1/2047/2047 + fG-gF=18433
   (resultant gates) + auxiliary conditions => epsilon > 0 (target >= 1/4;
   otherwise the best honest bound with a proof).
3. Coding bound | acceptance, from the failure-path structure of 134 =>
   the final epsilon for the whole call.
4. Z >= epsilon > 0 as a theorem consumed by KeygenSuccessMass134 /
   KeygenModelBinding134.package. The measurement 8192/23628 is a
   consistency control, never a premise.

Deliverables: `KeygenMode1Law134` (step 1), `KeygenModelUnlock134`
(step 4 consumption chain), `keygen_zlower134_controls.sage` (auxiliary
exact controls), audit `KeygenZLower134Audit`, report
`KEYGEN_Z_LOWER_134_REPORT.md` with the step table, the exact epsilon with
declaration names and three sentences.
