# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_036 notes (upper loops + exceptional igm0 core)

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN. CLOSED_AT_RECOVERABLE_MIDPOINT.**
2026-10-09, BATCH_036, GPT-6 Astra (`openai/gpt-6-astra`). B1.06 Acceptance NOT MET.
B1.05 remains closed at BATCH_032; B1.07 is not entered. Resume: **16R**.

## Closed this window

1. **Whole upper-loop composition (15.1 item 1) — DONE.**
   `KeygenPublicUpperFrames`: byte-level `UpperFrame` (size/writable maps and
   every byte outside the two full table ranges survive), `full_write_frame`,
   `from_last` (LastFrame implies UpperFrame) and `cube_frame`/`square_frame`
   derived from the actual store executions.
   `KeygenPublicUpperLoops`: `u_increment`/`u_decrement` (scalar updates on the
   size_t counter), executed initializer words (k=8, u=256, u=255), both guard
   values, `CubeInv`/`SquareInv` with child Cell facts at 2*i supplied by the
   preceding iterations of the SAME run, `cube_progress`/`square_progress`,
   `cube_step`/`square_step`, `cube_source_loop`/`square_source_loop` (full
   loop induction to u=512 / u=0), `source_upper` (the SAME afterRows execution
   decomposes initK/cubeLoop/initSquare/squareLoop, filling both tables at
   1..1023, leaving only the actual `finish` statement) and `source_tables`
   (complete generate execution through both loops, original-heap frame).
2. **Exceptional finish core (15.1 item 2) — CORE DONE, execution layer open.**
   `KeygenPublicUpperFinish`: `source_finish` binds the actual parse of source
   881-884 (`gm[0]=gm[1]; w=gm[1]; igm[0]=(uint16_t)mq_div_18433(R2t,...);`),
   literal-index/load adapters, add/sub/divT call normalization with U32
   argument conversion and word exactness, and the full field algebra:
   `add_field`, `sub_field`, `division_scaled` (value x*(value y)^18431 with
   Fermat inversion and nonzero domains), `te_zero`/`te_one` (tableExponent 0=1=768),
   `two_first_root_nonzero` ((2*firstRoot-1)^2=-3), and `exceptional`:
   the stored word of igm[0] is **radix/(2*firstRoot-1), NOT radix/firstRoot**;
   ((2*firstRoot-1)^-1) is proved different from (root^-1)^tableExponent 0.

## Traps met (186-190)

- **186.** Mathlib notation breaks the token adjacency `0<i` before `)`
  (parse error); `0 < i` with spaces parses. Diagnosed by minimal probes.
- **187.** `omega` cannot see structure projections: bounds like `inv.upper`
  must be extracted to named hypotheses first.
- **188.** `cases` eliminates `out`; statement-level results must be phrased on
  the constructor's heap (`heap`) and closed by defeq through `restoreScope`.
- **189.** Definitions (`Slot`, `USlot`, `Pointers`) hide their fields from
  `rw`; use `show` to unfold before rewriting.
- **190.** `C99NarrowReads.unsignedPromotion w` is not unifier-defeq with
  `.uint32 (BitVec.ofNat 32 w.toNat)` at the `narrow` argument, although their
  `.integer` projections are convertible; the statement layer needs an explicit
  promotion bridge. This stopped gstore/wset/istore composition (retained in
  job `keygen_public_upper_finish_036_005`).

## Pins

- Entry: `.build/levels_036/ENTRY_PINS_036.json`, SHA256
  `8d48dfb915639e49843f9a2174c51dfa10576222b1a6c30ce184dcd7d7ab924c` — BATCH_015-035 verified:
  6089 distinct pins, 592 current inputs, no supersession, no active job.
- Pair JSON `notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_036.json` (this file's twin).
- Accepted modules (0/0 streams, standard axioms, zero elisions):
  - `KeygenPublicUpperFrames.lean` `2d8a6b44c84791c30c3553648462ecdc94aabab095c50dd23b4e2c8e258a6159`
  - `KeygenPublicUpperLoops.lean` `0324535ea4802a7dbec3162840f1e96f668d6905c40853bf3e399ce9e23d6b18`
  - `KeygenPublicUpperFinish.lean` `4486bf62bcea745f47b4ac15efde5c556dc8696f11a49f21c7784fd14a101048`
- Accepted jobs: `keygen_public_upper_loops_036_007` (receipts
  `58b57e86853a148a705bbf04581ea4322db273a9dc7c35a6f5bb7f5444511193`),
  `keygen_public_upper_finish_036_006` (receipts
  `9531d427bddf6f6036058ec93b14648694af2eb41cb145bb31373c606b2d4a84`).
- All failed attempts retained under `.build/jobs/keygen_public_*_036_*`
  (001-005 families) and `.build/parse_probe_036_001` (diagnostic only).
- Commits: `36966a99`, `265cedbe` on main as niirmataa, exact owned paths.

## Honest status

This is a missing enclosing source proof, not a numerical/code counterexample.
Item 1 meets its local goal; item 2's algebra and the exceptional inequality are
kernel-checked; the statement-composition layer of item 2 and all of items 3-5
(NTT, nonzero, division/inverse, canonical h, fInv, BOTH SAME-material
Relation.mulRq equations) remain OPEN in plan order. The BATCH_036 seal
ceremony (full audit, Sage controls, POSTSEAL, FINAL_VERIFY, dedicated 036
verifier) is itself an open obligation and must run BEFORE new proof work.
Complete KeyGen, emitted-to-fiber, compiler, laws/PRG/security and review
remain outside this midpoint's claims. No push, review, subagent, worker/
session/relay, migration or stages import.
