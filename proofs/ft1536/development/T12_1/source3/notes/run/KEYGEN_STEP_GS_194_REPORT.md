# Checkpoint194 window R1 — gs path s4-s7 opened, s8 closed (window report)

2026-10-20. Window prompt
`run2/notes/PROMPT_R1_RESUME_005.md`; window frozen at a safe mid-point
with this report (B1 staged-roadmap iron rule 3: one stage per window,
freeze at a recoverable point rather than run into the context wall).

## Entry (obligation 0 of the resume)

Fresh read-only entry verification before any proof work:
`tools/keygen_stepgs194_entry.py` verified POSTSEAL_193
(`.build/stepassembly193/POSTSEAL_193.json`, SHA256
`386e4cbcf8ecee725cec39de9e32e0012d8c0efbdb96b8f0f99fe9a03e964562`)
and the sealed receipt `notes/run/KEYGEN_STEP_ASSEMBLY_193.json` (SHA256
`1d6f11ec19d5b0cb0f1f4ba4be63bd9d74f4800bcef66d55d611a00931b16d3e`)
against their external pins in `KEYGEN_STEP_ASSEMBLY_193_PINS.md`,
re-checked all 73564 inherited pinned paths (0 missing, 0 changed) and
found no active owned job/Lean/Sage process. Receipt
`.build/stepgs194/ENTRY_PINS.json` SHA256
`99ac47a1d981ebfc3afe3c54aac98c02773816faa489682d205682fd31c475b8`.
Integrity facts only; no proof claim.

## Uncommitted-draft recognition duty (prompt step 0)

Every uncommitted draft in `source3/formal/Source3` was brought into the
tree as a small commit with its provenance (nothing removed, nothing left
waiting); the protected `catalog/FT1536_PREMISE_AUDIT_20261011_001.json`
was not touched:

- `34c6e348` — 58 files, the window-170 array-route certificate drafts
  (PublicStagePredicate170_1-8, PublicTriplePredicate170,
  FirstBlockCertificate170_1-3, StageBlockCertificate170_1-8_x,
  TripleBlockCertificate170_0-3, SelectedStageCertificate170_1-8,
  SelectedFirstCertificate170, SelectedNonzeroCertificate170); the
  accepted certificate of that window used balanced finite maps and these
  drafts stayed inactive.
- `59893692` — 6 files, window-126/130 sampler and resultant drafts
  (SelectedDraw126, SelectedResultantBind130, SelectedResultantCachedF130,
  SelectedResultantF130, ResultantSetup130Probe).
- `1826aef0` — 16 files, audit pretty-print dumps and diagnostic probes
  (KeygenKernel129AuditProbe, KeygenSampler129Audit[AuditProbe],
  KeygenKernel159AuditV2Part000/001, KeygenKernel159BAuditV2Part000,
  KeygenKernel191AuditV2Part000-004, PublicGenerateProbe159,
  PublicTailProbe159, PublicTailShapeProbe159, NttInverseShapeProbe192)
  and the `StableTopMemory.lean.sig.json` signature capture.
- `ad637864` — the sealed receipt `notes/run/KEYGEN_STEP_INVERSE_192.json`
  (pinned SHA256 `4a7edbb5...`), whose bytes had stayed untracked while
  the receipts of stages 190/191/193 are in the tree.
- `193fe202` — the window-158 public-input plan, its failure ledger and
  the signed16 Sage control (explicitly not an acceptance premise).

All drafts are committed byte-identical with no build or proof claim;
historical wording and pins are unchanged.

## Closed in this window (proof jobs 467-474)

Accepted clean jobs (logs 0/0, standard three axioms, values only as
executed words): 468, 469, 471, 472, 474. Failed workshop jobs retained
with causes in `KEYGEN_STEP_GS_194_FAILURES.json`: 467, 470, 473. No
controlled cancellation, no limit change, no sealed byte touched.

1. `MakeFgGsShape194` (job 468) — source-bound naming of the tail
   statements s4-s8 by decide against the sealed MakeFgTailShape190
   projections: s4 the gs-to-t1 copy loop (x = gs + u), s5 the skipped
   `!in_ntt` branch, s6 the gd pair-product loop (x = gd + u), s7 the
   active inverse branch with the original
   `modp_iNTT3_ext(gs + u, slen, igm, logn, 0, p, p0i)` call, s8 the
   false `!out_ntt` branch whose body is the fd/gd inverse pair
   `modp_iNTT3_ext(fd/gd + u, tlen, igm, logn - 1, 0, p, p0i)` — the
   `logn - 1` sub expression and the `tlen` stride of both pair calls
   matched the parsed syntax by decide (the pair is the logn-1 = 8 /
   tlen = 2 corpus instance).
2. `StepGsCopyKeep194` (job 469) — the s4 copy loop with the gs-bound
   invariant `FixedGs` and one tracked read image: the gs source words
   stay executed loads of the invariant and any image separate from the
   t1 walk (the igm twiddles) survives every copy write.
3. `SelectedStepGsCopy194` (job 471) — s4 and s5 executed at an
   arbitrary input state: the copy init (x = gs + u), all 512 iterations
   with the exact walked x pointer, the copied t1 image as executed loads,
   the kept igm reads, and the false `!in_ntt` guard as the s5 skip.
4. `SelectedStepOutNtt194` + `NttInverseSizeControl194` (job 472) —
   statement s8 executed as its skip (out_ntt = 1 at this step, so
   `!out_ntt` evaluates false and the fd/gd pair body never runs), and
   the owner-requested logn-8 control variant of the prologue size lemma
   in a separate module: the MKN size evaluation at logn 8 / full 0 is
   256 and the hn halving is 128, mirroring NttInversePrologue192 at
   logn 9. The control is value-free size arithmetic and is not a premise
   of any execution claim; no logn-8 corpus instance is built.
5. `StepGsProductKeep194` (job 474) — the s6 product loop with the
   gd-bound invariant `FixedGd` and two tracked read images (gs source
   image + igm twiddles), and the gd written image as the executed
   `value (gv (2v)) (gv (2v+1)) R2 p p0i` words over the copied t1 image.

## Structural findings recorded for the continuation

- The sealed `StepCopyFixed190.Fixed` / `StepProductFixed191.Fixed` bind
  the array names `"fs"` / `"fd"` in their `fsBinding` / `fdBinding`
  fields, so the gs/gd loops cannot instantiate them; the gs/gd variants
  bind `"gs"` / `"gd"` while reusing the generic body/inc/loop helpers.
- The sealed s0-s3 assembly (SelectedStepChain193.source) exports only
  the transformed fs image and the caller locals/arrays frames at its
  assembled `after` state. The gs source image, the igm twiddle reads and
  the heap writability at that state are therefore HYPOTHESES of the
  gs-path stage statements here (exactly the pattern of the
  SelectedStepInverse192 export follow-up), to be discharged at the full
  first-prime assembly. The fd written image is likewise not exported at
  the 193 assembly; that gap is inherited and recorded.
- Discharging those hypotheses needs bystander-load preservation through
  the inverse corpus's final pass and correction (the middle pass already
  exports it: NttInverseMiddleRounds192.source), then a re-assembly of
  s0-s3 with the extra keeps.

## Open (in order)

1. `SelectedStepGsProduct194`: s6 at the gs-copy output (the product init
   x = gd + u, the 256 iterations, the FixedGd frame) — the keep module
   is ready.
2. `SelectedStepGsInverse194`: s7 (the gs instance of the inverse call;
   the SelectedStepInverse192 Bind chain is fs-hardwired and needs its gs
   twin, reusing the generic entry/Bind helpers and NttInverseWhole192).
3. `SelectedStepGsChain194`: the composed s4-s7 stage statement and its
   export (gs transformed as scaledWord over the gs image, gd written
   image, caller frame), then the hypothesis discharge at the full
   first-prime assembly.
4. The outer u++/final guard tail, both CRT calls, the additional-prime
   part (slen 1 / tlen 2), the remaining d-levels and the
   root/certificate/codec path before the complete emitted witness can
   instantiate the corrected KeygenProbability134 consumers.

Next unused proof job suffix: **475**. Keep one Lean process
(`tools/job111.py`, `-j1 -M6144`), logs 0/0, standard axioms; never edit
sealed 187-193 sources. Retained failures so far in this stage: 3
workshop jobs (467/470/473); the inherited checkpoint192 register (58)
and checkpoint193 register (4) are retained untouched. No push (batch 4
waits for the owner's signal); no independent-review claim.

## Three sentences

Udowodniono: nazwy źródłowe s4-s8 (w tym para fd/gd przy logn-1 = 8),
wykonanie kopii gs s5/s4 z keeps igm, fałszywą ochronę !out_ntt s8 oraz
logn-8 wariant kontrolny rozmiaru prologu — wszystko wartościowo, jako
wykonane słowa. Najbliższy brak: wykonanie s6 (gd product) i s7 (para
odwrotna na gs) oraz montaż s4-s7, z hipotezami obrazu gs/odczytów igm
do rozliczenia przy pełnym montażu kroku. Nic z tego nie implikuje
własności NTT, prawa tabeli, dodatniości, warunkowego Z > 0 ani
p_accept/p_K — te pozostają OPEN; żaden dowód nie mówi też o pominiętej
treści gałęzi s8.

## R1 continuation window (2026-10-20) — s6/s7 and the composed s4-s7 chain closed

Window launched per this stage's `_NEXT_ROUTE.md` (s6, s7, chain +
hypothesis discharge). Entry re-verified read-only before any proof work:
POSTSEAL_193 `386e4cbc…`, receipt `1d6f11ec…`, ENTRY_PINS `99ac47a1…`
(all 73564 inherited pins, 0 missing / 0 changed; no active owned
process). The discharge of the stage hypotheses did not fit this window's
budget and is frozen as the exact next obligation (iron rule 3).

### Closed (proof jobs 475/476/478; logs 0/0, standard axioms)

1. `SelectedStepGsProduct194` (job 475) — statement s6 at the
   SelectedStepGsCopy194 copy output: the product init (v = 0,
   x = gd + u at the u = 0 cell), all 256 iterations through
   StepGsProductKeep194 with the two kept read images (gs source words,
   igm twiddle reads), the FixedGd frame and the written gd image as the
   executed `value (gvs (2v)) (gvs (2v+1)) R2 p p0i` words over the
   copied t1 image. Sources `5c61b378`, olean `fa38bf7a`, commit
   `8c6b8784`.
2. `SelectedStepGsInverse194` (job 476) — statement s7: the gs instance
   of the KeygenLevelCalls.Bind chain (name "gs", `addr gs 0 0 1`) over
   the generic entry/Bind helpers of SelectedStepInverse192 and the
   closed NttInverseWhole192 corpus at stride 1; export: the transformed
   gs words as `scaledWord gvs tws p p0i` and the caller frame. Sources
   `92c702b2`, olean `0404deab`, commit `8e92d57f`.
3. `SelectedStepGsChain194` (job 478) — the composed s4-s7 stage
   statement from the assembled `after`-state shape of
   SelectedStepChain193.source, with the stage hypotheses (gs source
   image, igm twiddle reads, heap writability) stated explicitly and the
   export (gs transformed, gd written image at the s6 output, the
   composed s0-s7 execution `fullPrefix`, caller frames). Sources
   `c4b65be7`, olean `28f7a597`, commit `652f8eb0`.

Retained failure: job 477 (workshop only) — the first chain draft stated
the gs/igm separation without index bounds and omega correctly refuted it
(the unbounded gs and igm index ranges overlap at j = k + 1024); the
bounded `j<512 / k<512` form is what the s7 hypothesis carries. Register
`KEYGEN_STEP_GS_194_FAILURES.json` now has 4 entries (467/470/473/477);
the inherited checkpoint192 register (58) and checkpoint193 register (4)
remain untouched.

### Structural findings for the discharge

- The assembled s0-s3 state carries `v = 256` (the s3 call leaves caller
  locals untouched), while SelectedStepGsCopy194's init is stated over
  the uninitialized declaration `some (.uint64,none)`. The chain
  therefore re-proves the s4 init for an arbitrary prior v cell value
  (`init_gs`); the generalization is local, no 194 module was edited.
- The bystander keep to mirror is the per-cell export of
  NttInverseMiddleRounds192.source:
  `∀ q, (∀ x, x<512 → Separate (walk a x stride) q) → ∀ w,
  Load32 s.heap q w → Load32 after.heap q w` plus
  `after.heap.writable=s.heap.writable`. The middle pass already exports
  it; the final pass and the correction do NOT — their loops
  (NttInverseFinalLoop192.remaining: 256 iterations, two writes each;
  NttInverseCorrectionLoop192.remaining: 512 steps, one write each) are
  sealed without keeps, so the discharge needs keep-extended re-proofs
  plus keep-threaded re-compositions (the prologue, the skipped triple
  pass, the scalar/pointer parts of both passes and the trailing skip are
  heap-free) and a whole-inverse keep over NttInverseWhole192.source's
  composition.
- The re-assembly of s0-s3 has an arity gap: the fs image must survive
  s2 (the s3 input), the gs image and the igm reads must survive s0 and
  s2 and s3, and the fd written image must survive s3. The existing keep
  modules are arity-limited (StepCopyKeep193: one image;
  StepProductKeep193: two images), so the re-assembly needs either
  N-image keep variants of both loops or parallel runs of the existing
  keep theorems identified by execution determinism.

### Open (in order)

1. The hypothesis discharge exactly as frozen in
   `KEYGEN_STEP_GS_194_NEXT_ROUTE.md` (bystander keeps through final
   pass + correction + whole inverse, then the s0-s3 re-assembly with
   the gs/igm/fd keeps and the unconditional s0-s7 assembly; the gd
   image extends to the s7 output state for free from the bystander
   keep).
2. The outer u++/final guard tail, both `zint_rebuild_CRT` calls, the
   additional-prime part (slen 1 / tlen 2), the remaining d-levels and
   the root/certificate/codec path, before the complete emitted witness
   can instantiate the corrected KeygenProbability134 consumers
   (KeygenModelUnlock134.package_of_witness,
   KeygenSuccessMass134.success_lower_of_witness); the prospective bound
   remains Z>=2^-256 and is NOT established by this window.

Next unused proof job suffix: **479**. Scoped proof, NOT_REVIEWED; no
IID/D1/F04 premise; no push (batch 4 waits for the owner's signal).

### Three sentences (this window)

Udowodniono: wykonanie s6 (pętla produktowa na gd z keeps obrazu gs i
odczytów igm oraz zapisanym obrazem `value (gvs (2v)) (gvs (2v+1)) R2 p
p0i`), wykonanie s7 (gałąź odwrotna na gs przez zamknięty korpus
NttInverseWhole192, eksport `scaledWord gvs tws p p0i`) i montaż s4-s7
z jawnymi hipotezami etapu oraz złożonym wykonaniem s0-s7 — wszystko
jako wykonane słowa. Najbliższy brak: rozliczenie hipotez — zachowanie
obcych odczytów przez final pass i correction (per-cell keep jak w middle
pass), re-montaż s0-s3 z keeps obrazów gs/igm/fd i bezwarunkowy montaż
s0-s7; okno zamrożono na granicy z dokładnymi zobowiązaniami. Nic z
tego nie implikuje własności NTT, prawa tabeli, dodatniości,
bezwarunkowego Z > 0 ani p_accept/p_K — te pozostają OPEN.

## R1 discharge window (2026-10-20) — hypothesis discharge closed, unconditional s0-s7

Window launched per `KEYGEN_STEP_GS_194_NEXT_ROUTE.md` (jobs 479+, the
discharge obligations). Entry re-verified read-only before any proof
work: ENTRY_PINS `99ac47a1…` recomputed against its receipt (SHA256
match), all 73564 inherited pins re-checked (0 missing / 0 changed) and
no active owned job/Lean/Sage process. Scoped proof, NOT_REVIEWED; no
push (batch 4 waits for the owner's signal).

### Closed (proof jobs 480/481/482/483/485/487/498/501; logs 0/0, standard axioms)

1. `NttInverseCorrectionLoopKeep194` + `NttInverseFinalLoopKeep194`
   (job 480) — keep-extended re-proofs of the two sealed writer loops in
   the per-cell bystander shape `NttInverseMiddleRounds192.source`
   exports: every load from a cell separate from the walked a region
   survives the whole loop (512 one-write steps of the Montgomery
   scaling; 256 two-write iterations of the degree-1 butterfly), with
   the writable transport. Sources `8bae905b`/`a0994994`, oleans
   `bb24ee52`/`5748a79a`.
2. `NttInverseCorrectionKeep194` (job 481) +
   `NttInverseFinalPassKeep194` (job 482) — keep-threaded
   re-compositions of `NttInversePrograms192.correction` and
   `NttInversePrograms192.finalPass` (the setNi/uInit and
   wAssign/uInit/r1Init/r2Init prefixes are heap-free; the loops are the
   only writers). Sources `3d1cbeae`/`5b6b232c`, oleans `3570ea1a`/
   `07517b1e`.
3. `NttInverseWholeKeep194` (job 483) — the whole-inverse bystander keep
   over the `NttInverseWhole192.source` composition at logn 9 / full 0:
   prologue and skipped triple pass heap-free, the middle pass keep from
   `NttInverseMiddleRounds192.source`, and the two keep-threaded passes
   close the chain. Export: the same executed-word image as
   `NttInverseWhole192.source` plus the per-cell keep (every load from a
   cell separate from the walked a region survives the whole
   `KeygenLevelNtt.inverse`) and the writable transport. This yields the
   fd/gd image keeps through the s3/s7 calls for free. Source
   `3505205e`, olean `6d9a455b`.
4. `StepCopyKeepTwo194` + `StepProductKeepThree194` (job 485) — the
   s0/s2 keep arity gap closed: two and three simultaneous tracked read
   images through the copy (t1-walk writes) and product (fd-walk writes)
   loops. Sources `012a19cd`/`823a1b81`, oleans `3dea25d2`/`76439b4c`.
5. `SelectedStepInverseKeep194` (job 487) — both modp_iNTT3_ext call
   statements of the tail (the fs instance s3, the gs instance s7)
   re-proved over the generic entry/Bind helpers with the body run
   through the whole-inverse keep; the call result is the caller state
   with the body heap, so the per-cell keep and the writable transport
   lift through the call wrapper. Source `45c91f3b`, olean `eb1183f5`.
6. `SelectedStepChainKeep194` (job 498) — the s0-s3 re-assembly with the
   extra keeps: the gs source image and the igm twiddle reads survive the
   copy writes, the fs reads, gs source and igm twiddle reads survive the
   product writes, and the fd written image, the gs source image and the
   igm twiddle reads survive the s3 inverse call. Export at the
   assembled state: the transformed fs image, the written fd image, the
   gs source image `gvs` (the actual executed load words of
   `SelectedGen0Frame189.g_read`), the igm twiddle reads `tws`, the v
   cell (v = 256) and the caller frames - every stage hypothesis of the
   sealed `SelectedStepGsChain194.source` is now unconditional. The v
   cell rides through the s3 wrapper via the generic `localSafe`
   caller-local extraction (`localSafe_result`); the parser leaf
   `modp_iNTT2_ext` of the false-ter branch is a make-level binary call
   whose rule returns the caller state with the callee heap (probed in
   jobs 492/495). Source `125e7d4a`, olean `cb77a6b9`.
7. `SelectedStepFull194` (job 501) — the unconditional full first-prime
   assembly. `stage_discharge` instantiates the sealed
   `SelectedStepGsChain194.source` at the re-assembled state (its stage
   hypotheses free) and records the composed
   `Exec SelectedStepGsChain194.fullPrefix base ⟨final,.normal⟩` with
   the gs transformed words (`scaledWord gvs tws p p0i`), the gd written
   image at the s6 output and the caller frames. `source` additionally
   extends the gd written image to the final assembled state through the
   s7 keep (bounded gd/gs walk separation), exporting: the unconditional
   full-prefix execution, the gs transformed words, the gd written image
   `value (gvs (2v)) (gvs (2v+1)) R2 p p0i` at the final state, the fd
   written image at the assembled s0-s3 state, the transformed fs image
   and the caller frames. Source `a3465686`, olean `e3b014eb`.

Retained diagnostic records (not proof evidence):
`NttInverseLocalSafeProbe194` (job 492 probe; sources of the draft
checker's values) and `NttInverseTerProbe194` (job 495 probe; the
false-ter leaf's form is the make-level binary call), both accepted as
records in job 501 (`35f40e96`/`f658b2e6` oleans).

Retained workshop failures in this window (register grew to 18 entries):
479, 484, 486, 488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 499,
500 - all mechanical (type conflation, missing imports, IH arity,
destructure off-by-one, defeq coercion, `=`/`&&` precedence in
annotations, unused binders); no source statement, value, pin or sealed
module was touched by any of them. The inherited checkpoint192 register
(58) and checkpoint193 register (4) remain untouched.

### Open (in order)

1. The outer u++/final guard tail, both `zint_rebuild_CRT` calls, the
   additional-prime part (slen 1 / tlen 2), the remaining d-levels and
   the root/certificate/codec path, before the complete emitted witness
   can instantiate the corrected KeygenProbability134 consumers
   (KeygenModelUnlock134.package_of_witness,
   KeygenSuccessMass134.success_lower_of_witness); the prospective bound
   remains Z>=2^-256 and is NOT established by this window.

Next unused proof job suffix: **502**. Scoped proof, NOT_REVIEWED; no
IID/D1/F04 premise; no push (batch 4 waits for the owner's signal).
Values remain executed words only: no transform property, table law,
root law or positivity claim; unconditional Z>0, numerical p_accept,
conditional coding and positive p_K remain OPEN. Old110 stays frozen;
measured wording 8192/23628 with the separate 256/739 control and the
five do_sign items remain unchanged.

### Three sentences (this window)

Udowodniono: rozliczenie hipotez etapu w całości — obcy odczyt przeżywa
final pass, correction i całe odwrotność (per-cell keep w kształcie
middle pass, z transportem writability), lukę aritytetu s0/s2 domykają
keep-moduły na 2 i 3 obrazy, re-montaż s0-s3 unieważnia hipotezy
(obraz gs, odczyty igm, zapisany obraz fd, komórka v=256), a montaż
s0-s7 jest bezwarunkowy także z obrazem gd w stanie finalnym przez keep
s7 — wszystko jako wykonane słowa. Najbliższy brak: ogon u++/guard, oba
`zint_rebuild_CRT`, część dodatkowej liczby pierwszej, pozostałe
d-pozomy i ścieżka root/certificate/codec do pełnego świadka
KeygenProbability134. Nic z tego nie implikuje własności NTT, prawa
tabeli, dodatniości, bezwarunkowego Z > 0 ani p_accept/p_K — te
pozostają OPEN.

## R1 tail window (2026-10-20) — the loop u++/guard tail closed, exit state exported

Window launched per `KEYGEN_STEP_GS_194_NEXT_ROUTE.md` (proof job
suffix 502, the outer u++/final-guard tail of the first-prime loop).
Entry re-verified read-only before any proof work: ENTRY_PINS
`99ac47a1…` recomputed against its receipt (SHA256 match), all 73564
inherited pinned paths re-checked (0 missing / 0 changed) and no active
owned job/Lean/Sage process. Scoped proof, NOT_REVIEWED; no push (batch
4 waits for the owner's signal).

### Closed (proof job 505; logs 0/0, standard three axioms)

1. `SelectedStepLoopTail194` (job 505) — the complete one-iteration
   execution of the make_fg_step first-prime loop at the selected seed9
   state. The s0-s8 tail is re-derived from the sealed
   `SelectedStepFull194.source` fullPrefix run by generic sequence
   destructuring (`seq_inv`) and the `MakeFgSequence187.Run` chain
   against the sealed projection splits (`tail_expand`); the body scope
   runs over the tail (SelectedGen0Call189.continue_inner plus the scope
   restore), the u increment reaches u = 1 (C99LoopScalar141.increment),
   the false u < slen guard exits the loop (loopFalse at u = 1 against
   slen = 1) and the part-2 statement (`u = 0; for (u = 0; u < slen;
   u ++) { body }`) executes from SelectedStepMove187.after to the loop
   exit state — the state transport to the second prime. Export at the
   exit state: the executed u = 1 / n = 512 / hn = 256 / slen = 1 /
   tlen = 2 / logn = 9 / ter = 1 / in_ntt = 1 / out_ntt = 1 cells, the
   caller frames outside u/v/p/p0i/R2 and x, the x binding restored to
   its caller-scope value, and the gs transformed words
   (`scaledWord gvs tws p p0i`) and the gd written image at the exit
   state (both ride through the scope restore and the u increment
   unchanged, since both are heap-free). Sources `98d0b2e6`, olean
   `01ada839`, commit `04aca610`.

Retained workshop failures in this window (register grew to 22
entries): 502, 503, 504 — all mechanical (deprecated if_neg/if_pos
rewrites in the restoreScope transport helpers; the unopened
SelectedStepLayout187.gs/gd names auto-bound as implicits in the export
statement; one rcases pattern short of the five-way localNames
membership disjunction; the nested seqNormal of the part-2 composition
carrying the wrong middle state; simp's ite normalization form clashing
with the contains-form hypotheses; List.not_mem_nil arity; String.toList
versus the cons form of the concrete name; and the x binding being the
caller-scope value rather than none). No source statement, value, pin or
sealed module was touched by any of them. The inherited checkpoint192
register (58) and checkpoint193 register (4) remain untouched.

### Open (in order)

1. The fs/fd image transport from the assembled s0-s3 state to the loop
   exit state (their consumption feeds the CRT/additional-prime
   consumers). The s4 copy keep is single-image (FixedGs binds the gs
   source; the tracked slot carries the igm reads) and the s6 product
   keep is two-image (gs source + igm), so the fd+fs bystander images
   need either a two-image StepGsCopyKeep194 variant over the combined
   fd/gd/fs or fs+gs+gm+igm walks, or a per-cell bystander keep for the
   copy/product loops in the NttInverseMiddleRounds192.source form. The
   s7 per-cell keep (SelectedStepInverseKeep194) and the gd/gs images at
   the exit state are already exported; the gd input words of a combined
   walk would need the SelectedStepMove187.input_read loads carried to
   the s0-s3 assembly state.
2. Both `zint_rebuild_CRT` calls (part 3) at the exit state (xlen = slen
   = 1 makes the co-reduction loop empty and the normalize_signed norm
   loop runs 512 zint_norm_zero words over the fs and gs walks), then the
   additional-prime part (slen 1 / tlen 2), the remaining d-levels and
   the root/certificate/codec path, before the complete emitted witness
   can instantiate the corrected KeygenProbability134 consumers
   (KeygenModelUnlock134.package_of_witness,
   KeygenSuccessMass134.success_lower_of_witness); the prospective bound
   remains Z>=2^-256 and is NOT established by this window.

Next unused proof job suffix: **506**. Scoped proof, NOT_REVIEWED; no
IID/D1/F04 premise; no push (batch 4 waits for the owner's signal).
Values remain executed words only: no transform property, table law,
root law or positivity claim; unconditional Z>0, numerical p_accept,
conditional coding and positive p_K remain OPEN. Old110 stays frozen;
measured wording 8192/23628 with the separate 256/739 control and the
five do_sign items remain unchanged.

### Three sentences (this window)

Udowodniono: pełne wykonanie jednej iteracji pętli liczby pierwszej
make_fg_step — ogon s0-s8 odtworzony jako Run przez rozłożenie
fullPrefix, zakres ciała z restoreScope, przyrost u do 1, fałszywe
wyjście guardu u<slen oraz wykonanie part-2 do stanu wyjścia pętli
(transport do drugiej liczby pierwszej), z komórkami u/n/hn/slen/tlen/
logn/ter/in_ntt/out_ntt, ramkami wywołującego i obrazami gs/gd w stanie
wyjściowym — wszystko jako wykonane słowa. Najbliższy brak: transport
obrazów fs/fd ze stanu montażu s0-s3 do stanu wyjścia pętli (luka
aritytetu keep-ów s4/s6), potem oba `zint_rebuild_CRT`, dodatkowa liczba
pierwsza, d-pozomy i ścieżka root/certificate/codec do pełnego świadka
KeygenProbability134. Nic z tego nie implikuje własności NTT, prawa
tabeli, dodatniości, bezwarunkowego Z > 0 ani p_accept/p_K — te pozostają
OPEN.

## R1 crt window (2026-10-20) — fs/fd at the loop exit state closed; both CRT calls named, execution open

Window launched per `KEYGEN_STEP_GS_194_NEXT_ROUTE.md` in the route
order pinned by the tail window (proof job suffix 506): the fs/fd image
transport to the loop exit state first, then both `zint_rebuild_CRT`
calls. Entry re-verified read-only before any proof work: ENTRY_PINS
`99ac47a1…` recomputed against its receipt (SHA256 match), all 73564
inherited pinned paths re-checked (0 missing / 0 changed) and no active
owned job/Lean/Sage process. Scoped proof, NOT_REVIEWED; no push
(batch 4 waits for the owner's signal).

### Closed (proof jobs 507/509/511; logs 0/0, standard three axioms)

1. `StepGsCopyKeepCell194` + `StepGsProductKeepCell194` (job 507) — the
   per-cell bystander keep in the `NttInverseMiddleRounds192.source` form
   for the s4 gs-copy loop and the s6 gd-product loop (the keep-arity gap
   of the step re-assembly): every load from a cell separate from the
   whole t1 copy walk (resp. gd product walk) survives the loop, with the
   writable transport. The gs/gd invariants, the written gd image and the
   tracked reads of the sealed `StepGsCopyKeep194` /
   `StepGsProductKeep194` are kept unchanged (edit-by-new-module; the
   induction threads the keep as one more conclusion of the same run).
   Sources `c0d37bfe`/`33f7397e`, oleans `a8181a8f`/`236d6a18`, commit
   `ed565081`.
2. `SelectedStepFsFd194` (job 509) — the fs transformed words and the fd
   written image transported from the assembled s0-s3 state to the loop
   exit state: the s4/s6 cell keeps, the s7 per-cell keep of
   `SelectedStepInverseKeep194` (bounded fs/fd-vs-gs walk separation) and
   the heap-free loop tail (body scope restore, u increment, false guard,
   part-2 statement). The window run is tied to the sealed
   `SelectedStepLoopTail194.source` exit package by the
   `KeygenMakeFgDeterminism099.execution` determinism of `part .step 2`
   (`KeygenMakeFgArity099.step2` / `KeygenMakeFgArity099.body`), so the
   export carries the complete exit-state package: the cells
   u/n/hn/slen/tlen/logn/ter/in_ntt/out_ntt, the caller frames, the gs
   transformed words and gd written image of the sealed export, the new
   fs transformed words and fd written image, and the heap writability
   transport. **The window deliverable (1) is closed.** Sources `e697021c`,
   olean `4626649e`, commit `ed565081`.
3. `MakeFgCrtShape194` (job 511) — source-bound naming of both
   `zint_rebuild_CRT` calls of `KeygenMakeFgSource.part .step 3`
   (`zint_rebuild_CRT(fs/gs, slen, slen, n, primes, 1, gm)`) with their
   exact parsed arguments checked by decide (walk source pointer at index
   0, the xlen/xstride words read from the slen cell, the num word from
   the n cell, the primes table pointer, the i32 literal 1 and the gm
   scratch pointer), and the body spines of `zint_rebuild_CRT` (xlen = 1)
   and `zint_norm_zero` (len = 1) as decide-checked projections (the u/x
   declarations, the `tmp[0] = primes[0].p` storePrime, the u = 1 init,
   the empty co-reduction loop, the normalize branch; the cc/u
   declarations, the cc = 0 and u = len assignments and the u > 0 loop
   with its trailing guard decrement). Sources `3596a3f6`, olean
   `2db56824`, commit `e6023c7a`.

### Parse record (DIAGNOSTIC, retained)

`ZintCrtParseProbe194` (job 510, source `28d62dc7`, olean `2bfd6593`) is
a DIAGNOSTIC parse-dump probe (not proof evidence) whose pinned job log
records the exact parsed ASTs of part 3 and of the three consumed bodies.
Key facts pinned by the probe: the `u -- > 0` guard of zint_norm_zero is
emulated exactly by the loop body prefix `u -= 1` plus the trailing
`u -= 1` of the final guard evaluation (one iteration at len = 1, ending
with u wrapped as in C); the two comparison branches return (the second
through a `zint_sub(x, p, len)` call), so the per-word outcome is the
data-dependent three-way split; the zint_sub leaf body at len = 1 has the
unconditional single write `a[0] := a[0] - b[0]` (the borrow word is
computed into a discarded local).

### Retained failures (register 22 -> 25)

506, 508 (mechanical workshop failures) and 510 (the DIAGNOSTIC probe,
accepted as a record) with causes in `KEYGEN_STEP_GS_194_FAILURES.json`:
506 — the induction hypothesis already carries the per-cell keep inside
its existential conclusion, so the step application passed the keep as
one argument too many; 508 — the walk-separation lemmas were stated
without index bounds and omega correctly refuted the unbounded forms
(the writer walks are finite). No source statement, value, pin or sealed
module was touched by any of them. The inherited checkpoint192 register
(58) and checkpoint193 register (4) remain untouched.

### Open (in order)

1. **Both `zint_rebuild_CRT` calls EXECUTED at the loop exit state** —
   the window deliverable (2) is NOT closed: the calls are named and
   their arguments bound, the callee bodies are not executed here. Exact
   obligations in order:
   (a) the table-word transport
   `Load32 next.heap (KeygenLevelCalls.fieldPointer primes .p)
   SelectedTopInit178.p` to the rebuildCrt entry state (the bind chain
   keeps the heap): block 21 is readonly and never written by the step,
   but the keep/stability plumbing covers only parts of the segment — the
   mkgm3 call needs the `SelectedGen0Frame189.stable` pattern, the s0
   copy loop and the s2 product loop need fs/fd-name cell keeps (mirrors
   of `StepGsCopyKeepCell194`/`StepGsProductKeepCell194` over
   `StepCopyKeep193`/`StepProductKeep193`, or one generic block keep over
   the loop runs), the s3 call is covered by
   `SelectedStepInverseKeep194.fs_source`, and
   `Gate00Memory.load32_transport` then supplies the load;
   (b) the `zint_norm_zero` / `zint_sub` body runs at len = 1 — the two
   comparison branches are data-dependent, so the honest export is the
   executed-word image `normWord p0 x = if x < p0 >>> 1 then x else if
   p0 >>> 1 < x then x - p0 else x` (decidable case splits in the proof;
   the zint_sub write is the unconditional word `x - p0`);
   (c) the 512-step normalize loop induction over the x walk (xlen = 1
   stride), the `zint_rebuild_CRT` body run (the storePrime, the empty
   co-reduction loop at xlen = 1, the normalize branch), then both call
   statements of part 3 composed at the exit state over the named
   arguments.
2. Then the additional-prime part (slen 1 / tlen 2), the remaining
   d-levels and the root/certificate/codec path, before the complete
   emitted witness can instantiate the corrected KeygenProbability134
   consumers (KeygenModelUnlock134.package_of_witness,
   KeygenSuccessMass134.success_lower_of_witness); the prospective bound
   remains Z>=2^-256 and is NOT established by this window.

Next unused proof job suffix: **512**. Scoped proof, NOT_REVIEWED; no
IID/D1/F04 premise; no push (batch 4 waits for the owner's signal).
Values remain executed words only: no transform property, table law,
root law or positivity claim; unconditional Z>0, numerical p_accept,
conditional coding and positive p_K remain OPEN. Old110 stays frozen;
measured wording 8192/23628 with the separate 256/739 control and the
five do_sign items remain unchanged.

### Three sentences (this window)

Udowodniono: transport obrazów fs/fd ze stanu montażu s0-s3 do stanu
wyjścia pętli — luka aritytetu keep-ów s4/s6 domknięta per-cell
bystander keepami w kształcie NttInverseMiddleRounds192 (z transportem
writability), przez keep s7 i bezpieczny ogon, z pełnym pakietem stanu
wyjścia (komórki, ramki, obrazy gs/gd) spiętym determinizmem part .step 2
— oraz nazwy i dokładne argumenty obu wywołań `zint_rebuild_CRT` z
części 3 (decide na parsowanej składni, z pinowanym zapisem parse
probe). Najbliższy brak: samo wykonanie obu wywołań — transport słowa
tabeli primes[0].p do stanu wejścia ciała (blok 21 przez mkgm3/s0/s2/s3),
wykonania ciał zint_norm_zero/zint_sub przy len = 1 z rozgałęzieniami na
porównaniach (eksport jako słowo `normWord p0 x`), pętla 512 kroków
normalizacji i montaż part 3. Nic z tego nie implikuje własności NTT,
prawa tabeli, dodatniości, bezwarunkowego Z > 0 ani p_accept/p_K — te
pozostają OPEN; okno nie wykonało też żadnego z wywołań CRT, więc
deliverable (2) pozostaje niezamknięte w całości.

## R1 normZero window (2026-10-21) — the len = 1 zint_sub/zint_norm_zero engines closed

Window launched per this stage's `KEYGEN_STEP_GS_194_NEXT_ROUTE.md`
(proof job suffix 517, obligation (b): the normZero engine). Entry
re-verified read-only before any proof work: ENTRY_PINS `99ac47a1…`
recomputed against its receipt (SHA256 match), all 73564 inherited
pinned paths re-checked (0 missing, 0 changed) and no active owned
job/Lean/Sage process. Scoped proof, NOT_REVIEWED; no push (batch 4
waits for the owner's signal). Values remain executed words only.

### Closed (proof jobs 520/524; logs 0/0, standard three axioms)

1. `ZintSubWord194` (job 520) — the zint_sub leaf engine at len = 1:
   the pinned leaf body `KeygenZintLeaves.code .sub` is executed in full
   (`sub_shape` re-binds the parsed body by decide, no new parse probe)
   and exported as executed words. The single limb write is the parsed
   store `w & 0x7FFFFFFF`, so the executed word is
   `subWord x p = (x - p) &&& 2147483647` — the 31-bit masked limb
   difference — and the returned borrow word is
   `borrowWord x p = (x - p) >>> 31` (`ReturnValue.value .uint32`, the
   call site discards it). Everything outside the a[0] cell keeps its
   bytes (the Store32 frame of `Word32Memory176.write`); `sub_image` /
   `sub_frame` export the load and the frame. `call_len1` packages the
   leaf `Call` statement at the concrete `zint_sub(x, p, len)` argument
   list, and `bind_leaf`/`leafEntry` bind it for the normZero consumer.
   Source `2f44d37f`, olean `147a5077`, commit `11b9c37d`.
2. `ZintNormWord194` (job 524) — the zint_norm_zero engine at len = 1
   (obligation (b) of the CRT route): the pinned body
   `KeygenZintCall.calleeBody .normZero` is executed in full
   (`norm_shape` re-binds the parse-record shape of probe job 510 by
   decide; no re-recognition at start) with the two data-dependent
   comparison branches resolved by decidable case splits. Export — the
   executed-word image

     normWord p0 x = if x < p0>>>1 then x
                     else if p0>>>1 < x then (x-p0) &&& 2147483647
                     else x

   together with `normImage` (the heap image: the single limb write in
   the second case, untouched otherwise), `normFlow` (`.returned none`
   on both comparison returns, `.normal` on the tie path that falls out
   through the false guard into the trailing `u -= 1` wrap — the run
   ends `u = 0-1` in that case, as in C) and the heap-keeps-except-x[0]
   frame in all three cases. The void return flow is closed for both end
   flows actually reached (`void_flow`/`flow_shape`: `ReturnValue none
   flow none` via `voidReturn`/`voidEnd` against `KeygenZintCall.Call`).
   `norm_call` packages the call statement of the rebuildCrt normalize
   loop (`zint_norm_zero(x, tmp, xlen)`) at the len = 1 instance over
   `normEntry`/`bind_norm`. The len = 1 zint_sub run is the leaf engine
   of job 520, called through `Exec.call` + `bind_leaf` with the state
   cast through the sub_run heap fact. Source `e6b8ac7b`, olean
   `ac67288c`, commit `f320cde7`.

Retained diagnostic record (not proof evidence): `ZintNormAudit194`
(job 525, source `abedab24`, olean `b360bbd4`) prints the axioms of the
six engine exports — all the standard three
[propext, Classical.choice, Quot.sound].

### Trap recorded (route discrepancy — supplement, not overwrite)

The CRT route's shorthand "the zint_sub write at len = 1 is the
unconditional word x-p0" (and the job-510 report note "a[0] :=
a[0] - b[0]") drop the 31-bit limb mask of the parsed store
`a[u] = w & 0x7FFFFFFF`. The honest executed word is
`(x - p0) &&& 2147483647`, which is NOT the bare 32-bit `x - p0`
whenever bit 31 of the difference is set. The engine exports follow the
pinned parse record and carry the mask; `subWord` is the name to use in
every downstream composition. No historical wording was changed.

### Retained failures (register 28 -> 35)

517, 518, 519, 521, 522, 523 (mechanical workshop failures of the two
engine drafts) and 525 (the DIAGNOSTIC axiom audit, accepted as a
record) with causes in `KEYGEN_STEP_GS_194_FAILURES.json`: 517 — the
`Eval.literal` type argument written with the B20.C.Ty constructor,
`Bind.nil` applied to an argument, convert lemmas referenced before
their declaration, BitVec rewrite-chain order, Eq.trans chains over raw
bindValue/restoreScope forms instead of show-normalized statements;
518 — deprecated if_pos/if_neg/if_true, the missing `setWidth_eq` tail,
`Call.run` wanting the bare `KeygenWordExec.Exec` source, the call
state needing the heap fact rewritten in; 519 — the and_mask rewrite
direction; 521 — the `or_zero_right` rewrite direction, Bool-ite
motive failures in the comparison helpers (fixed via the sealed
`C99NatWord141.less` change/simpa pattern), unnormalized guard Boolean
facts (`BitVec.toNat_ushiftRight` shape), `B20.C.BinOp.and` vs
`.band`, `ReceiveC` under the wrong namespace, seqNormal middle
argument positions, the loop-body definition missing the head `u -= 1`;
522 — the case exports' hypothesis normalization mismatch, the
`ReceiveC.discard` arity, have-bound states not unfolding in `show`
patterns (promoted to the top-level defs tAfter/tGt9); 523 — the
`ReceiveC` unification against the opaque existential heap (fixed by
constructing at the raw state and casting through the sub_run heap
fact) and the swapped obtain order in `norm_call`. No source statement,
value, pin or sealed module was touched by any of them. The inherited
checkpoint192 register (58) and checkpoint193 register (4) remain
untouched.

### Open (in order)

1. The 512-step normalize loop induction over the x walk (obligation
   (c) of the CRT route): the loop body is one `norm_call` per walked
   word at xlen = 1 (the walk rebinds the caller's `x` pointer through
   `bindPtr x xx (var xstride)`; the per-step engine is now closed), the
   induction threads the normImage writes through `Word32Memory176`
   keeps over the twin walk. Then the `zint_rebuild_CRT` body run (the
   `tmp[0] = primes[0].p` storePrime, the empty co-reduction loop at
   xlen = 1, the normalize branch) and both call statements of part 3
   composed at the exit state over the named arguments of
   `MakeFgCrtShape194`.
2. Then the additional-prime part (slen 1 / tlen 2), the remaining
   d-levels and the root/certificate/codec path, before the complete
   emitted witness can instantiate the corrected KeygenProbability134
   consumers (KeygenModelUnlock134.package_of_witness,
   KeygenSuccessMass134.success_lower_of_witness); the prospective
   bound remains Z>=2^-256 and is NOT established by this window.

Next unused proof job suffix: **526**. Scoped proof, NOT_REVIEWED; no
IID/D1/F04 premise; no push (batch 4 waits for the owner's signal).
Values remain executed words only: no transform property, table law,
root law or positivity claim; unconditional Z>0, numerical p_accept,
conditional coding and positive p_K remain OPEN. Old110 stays frozen;
measured wording 8192/23628 with the separate 256/739 control and the
five do_sign items remain unchanged.

### Three sentences (this window)

Udowodniono: pełny wykonawczy silnik normZero przy len = 1 — ciała
zint_norm_zero i zint_sub wykonane w całości z rozstrzygalnymi
trójdrożnymi rozgałęzieniami na porównaniach, eksport jako obraz
wykonanych słów `normWord p0 x` (z gałęzią piszącą `(x-p0) &&&
2147483647` — maska 31-bitowa z pinowanego parse'u, nie surowe `x-p0`),
obrazy `normImage`/`normFlow`, ramka heap-keeps-except-x[0] i pusty
przepływ zwrotu dla obu realnie osiąganych końcówek; wszystko jako
wykonane słowa, standardowe trzy aksjomaty. Najbliższy brak: indukcja
pętli normalizacji 512 kroków, wykonanie ciała zint_rebuild_CRT i montaż
obu wywołań części 3, potem dodatkowa liczba pierwsza, d-pozomy i
ścieżka root/certificate/codec do pełnego świadka KeygenProbability134.
Nic z tego nie implikuje własności NTT, prawa tabeli, dodatniości,
bezwarunkowego Z > 0 ani p_accept/p_K — te pozostają OPEN; trasa nie
została zgodna z niepoprawnym skrótem `x-p0` i wymaga użycia `subWord`
w każdym dalszym montażu.

## R1 walk/body window (2026-10-21) — the 512-step normalize walk and the rebuildCrt body engine closed; the part-3 assembly in progress

Window launched per this stage's `KEYGEN_STEP_GS_194_NEXT_ROUTE.md`
(proof job suffix 526, obligation (c) of the CRT route). Entry
re-verified read-only before any proof work: ENTRY_PINS `99ac47a1…`
recomputed against its receipt (SHA256 match), the inherited pin chain
intact and no active owned job/Lean/Sage process. Scoped proof,
NOT_REVIEWED; no push (batch 4 waits for the owner's signal — 10 commits
outstanding at window start, 12 at close). Values remain executed words
only: no NTT property, table law, root law, positivity or Z>0 claim.

### Closed (proof jobs 529/530/534; logs 0/0, standard three axioms)

1. `ZintNormWalk194` (job 529; source `a011b7e4`, olean `d0aaf240`) —
   the 512-step normalize walk of the zint_rebuild_CRT normalize branch
   at num = 512, xstride = xlen = 1: the walk-loop statement pieces are
   decide-bound projections of the pinned parse record through
   MakeFgCrtShape194.crtNormalize (norm_split…norm_p2_skip), each
   iteration is exactly one ZintNormWord194.norm_call at the walked word
   with the same p0 = tmp[0], the fuel induction threads the
   executed-word writes through the Word32Memory176 keeps
   (walkImage_pending/walkImage_keep/walkImage_written over the
   walkImage/stepImage image), and the export carries the executed-word
   image `fun i => normWord p0 (words i)` over the walk, the keeps
   outside the walk region (the twin fs/gs instantiations at the
   512-word separation) and the u = 512 / x one-past-walk exit cells.
   The case facts of normWord are consumed in the `p0.toNat >>> 1`
   normalized form (the job-522 trap; see the retained failures).
   Commit `cab5bf85`.
2. `ZintNormWalkAudit194` (job 530, DIAGNOSTIC record) — the axioms of
   norm_loop/walkImage_cells/walk_fuel/walk_run: all the standard three.
3. `ZintRebuildCrt194` (job 534; source `dfc11ef8`, olean `82c5abe1`) —
   the full zint_rebuild_CRT body run at xlen = 1 over an abstract entry
   state: the u/x declarations, the storePrime tmp[0] = primes[0].p (the
   KeygenLevelCalls.PrimeRead of the block-21 table word with the
   alloc/writable transport and the Store32 write), the u = 1 init, the
   EMPTY co-reduction loop (one false guard at u = xlen = 1), the
   normalize branch through the closed 512-step walk and the
   fall-through end flow; the export carries the executed run, the
   body-end heap `walkImage (write entry.heap pp p0) px p0 words 512`
   and the per-word image. Commit `df6c67ac`.

### In progress — the part-3 assembly (`SelectedStepCrtRun194`, drafts 535–548)

The Bind chain of the named part-3 arguments (`entryOf`/`bind_crt` —
the first parameter binds outermost exactly as the Bind constructors
nest), the per-call engine wrapper (`call_run`, including the image
conjunct), the image keeps (`keep_through` over walkImage_keep and the
gm/table separation lemmas: gm_offset0/fs_offset/gs_offset,
fs_gm_separate/gs_gm_separate over the literal 2718/1694/2206 offsets,
block separations 31 vs 21 by decide) and the composition skeleton
(first3/second3/tail3 via part3_split/rest3_split) are written. The
final `source` theorem is blocked on the pathological unification below;
the current source file plus the abstract-bridge recipe (proj_heap
applied at the concrete memory, all other crossings syntactic via
unfold/rewrite) are in place for the next window.

### Trap recorded (księga pułapek) — concrete-Memory defeq explodes

Unification across `Memory`-valued terms that differ syntactically
dives into the nested `Word32Memory176.write` byte closures and the
walkImage recursion: it first exceeded the recursion cap (jobs 543–545,
with the cap raised to 4194304), then exhausted the stack and finally
the heap (jobs 546/548, `Stack overflow` / `std::bad_alloc` / `out of
memory`). The isolated probe `CrtBridgeProbe194` (job 547, DIAGNOSTIC)
localized it: `({s with heap := H}).heap = H` discharges trivially with
ABSTRACT `H` but fails at max recursion depth with the CONCRETE
`heapFsOf next`. Consequence for all future modules: never let the
unifier compare concrete memory terms — project through abstract
bridges (lemma application) and make every remaining crossing
syntactic (`unfold` of the defs on both sides, or `rw` along a bridging
equation). The set-tactic is also not defeq-safe here (its bindings are
fvar+equation, not definitions) — use plain top-level
noncomputable definitions.

### Retained failures (register 35 -> 55)

Jobs 526/527/528 (ZintNormWalk194 drafts), 531/532/533 (ZintRebuildCrt194
drafts), 535–546/548 (SelectedStepCrtRun194 drafts) — all mechanical
workshop failures with causes recorded, and 547 (the DIAGNOSTIC bridge
probe, accepted as a diagnosis). No source statement, value, pin or
sealed module was touched by any of them. The inherited checkpoint192
register (58) and checkpoint193 register (4) remain untouched.

### Open (in order)

1. Finish `SelectedStepCrtRun194.source` (the part-3 composition and
   the exit-state export) with the abstract-bridge discipline above;
   then an axiom audit of both 194 assembly modules.
2. The additional-prime part (slen 1 / tlen 2), the remaining d-levels
   and the root/certificate/codec path, before the complete emitted
   witness can instantiate the corrected KeygenProbability134 consumers
   (KeygenModelUnlock134.package_of_witness,
   KeygenSuccessMass134.success_lower_of_witness); the prospective
   bound remains Z>=2^-256 and is NOT established by this window.

Next unused proof job suffix: **549**. Scoped proof, NOT_REVIEWED; no
IID/D1/F04 premise; no push (batch 4 waits for the owner's signal).
Values remain executed words only: no transform property, table law,
root law or positivity claim; unconditional Z>0, numerical p_accept,
conditional coding and positive p_K remain OPEN. Old110 stays frozen;
measured wording 8192/23628 with the separate 256/739 control and the
five do_sign items remain unchanged.

### Three sentences (this window)

Udowodniono: pętlę normalizacji 512 kroków przez norm_call per słowo
(indukcja paliwowa z keepami marszu przez Word32Memory176, eksport
obrazu `fun i => normWord p0 (words i)` i keepy bliźniaczych marszów
oraz kompletne wykonanie ciała zint_rebuild_CRT przy xlen = 1 —
storePrime/PrimeRead bloku 21, fałszywy guard pętli współredukcji,
gałąź normalizacji i przepływ końca; joby 529/530/534, commity
cab5bf85/df6c67ac, standardowe trzy aksjomaty). Najbliższy brak:
domknięcie montażu part 3 (SelectedStepCrtRun194.source — łańcuch Bind,
kompozycja first3/second3/tail3 i eksport stanu wyjścia zablokowane
patologiczną unifikacją termów Memory; przepis naprawy gotowy), potem
dodatkowa liczba pierwsza, d-pozomy i ścieżka root/certificate/codec
do pełnego świadka KeygenProbability134. Nic z tego nie implikuje
własności NTT, prawa tabeli, dodatniości, bezwarunkowego Z > 0 ani
p_accept/p_K — te pozostają OPEN; okno nie wykonało additional-prime
ani żadnego z wywołań CRT w pełnym montażu, więc deliverable (2)
pozostaje w toku w części montażowej.

---

## R1 crt-run window (2026-10-21) — part-3 composition closed at the exit state (job 551)

Window launched per this stage's `KEYGEN_STEP_GS_194_NEXT_ROUTE.md`
(proof job suffix 549, obligation 1 of the CRT route: close
`SelectedStepCrtRun194.source`, then axiom audit; additional-prime only
if budget). Entry re-verified read-only before any proof work: ENTRY_PINS
`99ac47a1…` recomputed against the route pin (SHA256 match), the
inherited pin chain intact and no active owned job/Lean/Sage process.
Scoped proof, NOT_REVIEWED; no push (batch 4 waits for the owner's
signal). Values remain executed words only: no NTT property, table law,
root law, positivity or Z>0 claim.

### Closed (proof jobs 551/552; logs 0/0, standard three axioms)

1. `SelectedStepCrtRun194` (job 551; source `3e2337dd`, olean
   `379dcff0`) — the make-level composition of the two zint_rebuild_CRT
   call statements of part 3 at the loop exit state of
   SelectedStepFsFd194.source, and the exit-state export. The export of
   `source` is the existential pair (next, final) with the part-2 run at
   `SelectedStepMove187.after`, the part-3 run, the two executed-word
   images `normWord p0 (fsWords i)` / `normWord p0 (gsWords i)` over the
   twin 512-word walks at `final.heap`, and the bystander keep from
   `next.heap` to `final.heap` for every cell separated from gm and from
   both walks. The engines consumed without re-derivation: `bind_crt`/
   `entryOf` (the exact Bind chain of `crtArgs "fs"/"gs"`, first
   parameter outermost), `call_run` (one full rebuildCrt call over the
   named arguments at xlen = 1, with the flat walkImage result state and
   the per-word image), `keep_through` over walkImage_keep and the
   gm/table separations (gm_offset0/fs_offset/gs_offset, fs_gm_separate/
   gs_gm_separate, block facts 31 vs 21). Commit of this window.
2. `SelectedStepCrtAudit194` (job 552, DIAGNOSTIC record) — the axioms
   of proj_heap/proj_arrays (axiom-free), bind_crt/call_run/
   keep_through/midFs_heap/midGs_heap/source: all the standard three
   (propext, Classical.choice, Quot.sound). Olean `ba2427e2`.

### The bridge recipe that closed it (księga pułapek — extend, do not re-derive)

The concrete-Memory defeq trap (jobs 543-548) is now pinned with its
working discipline, validated end-to-end by job 551:

- Never let the unifier compare two syntactically different concrete
  Memory terms. The unifier unfolds the non-projection side first, which
  unrolls the walkImage/write closures to different depths and then
  compares nested byte closures (recursion cap -> stack overflow ->
  bad_alloc). Projection-of-instance vs its own field value is equally
  lethal at a concrete memory (CrtBridgeProbe194 probe1): project
  instead through an ABSTRACT bridge lemma instantiated at the concrete
  memory (`proj_heap s H := rfl`, applied at the concrete H).
- Every remaining crossing must be (a) a rewrite along a bridging
  equation whose pattern is closed (no metavariable patterns where a
  stuck fvar projection could be matched), (b) a single delta step of a
  plain top-level definition into its own body, or (c) syntactic
  identity. Intermediate states/heaps are plain noncomputable top-level
  defs (fsHeapOf/midFs/gsHeapOf/midGs), never set-bindings.
- State witnesses follow the engines: midFs/midGs ARE the literal result
  states of the two calls, so the composition (first3/second3/tail3 via
  part3_split/rest3_split and two seqNormal steps) is fully syntactic
  and no double record-update collapse is ever needed.
- New parse trap (job 549): in `{src with f := v}` a field value placed
  on the NEXT line parses as a new ELIDED field (sepByIndent/layout),
  so the def silently fails to parse and, as a stub, poisons later
  unification with bogus recursion-depth errors. Keep structure-instance
  field values on the same line; feed them through named defs.

### Retained failures (register 55 -> 57)

Jobs 549/550 (SelectedStepCrtRun194 fourteenth/fifteenth drafts) — both
mechanical workshop failures with causes recorded above; no source
statement, value, pin or sealed module was touched. The inherited
checkpoint192 register (58) and checkpoint193 register (4) remain
untouched.

### Open (in order)

1. The additional-prime part (slen 1 / tlen 2): NOT started in this
   window (the designated deliverable — the part-3 composition and its
   axiom audit — consumed the budget; the additional-prime section needs
   its own route pinning of the parsed call shapes before any engine).
   Then the remaining d-levels and the root/certificate/codec path,
   before the complete emitted witness can instantiate the corrected
   KeygenProbability134 consumers (KeygenModelUnlock134.package_of_witness,
   KeygenSuccessMass134.success_lower_of_witness); the prospective bound
   remains Z>=2^-256 and is NOT established by this window.

Next unused proof job suffix: **553**. Scoped proof, NOT_REVIEWED; no
IID/D1/F04 premise; no push (batch 4 waits for the owner's signal).
Values remain executed words only: no transform property, table law,
root law or positivity claim; unconditional Z>0, numerical p_accept,
conditional coding and positive p_K remain OPEN. Old110 stays frozen;
measured wording 8192/23628 with the separate 256/739 control and the
five do_sign items remain unchanged.

### Three sentences (this window)

Udowodniono: domknięcie montażu part 3 — oba wywołania zint_rebuild_CRT
("fs"/"gs") złożone na stanie wyjścia pętli make_fg_step przez dokładny
łańcuch Bind nazwanych argumentów, uruchomienia ciała przy xlen = 1 i
kompozycję first3/second3/tail3, z eksportem obrazów wykonanych słów
`normWord p0 (fsWords/gsWords)` i keepów bliźniaczych marszów oraz
komórek obojętnych (job 551, standardowe trzy aksjomaty; audyt job 552)
— i to recepturą z probe 547: abstrakcyjne mosty proj_heap/proj_arrays,
przejścia syntaktyczne, zero unifikacji konkretnych termów Memory.
Najbliższy brak: additional-prime (slen 1 / tlen 2) — nie rozpoczęte
w tym oknie (budżet zużyty na domknięcie i audyt; wymaga najpierw
przypięcia kształtów parsowanych wywołań), potem d-pozomy i ścieżka
root/certificate/codec do pełnego świadka KeygenProbability134. Nic z
tego nie implikuje własności NTT, prawa tabeli, dodatniości,
bezwarunkowego Z > 0 ani p_accept/p_K — te pozostają OPEN; okno nie
wykonało additional-prime ani nie ruszało pełnego montażu KeyGen, więc
deliverable (2) trasy pozostaje otwarty.

---

## R1 additional-prime window (2026-10-21) — the section call shapes pinned; the modp_Rx stratum wall

Window launched per this stage's `KEYGEN_STEP_GS_194_NEXT_ROUTE.md`
(proof job suffix 553, route obligation 1: the additional-prime part
(slen 1 / tlen 2) — first the parsed call shapes in the
MakeFgCrtShape194 decide-bound pattern against a parse probe record,
then the steps). Entry re-verified read-only before any proof work:
ENTRY_PINS `99ac47a1…` recomputed against the route pin (SHA256 match),
all 73564 inherited pinned paths re-checked (0 missing, 0 changed) and
no active owned job/Lean/Sage process. Scoped proof, NOT_REVIEWED; no
push (the outgoing range holds 3 commits for the owner's publication
signal). Values remain executed words only: no NTT property, table law,
root law, positivity or Z>0 claim.

### Closed (proof jobs 553/557/558; logs 0/0, standard three axioms)

1. `AddPrimeParseProbe194` (job 553, DIAGNOSTIC record; source
   `57089341`, stdout `ad9df22f`) — the parse-dump probe of the
   additional-prime section: `KeygenMakeFgSource.part .step 4` (the
   remaining-words loop `for (u = slen; u < tlen; u ++)`) and the
   consumed callee bodies `KeygenZintCall.calleeBody .modSigned` /
   `(.leaf .reduce)`. Retained as a record in the register; no
   execution or numerical property is claimed.
2. `MakeFgAddPrimeShape194` (job 557; drafts 554/555/556 retained;
   source `a7cd77d3`, olean `828367ab`) — source-bound naming of the
   whole additional-prime section by decide against the probe's parse
   record. Pinned shapes: the loop head (u = slen init, u < tlen guard,
   u += 1 increment, body scope locals p/p0i/R2/Rx/v and pointer x), the
   seven-statement prime prefix (the three declarations; pSet/iSet/rSet
   = StepPrimeShape188 verbatim; the new `Rx = modp_Rx(slen, p, p0i,
   R2)` call4), and the eight-statement chain with every call's exact
   parsed argument list: the ter generator branch (modp_mkgm3 wrapper at
   the seven named arguments and the modp_mkgm2 binary at six),
   walkFs/walkGs (the per-word zint_mod_small_signed call over the
   walked pointer x with the section words p/p0i/R2/Rx, stored to
   t1[v]; the fs/gs instantiations of one walk), nttFs/nttGs (the
   modp_NTT3 wrapper at the expanded stride-1 argument list and the
   modp_NTT2 binary), productFd/productGd (= MakeFgProductShape191.
   productF / MakeFgGsShape194.productFGd verbatim) and outBranch (the
   false !out_ntt branch: the fd/gd modp_iNTT3_ext pair at logn-1/tlen
   and the modp_iNTT2_ext binary pair, all argument lists named). The
   zint_mod_small_signed callee spine is split and pinned as well (z
   declaration, dlen = 0 early return branch, the zint_mod_small_unsigned
   leaf call into z, the modp_sub sign correction, the z return). THE
   OWNER'S NAJPIERW OBLIGATION IS CLOSED. (Trap recorded: two
   cross-parse shape equalities against whole-section projections of the
   part-2 parse blew the kernel memory limit — bind such shapes as local
   transcriptions in split form instead; see register 556.)
3. `KeygenModpRx` (job 558; source `103a04dd`, olean `5d341010`) — the
   source binding for the composite modular callee modp_Rx in the
   KeygenMkgm3Callees form: the body transcription rxCode (rxParams
   x/p/p0i/R2; `x--; r = R2; z = modp_R(p); for (i = 0; (1U << i) <= x;
   i ++) { if ((x & (1U << i)) != 0) z = modp_montymul(z, r, p, p0i); r
   = modp_montymul(r, r, p, p0i); } return z;` with the 1U literal
   parsed as .u32 1) is checked against the pinned source parse
   (`rx_source_bound : C99ModularParser.region 2609 18=some rxCode`,
   `rx_header` pins line 2607). This is the ready plug for the call
   stratum decision below: the transcription and the binding move
   verbatim into the ModCall extension.

### WALL (księga pułapek — modp_Rx is outside the pinned ModCall stratum; do not re-derive)

The `Rx = modp_Rx(slen, p, p0i, R2)` statement of the additional-prime
loop body parses as a modular-layer `Expr.call4` assignment (probe 553).
The canonical modular execution relation is `C99ModularReference.Exec =
GenExec ModCall`, and the closed ModCall stratum covers exactly
modp_montymul / modp_add / modp_sub / modp_ninv31 / modp_set / modp_R /
modp_R2 / modp_div; KeygenMakeFgSource.Exec, KeygenLevelExec.Exec and
KeygenWordExec.Exec all fix that relation. NO KeygenMakeFgSource.Exec
derivation can exist for the rxSet statement — the section is blocked at
statement 7 of its loop body (the three declarations, the prime read
`p = primes[u].p`, `p0i = modp_ninv31(p)` and `R2 = modp_R2(p, p0i)`
are executable under the pinned semantics; the seventh is not). The fix
is the precedented call-stratum extension in the PINNED source
`formal/Source3/C99ModularReference.lean` (the r2/div constructors were
added exactly this way in B1.03, commits 0e5a0b02/c3170530): rxParams/
rxCode/rxBody plus `| rx (args out) (body : rxBody args out) : ModCall
"modp_Rx" args out`. That file is inside the inherited 73564-path pin
set, so the edit is an owner decision and needs a documented pin-chain
re-baseline. The same wall hits every later modp_Rx call site
(poly_sub_scaled_ntt falcon-keygen.c:4626, solve_NTRU_intermediate
:5906/:5985, solve_NTRU_binary_depth1 :6474) — one extension closes
them all. Scope note: the wall is a coverage gap of the pinned call
whitelist, not a source-correctness result; nothing here speaks against
the C code.

### Retained failures (register 57 -> 61)

553 (DIAGNOSTIC parse-dump probe, retained as a record), 554 (first
shape draft: the statement-chain projections skipped the gd product
loop, shifting the last two bindings), 555 (second run interrupted at
job start by a server/provider restart — empty logs, no receipt;
environment event, label consumed), 556 (second shape draft: the two
cross-parse equalities hit the kernel memory limit; replaced by split
local transcriptions). No source statement, value, pin or sealed module
was touched by any of them. The inherited checkpoint192 register (58)
and checkpoint193 register (4) remain untouched.

### Open (in order)

1. THE OWNER DECISION on the modp_Rx wall: extend the pinned ModCall
   stratum (ready plug KeygenModpRx) with a documented pin-chain
   re-baseline, or route otherwise. Without it no statement of the
   additional-prime loop body past the prime prefix receives a canonical
   KeygenMakeFgSource.Exec derivation.
2. The additional-prime steps at slen = 1 / tlen = 2 (after the
   decision): the prologue words at the u = 1 iteration (p = primes[1].p,
   p0i = modp_ninv31(p), R2 = modp_R2(p, p0i), Rx = modp_Rx(1, p, p0i,
   R2); at x = 1 the body loop is empty and the intended executed word
   is modp_R(p) — PAPER ANALYSIS ONLY, the value law is not proven here
   and needs the stratum constructor), the ter generator call
   modp_mkgm3(gm, igm, logn, 0, primes[1].g, p, p0i), the two 512-step
   zint_mod_small_signed walks over fs/gs (their per-word engine at
   dlen = 1 is NOT blocked by the wall and is the first engine to build:
   ZintModSignedWord194 over the pinned callee spine plus the
   zint_mod_small_unsigned leaf at dlen = 1), the two forward modp_NTT3
   runs (KeygenNttForwardPrograms pins the body; no execution engine
   exists yet — the biggest item), the fd/gd product loops at the u = 1
   cell (tlen = 2 walk; the product engines transfer) and the false
   !out_ntt skip; then the loop composition and the section export.
3. Then the remaining d-levels and the root/certificate/codec path,
   before the complete emitted witness can instantiate the corrected
   KeygenProbability134 consumers (KeygenModelUnlock134.package_of_witness,
   KeygenSuccessMass134.success_lower_of_witness); the prospective bound
   remains Z>=2^-256 and is NOT established by this window.

Next unused proof job suffix: **559**. Scoped proof, NOT_REVIEWED; no
IID/D1/F04 premise; no push (batch 4 waits for the owner's signal).
Values remain executed words only: no transform property, table law,
root law or positivity claim; unconditional Z>0, numerical p_accept,
conditional coding and positive p_K remain OPEN. Old110 stays frozen;
measured wording 8192/23628 with the separate 256/739 control and the
five do_sign items remain unchanged.

### Three sentences (this window)

Udowodniono: przypięcie kształtów parsowanych wywołań całej sekcji
additional-prime (part .step 4 przy slen = 1 / tlen = 2) — głowę pętli,
siedmiowyrazowy prefiks prime/p0i/R2/Rx, gałąź generatora ter z
dokładnymi listami argumentów modp_mkgm3/modp_mkgm2, oba marsze
zint_mod_small_signed po fs/gs z dokładnym wywołaniem per słowo i
zapisem t1[v], gałęzie modp_NTT3/modp_NTT2, pętle produktowe fd/gd
(= znane kształty productF/productFGd) i fałszywą gałąź !out_ntt z parą
fd/gd — decide na pinowanym probe (553/557), oraz transkrypcję i source
binding ciała modp_Rx gotową do decyzji o stratumie (558). Najbliższy
brak: wykonanie kroków dodatkowej liczby pierwszej jest zablokowane na
siódmym kroku sekcji (`Rx = modp_Rx`) — pinowana stratum ModCall nie
ma konstruktora dla modp_Rx, więc wymagana jest decyzja właściciela o
rozszerzeniu C99ModularReference (precedens B1.03); potem prolog,
marsze (ich silnik per słowo nie jest zablokowany), forward NTT3 (brak
silnika) i produkty. Nic z tego nie implikuje własności NTT, prawa
tabeli, dodatniości, bezwarunkowego Z > 0 ani p_accept/p_K — te
pozostają OPEN; okno nie wykonało ani jednego kroku sekcji, a ściana
jest luką pokrycia semantyki wywołań, nie wynikiem o niepoprawności
kodu.

## R1 engine window (2026-10-21) — the zint_mod_small_signed march engine accepted (job 563)

Window launched per the WORK_STATE resume (proof job suffix 563: the
engine ZintModSignedWord194 (per march word, dlen = 1) first, then the
additional-prime steps 1-7). Entry re-verified read-only before any
proof work: ENTRY_PINS `.build/steprx195/ENTRY_PINS.json` SHA256
00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964
(matches the route pin), the old manifest 99ac47a1d981ebfc… untouched
in `.build/stepgs194/` and recorded in the supplement
`run2/notes/PINY_I_OLEAN_STRUKTURA.md`; no active owned job/Lean/Sage
process. Build-order rule (księga) observed: the engine is a single
module over cached bindings, its real transitive import graph
(MakeFgAddPrimeShape194 -> KeygenModpR2Exec -> ZintNormWord194 ->
ZintSubWord194, all cached) checked before the run; no cache-map order
was relied on. Scoped proof, NOT_REVIEWED; no push (the outgoing range
holds 7 commits for the owner's publication signal).

### Closed (proof job 563; logs 0/0, standard three axioms)

`ZintModSignedWord194` (job `keygen_publicforward159_563`; source
`4f96c58f8dddd45a…`, olean `a85b5697a5f28e98…`, receipts
`4667a145f0b7a523…`; 42.299 s, `-DwarningAsError=true`, clean_log,
forbidden_proof_markers = [], sandbox bwrap/prlimit 12 GiB) — the
zint_mod_small_signed engine at dlen = 1, per march word (the marched
limb `d[0] = d0` and the section words p/p0i/R2/Rx are arbitrary
BitVec 32; the walked pointer x is arbitrary at its marched position
pd):

1. `unsignedWord d0 p p0i R2` — the executed word of the nested
   zint_mod_small_unsigned leaf at dlen = 1: one loop round (u = dlen
   = 1; the body decrements u first, so the read limb is d[0] = d0):
   `x := modp_montymul(0, R2, p, p0i); w := d0 - p; w := w +
   (p & -(w >>> 31)); x := modp_add(x, w, p)`, then the trailing u wrap
   (u = 0-1) and the x return; both modular calls at their pinned leaf
   bodies (KeygenModpWord.montgomery / KeygenModpAddSub.result .add).
2. `signWord Rx d0 = Rx & -(d0 >>> 30)` and the exported image
   `modSignedWord d0 p p0i R2 Rx = modp_sub(unsignedWord d0 p p0i R2,
   signWord Rx d0, p)` (KeygenModpAddSub.result .sub) — the honest
   executed word of the whole callee (the mask/negation semantics
   follow the pinned parse, not any shorthand).
3. `leaf_run` — the complete pinned leaf body
   `KeygenZintCall.calleeBody (.leaf .reduce)` executed in full as one
   KeygenWordExec.Exec (declaration chain, one loopNormal round, the
   loopFalse exit, the wrap decrement, the return) with the returned
   word and the heap-keeps fact (the body writes locals only).
4. `spine_run` — the complete pinned spine `MakeFgAddPrimeShape194.msBody`
   executed in full as one KeygenZintCall.Exec: the z declaration, the
   dlen = 0 early-return branch resolved FALSE at dlen = 1, the
   zint_mod_small_unsigned leaf call into z (its Bind over the five
   leaf parameters and the ReceiveC.into), the modp_sub sign
   correction with the `d[dlen-1]` load at index 0, and the z return.
5. `ms_call` — the call-level export at the pinned walk shape
   `MakeFgAddPrimeShape194.modArgs`: for any caller state with the
   slen = 1 u64 cell, the p/p0i/R2/Rx u32 cells and the walked pointer
   x at pd with the loaded word d0, `KeygenZintCall.Call .modSigned
   before modArgs before (some (.uint32 (modSignedWord d0 pw p0w r2w
   rxw)))` — the per-march-word engine the two 512-step walks will
   consume (512 instantiations at slen = 1).

Shape bindings stay decide-bound to the pinned job-553/557 parse
record (`reduce_shape`, `ms_decl_shape`, `ms_zero_shape`,
`ms_leaf_shape`, `ms_sub_shape`, `ms_ret_shape`); no new parse
recognition was performed. Axiom audit (workshop, `#print axioms` on
leaf_run/spine_run/ms_call/reduce_shape/ms_leaf_shape): exactly the
standard three (propext, Classical.choice, Quot.sound); marker scan
sorry/admit/native_decide = 0 hits. Workshop note (honesty): the
module was developed in a local typecheck loop (about 12 iterations
against the job-562 library) before the single acceptance run; no
draft job suffixes were consumed and no draft job records exist.

Values stay executed words: no residue range, normalization,
positivity or correctness claim of the C algorithm is made; no
transform property, table law, root law or Z>0 claim.

### Traps met (księga pułapek — do not re-derive)

- `KeygenWordExpr.Eval` constructors take every index explicitly
  (bin: 9 arguments, neg: 5, call3: 12, call4: 15); partially
  dot-annotated applications fail or elaborate against the wrong type.
- The CLogic-layer read `bin sub a b` evaluates through
  `C99Frontend.binary = .arithmetic .minus`; build it with `_` for the
  translated operands and `C99ScalarReference.Eval.literal .int32 n`
  for literals (the `C99ValueBridge.type` conversions are defeq).
- `Exec.loopNormal`'s middle state is the state after the whole loop
  BODY (the first body statement is inside); `branchFalse`/`loopFalse`
  take `out` before the boolean guard value.
- Deep `rfl` heap chains time out (`whnf`, 2M heartbeats) when they
  cross both a t*-state chain and an entry bind chain; split them into
  `Eq.trans` of per-definition heap lemmas (leaf_entry_heap,
  ms_entry_heap, msV_heap).
- `show` does not unfold definitions: the bind-cell/bind-other rewrites
  need the unfolded `bindValue …` form in the goal first.
- The acceptance runner enforces `-DwarningAsError=true`; unused simp
  arguments are errors in acceptance runs (drop them).
- Lean resolves a module name against the first LEAN_PATH entry that
  contains the parent directory; a scratch library root must contain
  the whole symlink farm, not just the new olean.

### Retained failures (register unchanged: 64 + 58 + 4)

No job failed this window; `KEYGEN_STEP_GS_194_FAILURES.json` keeps
its 64 records, the inherited checkpoint192 register (58) and the
checkpoint193 register (4) are untouched.

### Open (in order)

1. The additional-prime steps 1-7 (the seven-statement prime prefix of
   the loop body at the u = 1 iteration: the three declarations, the
   `p = primes[1].p` read, `p0i = modp_ninv31(p)`, `R2 = modp_R2(p,
   p0i)`, `Rx = modp_Rx(1, p, p0i, R2)`) — NOT started this window
   (budget; clean freeze instead of stretching). Everything is
   prepared: the shapes are pinned and decide-bound
   (MakeFgAddPrimeShape194.prefixSteps / front / prefix_shape), the
   modp_Rx wall is closed (the rx constructor + KeygenModpRx + the
   pin-chain re-baseline of the previous window) and the route file
   carries the plan. The first lemma is the empty-loop rx body at
   x = 1 (x-- leaves 0, the loop is empty, the intended executed word
   is modp_R(p) — paper analysis of earlier windows, to be PROVEN).
2. Then the ter generator call (modp_mkgm3 wrapper), the two 512-step
   walks (their per-word engine is NOW READY: ZintModSignedWord194.ms_call),
   the forward modp_NTT3 runs (no execution engine exists yet — the
   biggest item), the fd/gd product loops and the false !out_ntt skip;
   then the loop composition and the section export.
3. Then the remaining d-levels and the root/certificate/codec path,
   before the complete emitted witness can instantiate the corrected
   KeygenProbability134 consumers. Unconditional Z>0, numerical
   p_accept, conditional coding and positive p_K remain OPEN.

Next unused proof job suffix: **564**. Scoped proof, NOT_REVIEWED; no
IID/D1/F04 premise; no push (the outgoing range holds 7 commits plus
this window's local commits for the owner's publication signal).
Old110 stays frozen; measured wording 8192/23628 with the separate
256/739 control and the five do_sign items remain unchanged.

### Three sentences (this window)

Udowodniono: kompletny silnik egzekucji zint_mod_small_signed przy
dlen = 1 per słowo marszu — ciało zint_mod_small_unsigned w całości
(jedna runda pętli, montymul/add na przypiętych ciałach liści),
kręgosłup modSigned z wywołaniem tego liścia, poprawka znaku modp_sub
przez wczytanie d[dlen-1] oraz eksport na poziomie wywołania dla
przypiętego kształtu marszu modArgs (job 563, logi 0/0, trzy
standardowe aksjomaty, markery 0). Najbliższy brak: kroki 1–7 sekcji
additional-prime (siedmiowyrazowy prefiks prime/p0i/R2/Rx przy u = 1)
nie rozpoczęte w tym oknie — budżet; najpierw pusty przypadek pętli
rxBody przy x = 1 (zamierzane słowo modp_R(p)), potem prolog, mkgm3,
oba marsze (silnik gotowy), modp_NTT3 (brak silnika — największa
pozycja), pętle produktowe i fałszywa gałąź !out_ntt. Wynik NIE
implikuje żadnej własności liczbowej algorytmu C (zakres/reszta/
normalizacja/Z>0/p_accept/p_K pozostają otwarte), nie zamyka sekcji
additional-prime ani KeyGen i nie jest odbiorem (NOT_REVIEWED).
