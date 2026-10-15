# Continuation after the actual inverse-norm call154

Verify the154 receipt/postseal into the next ENTRY_PINS and inspect live
processes before resuming. The new actual caller state is
`SelectedGsInvNorm154.after`; do not restart the raw FFT or inverse-norm
computation. `SelectedGsContinuation154.source` supplies the first original
head call and requests only `remaining` from that new state.

Next prove the two original `falcon_poly_adj_fft3` calls. Their source loop
negates indices hn..n-1; with n=1536 this changes only the imaginary halves.
Reuse FprHeadersFast137.neg_source, word stores, scope frames and generic
loop induction. Then close the two `KeygenAttemptFft.Call` scaling calls:
the header alias is falcon_poly_mulconst3, the argument is source
fpr_of(18433), and the loop covers all1536 words. Preserve actual binding,
normal return and both buffer images. The two mul-autoadjoint calls use
the real768-word rt3 buffer; each iteration writes both a[u] and a[u+hn].

The inverse-norm output is already represented by
`SelectedGsInvNorm154.image`, with exact formula `values` over the certified
FFT literals. Both original inputs remain available through first_image and
second_image. Calls preserve caller locals/arrays by their defined return
state; obtain further byte frames from source footprints or explicit writes.
Do not assume untouched scratch intervals without a frame proof.

After the remaining calls, reuse KeygenNormInduction151/NormTrace153 for the
original ordered accumulation, double and comparison. New source-shape
equalities must identify the GS tail; do not assume its equality to the raw
norm tail. The accepted raw gate153 does not prove this second gate.

Numeric candidates are in job009/GS154_CANDIDATES.json, SHA256
dcc03ce308ed26ab1e17578ec0884e3d0487d716df97877ccabeb37ae22b987b.
They include768 denominators/inverses,1536-word adjoint/scaled/product
vectors and1537 norm trace points. The proposed norm word is
4736654857535133486, the inherited bound word4737176763271429578.
These are FPEMU encodings; no numerical equality or gate acceptance follows
from the auxiliary controls alone. Certify bounded literal chunks using
FiniteWordVector153 and balanced WordTree153, without increased limits or
direct nested-expression retries. FprDivFast154 now gives the source-proved
efficient55-round word formula needed for those checks.

GS acceptance is still intermediate: solver, final bytes/certificate/codecs
and the seed-atom mass instantiation for corrected134 remain. The marginal
acceptance population bound and conditional coding bound remain separate.
No F04, IID, D1, geometric cap formula or measured number as a premise;
five do_sign items and measured wording unchanged. Preserve failures and
0/0 accepted logs, one Lean process, local commits without push and postseal.
