# Next182: actual 32-bit forward NTT calls in ternary-top

Verify181 into ENTRY182 and inspect live processes before one Lean job.
The selected generator is now COMPLETE, not an execution premise:
  SelectedGeneratorCall181.source : KeygenLevelCalls.Call .generate
    SelectedTopInit178.after TopInitShape178.args SelectedGeneratorCall181.after
Its complete body is SelectedGeneratorTop181.body_source and the actual
void return uses ReturnValue.voidEnd. This is the selected logn10/full1,
first-prime invocation, not a claim for all generator parameters.

Start at SelectedGeneratorCall181.after. The next exact obligation is:
  KeygenLevelExec.Exec TopInitShape178.remaining SelectedGeneratorCall181.after out
SelectedGeneratorCall181.continue_top composes it into the original
KeygenMakeFgTop.code. This remaining body begins with the two forward calls,
then R3 and the paired triple-product loop, then the inactive inverse branch.

Closed inputs:
- SelectedGeneratorCall181.forward_table is the full source-derived
  KeygenMkgm3Table.Initialized gm table, all1024 canonical cells.
- both_initialized and SelectedGeneratorFrame181.g_read/i_read give actual
  reads from all1024 cells of BOTH gm/igm buffers, including index0.
- SelectedGeneratorFrame181.f_image/g_image preserve the same1536-word
  converted sampler images at fs/gs through the whole generator call.
- sizes and bytes preserve actual allocation metadata and all other blocks
  or block31 offsets below19064. Caller locals/arrays are retained by Call.
- Actual views in block31, width4, count71680: fs1694, gs3230, gm4766, igm5790.
  logn10, out_ntt1, p2147355649, p0i and R2 are the source-bound caller slots.

Use the normalized parser interface from177: TopInitShape178.remaining,
LevelPrefix177.take/partition and LevelSequence177.drop. Do not recompute
whole original parser equality; that caused the earlier memory failures.
The original calls are modp_NTT3(fs,gm,logn,1,p,p0i) and the same for gs.
The parser's checked stride-one macro expansion inserts the literal1 into
KeygenLevelCalls arguments. Bind the actual .forward call (not the separate
KeygenLevelNtt.Call relation with a different argument representation).
Its parameters are a pointer, uint64 stride, gm pointer, uint32 logn/full/p/p0i.

The complete source body is KeygenNttForwardPrograms.forwardBody:
- prologue: declarations, false logn==0 guard, n1536/hn768;
- firstPass: gm[1],768 first butterflies, advancing r1/r2;
- intermediatePass: eight doubling rounds, t768 down to3;
- triplePass: full1,512 triple butterflies.
All four parts and their glue are already source-bound. Existing NTT
correctness lemmas generally CONSUME Exec; construct the execution rather
than treating those lemmas as totality. Reuse the parametric construction
methods and common scalar/index facts from public159-174, but those16-bit
public judgments cannot replace these32-bit modular judgments. Leaf
modp_add/sub/montymul and modp_R2/div have source-existence proofs.

Build one reusable execution theorem for the selected profile and apply it
to both buffers. Preserve the second input and gm table while transforming
the first. Coarse array footprints extend to the entire scratch descriptor;
a precise frame on the1536-word destination interval is needed to keep gs
and the tables in the same block. Word32Memory176, initialization monotonicity
and explicit loop ranges can supply that frame. First use of each source
butterfly should be parametric, not hundreds of separately certified runs.

After both forward calls: original R3 assignment,512 paired Montgomery
triple products and inactive inverse branch; then nine make_fg_step calls,
CRT/Bezout/carry tests, intermediate/depth0/root validation and certificate/
codecs before the corrected134 emitted witness. Full source generator
completion does NOT prove the full KeyGen witness or a positive probability
bound. Old110 stays frozen; measured wording and exactly five do_sign items
remain unchanged. No IID/D1/F04 or empirical premise.

One job111 process, standard limits, retained failures,0/0 accepted logs,
small local commits, postseal and no push. Audit287 is final if its receipt
confirms PASS; inspect it before choosing the next unused suffix288.
