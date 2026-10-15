# GS numerical certificates after155

Verify the155 receipt/postseal into the next ENTRY_PINS and inspect live
processes. Actual GS computation is complete up to the exact comparison;
do not restart source helper loops. The remaining target is
`SelectedGsNorm155.NumericalObligation`, and the accepted endpoint will be
`SelectedGsNorm155.after`. `accepted_of_comparison` supplies the original
GS relation; `norm_prefix` also includes the proved raw gate153.

Use the pinned auxiliary candidates from
`.build/jobs/keygen_gs154_009/GS154_CANDIDATES.json`, SHA256
dcc03ce308ed26ab1e17578ec0884e3d0487d716df97877ccabeb37ae22b987b.
Job155_008 independently compares9985 native C words with these candidates;
its CONTROL155.json is auxiliary, not a proof premise.

Recommended bounded certificate chain:

1. Generate a balanced WordTree153 literal vector for the768 inverse-norm
   words and prove it equals `SelectedGsInvNorm154.values`. Each source
   value uses four exact squares, three additions and the source-certified
   FprInvFast154/FprDivFast154 word operation (55 rounds, not a state evaluator).
   Start with a bounded probe and retain every failure; do not raise limits.
2. Certify the adjoint/scaled1536-word vectors or directly rewrite the
   corresponding `GsMapLoop155.image` formulas. The scale word is now
   source-certified by FprOfModulus155. Use the proven inverse-vector
   equality when certifying the two final mul-autoadjoint vectors;
   `GsAutoValues155.pointwise` already eliminates the768-step update recurrence.
3. Rewrite `SelectedGsNorm155.sumWord/finalWord` to the certified final
   vectors, check1536 ordered transitions against the1537-point norm trace
   using NormTrace153, prove its endpoint and final double, then decide the
   original comparison against GeneratedBound135.finalWord in the kernel.

The candidate norm word4736654857535133486 is not yet a theorem. Do not
replace the exact word comparison by a real-arithmetic estimate or native
comparison. The old raw norm's direct whole-expression memory failure151
is a warning against repeating that route, not evidence about this gate.

Source state facts available: SelectedGsAuto155.f_image/g_image/r_image;
SelectedGsNorm155.images/heap/norm_cell/bound_cell/comparison. All caller
bindings and intervals are already derived; no numerical snapshot may be
substituted as a source premise. Preserve the full original rounding order.

GS acceptance remains intermediate to the selected solver, final packet,
certificate/codecs and positive seed mass. Population acceptance and
conditional coding remain separate goals. Corrected134, frozen110 history,
measured paper wording and five do_sign items stay unchanged. One Lean
process, standard Sage,0/0 accepted logs, retained failed jobs, local commits
without push and postseal remain mandatory.
