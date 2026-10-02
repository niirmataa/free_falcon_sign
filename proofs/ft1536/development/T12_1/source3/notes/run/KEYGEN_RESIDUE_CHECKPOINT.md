# KEYGEN_SOURCE_TO_FIBER_001 — residue checkpoint (expanded)

Package status: **IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN**.
Checkpoint written 2026-10-02 at the close of the owner-scoped window
"EXCLUSIVELY sections 2.1.2 and 2.1.1-second" (staged-roadmap iron rule
3: the stage is BIG and froze at a recoverable mid-point with exact
remaining obligations; not a failure). Session harness: **MiMo V2.6
Pro** (B1 continuation window). Batch receipt pair:
`KEYGEN_SOURCE_TO_FIBER_001_BATCH_011.json` + `_BATCH_011_NOTES.md`.
This file supersedes the previous expanded checkpoint; carried facts are
in section 5. The window executed EXCLUSIVELY 2.1.2 and 2.1.1-second of
the then-current remainder, per the owner instruction and section 6.

## 1. Closed — commits, modules, evidence (verified before commit)

Two local commits on `main` this window (no push, owner signal absent),
on top of the previous window's `e81051c4`/`6343029e`/`05ef631f`:

| Commit | Scope | Checked by |
|---|---|---|
| `aa86ba27` | `KeygenNttButterflyCalls` (new): call-observation EXTRACTION (2.1.2) — first/binary/triple chain walks yielding `FirstCalls`/`BinaryCalls`/`TripleCalls` with Load32/Store32 witnesses at the pinned r1/r2/gm positions; call inversions without case-binder absorption; uniform declaration/assign/store walk packages; FCtx/TCtx transport; binary body frame | job `keygen_ntt_butterfly_calls_009` |
| `d81c257c` | `KeygenNttMiddleLoops` (new): intermediate-pass v-loop and u1Inner positions (2.1.1 second, part 1) — `VInv`/`VTrace`/`loop_trace`/`v_result`, `bind_product`, `counter_update`/`step_result`, `u1_inner_result` | job `keygen_ntt_middle_loops_006` |

### 1.1 What is proved (kernel, no sorries, no oracle)

- **2.1.2 — butterfly call-observation extraction: CLOSED.**
  `KeygenNttButterflyCalls.first_calls / binary_calls / triple_calls`:
  from `Exec (block firstBody/binaryBody/tripleBody) before result` with
  the pinned r1/r2 (and gm) pointer slots and the p/p0i/w parameter words,
  one gets the loaded input words, the `KeygenNttButterflyAlgebra` call
  structure (`FirstCalls`/`BinaryCalls`/`TripleCalls`), and chained
  `Store32` witnesses for the outputs with `result.state.heap` the last
  store. The call observations are CONCLUSIONS now; the interface-only
  status (old item 2 call-premise leakage) is gone for these bodies.
  No value/range/polynomial invariant (B1.04); words stay symbolic.
- **2.1.1 second bullet — PARTIAL (part 1 closed):** `u1_inner_result`
  (+ `v_result`/`loop_trace`): executing `block u1Inner` yields a v-loop
  trace whose nodes carry `v ↦ k`, `r1 = a + v1*stride + v*stride`,
  `r2 = r1 + ht*stride + v*stride`, from the executed bindPtr chain with
  `r2` re-derived from `r1` each u1 round via `htBind`. Explicit
  non-overflow premises `v1*σ<2^64`, `ht*σ<2^64` (plus `v1,ht<2^64`
  representation bounds) cover the executed `size_t` products.
- **2.2 stride=1 boundary — kept, not claimed** (unchanged): all new
  theorems quantify over symbolic σ; wrapper/call-frame binding stays
  B1.07.

### 1.2 Evidence pins (verified MATCH against current files)

- Job `keygen_ntt_butterfly_calls_009`: 1/1 accepted, logs 0/0,
  27.527s, maxRSS 2584180 KiB. RECEIPTS.json SHA256
  `7ba24d47c466411ab325288de4a81c8211553899d3f7a13a05200cff77ad086c`;
  SOURCE_INPUTS.json SHA256
  `1986e5bd6f770436899cb7cf7e7cb1ef73f0043982757375825eb38a0bdb105e`.
- Job `keygen_ntt_middle_loops_006`: 1/1 accepted, logs 0/0, 5.429s,
  maxRSS 2572244 KiB. RECEIPTS.json SHA256
  `6a13b169100564229e53e66fb18a9a084d4ea7667e8df9d960edf307aa24be9c`;
  SOURCE_INPUTS.json SHA256
  `0e0e76f99c7fc5f8e532346ec28fbe76463cd54cb0c382d3b63839e7311fdff4`.
- Committed file SHA256s: `KeygenNttButterflyCalls.lean`
  `28d1e50a63d9d21d22641355e67d0eced689e185aae3c978ac83e3cd09136a87`;
  `KeygenNttMiddleLoops.lean`
  `2af95ae1392b5e712f86c50607b318123b2ae07e9b26706be13c37a01b4780db`.
- Input pins re-verified BEFORE new work (resume protocol step 2):
  `keygen_ntt_loop_support_006` (d67240e2…/e28cbff7…, 348/348),
  `keygen_ntt_first_loop_005` (ee6b5593…/70e4e64e…, 349/349),
  `keygen_ntt_triple_loop_006` (67b9b545…/1a7bcb93…, 350/350) all
  MATCH; the three previous-window jobs MATCH (22/23 with the single
  documented `C99ModularParser` drift; 24/24; 1/1). All nine
  committed-file pins of the previous checkpoint section 1.2 re-verified
  MATCH.
- Retained FAILED attempts (do not cite as PASS):
  `keygen_ntt_butterfly_calls_001..008`, `keygen_ntt_middle_loops_001..005`.
  The pinned runner `tools/job.py` remains byte-identical (sha256
  `3bc29bf7…`); its hardcoded PREFLIGHT `model`/`session` fields remain
  historical labels (BATCH_010/011).

## 2. In flight — exact types and state

B1.02 is at its Acceptance boundary minus the 2.1.1-second counter
composition. Grammar, complete-body execution, prologue values, the
first/triple pass counter+position extraction AND the butterfly
call-observation extraction are closed (section 1). The v-level of the
intermediate passes (positions from the bindPtr chain) is closed.

### 2.1 B1.02 remainder — exact obligations

1. **Loop counters and pointer positions from execution** — PARTIAL:
   - first pass: **CLOSED** (previous window);
   - intermediate passes: **PARTIAL** —
     - v-loop counters+positions and the u1Inner bindPtr chain
       (`r1 = a + v1*stride + v*stride`, `r2 = r1 + ht*stride + v*stride`,
       `r2` re-derived via `htBind`): **CLOSED** this window
       (`KeygenNttMiddleLoops.u1_inner_result`, `v_result`);
     - **OPEN**: u1-loop counters (`u1 ↦ j`, `v1 ↦ j*t`, `j ≤ m`) and the
       outer doubling rounds (`m ↦ 2^(i+1)`, `t ↦ 768/2^i`, `t = ht =
       t >> 1`) with guards `u1 < m` and `mGuard : t > 1+(full<<1)`; the
       derived bounds `m ≤ 2^8`, `t ≤ 768` (round count from the t
       halving) and `v1 ≤ 2^18`-class so a single `2^18*σ < 2^64`
       discharges the two fit premises; compositions `u1_result`,
       `round_result`, `intermediate_result`. `t*m=n` stays B1.04 and
       must NOT be used.
   - triple pass: **CLOSED** (previous window).
   No value/range/polynomial invariant belongs to this obligation.
2. **Butterfly call-observation extraction (old 2.4)**: **CLOSED** this
   window (`KeygenNttButterflyCalls.first_calls / binary_calls /
   triple_calls`). The call premises of `KeygenNttButterflyAlgebra` are
   now conclusions for these three bodies; downstream B1.04 may consume
   them per trace node.

### 2.2 stride=1 boundary

Unchanged: `stride = 1` is bound to the pinned wrapper argument and
instantiated in B1.07. All new theorems keep σ symbolic with explicit
non-overflow premises on the executed `size_t` products (`768*σ < 2^64`,
`3*σ < 2^64`, `v1*σ < 2^64`, `ht*σ < 2^64`).

## 3. Remaining work — order from `KEYGEN_SOURCE_TO_FIBER_001_EXECUTION_PLAN.md`

1. **B1.02 (finish)**: 2.1.1-second part 2 (u1/m/t counter composition
   and bounds) above; then the stage Acceptance is fully met and its
   window may close as complete.
2. **B1.03** — twiddle-table generation and memory layout (`modp_mkgm3`)
   as previously checkpointed (modp_R/modp_R2, REV10, per-row
   exponent/order law, Montgomery scale, generator order 9216/4608 as
   proof obligations, `igm = ft` overwrite, table extents).
3. **B1.04** — NTT canonical range and polynomial evaluation (6
   sub-proofs; `t*m=n` lives here and ONLY here).
4. **B1.05** — solver success to exact integer NTRU; **B1.06** — public
   computation and inverse; **B1.07** — whole KeyGen control/attempts
   (+ wrapper/stride=1 binding); **B1.08/B1.09** — secret/public
   serialization; **B1.10** — `emitted_to_actual_fiber`; **B1.11** —
   replay, mutations, final artifacts. (Details unchanged from the
   previous checkpoint section 3.)

Forbidden in all remaining steps (final premise boundary): solver or
serializer correctness assumptions; NTRU or certificate acceptance as
premises; unproved source completeness; arbitrary callee contracts;
success constructors containing evaluations.

## 4. Traps encountered (do not re-trigger)

1..18 (carried from previous checkpoints; the failed-job, region
numbering, Montgomery scale, constructor/consumer, `size_t`, MKN,
shared-`main`, region sub-parse, call-premise, attempt-cap, elaborator,
`end` keyword, cases-absorption, simpa defeq, simp no-op, Exec
induction, List.Mem, warningAsError families all still apply).
New this window:
19. **`∃`-notation binder restriction**: `∃ a b (c : T), …` is a parse
    error (binderIdent+ then `,`). Nest: `∃ a b, ∃ c : T, …`.
20. **`*Calls` structures are Type, not Prop** (they carry BitVec data).
    They cannot sit in `∧` chains; lift them into `∃` binders of the
    conclusion (and silence the unused-binder linter with `_calls`).
21. **`cases … with` binder absorption confirmed in the wild**: fields
    that unify with existing derivation variables silently drop their
    binder name (`callOut`/`vout` vanished). Fix: invert through
    var-major lemmas proved by `cases h with | ctor existingVars body
    => exact body`, or name the binder after the existing variable.
22. **`theorem` cannot declare data** ("type … is not a proposition"):
    name lists and other data need `def`; opaque theorems also make
    `decide` reduction get stuck.
23. **`rw` chain bookkeeping through `⟨state,.normal⟩.state` projections**
    works by defeq pattern matching, but each equation's pattern must
    actually occur in the target — wrong chain order fails loudly
    ("did not find an occurrence"); rewriting inside an extraction and
    again at the end double-rewrites.
24. **`decide`/`omega` on free variables**: `0 ≤ htp` and `k < 2^64` for
    variable bounds need real premises (`Nat.zero_le`, `hhtp : htp<2^64`)
    — literals were hiding this in earlier clones.
25. **Direction of `Ne` for `fresh_single`/frame keepers**: `n ≠ name`
    vs `name ≠ n` need `.symm` at the application, not at the use site.

## 5. Carried facts (earlier checkpoints, still true)

- B1.02 closed items (previous windows): grammar with five consumers
  patched and earlier pinned parses re-proved; `KeygenNttForwardPrograms`
  (body_source, four region pins); `KeygenNttForwardExec`
  (prologue_result, ready_n_slot, ready_hn_slot, guard_value logn0);
  `KeygenNttLoopSupport`/`KeygenNttFirstLoop`/`KeygenNttTripleLoop`
  (first/triple counters+positions). Jobs/pins in BATCH_009/010.
- `KeygenResidueVectors.source_vectors` and the residue conversion
  family, `KeygenCheckOutcome.accepted`, certificate suffix/prefix
  results, STABLE_BINARY_004 and the frozen stage dependencies: all
  unchanged (previous checkpoint section 5).
- Sage probes remain finite diagnostics, not kernel results.

## 6. Resume protocol (next window)

1. Read `WORK_STATE.md` (live), this file, the EXECUTION_PLAN and
   `run2/notes/B1_STAGED_ROADMAP.md`. The next window FINISHES 2.1.1
   second (part 2: u1/m/t counter composition and bounds, then
   `u1_result`/`round_result`/`intermediate_result`) — one stage per
   window; do not start B1.03. Suggested order: u1-loop trace first
   (`u1 ↦ j`, `v1 ↦ j*t` from `u1Step`), then the doubling outer rounds
   (`mStep`/`tFromHalf2`, guards via `KeygenNttMiddleLoops.guard_value`
   and the `plus_three_value` form of `mGuard`), then the compositions
   with the `2^18` bound derivation (round count from t halving; NOT
   `t*m=n`).
2. Verify current pins against SOURCE_INPUTS.json of
   `keygen_ntt_butterfly_calls_009` and `keygen_ntt_middle_loops_006`
   (plus the six previous-window jobs) before any new claim.
3. One proof job at a time (`tools/job_when_available.py`), unique
   labels, guarded serial compiles, logs 0/0, limits unchanged. Rebuild
   the FULL cached descendant closure of any changed module in one job;
   the two new modules currently have no descendants beyond themselves.
4. Small logical local commits on `main` with exact pathspecs after each
   verified step; NO push until an explicit owner signal. One Git writer
   at a time.

`emitted_to_actual_fiber` is still uninhabited. Nothing in this package
is REVIEWED; REVIEWED is never self-declared.
