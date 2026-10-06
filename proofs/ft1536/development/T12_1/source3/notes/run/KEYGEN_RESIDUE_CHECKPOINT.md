# KEYGEN_SOURCE_TO_FIBER_001 — residue checkpoint (expanded)

Package: **IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN**.
Checkpoint at the close of the owner-scoped **B1.03 stage (c)** window,
2026-10-06. **Stage (c) CLOSED / PROVED_KERNEL_SCOPED.** The next owner
step is **Acceptance B1.03**, in the next window. This window ends here
under the staged-roadmap iron rules1/2. B1.04 was not entered.

Harness: **GPT-6 Astra Ultrafast** (`openai/gpt-6-astra-ultrafast`). The
unchanged runner retains historical labels. Receipt pair:
`KEYGEN_SOURCE_TO_FIBER_001_BATCH_017.json` + `_017_NOTES.md`.
This live checkpoint supersedes BATCH_016's checkpoint; its bytes and pins
remain in Git. No independent review, archive import, owner acceptance or
push has occurred in this window.

## 1. Closed this window — modules, source and evidence

Four local source commits on `main`, as `niirmataa`:

- **`9c9f75fe`** — source-scaled algebra, generator-order bridge, caller layout;
- **`8e132c16`** — finite index certificate, source upward stores, REV10 memory;
- **`fa938836`** — generator initialization, last-row branch, all row loops;
- **`159386b3`** — complete table contract, material/overwrite, audit/controls.

This checkpoint and BATCH_017 are the final documentation commit. Each
writer window held the shared `proofs/ft1536/work/archive.lock` and used
exact paths. Foreign changes are preserved.

| Components (`KeygenMkgm3…`) | Checked result |
|---|---|
| `Rows` | Source R2 conversion and scaled products; exact ZMod generator orders9216/4608; pair exponent progression |
| `Indices`, `IndexCert`, `Table` | All1024 physical exponents/orders, REV10 bijection/coverage, cube/square recurrences and table-cell memory laws |
| `Control`, `Atoms`, `RevMemory` | Ordinary source control/frames, arithmetic/store extraction, source-bound read-only REV10 transport |
| `Upward`, `LastRow` | Actual cube/square/paired-last-row bodies, including nested calls and interleaved igm stores |
| `Counters`, `Loops` |256 paired iterations,256 cubes,255 descending squares; derived exit counters512/512/0 |
| `Prelude`, `RowInit` | Actual declarations, R/R2 calls, generator conversion and one squaring, post-increment effects and complete last-row selection |
| `Assembly`, `Frame` | Entire parsed generator and top copy; legal scratch-object footprint and same original material |
| `Layout`, `KeygenMkgm3` | Executed caller aliases, allocated extents/non-overlap, complete source/parsed contracts and igm=ft overwrite composition |
| `Audit` |57 actual definitions/exports, complete types/terms, standard axioms only, zero elisions |

All18 new modules have matching accepted source/artifact/receipt bindings
and0/0 logs. Final `keygen_mkgm3_contract_002` checks the contract and audit
together (1.317s/1.919s). Checking was incremental in dependency order;
the unchanged previous closure was not replayed. Loops/Prelude passed in
`rowinit_001`; its new RowInit child failed and passed `rowinit_002` after
repair. This partial-job distinction is recorded in the JSON.

### 1.1 Exact premise boundary and result

```text
KeygenMkgm3.Entry s p0i scratch rev
KeygenNinv31.SourceExec prime (.uint32 p0i)
C99ModularReference.Exec KeygenMkgm3Program.code s out
  -> KeygenMkgm3.Contract s out scratch rev
```

Entry expands to M0 scalar arguments (`p=2147355649`, `g=1907584673`,
`logn=10`, `full=1`), gm/igm/REV10 pointer bindings, the parsed read-only
REV10 initializer and legal writable scratch memory. No initialized gm,
canonical output, generator order, root identity, arbitrary callee or
source-completeness assumption is inserted. The same existing fixed-call
`Exec` is used. `parsed_contract` additionally consumes region2945/91's
parser equality.

Let `h=g^2` and `R=2^31` in ZMod p. For row `2^k+j`, `0≤k≤9`, `j<2^k`,
put `u=bitrev(k,j)` and `e(u)=3*u+1+(u%2)`. The actual canonical word has
value `R*h^(c(k)*e(u))`, where `c(9)=1` and `c(k)=3*2^(8-k)` for k<9.
The unscaled root order is4608 for row9 and `6*2^k` for rows0–8.
`gm[0]=gm[1]`, with unscaled order6. The kernel checks all finite index
facts in64 chunks of16; Sage only generates untrusted candidates.

The caller layout is ft/gt/Ft/Gt at word offsets0/1536/3072/4608, followed
by gm at6144. Each coefficient array has1536 words; each table has1024.
The required span is7168 words/28672 bytes. The actual call gives igm=ft,
occupying its first4096 bytes. Allocated cells, all pairwise output/table
separations and the alias containment are proved.

`source_then_overwrite` derives the same gm rows and preserves the same
four original Vec witnesses through the source conversion loop. Its local
call-composition interfaces remain explicit: equal returned/next-entry
heap, conversion pointer/scalar bindings, legal separated input objects and
their original byte representation. These are not desired output premises.

The enclosing allocation routine and complete caller frame are B1.07;
the scratch capacity here is legal entry memory, not a newly proved
`temp_size`/`malloc` result. Inverse-table calls execute their fixed bodies,
but `modp_div`'s inverse-value law is neither needed nor claimed. The scope
is the pinned C-fragment reference semantics, not compilation or full C.

### 1.2 Pins and validation

Preflight:774 distinct file checks, all364 then-current inputs of the final
R2 audit matching, no active proof job. File:
`.build/mkgm3_rows_017/PREFLIGHT.json`,
`40445fdd9597426d93a942030f6f6e2abe6a8cf5e1ca415933d9529e3af125c6`.

- **BATCH_017 JSON:** `50f35519c32d1d16dd6987b781ac43e59cc835dd076ce15f146a1fe9ac9cbc0b`.
- **BATCH_017 notes:** `814660ca606d29600793dc3e61e5903b05ef56e83042b4d6aba131f86c6f28d6`.
- Final contract source: `a231c2edc71db67aca245cc658898f498caf66799fdad2ce0470ba742ba15772`.
- Index certificate: `c3bdd7bc6a10a750c7cb6723256eae3abf2cfccbdd5621ca02d1f6818b7b2d2c`.
- `contract_002/RECEIPTS.json`: `c41c8831073ea330e59a69dbb3d298bf827eef8223cd750432ac88fa99fc38d5`.
- `contract_002/SOURCE_INPUTS.json` (382 inputs): `b3a02328e85434615b575be1ce56771fce265bf73107b491b7f2fec693c69377`.
- `.build/jobs/keygen_mkgm3_contract_002/MKGM3_AUDIT.json`:
  `9235ffa4c4170591d5c81af56e82da378aaf68a93d30d576429dbe19c60cd52b`.
- `.build/jobs/keygen_mkgm3_checks_002/MKGM3_CHECK.json`:
  `01341f2a4faf797ba3a0046b65f87c19406e76249dbd4eda413bbe3c0ab208df`.
- BATCH_016 JSON: `cc28381bb1188400d0ea1d15e3c83ba045a2e5476a9644ee4dd0585c58e2b25f`;
  notes: `e323ac9783e41e2143638088af6cfb0453b756a8418273b62bd961c1b0695419`.
- BATCH_015 JSON: `b5bb63f5ddfb423ff6a4742dfd2893bcc7587b4cb50f51877b9b3910285be134`;
  notes: `aec981ffab3f9065ac10d6d99f4f931ceccd852f237382e3b0240b64fbe53cd8`.

The paired JSON pins every current module, immutable job snapshot/olean,
accepted stream, dependency inventory and all49 attempts (28 failed).
Limits unchanged; max recorded accepted RSS2851084KiB. Audit printing
uses `pp.deepTerms=true` and the existing200000-step output budget; proof
limits are unchanged. No warning suppression or unfinished proof markers.

Sage/C controls passed in2.671s: all1024 words before/after overwrite,
normal/UBSan baselines and six detected mutations in each mode (14 runs).
Only public synthetic coefficients were used. These are finite diagnostics,
not a replacement for the kernel theorem. Historical Sage inventories of
unused Lean modules retain the pre-final layout-export versions; the final
57-export audit has separate current pins.

## 2. In flight — exact types and state

**Nothing in flight. No owned job remains. Stage (c) is complete.**
`source_contract`, `parsed_contract`, `allocated_tables`,
`allocated_outputs`, `output_pairwise`, `inverse_prefix` and
`source_then_overwrite` have checked inhabitants with the boundary above.
No unresolved draft/type remains within (c). This is author evidence for
the requested next Acceptance B1.03, not an owner/reviewer verdict.

## 3. Remaining work — execution-plan order

1. **Next owner window: Acceptance B1.03**, consuming BATCH_015/016/017
   and the exact full types. Do not continue this closed implementation
   window into the next stage.
2. **B1.04:** NTT canonical range and polynomial evaluation, its six
   planned sub-proofs. `t*m=n` belongs there only.
3. **B1.05–B1.11:** solver/public equations, complete caller/attempt/gates,
   codecs, emitted-to-fiber assembly, final replay and owner review.

`emitted_to_actual_fiber` remains uninhabited. No solver/serializer
correctness, desired NTRU/certificate result or source-completeness premise
may replace the remaining enclosing source proofs.

## 4. Traps — preserve earlier1–53; new54–61

Earlier traps and failed attempts remain in Git/BATCH_013–016.

54. Supply the pointer-name context to the modular parser for caller
    pointer assignments; an empty context parses them as scalar expressions.
55. Explicitly choose the intermediate State before passing a slot proof;
    otherwise Lean may infer the earlier State from that proof. Normalize
    Result/State projections before rewriting heap/locals equalities.
56. `while`, `prefix`, `meta` are reserved. Put whitespace around comparisons
    ending in variable i, since `<i`/`≤i` can be notation tokens.
57. Inductive records parameterized by State need fieldwise reconstruction
    after updates, even when all relevant state projections are unchanged.
58. `BitVec.toInt_ofInt_eq_self` has three premises. `convert` or `norm_num`
    can already solve the goal; a following tactic then fails strict linting.
59. Complete term printing needs `pp.deepTerms=true` for deep source-body
    proofs. Keep the explicit no-elision guard; never treat compilation alone
    as proof that an audit print is complete.
60. A source mutant that makes a local unused is rejected by `-Werror` before
    a semantic test runs. Mutate the computed value while retaining its use;
    keep the failed compiler attempt and do not relax warning flags.
61. Sage integers need explicit conversion at the JSON serialization boundary.
    This is organizational conversion, not a replacement for exact Sage math.

## 5. Carried facts and resume protocol

- BATCH_015 retains `KeygenRev10Cert.rawTable_exact` and its source pin
  `9fd2b27e1138f88e686513f8814d53c23c421caab2fe430353ba2bba89dfb69b`.
- BATCH_016 retains the universal source R2 contract and M0 conversion.
  No predecessor source/reference/parser was changed in (c).
- B1.01 word adapter and B1.02 complete forward-body/control scope retain
  their existing pins; their value/evaluation obligations remain B1.04.
- Read WORK_STATE, this checkpoint, the requested step's EXECUTION_PLAN
  and `run2/notes/B1_STAGED_ROADMAP.md`. Verify the BATCH_017 pair and its
  module/receipt/audit pins before consuming the result.
- A new proof job requires owner scope, a unique label and
  `tools/job_when_available.py`, one guarded job, unchanged limits and0/0
  logs. Rebuild every cached descendant when changing a dependency.
- Small local exact-path commits on `main`, one shared Git writer. Push
  waits for a separate explicit owner signal. Nothing here is REVIEWED.
