# Continue after both actual FFT calls

1. Verify150 receipt/postseal into the next ENTRY_PINS. Start from
   SelectedFftGComplete150.after. KeygenSmallShape136.remaining is already
   discharged through both FFT calls by continue_norm; do not re-execute them.
2. Read original Extra/c/falcon-keygen.c lines7973-7990 and the corresponding
   FftShape138.remaining AST. Next: norm=fpr_of(0); for u<n, ordered additions
   of fpr_sqr(rt1[u]) and fpr_sqr(rt2[u]); fpr_double; original fpr_lt gate.
3. Use SelectedFftGFrame150.both_images: exact symbolic1536-word rt1/rt2
   images, disjoint spans[0,12288)/[12288,24576), same caller locals,arrays,
   globals,tables,metadata and pinned readonly tables. Existing bound135
   word4737176763271429578 (1250/100 scale) is inherited. Derive gate inputs
   from source cells; do not silently replace symbolic FFT values by native
   bytes. Concrete numerical comparison remains to be kernel-certified.
4. Prove the norm iteration once, with the exact source order and arithmetic;
   instantiate by induction. For numerical certificates, retain explicit
   source-word/image equalities and bounded checks; avoid thousands of
   repeated source executions. No promotion of empirical evidence.
5. Then the original invnorm2/adjoint/mulconst/mul_autoadj calls and second
   norm/gate. Source-fast fpr_div remains open. Solver/certificate/codecs and
   complete synthetic-seed emitted packet witness remain later obligations.
6. Only the complete corrected134 source witness can instantiate positive
   mass; old110 still has its sealed zero-mass diagnostic. No new acceptance
   probability or encoding-bound claim follows from FFT completion alone.

All150 evidence immutable; failures003/005/006 retained. Audit118decl in
33 sequential processes, unchanged checks/limits. Use exact own paths for
local main commits, no push, one Lean job, no new worker, no new schedules.
