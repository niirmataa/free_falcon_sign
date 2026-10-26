# R1: full forward call-frame image and concrete additional-prime products (578)

Date: 2026-10-26. Proved exports: **PROVED_KERNEL_SCOPED / NOT_REVIEWED**.
Overall requested integration: **PARTIAL_PROOF**. The full aLoop/part4
section and the concrete body_entry domain discharge remain OPEN.
WYKONANE: three proof modules, one original-type/axiom audit and retained
attempt evidence. PRZETESTOWANE: canonical job 578, 4/4 accepted, diagnostics
0 errors / 0 warnings. NIEZALEZNIE ODEBRANE: NOT_RUN / NOT_REVIEWED.
No subagents, push, stages import, migration or production C change.

## Proven scope

`StepNttForwardImage195.firstWords` converts the completed first-pass
low/high image into a total Nat-indexed word function. Only indices below
512 are observed. `first_image` proves that conversion. `prefix_image`
uses the corrected execution-derived job-571 bodyAt/stepAt chain and
constructs ONE prefix output with its first-pass image, MFixed, u=256
and declared m/t. It retains the first-pass image that the earlier
entry_middle interface did not export. The historical bodyHeap defect
and its permanent supplement remain authoritative; defective stepState
is never used.

`forwardWords` applies the job-577 counted eight-round doublingWords to
those first-pass words. `complete_image` constructs the entire original
modp_NTT3_ext forwardBody execution at logn=9/full=0/stride=1 with its
image of ALL 512 words, MFixed and terminal m=512/t=1 on the SAME output.
The caller supplies input loads, pointer domains, gm loads and separation;
no resulting forward execution or resulting image is assumed.

`call_image` executes the actual seven-argument Bind and the forward
wrapper call, returning the callee heap to a caller state whose locals
and arrays are unchanged. The exact image belongs to that returned heap.
`branch_image` executes the actual ternary NTT branch. `call_stable`
derives allocation-metadata stability from the executed writes and
argument binding, rather than adding a heap-stability assumption.

`StepAddProduct195` instantiates the product engines at the CONCRETE
selected layout and ADDITIONAL-prime cells u=1, tlen=2, hn=256,
p1/p0i1/r21. Its Input lists individual caller cells, pointer bindings,
writability and the source image, rather than an assumed product run or
post-initialization loop invariant. Destination allocations are derived
from the t1 image load and the shared allocation extent. Destination/source
separation and pairwise destination separation are proved at addresses
fd[1+2*v] and gd[1+2*v]. Each initializer executes v=0 and x=fd+u or gd+u
for any declared old v. fd_reads/gd_reads explicitly consume the literal
job-577 t1[(v<<1)+0/1] bridge at the initialized state. fd_fixed/gd_fixed
construct the full loop domains, and fd_source/gd_source execute all 256
products using the original loop/body/increment. The output image records
exactly the two nested Montgomery products of W(2*v), W(2*v+1), with R2.
Both loops preserve all 512 t1 source words and caller cells outside v/x.

`StepAddForwardProduct195.forward` builds the full forward output and
ALL product Input fields at that output, including writability from
call_stable. The concrete gm/t1 separation is discharged by layout.
fd_section/gd_section then construct, respectively, nttFs;productFd and
nttGs;productGd with the actual forwardWords as product input, on one
threaded sequence of states. Neither theorem assumes the target forward
or product execution. out_skip proves the ADDITIONAL-prime !out_ntt=false
branch at out_ntt=1. gd_suffix composes the actual r5/r6/r7/r8 parse spine,
including that skip and the final skip, and preserves the gd product and
t1 images at its final state.

These are concrete-domain section fragments. They do not yet produce
BOTH fd and gd images at one full additional-prime-section exit.

## Canonical verification and pins

Command from source3:

```sh
python3 -B tools/job111.py lean keygen_publicforward159_578 \
  Source3.StepNttForwardImage195 Source3.StepAddProduct195 \
  Source3.StepAddForwardProduct195 Source3.StepForwardProductAudit195
```

4/4 accepted, exit 0, warningAsError, forbidden proof markers [].
Elapsed times: forward 6.936s, products 4.676s, composition 4.275s,
type/axiom audit 3.024s; cumulative child maxRSS 4103296 KiB.
The three proof stdout/stderr files and audit stderr are empty. Audit
stdout retains 13 original types and 21 separate #print axioms results.
firstWords/first_image/forwardWords depend on [propext, Quot.sound];
the other 18 audited declarations use only
[propext, Classical.choice, Quot.sound]. No extra axiom or suppression.
The inherited -j1/-M6144, AS12GiB/RSS8GiB/wall1800s and bwrap isolation
were kept. Canonical PREFLIGHT records no competing process.

ENTRY_PINS `.build/steprx195/ENTRY_PINS.json` SHA256
`00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964`:
74673/74673, 0 missing / 0 changed before AND after. Job-577 evidence and
retained-attempt bindings: 52/52 before AND after. No re-baseline and no
change to pinned predecessor sources, receipts or manifests. Full new
source/snapshot/olean/log/receipt hashes are in
KEYGEN_STEP_FORWARDIMAGE_195_578.json beside this report.

## Retained attempts and traps

Historical 65 + 58 + 4 plus the permanent bodyHeap finding, both job-575
setup failures, the job-576 dif_pos failure and the job-577 performance
failure are preserved through the pinned predecessor registers.
This window retains FOUR new failed local attempts; no canonical lane
job failed and no failed product was admitted into its cache.
All six local attempts, including partial/complete successes, keep their
actual snapshots, receipts and logs under .build/forwardimage578/.
KEYGEN_STEP_FORWARDIMAGE_195_FAILURES_578.json enumerates their hashes.

- attempt001: outer sandbox rejects bwrap NETLINK_ROUTE before Lean,
  0.004s/exit 1. Environment failure, not a proof check. Re-run via the
  permitted host path, preserving bwrap isolation and limits.
- attempt002: Lean cannot infer hn from Fin (2*hn)=Fin 512; a local
  identifier `scoped` also collides with a reserved token. Add explicit
  hn:=256 and rename the identifier scopedRun. 18.371s/exit 1.
- attempt003: simp normalizes the target KeygenSmallOutput.element but
  leaves the source StepCopyBody190.elem wrapper. Normalize BOTH pointer
  definitions in the image conversion. 4.625s/exit 1.
- attempt004: forward accepted (5.327s); products failed (3.424s).
  `decide` refuses syntactically open allocation fields even when their
  normal forms are constants: change to 0<4 and 0%4=0 first. A heap
  equality `rfl` lets inference choose the source state instead of the
  initialized state: pass out:=fdMid s / out:=gdMid s explicitly.
- attempt005: products accepted, 3.171s, diagnostics 0/0.
- attempt006: all three final proof modules accepted, 5.327/3.676/3.021s,
  diagnostics 0/0, maxRSS 4099520 KiB.

No mathematical counterexample, timeout, limit increase, warning
suppression or marker-based proof shortcut occurred in this window.
The copied entry verifier retains its historical suffix-577 docstring;
its unchanged implementation was used for both suffix-578 checks, as
recorded by its path/hash. It is not a new manifest or re-baseline.

## Recoverable handoff

Next unused lane suffix: **579**. Resume from this report, WORK_STATE,
ENTRY_PINS and the job-578 evidence, without rebuilding failed attempts.

1. Instantiate the pre-forward Input fields and gmLoads at the ACTUAL
   walkFs/walkGs outputs after the generator, with W bound to the
   executed modSignedWord march image. The current forward/product
   fragments take those explicit caller domains; they do not discharge
   them from SelectedStepAddPrime195.body_entry.
2. Compose generator; walkFs; fd_section; walkGs; gd_suffix while
   preserving the fd image across the later gs march, NTT and gd writes.
   Export BOTH product images at the same additional-prime body exit.
3. Consume SelectedStepGenerate195.continue_inner and
   SelectedStepAddPrime195.continue_inner/body_entry, restore aBody
   scope, increment u=1 to 2, prove the terminal u<tlen guard false,
   and export the full aLoop/aFor/part4 section.

This window freezes at the checked forward/product boundary under
ft-lean-okno (`/home/footfalcon/.agents/skills/ft-lean-okno/SKILL.md`):
"Kontekst: przy >60% budżetu — zamroź w punkcie odzyskiwalnym i melduj."
The remaining integration is not reclassified as completed or outside
the owner's requested scope. One local source checkpoint is intended;
eight unpublished commits at entry plus that checkpoint = nine waiting.
The unrelated threshold prompt remains untouched.

This proves scoped executed-word behavior in the pinned author-defined
reference semantics, not a closed-form transform/root/table law,
compiler correctness, full KeyGen/Sign or security. Unconditional Z>0,
p_accept, p_K and prospective Z>=2^-256 remain OPEN. Old110, measured
wording and the five do_sign obligations are unchanged.
