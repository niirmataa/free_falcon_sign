# Next178: actual ternary-top scalar initialization and generator

Verify177 into ENTRY178, and check live processes before starting one Lean.
The next exact obligation is:
  KeygenLevelExec.Exec MakeFgTopShape177.remaining SelectedTopMove177.after out
SelectedTopMove177.continue_body composes it with the actual source prefix.
This is still an execution obligation, not a postcondition to assume.

Closed input facts:
- SelectedTopPrefix177.source: original declarations, all three MKN size
  evaluations, all six pointer bindings and the original memmove.
- SelectedTopMove177.f_image / g_image: the same converted sampler words
  at fs/gs after copying. These are complete1536-word images, not samples.
- SelectedTopMove177.allocated / extent / size_bound / writable: actual
  scratch domains. Its outside theorem preserves all bytes outside the
  destination interval [6776,19064), including static tables and inputs.
- SelectedTopPrefix177.output_cell / logn_cell / n_cell / dn_cell / tn_cell:
  out_ntt1, logn10, n1536, dn1024, tn512.
- Source pointer indices: fd670, gd1182, fs1694, gs3230, gm4766, igm5790;
  all in block31, width4, count71680. The source and destination of the
  12288-byte memmove overlap; the proof uses the pre-call snapshot.

Remaining begins at p=PRIMES3[0].p, p0i=modp_ninv31(p), R2=modp_R2(p,p0i).
Reuse KeygenNinv31.source_exists and KeygenModpR2Exec.source_exists with
actual source scalar calls and the static prime bytes. The latter is a
constructive source-body theorem, unlike a correctness-from-execution rule.
Transport the prime table through the exact memory frame; do not assume
whole-heap equality after the move. PRIMES3[0].p is2147355649 and its g
field is1907584673, from existing source-bound STATIC facts.

Next are KeygenLevelCalls.Call .generate for modp_mkgm3, then .forward
for each of fs and gs, followed by R3 and512 paired triple products.
The generator body is KeygenMkgm3Program.code; the forward body is
KeygenNttForwardPrograms.forwardBody. Existing KeygenMkgm3Assembly and
NTT correctness lemmas largely require source execution as an input;
inspect exact types and construct that input. Public16-bit NTT execution
proofs cannot be substituted for these32-bit modp judgments. Reuse their
parametric construction methods and the valid common scalar/memory facts.
Actual out_ntt1 excludes the last inverse branch only after the full body
has been constructed. Then remain the nine original make_fg_step calls,
CRT/Bezout/carry tests, intermediate/depth0/root validation and the final
certificate/codecs before the emitted witness for corrected law134.

Parser trap resolved in177: reducing the entire original parser during
shape equality exceeded kernel memory. MakeFgTopBytes/Lex/Normalize/Parse177
prove exact staged equations. MakeFgTopShape177.parsedCode is proved equal
to the original code; remaining uses drop13 of this normalized parse.
Use that interface and LevelPrefix177.partition, rather than unfolding
KeygenMakeFgTop.code again. No parser or C semantics changed.

No concrete Z>0, numerical p_accept, coding bound or p_K is yet available.
No IID/D1/F04/measurement premise; paper remains measured and exactly five
do_sign items remain unchanged. Standard limits, one proof job, retained
failures,0/0 accepted logs, local commits and postseal; no push.
Last proof job235 is the full audit; next unused numeric suffix236.
