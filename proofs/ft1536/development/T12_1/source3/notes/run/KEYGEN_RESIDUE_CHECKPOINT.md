# KEYGEN_SOURCE_TO_FIBER_001 — residue checkpoint (expanded)

Package status: **IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN**.
Checkpoint written 2026-10-06 at the close of the owner-scoped window
"B1.03 continuation (KROK 0 + div/mkgm3 bindings + closure + REV10)".
Frozen at a staged-roadmap iron-rule-2/3 boundary: KROK 0, the corrected
`div_source_bound`, the corrected `KeygenMkgm3Program.source_bound`, the
one-job closure rebuild (35/35) and the REV10 chunked certificate module
are done; the row/Montgomery/memory-layout laws of B1.03 remain.
Session harness: **MiMo V2.6 Pro** (B1.03 continuation window). Batch
receipt pair: `KEYGEN_SOURCE_TO_FIBER_001_BATCH_014.json` + `_014_NOTES.md`.
This file supersedes the previous expanded checkpoint; carried facts are
in section 5.

## 1. Closed this window — commits, modules, evidence (verified before commit)

Local commits on `main` this window (no push, owner signal absent):
(1) `dc5ecf5c` KROK 0 tree repair + BATCH_014 receipt pair; (2)
`c3170530` `div_source_bound` closed; (3) `83174c1c`
`KeygenMkgm3Program.source_bound` closed + one-job closure rebuild.
(The B2/B5 lane committed to shared `main` concurrently; exact
pathspecs, one writer at a time.)

| Scope | Content | Checked by |
|---|---|---|
| KROK 0 tree repair | false `div_source_bound` removed (kept `div_header`), divCode candidate recorded as a receipt OBLIGATION (discharged later this window); `KeygenNttLoopSupport.atom_frame` storeRev alternative; `KeygenNttMiddleLoops` storeRev grouping; `KeygenNttButterflyCalls` `Call`->`ModCall`; closure green 0/0 BEFORE continuing | `keygen_mkgm3_repair_004/005` (19/19 accepted/clean) |
| `div_source_bound` (corrected binding sentence) | single parser<->divCode mismatch was the `z ^=` select: candidate `divSelect` carried a duplicated outer `xor z`; corrected; `C99ModularParser.region 2642 26 = some divCode` kernel-proved | probe `keygen_mkgm3_div_probe_001`, job `keygen_mkgm3_div_bound_001` (4/4) |
| `KeygenMkgm3Program.source_bound` | THREE defects fixed: `thenOne` syntax typo; `revStoreTail` never fired on real `base + REV10[...]` stores (greedy pureExpr ate `+ REV10` as `b + var REV10`; fixed by the `revSplit` marker cut); fake `call1 '(' …` on `((size_t)1 << k) - 1` (call pattern now requires a name token); `code` restructured to the parser's flat seq spine; `region 2945 91 = some code` kernel-proved | probe jobs `keygen_mkgm3_program_probe_001..009`, job `keygen_mkgm3_program_003` |
| closure rebuild (owner step 3) | **35/35 accepted/clean in ONE job** — full descendant closure of the changed `C99ModularReference`/`C99ModularParser` | `keygen_mkgm3_closure_001` |
| REV10 exactness certificate | `KeygenRev10Cert` (draft v3, UNCOMMITTED): model side validated green (32 kernel-decided 32-entry chunks vs `bitrev10`); source binding OPEN at a measured seam (kernel granularity ~8 parse lines per decide) — exact missing types in section 2 | probes `keygen_rev10_probe_002`; retained failures `_001.._003` |

### 1.1 What is proved (kernel, no sorries, no oracle)

- **B1.03 callee binding phase — CLOSED.** `r2_source_bound` and the
  corrected `div_source_bound` identify the hand-built `r2Code`/`divCode`
  trees with the parser output on the pinned bytes; `modp_R` keeps its
  exact value law; generator orders 9216/4608 stay kernel-checked.
- **`KeygenMkgm3Program.source_bound` — CLOSED.** The full `modp_mkgm3`
  body tree equals the parser output on the pinned 91 lines. The modular
  parser now genuinely covers the mkgm3 syntax: REV10 mixed-index stores
  fire via the marker cut, parenthesized cast-shift expressions parse,
  and the body spine is flat.
- **REV10 exactness certificate** (`KeygenRev10Cert`): the pinned 1024
  table entries are exactly `bitrev10 0..1023`, kernel-checked in
  32-entry chunks with a source binding and tail glue (see section 2 for
  the job result at the freeze).
- **Not claimed (unchanged boundary):** no gm row law, no
  Montgomery-scale identity of the emitted table words, no canonical
  ranges, no `igm=ft` overwrite or memory-layout theorem, no `modp_div`
  value law (its exact quotient law needs modulus primality and is not
  required for the gm words).

### 1.2 Evidence pins (verified MATCH against current files)

- Owner-pinned job `keygen_mkgm3_frontend_011`: RECEIPTS SHA256
  `3ca613d70be08968f902e729705754f687b5224e0286da1d46578dda4f381cdd`
  MATCH; SOURCE_INPUTS SHA256
  `7772a7a79458d5d37281e6c7f7ab8898567232449ad76df909bf4c0eeb0c5ade`
  MATCH (re-verified before new work).
- Runner byte-identical (`3bc29bf7…`).
- Retained FAILED attempts (never cited as PASS):
  `keygen_mkgm3_frontend_001..011`, `keygen_mkgm3_repair_001..004`,
  `keygen_mkgm3_program_001/002`, `keygen_rev10_cert_001`, probe jobs
  `keygen_mkgm3_div_probe_001`, `keygen_mkgm3_program_probe_001..009`,
  and all earlier retained failures. The transient probe module
  `KeygenMkgm3DivProbe` was deleted after use and its runner-cache entry
  pruned (documented hygiene; compiled copies and outputs retained in
  the job dirs).

## 2. In flight — exact types and state

**REV10 exactness certificate — OPEN at a measured, recoverable seam.**
Draft module `formal/Source3/KeygenRev10Cert.lean` (generated v3,
UNCOMMITTED draft preserved in the tree per the interruption rule; the
committed tree stays green without it). Retained FAILED attempts:
`keygen_rev10_cert_001` (design A killed after 25 min),
`keygen_rev10_cert_002` (design B: 1024-entry source decide blew the
kernel bound; `List.map_congr` not in the import closure),
`keygen_rev10_cert_003` (design C: chunked source binding, 33/33
parse-bearing decides blew; helpers needed shape fixes),
`keygen_rev10_probe_001/002` (granularity probes).

**Exact missing types for `rawTable_exact : rawTable = some ((List.range
1024).map bitrev10)`:**

1. *Source binding, chunked.* Measured kernel granularity (probe
   `keygen_rev10_probe_002`): one `decide` may parse **at most ~8 pinned
   table lines** (1/2/8-line `mapM parseLine` decides green; 86-line
   decides blow kernel memory even with a trivial `isSome` comparison;
   comparisons themselves are cheap — 32-entry model-side decides pass).
   Route: `sNN : ((Pinned.keygenLines.drop (8*NN)).take 8).mapM
   KeygenRev10.parseLine = some G_NN` (11 slice decides, the last slice
   6 lines) + a mapM/flatten glue over the slice facts (`rw`-chain +
   `rfl`; the glue must NOT re-parse).
2. *Model side* — validated green in `_003`'s run (the 32 `chunkNN`
   32-entry decides reported no errors; the module as a whole was not
   accepted due to the later source-binding failures). Re-prove inside
   the working module.
3. *Helper fixes* (v3 pitfalls, all local): `map_split`/`map_range_ext`
   by induction on the FIRST argument with `rfl`-grade base cases (the
   `omega` calls failed on `Nat.zero`/literal spellings; also `a + 0`
   does not reduce definitionally for variable `a`); `nomatch` instead
   of `Option.noConfusion` (universe mismatch on the reduced form);
   explicit type ascriptions on `List.mapM` (the monad is ambiguous
   without an expected type) and fully qualified names (bare `line` was
   auto-bound as a free variable). The `eq_of_split` ladder and the
   descending `tail1024..tail0` glue shapes in v3 are structurally
   sound; keep them.
4. *Assembly*: `tableData_exact` (from `tail0` + `map_range_ext`) and
   `rawTable_exact` (from the source binding + `congrArg some`) as in
   v3.

## 3. Remaining work — order from `KEYGEN_SOURCE_TO_FIBER_001_EXECUTION_PLAN.md`

1. **B1.03 (continuation)** — r2 exact value law (`2^62 mod p`
   Montgomery scale); per-row exponent/order laws and canonical ranges
   from the executed stores; `igm=ft` overwrite with gm/source-material
   preservation; extents and non-overlap from the caller buffer layout.
   Acceptance unchanged (initialized source gm words with canonical
   ranges and exact scaled root identities).
2. **B1.04** — NTT canonical range and polynomial evaluation (6
   sub-proofs; `t*m=n` lives here and ONLY here).
3. **B1.05**–**B1.11** as previously recorded.

Forbidden in all remaining steps (final premise boundary): solver or
serializer correctness assumptions; NTRU or certificate acceptance as
premises; unproved source completeness; arbitrary callee contracts;
success constructors containing evaluations.

## 4. Traps encountered (do not re-trigger)

1..31 (carried; still apply). 32..39 (previous window; still apply).
New this window:

40. **The runner's cache staleness check is SHALLOW** (source hashes +
    one level of recorded import artifacts). A rebuilt module whose
    inductive changed silently breaks stale importers via stuck `match`
    reduction (`localOnly X =?= some ?m` unification failures look like
    proof errors in the CONSUMER). The only reliable guard is the full
    descendant closure rebuild in one job (the checkpoint protocol).
41. **`revStoreTail`-style split parses cannot use greedy `pureExpr` for
    the prefix**: `b + REV10[u << k]` parses as `(b + var REV10)` with a
    dangling `[`. Cut at the literal marker (`+ REV10 [`) FIRST, then
    parse the prefix with full-consumption.
42. **`name::['(']` matches punctuation**: guard call patterns with a
    token-name check (`name.all wordChar`), else `((size_t)1 << k) - 1`
    degrades into a fake `call1 '(' …` and fails late and confusingly.
43. **Nested `chainOf` sublists are NOT the parser's tree shape**: the
    body recursion produces one flat right-nested seq spine (+ one
    trailing `skip`); splice nested statement groups into the same flat
    list or the equality fails everywhere after the nest.
44. **Prefix/line bisection of `region` is misleading at block
    boundaries** (an empty block swallows the probe's appended `}` and
    the trailing-consumption check fails). Bisect with synthetic
    `statement` probes on exact source lines instead.
45. **A `decide` over `rawTable`/`keygenLines` re-runs the whole pinned
    parse per theorem, and the KERNEL BOUND is on that parse**: measured
    (probe `keygen_rev10_probe_002`) at ~8 pinned table lines per
    `decide` (1/2/8-line parses green, 86-line parse blows kernel memory
    even with a trivial `isSome` comparison). Comparisons are cheap
    (32-entry list decides pass). Chunk certificates must parse in
    <=8-line slices and glue through intermediate facts; never reduce
    `rawTable` whole inside one `decide`.

## 5. Carried facts (earlier checkpoints, still true)

- B1.02 CLOSED at its Acceptance (first/intermediate/triple passes,
  counters, positions, complete-body execution); `KeygenNttMiddleRounds`
  etc. green in the new closure job.
- B1.01 word algebra adapter; `KeygenResidueVectors.source_vectors` and
  the residue conversion family; `KeygenCheckOutcome.accepted`;
  certificate suffix/prefix results; STABLE_BINARY_004 and frozen stage
  dependencies: all unchanged.
- Sage probes remain finite diagnostics, not kernel results.

## 6. Resume protocol (next window)

1. Read `WORK_STATE.md` (live), this file, the EXECUTION_PLAN and
   `run2/notes/B1_STAGED_ROADMAP.md`. The next window continues **B1.03**
   only (one stage per window) from section 3 item 1 (row/Montgomery/
   memory-layout laws), plus the REV10 closure check from section 2 if
   needed.
2. Verify current pins against SOURCE_INPUTS.json of
   `keygen_mkgm3_frontend_011` (plus the BATCH_013/014 pins) before any
   new claim.
3. One proof job at a time (`tools/job_when_available.py`; the shared
   slot had concurrent B2/B5 compiles this window), unique labels,
   topological module order, guarded serial compiles, logs 0/0, limits
   unchanged. Rebuild the FULL cached descendant closure of any changed
   module in one job (35 modules after this window's parser/reference
   changes) — trap 40.
4. Small logical local commits on `main` with exact pathspecs after each
   verified step; NO push until an explicit owner signal. One Git writer
   at a time (the B2/B5 lane commits concurrently).

`emitted_to_actual_fiber` is still uninhabited. Nothing in this package
is REVIEWED; REVIEWED is never self-declared.
