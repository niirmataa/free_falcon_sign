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
