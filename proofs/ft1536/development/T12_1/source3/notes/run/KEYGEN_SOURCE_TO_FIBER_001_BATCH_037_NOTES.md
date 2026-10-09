# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_037 notes (BATCH_036 seal ceremony + finish execution + complete BOTH images)

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN. CLOSED_AT_RECOVERABLE_MIDPOINT.**
2026-10-09, BATCH_037, MiMo V2.6 Pro (`xiaomi-token-plan-ams`), owner-started
window per checkpoint **16R**. B1.06 Acceptance NOT MET. B1.05 remains closed
at BATCH_032; B1.07 is not entered. Resume: **17R**.

## Closed this window

1. **BATCH_036 seal ceremony (16.1 step 5) — DONE, before any new proof work.**
   - Full audit job `keygen_public_upper_seal_037_001` (0/0, 15.4s): generated
     producer `Source3.KeygenPublicUpperAudit` audits the three accepted
     BATCH_036 modules (66 named declarations) plus 121 exact inherited
     interfaces = **187 entries, 171 complete terms + 16 kernel inductives
     with constructor types, standard axioms only, zero elisions**. Generator
     `tools/keygen_public_upper_audit_source.py`; producer
     `formal/Source3/KeygenPublicUpperAudit.lean`.
   - Sage standard-preparser/ZZ control job `keygen_public_upper_checks_037_001`
     (0/0, 65.9s): `sage/check_keygen_public_upper_finish.sage`, **14
     normal/UBSan runs** (7 variants x 2 modes, **six mutations per mode**, all
     detected in both modes, baseline clean). Each run checks all 256 cube and
     255 square paired stores, the complete final gm/igm image 1..1023 with
     sentinels (2050 rows) and the exceptional top row: gm[0]=gm[1], w=gm[1],
     igm[0]=radix/(2*firstRoot-1), checked exactly over ZZ and proved
     different from radix/firstRoot in the fixture. Finite diagnostic controls
     only.
   - Dedicated BATCH_036 verifier `tools/keygen_public_upper_batch.py`
     (`ceremony` + `verify` subcommands). Ceremony manifest
     `.build/levels_036/SEAL_CEREMONY_036.json` SHA256
     `3c71f60f5186cf5d35be6f2b052952d3fffceedd790317adb95e4bc9524c5191`.
     The first manifest attempt is retained byte-for-byte as
     `SEAL_CEREMONY_036_ATTEMPT_001.json` (SHA256 `5400c742…`): a pin-loop
     variable had overwritten the descriptive audit entry count; the `checked`
     pins of that attempt were already correct (trap 196).
   - **POSTSEAL** `.build/levels_036/POSTSEAL.json` SHA256
     `0118a5735fbcfaeb722cea278c38c829e93c93e9240be07857d7ce8e55f21dab`:
     **6120 distinct pinned files** (the 6108-file BATCH_015-036 closure plus
     12 ceremony artifacts), 595 current inputs, no supersession, no active
     job. **FINAL_VERIFY** `.build/levels_036/FINAL_VERIFY.json` SHA256
     `496e5b8ec319c8069733aed6d7d1be43df131a472a1714599bd151279f70a3f9`
     (documentation time) verifies the identical 6120 pins.
2. **Finish statement composition (16.1 item 1) — DONE.**
   `KeygenPublicUpperImages` (job `keygen_public_upper_finish_037_003`, 0/0,
   clean log, 2.9 GiB max RSS) executes the three actual finish statements and
   concludes the complete BOTH images from the SAME generate execution:
   - **Promotion bridge (trap 190, root cause now proved):** `Value.integer`
     maps `.int32` to `toInt` and `.uint32` to `toNat`; the two narrow/Slot
     forms are therefore only propositionally equal. `promotion_convert`,
     `promotion_slot`, `promotion_narrow`, `write_promoted` are the explicit
     bridges; `wset_result` binds the promoted word through the Slot/Value form.
   - **`gstore_result`:** executes `gm[0]=gm[1]` on the store constructor's
     heap: `Cell out.state.heap gm 0 (root^tableExponent 0)`, per-cell
     preservation for both tables and the byte frame.
   - **`wset_result`:** executes `w=gm[1]`: `Slot out.state "w" (BitVec.ofNat 32 w.toNat)`
     with the scaled word; `exceptional_scaled` identifies it with firstRoot.
   - **`istore_result`:** executes the exceptional `igm[0]=(uint16_t)mq_div_18433(R2t,
     mq_sub(mq_add(w,w,Qt),Rt,Qt))` through the full word/field chain
     (add_field/sub_field/div_word/division_scaled) and stores
     `Cell out.state.heap igm 0 ((2*firstRoot-1)⁻¹)` with the raw word law
     `value q = radix/(2*firstRoot-1)` for the division result `q`;
     `(2*firstRoot-1)≠0` from `two_first_root_nonzero`, `(2*firstRoot-1)²=-3`.
   - **`finish_images` / `source_complete_tables`:** the composed export —
     `out.flow=.normal`, `PairCells gm igm out.state.heap 1` (every pair cell
     at 1..1023), both exceptional top cells with the raw word law,
     `Word out.state "w" firstRoot`, `Pointers`, `logn`/`k` slots, `USlot "u" 0`
     and `UpperFrame gm igm s.heap out.state.heap`.

## Traps met (191-196)

- **191.** `Value.integer` is `toInt` on `.int32` but `toNat` on `.uint32`;
  this asymmetry is the root cause of trap 190's non-defeq. Bridges must be
  propositional (`unsigned_promotion_exact` + `BitVec.toNat_ofNat` + omega),
  never defeq.
- **192.** One unknown name in `open X (...)` invalidates the whole open and
  every statement using its names; `cases` then reports "Alternative ... has
  not been provided" for all constructors. Check open lists against the target
  namespace (this window's 001 failure listed `exceptional_scaled`, which only
  exists in the retained BATCH_036 attempt, not in the accepted module).
- **193.** `a ∧ b ∧ c ...` is right-nested: destructure with `obtain ⟨...⟩`;
  `.N` projections beyond `.2` are invalid.
- **194.** `Decidable (Canonical w)` does not synthesize through the `Canonical`
  definition; `unfold Canonical` first or supply the fact explicitly.
- **195.** Call arity must carry the explicit scale/element parameters:
  `write_promoted` takes `p` and `i` separately, `sub_field` takes `a b`,
  `add_field` takes `x`. Omitted positional arguments silently misbind proofs.
- **196.** Descriptive counters in seal tooling must not reuse pin-loop
  variables (the retained `SEAL_CEREMONY_036_ATTEMPT_001.json` case).

## Cross-reference to retained BATCH_036 attempts (trap-190 history)

Per the owner's continuity rule the attempt history reads through this
description, not through job labels. The preserved failed attempts of the
previous window are `.build/jobs/keygen_public_upper_finish_036_001..005`
(CLogic literal indices; `linear_combination` atom split; the statement-layer
promotion unification failures) and `.build/jobs/keygen_public_upper_loops_036_001..006`
(String/List name arguments; `cases` eliminating `out`; frame rewrite
direction; def-unfold before rewrite; Mathlib token adjacency `0<i`; `omega`
blind to structure projections). Their exact causes are recorded in
`KEYGEN_SOURCE_TO_FIBER_001_BATCH_036_NOTES.md` and `_036.json`. This window's
traps 191-195 resolve the statement-layer promotion failures of
`keygen_public_upper_finish_036_005` and supersede no earlier byte.

## Pins

- Entry (before edits/jobs), BATCH_015-036 verified: `.build/levels_037/ENTRY_PINS_037.json`
  SHA256 `deb7a62b9d554033f9d1aacd5609b18b4662d7ab003f1de433235136e21727fd`
  (6108 distinct pins, 595 current inputs, no supersession, no active job);
  035-verifier chain receipt `ENTRY_PINS_037_CHAIN.json` SHA256 `6da71ff7…`;
  entry tool `ENTRY_PINS_037_TOOL.py` SHA256 `ef15535e…`.
- Accepted module `KeygenPublicUpperImages.lean` SHA256
  `cb2564a54ddd134860271756fffca656c7324f6caa7e9a766f19d49af92cfa49`;
  job `keygen_public_upper_finish_037_003` receipts SHA256 `15272eee…`,olean
  `ad4cdbcc…`, streams 0/0.
- Seal jobs: `keygen_public_upper_seal_037_001` receipts `080e26c8…`;
  `keygen_public_upper_checks_037_001` receipts `8c2592d0…`.
- Failed retained proof attempts: `keygen_public_upper_finish_037_001` (open
  list + trap-191 projections; 27536-byte log retained),
  `_037_002` (write_promoted arity, `Decidable (Canonical ...)`, missing open
  name). No pin weakened; no supersession.
- Seal-ceremony artifacts live in `.build/levels_036/` (they act ON the sealed
  BATCH_036 pair); the executing jobs are `_037_` and are listed in this pair.
- Commits: `1e6ad254` (audit generator/producer + Sage controls), `53e5d875`
  (dedicated 036 verifier), `bcba8c25` (verifier counter fix), `4d53bf44`
  (finish execution + complete images), plus the final pair/checkpoint commit,
  all as niirmataa on main with exact owned paths.

## Honest status

This is still a missing enclosing source proof, not a numerical/code
counterexample. The BATCH_036 seal ceremony is complete and the last-row /
upper-loop / exceptional-core chain now reaches the complete BOTH table images
with the exceptional top cell and the finished `w` word. Items 2-5 of 16.1
(SAME f/g conversion, forward NTT and polynomial evaluations, all nonzero
tests, division/inverse/normalization to canonical h, fInv witness and BOTH
SAME-material Relation.mulRq equations) remain OPEN in plan order. Complete
KeyGen, emitted-to-fiber, compiler, laws/PRG/security and independent review
remain outside this midpoint's claims. No push, review, subagent, worker/
session/relay, migration or stages import.

Errata (append-only, per owner decision 2026-10-09): checkpoint 16R pkt 4
spoke of `keygen_public_*_036_*` job labels; this window used `_037_` labels
per the written convention "pair N => jobs _N_" (owner confirmed variant 2
before any job started). Continuity of attempts is preserved by the explicit
cross-reference above. §16R itself is not rewritten.
