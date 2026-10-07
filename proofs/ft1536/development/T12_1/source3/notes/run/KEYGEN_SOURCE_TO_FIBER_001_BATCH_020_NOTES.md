# BATCH_020 — B1.05 validation seam, recoverable midpoint

2026-10-07. **PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
Window **CLOSED_AT_RECOVERABLE_MIDPOINT** under staged-roadmap rule3.
**B1.05 Acceptance NOT MET.** Resume B1.05, not B1.06.

## Checked result and exact boundary

`KeygenSolverValidation.generated_converted_checked` concludes:

```text
KeygenSolverEquation.Equation material
and forall slot, KeygenMaterial.Represents finalHeap (arrays.input slot) (material slot)
```

`Equation material` is the exact integer identity in the existing quotient:

```text
multiply (material 0) (material 3) - multiply (material 1) (material 2)
  = constantCoeffs (18433 : Int)
```

The same four vectors occur before source table generation and in final
memory. The proof consumes generation, conversion, four complete source NTT
calls, actual target initialization and the parsed successful comparison.
It derives canonical ranges, all four polynomial Images, pointwise equations,
the coefficient equation modulo2147355649 and the zero residual needed by
the existing37748737 integer lift. Caller parameter evaluation/restoration
is modeled by a fixed NTT call stratum, with the pinned stride1 macro.
Byte preservation is derived independently from actual stores/pointer
provenance, including16-bit original material and same-block separation.

**Remaining local premises:** generator Entry/legal memory/static REV10;
source p0i initialization; original material representation and bounds
1/1/2047/2047; legal scratch/input separation; actual source fragment
executions, caller bindings/layout and generation-return/conversion-entry
heap equality. The generator/conversion/four-transform/check sequence is
now composed; the full preceding solver/caller and source bounds are not.
No complete successful-solver theorem or B1.05 Acceptance is claimed.

## Modules and checks

- `KeygenSolverEquation`: exact loaded-word identification, pointwise and
  quotient equation, cast transport and integer recovery.
- `KeygenSolverNttCalls`: parsed7374–7377 calls, macro/signature binding,
  actual Bind environments and fixed complete-NTT body execution.
- `KeygenSolverTransforms`: shared-heap sequence, exact later input words
  and earlier Images preserved by every subsequent transform.
- `KeygenSolverTarget`: parsed7378 target; signed literal arguments become
  uint32 parameters in the same primitive execution; check bindings derived.
- `KeygenNttMemoryFrame`: byte footprint and original material preservation.
- `KeygenSolverValidation`: preceding generation/conversion composition,
  derived conversion counter1536, final readonly heap and same-material result.
- `KeygenSolverValidationAudit`:88-entry internal audit covering all69 new
  declarations and19 inherited interfaces,85 complete flat terms and3
  inductives/structures with expanded constructors, standard axioms only.

Start preflight:1336 predecessor files, BATCH_015–019 pairs and402 final
BATCH_019 inputs matched. Seal: all409 final current audit inputs and all
1336 predecessor files match.7 module source/snapshot/artifact/receipt
bindings accepted with0/0 logs; maximum accepted RSS3004140KiB.
Final affected closure job: `keygen_solver_audit_020_005`; unchanged Equation
artifact is from `keygen_solver_equation_020_003`.

Sage/C controls: exact QQ inverse and ZZ quotient/bound checking produce
a public synthetic valid tuple with maxima1/1/41/168. Six cases include
two bounded valid tuples, two material perturbations, zero material and
an exact tuple with G=18433 that validation accepts but `poly_big_to_small`
rejects.14 normal/UBSan executions pass; six mutations are detected in both
modes (wrong target, wrong target scale, omitted G transform, overwritten ft,
swapped cross operands, ignored comparison). Material, gm and guards survive.
This is finite supporting evidence, not the missing solver/sampler proof.

19 attempts retained:8 accepted jobs,10 failed jobs, one interrupted outer
shell launch without a receipt. `_audit_001` rejected a truncated print;
`_audit_002` rejected metadata unsupported by the inherited annotation-free
DAG exporter. A direct conversion-identity proof replaced the bulky binding
simplification; its statement is unchanged and all affected descendants
were rebuilt. Final terms are fully flat-printed, with no new DAG required.
Other failures were elaboration/API issues. No mathematical counterexample
was found or disproved by these failed attempts. No limits/warnings changed.

## Pins and commands

- Batch JSON: `6b8a839151d8d174eb1b6a8b09e1b2f02a8f6c20b8c9055d40e687e951602dff`.
- Final theorem source: `60faf3802b348e7080d6285a828d6a4e70c42d61f2c8bceec3e9f37e4ecc8baf`.
- Final receipt: `fa26d87d7c85dd5e7d45773dd4a2ea0f36f0fba3523b2f3f828ce67cf1538674`.
- Final SOURCE_INPUTS: `b6ab79b9638d1d08d9fe51872575cb08e4a1373c614c9638ba6bcafa9f55ffbe`.
- Audit: `c7d037950b751c0287e9dbd15a189aadaa9ef133bf9ea66a862ef424ddbd6abc`.
- Sage/C result: `2e69ed931116fcc622ae9c006502d2594ece9e77ea2d94eb7093314bf1223d28`.
- Public fixture: `d9cc77c74b13c542adf6cf7d8333cb0e3656f9709c46dfcd67b5c7912497c455`.

From source3, use fresh labels for any necessary subsequent build:

```sh
python3 -B tools/job_when_available.py lean UNIQUE_LABEL Source3.KeygenSolverValidationAudit
python3 -B tools/job_when_available.py sage UNIQUE_LABEL check_keygen_solver_validation.sage
```

`tools/keygen_solver_batch.py` records exact evidence/pins and refuses to
overwrite BATCH_020. The source3 `.build/jobs/` directories retain all raw
logs, snapshots and generated artifacts; the audit/fixture are reproducible
from tracked generators. These checks were incremental, not a fresh replay
of the entire project. No owned job is live.

Local source commits: `b4c2e87f`, `e92271d2`, `ed98536b`, followed by the
documentation checkpoint commit. Main/niirmataa, shared archive.lock, exact
owned paths; foreign work preserved. No push, review, import or migration.
Next obligations and traps: `KEYGEN_RESIDUE_CHECKPOINT.md`, sections3/5/6.
