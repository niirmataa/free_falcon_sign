# KEYGEN_STEP_ASSEMBLY_193 — first-prime step assembly keeps (window 2026-10-20)

Checkpoint 193 closes the SelectedStepInverse192 export follow-up: the s3
product-output hypotheses are discharged at the step assembly. The fs
image and the igm twiddle reads are kept through the copy and product
writes (separation of the fs/gm/igm regions from the t1/fd walk
positions), the product-output caller frame comes from the kept
executions, and the stage statement `KeygenMakeFgSource.Exec
MakeFgTailShape190.s3 out after` and the composed prefix execution
`Exec tailPrefix base ⟨after,.normal⟩` hold unconditionally at the
assembled product output (SelectedStepChain193.source). Whole owner goal
stays ACTIVE / NOT_COMPLETE; the package stays IN_PROGRESS /
PARTIAL_PROOF / NOT_REVIEWED.

## Entry obligation

Before any new proof work the sealed checkpoint192 closure was verified:
POSTSEAL_192 (`3c31e461…`) and the sealed receipt KEYGEN_STEP_INVERSE_192
(`4a7edbb5…`) against their external pins in
KEYGEN_STEP_INVERSE_192_PINS.md, all 73379 inherited paths re-checked
(0 missing, 0 changed) into `.build/stepassembly193/ENTRY_PINS.json`
(SHA256 e18c761266abdd1b346efa4ef6e2caedeab1f897e3801b785b470a6f8ba97335),
and no active owned job/Lean/Sage process confirmed. The failure ledger of
checkpoint192 (58 register entries, 57 failed/mixed jobs retained with
causes) is untouched and stays in the inherited pins.

## What is proved (values as executed words only)

- `StepCopyKeep193` (job 460): the original fs-to-t1 copy loop with one
  additional tracked read image — every image loaded from cells separate
  from the t1 walk survives all 512 copy writes (the write cell is
  `elem t1 v`, kept by `Word32Memory176.outside` at each iteration, with
  the loop invariant threading of StepCopyLoop190 reused unchanged).
- `StepProductKeep193` (job 461): the original pair-product loop with two
  additional tracked read images — images separate from the fd walk
  survive all 256 product writes (`addr fd 0 v 2`), again through the
  unchanged StepProductLoop191 invariant.
- `SelectedStepChain193` (job 465): the step assembly. The igm twiddle
  reads are taken as the actual executed load words at the selected seed9
  state (`tws` from SelectedGen0Frame189.igm_read, no table law), kept
  through the copy and product; the copied fs image is kept through the
  product; and every product-output hypothesis of the sealed s3 theorem
  (SelectedStepInverse192.source) is discharged at the assembled product
  output: the u/slen/logn/ter/in_ntt/p/p0i cells, the fs/igm bindings,
  fs writability, the fs/igm capacities, the fs and twiddle separations
  (`walk_fs` to `elem fs`), the fs image and twiddle loads, and the
  locals/arrays caller frame from the kept executions. The composed
  statement `Exec tailPrefix base ⟨after,.normal⟩` runs s0 (copy), s1
  (skipped !in_ntt), s2 (products) and s3 (inverse call) in one execution
  at the actual selected state.

The exported image records the transformed fs words as the executed
modp_add/modp_sub/modp_montymul/modp_R/modp_div word terms
(NttInverseWholeBridges192.scaledWord) over the copied fs image
(SelectedStepProduct191.fvs), with the caller locals/arrays frame outside
v/x.

## What is NOT claimed

No transform property, table law, root law or positivity claim; no NTT
property and no Z>0 statement. The prospective corrected134 bound stays
Z>=2^-256>0 and is NOT a theorem established by 193; only the complete
emitted source witness can instantiate the corrected134 consumers. Paper
wording stays measured 8192/23628 with the separate 256/739 control. No
IID/D1/F04/empirical premise; exactly five do_sign items remain. No
independent-review claim; no push.

## Jobs and records

Jobs 459-466: three accepted clean modules (460, 461, 465; logs 0/0,
standard axioms), the accepted audit job 466 (3 audit modules, 26
declarations, full DAG/kernel roundtrip, logs 0/0), and four retained
workshop failures (459, 462, 463, 464) with recorded causes in
KEYGEN_STEP_ASSEMBLY_193_FAILURES.json. No controlled cancellation; no
limit increase. The checkpoint192 ledger keeps all 57 failed/mixed jobs.

## Open obligations

The gs copy/products/inverse path s4-s7, the false !out_ntt branch s8
(its body is the fd/gd inverse pair at logn-1 = 8 and tlen = 2 — a
different instance of the corpus needing a logn-8 control variant of the
prologue size lemma), the outer u++/final guard tail, both CRT calls and
the additional-prime part (slen1/tlen2), the remaining d-levels and the
root/certificate/codec path stay OPEN. Unconditional Z>0, numerical
p_accept, conditional coding and positive p_K remain OPEN. Old110 stays
frozen. See KEYGEN_STEP_ASSEMBLY_193_NEXT_ROUTE.md for the exact resume
obligation.
