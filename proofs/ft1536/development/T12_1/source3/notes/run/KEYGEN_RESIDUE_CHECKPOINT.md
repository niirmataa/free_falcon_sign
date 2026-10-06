# KEYGEN_SOURCE_TO_FIBER_001 — residue checkpoint (expanded)

Package status: **IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN**.
Checkpoint written 2026-10-06 at the close of the owner-scoped window
"EXCLUSIVELY B1.03", frozen at a staged-roadmap iron-rule-3 recoverable
mid-point (context soft ceiling reached; the frontend/certificate phase
is closed and green, the mkgm3 body binding has one open parse mismatch).
Session harness: **MiMo V2.6 Pro** (B1.03 window). Batch receipt pair:
`KEYGEN_SOURCE_TO_FIBER_001_BATCH_013.json` + `_BATCH_013_NOTES.md`.
This file supersedes the previous expanded checkpoint; carried facts are
in section 5.

## 1. Closed — commits, modules, evidence (verified before commit)

Local commits on `main` this window (no push, owner signal absent):
(1) B1.03 frontend + `KeygenModpR` + consumer patches; (2)
`KeygenGeneratorOrder` + `KeygenRev10`; (3) `KeygenMkgm3Callees` +
`KeygenMkgm3Program`; (4) this receipt/checkpoint pair + WORK_STATE.

| Scope | Content | Checked by |
|---|---|---|
| `C99ModularReference` (extended) | `Expr.call5`, `Stmt.storeRev`+`Exec` rule (exact `base + zext(REV10[idx]) mod 2^64` offset), `chainOf`/`bindParams`, hand-built `r2Code`/`divCode`, non-mutual strata `LeafCall`/`GenEval`/`GenExec`/`r2Body`/`divBody`/`ModCall`, `Eval`/`Exec` instantiations | job `keygen_mkgm3_frontend_011` |
| `C99ModularParser` (extended) | call5 arm, `return expr;`, REV10 store parse (`base + REV10[index]] = value;`), `while (name ++ OP bound)` state-exact desugaring (documented), `++`/`--` statements, `--` for-increment (two `-` tokens) | job `_011` |
| `C99ModularAnnotation` (extended) | call5/storeRev cases | job `_011` |
| `KeygenModpR` (new) | pinned `modp_R` body bound (`source_parses`/`model_exact`/`checked`/`source_exists`/`source_exact`) + `value_law` `2^31 mod p` | job `_011` |
| `KeygenGeneratorOrder` (new) | kernel-checked order facts: ord(g)=9216, ord(g²)=4608 at p=2147355649 (plan proof obligation CHECKED) | job `_011` |
| `KeygenRev10` (new) | REV10 source pins + `bitrev10` model + `rawTable` extractor | job `_011` |
| `KeygenMkgm3Callees` (new) | `r2_source_bound` **PASS** (`region 2575 24 = some r2Code`); `div_source_bound` **OPEN** | job `_011` |
| `KeygenMkgm3Program` (new, draft) | full `modp_mkgm3` body tree + `region 2945 91` binding attempt | untested at freeze |
| consumers | `storeRev` alternatives added in Exec enumerations (C99ModularFlow/Frame, KeygenCheckLoopBridge, KeygenNttFirstLoop, KeygenNttTripleLoop, KeygenResidueLoop, KeygenNttMiddleRounds) | job `_011` |

### 1.1 What is proved (kernel, no sorries, no oracle)

- **B1.03 frontend + callee binding phase — CLOSED.** The full syntax of
  `modp_mkgm3` and its callees is covered with source-bound semantics;
  `modp_R2`'s hand-built body equals the parser output on the pinned
  bytes (`r2_source_bound`), `modp_R` has its exact value law, and the
  generator-order obligation 9216/4608 is discharged by kernel-checked
  Nat computations (with the exact-order prime-factor arguments:
  9216 = 2^10*3^2, 4608 = 2^9*3^2).
- **Architecture correction (trap 33):** `induction` refuses mutually
  inductive `Exec`; the call strata are therefore NON-mutual with the
  call relation as a parameter (`C99ScalarReference.CallRelation`
  pattern). All previously green induction-based consumers keep working.
- **Not claimed:** no gm row law, no Montgomery-scale identity of the
  emitted table words, no canonical ranges, no `igm=ft` overwrite or
  memory-layout theorem, no `modp_div` value law (its exact quotient law
  needs modulus primality and is not required for the gm words, whose
  only division use feeds the temporary igm table that the checked
  coefficient-conversion loop overwrites).

### 1.2 Evidence pins (verified MATCH against current files)

- Job `keygen_mkgm3_frontend_011`: 17/34 accepted/clean at the freeze
  boundary, logs 0/0 per accepted module. RECEIPTS SHA256
  `3ca613d70be08968f902e729705754f687b5224e0286da1d46578dda4f381cdd`;
  SOURCE_INPUTS SHA256
  `7772a7a79458d5d37281e6c7f7ab8898567232449ad76df909bf4c0eeb0c5ade`.
- Committed file SHA256: `KeygenModpR` `d210c1b9…`, `KeygenGeneratorOrder`
  `a13deb39…`, `KeygenRev10` `018d6b25…`, `KeygenMkgm3Callees`
  `c0600ff8…`, `KeygenMkgm3Program` `a1b41168…`, `C99ModularReference`
  `8bb828b8…`, `C99ModularParser` `ca38a0e9…`, `C99ModularAnnotation`
  `2c7bc04b…` (full values in BATCH_013.json).
- Input pins re-verified BEFORE new work (resume protocol step 2): all 18
  named BATCH_011/012 pins MATCH (incl. the owner-pinned SOURCE_INPUTS
  `17b98f37…` of `keygen_ntt_middle_rounds_002`) and all six source
  closures byte-exact (353/353, 352/352, 353/353, 349/349, 350/350,
  351/351; 0 drift, 0 missing).
- Retained FAILED attempts (never cited as PASS):
  `keygen_mkgm3_frontend_001`..`_010` and all earlier retained failures.
  The pinned runner `tools/job.py` remains byte-identical (sha256
  `3bc29bf7…`).

## 2. In flight — exact types and state

`KeygenMkgm3Callees.div_source_bound : C99ModularParser.region 2642 26 =
some C99ModularReference.divCode` is the exact open statement (decide
FALSE; `r2_source_bound` passes). The `divCode` tree and the parser output
of the pinned `modp_div` body (file lines 2645-2670 = keygenLines
2641-2666) differ in one statement; candidates: the `i--` decrement
update shape, the single-clause for-initial wrapping, the `z ^=` select
expression, or the `modp_montymul(z, 1, …)` literal. Compare the region
output against `C99ModularReference.divCode` and fix the tree (the parse
theorem is the source binding).

`KeygenMkgm3Program.code` (full mkgm3 body tree) is drafted with
`source_bound : C99ModularParser.region 2945 91 = some code` untested.

## 3. Remaining work — order from `KEYGEN_SOURCE_TO_FIBER_001_EXECUTION_PLAN.md`

1. **B1.03 (continuation)** — close `div_source_bound`, then
   `KeygenMkgm3Program.source_bound`; re-check the remaining 17 closure
   modules in one job; REV10 exactness certificate via checked-chunk
   decomposition (32-entry chunks + assembly law); r2 exact value law
   (`2^62 mod p` Montgomery scale); per-row exponent/order laws and
   canonical ranges from the executed stores; `igm=ft` overwrite with
   gm/source-material preservation; extents and non-overlap from the
   caller buffer layout. Acceptance unchanged.
2. **B1.04** — NTT canonical range and polynomial evaluation (6
   sub-proofs; `t*m=n` lives here and ONLY here).
3. **B1.05**–**B1.11** as previously recorded.

Forbidden in all remaining steps (final premise boundary): solver or
serializer correctness assumptions; NTRU or certificate acceptance as
premises; unproved source completeness; arbitrary callee contracts;
success constructors containing evaluations.

## 4. Traps encountered (do not re-trigger)

1..31 (carried; still apply). New this window:
32. **`Pinned.keygenLines` index = file line of `KeygenSource.lean` − 4.**
    All pinned-line/region numbers must be shifted accordingly (region
    `S C` covers keygenLines `S-1 .. S+C-2` = file lines `S+3 .. S+C+2`).
33. **`induction` refuses mutually inductive `Exec`** ("use `cases`"):
    never put `Call`/`Eval`/`Exec` in a `mutual` block. Use the
    call-relation-parameter pattern (`GenEval`/`GenExec` + strata).
34. **Kernel `decide` memory blows on large list certificates** (1024
    entries) and on `BitVec.toNat_sub_of_not_usubOverflow`+`simpa`
    combinations: chunk the certificates (FFT-table precedent) and use
    plain `rw [BitVec.toNat_sub,…]` chains instead.
35. **`C99IntegerReference.Ty` constructors are `uint64/int64/uint32/
    int32`**, not the `B20.C.Ty` spellings `u64/…` used by `CLogic`.
36. **`LeafScan.tokenize` merges only `++`**, not `--`: post-decrement is
    two `['-']` tokens (`x--` also). Match `name::['-']::['-']`.
37. **`warningAsError` rejects unused `simp` arguments**: keep the simp
    lists minimal per function.
38. **Lean4 `exponentiation.threshold` (default 256)** blocks `decide` on
    `x^9216`: `set_option exponentiation.threshold 32768` is legitimate
    (still kernel `decide`).
39. **The runner compiles job modules in the given order** and stops at
    the first failure: pass the module list in topological order.

## 5. Carried facts (earlier checkpoints, still true)

- B1.02 CLOSED at its Acceptance (first/intermediate/triple passes,
  counters, positions, complete-body execution); `KeygenNttMiddleRounds`
  etc. unchanged and green in `_011`.
- B1.01 word algebra adapter; `KeygenResidueVectors.source_vectors` and
  the residue conversion family; `KeygenCheckOutcome.accepted`;
  certificate suffix/prefix results; STABLE_BINARY_004 and frozen stage
  dependencies: all unchanged.
- Sage probes remain finite diagnostics, not kernel results.

## 6. Resume protocol (next window)

1. Read `WORK_STATE.md` (live), this file, the EXECUTION_PLAN and
   `run2/notes/B1_STAGED_ROADMAP.md`. The next window continues **B1.03**
   only (one stage per window) from the exact open statement in section 2.
2. Verify current pins against SOURCE_INPUTS.json of
   `keygen_mkgm3_frontend_011` (plus the BATCH_011/012 pins listed in
   BATCH_013.json) before any new claim.
3. One proof job at a time (`tools/job_when_available.py`), unique
   labels, topological module order, guarded serial compiles, logs 0/0,
   limits unchanged. Rebuild the FULL cached descendant closure of any
   changed module in one job (34 modules today).
4. Small logical local commits on `main` with exact pathspecs after each
   verified step; NO push until an explicit owner signal. One Git writer
   at a time.

`emitted_to_actual_fiber` is still uninhabited. Nothing in this package
is REVIEWED; REVIEWED is never self-declared.
