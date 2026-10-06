# BATCH_014 — B1.03 continuation (KROK 0 tree repair and closure green)

Window scope (owner): EXCLUSIVELY B1.03 continuation per
`KEYGEN_RESIDUE_CHECKPOINT.md` section 2 and the EXECUTION_PLAN. B1.04
values/ranges outside row laws and `t*m=n` remain outside this window.

## KROK 0 — tree repair (mandatory first step), DONE

1. **Removed the false claim.** `KeygenMkgm3Callees.div_source_bound :
   C99ModularParser.region 2642 26 = some C99ModularReference.divCode`
   was DISPROVEN by kernel `decide` (retained failure log:
   `.build/jobs/keygen_mkgm3_frontend_011/logs/Source3_KeygenMkgm3Callees.stdout`)
   and is removed from the Lean tree. `div_header`, `r2_header`,
   `r2_source_bound` remain.
2. **divCode candidate recorded as an obligation (BATCH_014.json), not a
   claim.** `C99ModularReference.divCode` is a CANDIDATE body tree; its
   parse binding is false and the corrected binding sentence is pending.
   Exactly one statement differs from the parser output of the pinned
   `modp_div` body (file lines 2645-2670 = keygenLines 2641-2666);
   candidates: the `i--` decrement update shape, the single-clause
   for-initial wrapping, the `z ^=` select expression, the
   `modp_montymul(z, 1, ...)` literal (BATCH_013.json).
3. **Closure rebuilt to 0/0 (clean logs).** Jobs `keygen_mkgm3_repair_004`
   (6/6 accepted/clean) and `keygen_mkgm3_repair_005` (13/13
   accepted/clean) cover the full changed-descendant closure
   `KeygenNttButterflyPrograms .. KeygenResidueAudit` plus the repaired
   `KeygenMkgm3Callees`. `KeygenMkgm3Program` is deliberately outside
   this rebuild (leaf, no dependents, untested claim = step-2 work).

### Tree-repair fallout fixed (mechanical, no new claims)

The `_011` grammar extension (Stmt `storeRev`, Expr `call5`, call strata
`LeafCall`/`GenEval`/`GenExec`/`ModCall`) left untested modules broken;
this repair closed them:

- `KeygenNttLoopSupport.atom_frame`: `| storeRev => simp [localOnly] at
  shape` alternative (variable-index Exec case list).
- `KeygenNttMiddleLoops`: `storeRev` added to the grouped "impossible"
  alternative list (the established `_011` pattern).
- `KeygenNttButterflyCalls`: `C99ModularReference.Call` -> `ModCall`
  (3 inversion statements; `Call` no longer exists after the strata
  refactor). Cascading `have`-inference failures resolved.

### Traps (for the checkpoint)

- The runner's cache staleness check is SHALLOW (source hashes + one
  level of recorded import artifacts). A rebuilt module with a changed
  inductive silently breaks stale importers via stuck `match` reduction
  (`localOnly X =?= some _` unification failures). FULL descendant
  closure rebuild in one job is the only reliable guard.
- `localOnly` catch-all keeps defs compiling; the stuckness appeared only
  at consumer unification against the stale `.olean`.

Retained FAILED attempts this window (never cited as PASS):
`keygen_mkgm3_repair_001` (stale-source cache assertion — discovered the
forced rebuild set), `keygen_mkgm3_repair_002` (preflight refusal: an
occupied shared proof slot, foreign `run2` Lean process; waited),
`keygen_mkgm3_repair_003` (KeygenNttFirstLoop stuck-reduction failures
against the stale LoopSupport product),
`keygen_mkgm3_repair_004` (KeygenNttButterflyCalls `Call`/`have` errors).

## Open (continuing this window, in owner order)

1. `div_source_bound` — corrected parser<->divCode binding sentence
   (probe planned: transient Repr diff of `region 2642 26` vs `divCode`).
2. `KeygenMkgm3Program.source_bound` (region 2945 91 = some code).
3. Closure rebuild in one job after (1)+(2).
4. Row/Montgomery-scale/memory-layout laws (`igm=ft` overwrite with gm and
   source material preserved, extents, non-overlap) and the REV10
   1024-entry exactness certificate via checked-chunk decomposition.
