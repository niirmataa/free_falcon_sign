# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_040 notes (B1.06 first-loop fold)

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
2026-10-09, BATCH_040, MiMo V2.6 Pro (`xiaomi-token-plan-ams`).
Window closed at a recoverable midpoint. **B1.06 Acceptance NOT MET.**
B1.05 stays BATCH_032; B1.07 not entered. One midpoint this window.

## Scope actually executed this window

Entry and the complete 768-butterfly FIRST loop of the public forward NTT
(`mq_NTT_ternary` first pass), folded into the low/high coefficient images of
the ORIGINAL reduced CoefficientQuotient polynomial. This is §19.1 remaining
item 1 of the checkpoint ("fold all 768 first butterflies into low/high
polynomial coefficient images"). New source module:
`formal/Source3/KeygenPublicFirstFold.lean`.

The fold composes the SAME per-butterfly value results already proved in
BATCH_039 (`KeygenPublicFirstValues.source_body`), the low/high split of the
original polynomial (`KeygenPublicFirstPolynomial.low/high`,
`low_coefficient`/`high_coefficient`), and the converted input cells
(`KeygenPublicInputMaterial.reduced`) across the whole executed loop. It does
NOT assume canonicality, a generated table image, NTT transform correctness,
nonzero tests, or any polynomial evaluation at `KeygenPublicRoots.point`.

## Headline theorem (exact checked type)

`KeygenPublicFirstFold.source_first_fold`:

```text
original : Geometry.Vec; a : ArrayPointer; s : State; out : Result
width   : a.elementBytes = 2
pointer : s.arrays "a".toList = some a
hn      : USlot s "hn" 768
r       : Local s "r" (radix * root)          -- root = KeygenPublicRoots.firstRoot
u0      : USlot s "u" 0
input   : Cells s.heap a 1536 (reduced original)
source  : Exec KeygenPublicSource.program [] firstLoop s out
------------------------------------------------------------------------
out.flow = normal
  ∧ ∀ i < 768,
      Cell out.state.heap a i (lowP original).coeff i
      ∧ Cell out.state.heap a (i+768) (highP original).coeff i
```

`lowP original = low (Relation.reduceVec original) root` and
`highP original = high (Relation.reduceVec original) root` are the two
degree-<768 halves of the ORIGINAL reduced CoefficientQuotient polynomial.
So after the whole first loop the physical low cells 0..767 hold its low-half
coefficients and the physical high cells 768..1535 hold its high-half
coefficients, in butterfly order.

The entry domains (u=0, hn=768, seeded r = radix*firstRoot, converted input
cells) are explicit local caller domains, exactly as in the per-butterfly
`source_original_coefficients`. Deriving them from the SAME full forward/
generator invocation is the remaining part of §19.1 item 1 (see below).

## Modules and proof structure

- `image original k j` — the physical cell-value after k butterflies (low half
  holds `lowP` once written / original otherwise; high half holds `highP` at
  j-768 once written / original otherwise).
- `reduced_low`/`reduced_high` — original input cells are the two halves of
  `(Relation.reduceVec original ⟨i,_⟩)`.
- `lowP_coeff`/`highP_coeff` — the written values `x+y*z` / `x+y-y*z` equal
  the low/high polynomial coefficients (via `low_coefficient`/`high_coefficient`).
- `image_*` unfolding + `image_zero`/`image_advance`/`image_input_*`/
  `image_unchanged` — all four physical cases.
- `guard_cmp`, `increment_result`, `increment_counter` — the `u < hn` guard and
  `u++` at the empty signed-parameter list.
- `preserve_pair` — a cell survives the paired low/high stores of one butterfly.
- `body_data` — one executed butterfly advances the image to k+1 (u still k).
- `step` — body then increment advances to k+1 with u=k+1.
- `loop_result` — induction over the `firstLoop` Exec derivation to terminal 768.
- `folded`, `source_first_fold` — extract all 768 low/high cells.

## Axio m / type readout (diagnostic)

Probe `KeygenPublicFirstFoldAxioms` prints the headline type and the axioms.
**Every theorem depends on standard axioms only: `propext`, `Classical.choice`,
`Quot.sound`.** No `sorry`/`admit`/placeholder (fold module builds with
`warningAsError`, `forbidden_proof_markers: []`, logs 0/0).

## What is NOT claimed

This is a loop-composition value theorem, not a polynomial-evaluation theorem.
It does NOT establish: the loaded words' evaluations at
`KeygenPublicRoots.point` (radix-2/triple passes), the full physical 1536-value
composition, nonzero f-evaluations, division/inverse/normalization to canonical
h, fInv, either `mulRq` equation, complete KeyGen, emitted-to-fiber, compiler
correctness, laws/PRG/security, or any review. B1.06 Acceptance is NOT MET.

## Retained attempts (all `keygen_public_first_fold_040_*`)

- `_001` FAILED: `preserve_pair` argument order (`preserves` wants `i≠j`), one
  unused-variable lint (`warningAsError`).
- `_002` FAILED: `Polynomial`-valued defs need `noncomputable` (RealizeConstKey
  on `highP`/`image`; cascade into `simp [image]` and `highP_coeff` rw).
- `_003` ACCEPTED: foundation (image algebra, coefficient bridge, guard,
  increment, preserve_pair) clean.
- `_004` FAILED: unused simp arg in `step` locals; `omega` missing `inv.bound`;
  IH argument order (`ih3` is shape-eq, k, inv).
- `_005` FAILED: `step` locals `if`-reduction; `loop_result` `[]` signed index
  blocks `induction` (needs `sgnEq` generalization).
- `_006` ACCEPTED: **full fold module clean** (`body_data`, `step`,
  `loop_result`, `folded`, `source_first_fold`), logs 0/0.
- `_007` ACCEPTED diagnostic: `KeygenPublicFirstFoldAxioms` type/axiom readout
  (stdout carries the readout, so `clean_log` false by design; not a proof step).

## Pins

- Entry (BEFORE edits/jobs): BATCH_015–039 verified via
  `tools/keygen_public_input_batch.py verify`; **7048 pins / 621 literal
  bindings, no supersession, no active job**. Receipt
  `.build/levels_040/ENTRY_PINS_040.json` SHA256
  `2612bda3b90d735ec9b21c1db688cc3f05235d2a4cb44ddfa090660e5613d4d2`.
- `KeygenPublicFirstFold.lean` SHA256
  `2cc2e6ddfd9d90dca0633424180036721d3a8f2a9a047726811b13504e8f5bbb`.
- `KeygenPublicFirstFold.olean` SHA256
  `ac372671583b972d51d59796a52cefc68ca2c95a0a2b3b8f52eeba1319f65c8f`.
- `KeygenPublicFirstFoldAxioms.lean` SHA256
  `b8036b4424cbe2c6ff140a1755f5fd7003b2555e726799fcfe58e4d754eaf275`.
- Fold job receipt `_006` SHA256
  `311450ec9995be2ec5e36ec424f14906047cae99d52524599c3b375a91c973e9`.
- Axiom probe receipt `_007` SHA256
  `5f6327817bbf7bfd6eb5f605dd03b00d906d3aad679fa1b7ce8c04248675f4cc`.

Limits unchanged (Lean j1/-M6144, AS12GiB/RSS8GiB, wall1800s,
maxHeartbeats2000000, warningAsError); 0/0 proof streams. No Sage controls were
run this window (the fold is a kernel value-composition; finite per-butterfly
controls remain those of BATCH_039) — recorded as open. No push, review,
subagent, worker, session, relay, migration or stages import. Small local own
commits on `main` as niirmataa; foreign work/staging preserved.
