# Continuation after raw-norm acceptance153

Verify POSTSEAL_153 and the receipt into the next ENTRY_PINS before starting
another proof stage. Inspect processes and receipts; one execution job and
one Lean process at a time. Preserve every failed attempt and frozen input.

The exact seam is `SelectedNormGate153.continue_gs`. Its remaining argument is
`KeygenAttemptNorm133.GS KeygenFullData127.env.ctx SelectedRawNorm151.after out`.
`KeygenAttemptNorm133.GS` abbreviates `KeygenAttemptNorm.GS`; the latter is
defined in `KeygenAttemptNorm.lean`, not a file named KeygenGSFrame. The
existing `gs_frame` there is a conditional preservation theorem, not a
concrete successful GS execution.

Follow the original source operations in order:

1. `falcon_poly_invnorm2_fft3(rt3, rt1, rt2, logn, 1)` followed by both
   adjoint calls, using `KeygenAttemptNorm.headCode` and the old source
   execution relation required by GS. The inverse-norm loop has 768
   iterations and writes only the real half of rt3.
2. Both scaling calls through `KeygenAttemptFft.Call`, including the exact
   source `fpr_of(18433)` argument. The header alias maps
   `falcon_poly_mulconst_fft3` to `falcon_poly_mulconst3`.
3. Both `falcon_poly_mul_autoadj_fft3` calls, original zero/ordered norm
   accumulation/double and original comparison, through `tailCode` and
   `KeygenNormFrame.Gate`.

The inverse-norm expression groups the two a squares, the two b squares,
then adds those results before `fpr_inv`. Preserve this exact rounded word
order. Source division is already covered by FprDivRound/Suffix/Total,
C99DivLoopBridge/WhileProof/Sound and related modules. Inspect and reuse
these statements before adding an efficient explicit word adapter; do not
reprove division totality or replace it by real-number division. Subsequent
finite candidates must be tied to the actual source images and checked in
the kernel, as in153.

Reuse the generic operation, memory-frame, loop and trace lemmas. Prove one
parametric body rule per new loop family, then instantiate it. Check table
and scratch separation, actual logn=10/full=1/n=1536, caller bindings and
scope restoration from the actual state. Do not silently replace that
state with a native snapshot. The paired certified FFT vectors are now
available through `SelectedNumericFft153.images`.

GS acceptance is not the final witness. Continue later through solver,
emitted bytes/certificate and codecs, then instantiate the seed-atom mass
lemma for corrected law134. Population acceptance and conditional coding
remain separate obligations; neither follows from this one successful
raw-norm comparison. Do not use F04, IID, D1, measured acceptance as a
premise, or the geometric cap formula. Five do_sign items and measured
paper wording remain unchanged.
