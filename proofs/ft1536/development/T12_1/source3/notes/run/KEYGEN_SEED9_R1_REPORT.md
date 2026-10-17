# OKNO R1 — kernel certificate of one seed (fixture seed9): window report

2026-10-17. Owner window "R1: kernel certificate of one seed (fixture
seed9), G(seed*) = success -> Z > 0", continued from HEAD after Z-lower 134
on the base of infrastructure 159 and KEYGEN_PUBLIC_FORWARD_159_NEXT_ROUTE.
Status: **PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED**. The window is NOT
COMPLETE: region 1d is split into three modules, one accepted pair of
support modules and one accepted loop module are committed; the remaining
modules of 1d and regions 2-5 are open. No new assumption, no paper
change, no push, no worker/reviewer; corrected134, measured wording and
five do_sign unchanged.

## Region table

| Region | Content | Status at this close | Modules / jobs |
|---|---|---|---|
| 1d | mq_mkgm3 generator suffix: loops 256/256/255 + gm0/w/igm0 stores | **IN PROGRESS, split into 3 modules** | see below |
| 1d.a | value-free table + index support | **ACCEPTED** | PublicGenerateTable159 / PublicGenerateIndex159, jobs 020/024 |
| 1d.b | row loop (256 iterations, bit-reversed writes) | **ACCEPTED** | PublicGenerateRow159, job 029 |
| 1d.c | upper loop (256) + square loop (255) + final stores + init/remaining composition | shapes + invariant scaffold checking | PublicGenerateUpper159, job 030 |
| 2 | tail passes (fragment 1001 61: 768, 8 rounds, tripling 512) | OPEN — not started | — |
| 3 | suffix fragment 1537 10 + packet emit | OPEN — not started | — |
| 4 | root solver + certificate gate + codec tails | OPEN — not started | — |
| 5 | G(seed*) = KeygenByteGame134.evaluate + package_of_witness | OPEN — requires 1d+2+3+4 | — |

## What is kernel-proved in this window

All proofs are constructive executions of the pinned source statements,
value-free (no table image, no evaluation property, no semantic premise);
standard axioms only (`propext`, `Classical.choice`, `Quot.sound`); all
accepted logs 0/0; one Lean process per job (tools/job111.py, unchanged
limits, -j1 -M6144).

1. **PublicGenerateTable159** — `Written` cells, `Tables` frames, legal
   sixteen-bit writes (`store_source`), per-target write preservation
   (`written_new`/`written_after`/`separate_or_same`), `tables_write`.
2. **PublicGenerateIndex159** — forward source operations for all three
   suffix loops: `shl_one`/`shl_pow`/`add_two`/`sub_one`/`u32_add_one`/
   `plus_u64_u32`/`compare_gt_zero`, the CLogic and word-expression
   evaluations, the bit-reversed row indices through the executed rev10
   calls (`rev_call_u`/`rev_call_next` via `KeygenPublicRevCert`), the
   store/load addresses (`address_index`/`address_index_next`/
   `address_u64`/`address_shifted`) and `lastIndex_lt`/`lastIndex_big`.
3. **PublicGenerateRow159** — the complete row loop (falcon-vrfy.c
   852-859): `body_source` (four sixteen-bit stores and four scalar
   updates per iteration, exact four-layer heap composition, full caller
   frame), `Cover2` the value-free Written-range invariant, `loop_source`
   (256 iterations to the final false guard), `covered_top` delivering the
   [512,1024) coverage consumed by the upper loop.

## Region 1d.c scaffold (checked shapes; execution open)

PublicGenerateUpper159 carries the exact parsed shapes of the upper and
square suffix loops (kSet/u2Init/upperLoop/u3Init/squareLoop/finalTail)
with the kernel-checked decomposition `afterRows_shape` against the pinned
parser (verified byte-identical to the parser output by the retained
diagnostic probe PublicGenerateUpperProbe; the earlier false verdict was a
doubled trailing skip - `chain` appends its own), the `UpperInv`/`CoverUp`
invariants and the update-statement executions (`update_exec`/
`update_down_exec`). The two loop bodies, their inductions, the final
three statements and the initK/initB/initU + remaining composition remain
to be constructed.

## Checks, failures and preservation

Jobs keygen_publicforward159_016-030; accepted 020 (table), 024 (index),
029 (row), 030 pending. Failures retained with causes (016/017 table
syntax, 018/019 diagnostic syntax probes, 021-023 index fixes, 025-028
row fixes): no source-C counterexample or integrity failure was found;
all failures were elaboration/construction issues of the new modules.
The two DIAGNOSTIC syntax probes (PublicGenerateSyntaxProbe) are retained
as evidence of the environment parse quirk recorded below; they are not
proof evidence. The untracked 158/159 probe files found at entry were
left exactly as found.

Construction notes worth keeping: in this toolchain the tokenizer glues
comparison operators immediately followed by `i` (`j<i`, `j<=i` fail to
parse; spaced forms work); `scoped` is a keyword and cannot be a binder
name; unused binders are lint errors; structure applications such as
`Tables s gm igm` do not unify across defeq-equal states and need a
transport lemma (`tables_frame`); `Allocated` hides its `size` occurrences
from `rewrite` unless unfolded.

## Three sentences

The kernel now executes the complete mq_mkgm3 row loop of the seed9
fixture - 256 iterations of bit-reversed sixteen-bit writes with the exact
heap composition and a value-free Written-range invariant - so the first
of the three generator suffix loops is no longer a wall point but a
committed theorem. The upper and square loops, the final gm0/w/igm0
stores and the remaining/init composition are shaped and scaffolded but
not yet constructed, so region 1d is honest PARTIAL and regions 2-5 (tail,
suffix 1537, solver/certificate/codec, G(seed*)) are untouched. No G(seed*)
and no package unlock is claimed in this window: the analytic route stays
refuted per Z-lower 134 and the R1 witness track is the only live path,
now with its first loop kernel-certified.

## Next steps (for the following window)

1. Finish 1d.c: upper loop body/induction, square loop body/induction,
   finalTail execution, initK/initB/initU + remaining composition; expose
   `WrittenRange 0 1024` on both tables as the handoff to region 2.
2. Region 2: tail passes over the universal butterfly rules (already
   accepted in the 140-148 family) instantiated at the actual states.
3. Regions 3-5 per the ordered plan; region 5 consumes
   `KeygenModelUnlock134.package_of_witness` for Z >= 2^-256.
