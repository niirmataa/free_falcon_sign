# PROMPT — new window: T5-pointwise (restating the total-mass bounds as pointwise stage sandwiches)

Workspace: `proofs/ft1536/development/T12_1/run2/`. Small local commits via
`git commit --only -- <paths>`; NO push (owner signal); one Git writer at a
time (parallel lanes: B1 in `source3/`, AdvPRG in `formal/AdvPrg.lean`).
English crypto register in code. OWN FILES ONLY: create
`formal/T5Pointwise.lean` + `notes/T5_POINTWISE_WORK_STATE.md`. Everything
else READ-ONLY. Zero unfinished-proof markers; defs-first; guarded compiles;
logs 0/0; axiom audit.

**Read first:** `notes/B4_ATTEMPT_WEIGHTS_WORK_STATE.md` (the EXACT types
of the four missing pointwise sandwiches — your contract), and in
`formal/AttemptWeights.lean` the interfaces `TowerWhole`, `MachineStage`,
`WrapStage`, `BoxStage` (the consumers), `notes/B4_SYNTHESIS.md` (the
assembly map), the T5/REFINE toolkit (`Run2/T5ScalarMass`
(`local_exponents`, `rowRatio = 2^-48`, `CoefficientRange`),
`Run2/TriangularGaussian` (`triangular_mass_bounds`, per-row ratios),
`Run2/ShiftedGaussian`, `Run2/A2Theta`, and `formal/CenteringClosure.lean`'s
`cmul`/`sErr` chains — the machine-margin pointwise error transport).

## Goal — total-mass bounds are NOT pointwise; find the pointwise road

The T5/REFINE material's current bounds are TOTAL-mass sandwiches (tower
mass, continuous mass, deviation sums). `AttemptWeights` needs POINTWISE
multiplicative sandwiches on the realized weights (per point, INCLUDING
the tail — see the kernelized counter-theorems `bulkOnly_*`: bulk control
is provably insufficient). Prove the four stage sandwiches in pointwise
form:

1. **`TowerWhole`** (the heavy one): per-point multiplicative control of
   the tower/fiber-tilt weight over the WHOLE region. The likely road: the
   per-ROW multiplicative ratios (`rowRatio`, `local_exponents`) compose to
   per-point factors — a product over rows gives `1+2^-43`-class bounds
   pointwise. State the road precisely before proving (defs first).
2. **`MachineStage`**: the `cmul`/`sErr` chains of `CenteringClosure` are
   ALREADY pointwise error transports (machine word -> value) — restate
   them as the `MachineStage` interface (the numeric `1+2^-42` margin is
   proven; you only re-shape the transport).
3. **`WrapStage`**: wrap budget `1+1/(2^39-1)` (numeric margin proven) —
   the pointwise statement over the wrap/centering map.
4. **`BoxStage`**: box budget `1+1e-30` — the box-truncation transfer
   pointwise (mind the tail: the counter-theorems forbid truncating it
   away).

Where a total-mass bound genuinely CANNOT be restated pointwise, record the
EXACT strengthening needed (with intended type) and prove whatever is
possible from the row-ratio machinery — do not assume.

## Honesty rules specific to this task

- A total-mass bound never implies a pointwise bound by itself — every
  pointwise step needs an actual per-point structure (row ratios,
  multiplicative machine margins). If you find yourself "dividing by the
  mass", stop and record.
- The realized weights themselves are B1's (`do_sign` binding): state the
  sandwiches over the abstract weight interface of `AttemptWeights`
  (`target/mach/wrapS/w`-shaped), not over guessed definitions.
- Citations to the T5/REFINE material must be pinned (module + lemma
  names); no rebuilding of their totals.

## Deliverables

`formal/T5Pointwise.lean` (0/0 + axiom audit),
`notes/T5_POINTWISE_WORK_STATE.md` per batch, Polish handoff summary: which
of the four stages are pointwise-proven vs which need the B1 realization,
with the exact final interface types (= the last plug for `hattempt`).
