# KEYGEN_SOURCE_TO_FIBER_001 — residue checkpoint (expanded)

Package status: **IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN**.
Checkpoint written 2026-10-06 at the close of the owner-scoped window
"EXCLUSIVELY 2.1.1-bullet2 part 2" (staged-roadmap iron rule 3: the
stage Acceptance is met, so **B1.02 closes as complete**; it is not a
failure — it is the design). Session harness: **MiMo V2.6 Pro** (B1
continuation window). Batch receipt pair:
`KEYGEN_SOURCE_TO_FIBER_001_BATCH_012.json` + `_BATCH_012_NOTES.md`.
This file supersedes the previous expanded checkpoint; carried facts
are in section 5. The window executed EXCLUSIVELY 2.1.1-second part 2
per the owner instruction and section 6.

## 1. Closed — commits, modules, evidence (verified before commit)

Two local commits on `main` this window (no push, owner signal absent):
the proof module `KeygenNttMiddleRounds` and the batch012 receipt +
this checkpoint.

| Scope | Content | Checked by |
|---|---|---|
| `KeygenNttMiddleRounds` (new) | 2.1.1-second part 2: u1-loop counters (`u1 ↦ j`, `v1 ↦ j*t`, `j ≤ m`), doubling outer rounds (`m ↦ 2^(i+1)`, `t ↦ 768/2^i`, executed `t = ht = t >> 1` halving), guards `u1 < m` and `mGuard`, round-count bounds (m ≤ 2^8, t ≤ 768, v1/ht ≤ 2^18) and the compositions `u1_result`/`round_result`/`intermediate_result` carrying the nested v-runs | job `keygen_ntt_middle_rounds_002` |

### 1.1 What is proved (kernel, no sorries, no oracle)

- **2.1.1 second bullet, part 2 — CLOSED.** `u1_result` (with
  `U1Inv`/`U1Trace`/`U1Run`), `round_result`/`m_loop_trace` (with
  `MInv`/`RoundRun`/`MTrace`) and `intermediate_result`: the parsed
  `intermediatePass` executes with `m ↦ 2^(i+1)`, `t ↦ 768/2^i` per
  round i, the executed `t = ht = t >> 1` halving, per-round u1
  counters `u1 ↦ j`, `v1 ↦ j*t` with `j ≤ m`, and per-u1-round nested
  v-loop runs at the positions of `KeygenNttMiddleLoops.u1_inner_result`.
  Guards are evaluated: `u1 < m` via `KeygenNttMiddleLoops.guard_value`
  and `mGuard : t > 1+(full<<1)` via `plus_three_value` as `3 < t`.
- **Derived bounds (round count from the t halving, NOT t*m=n).**
  `3 < 768/2^i ⇒ 4*2^i ≤ 768 ⇒ i ≤ 7`, hence `m ≤ 2^8`, `t ≤ 768`,
  `v1 = j*t ≤ 2^8*768 ≤ 2^18`, `ht = t/2 ≤ 2^18`; one pass-level
  premise `2^18*σ < 2^64` discharges both executed `size_t` product
  fits (`v1*σ < 2^64`, `ht*σ < 2^64`).
- **B1.02 remainder (2.1.1 + 2.1.2) — CLOSED; the stage Acceptance is
  met.** First pass, intermediate passes and triple pass counters and
  positions, butterfly call-observation extraction and complete-body
  execution are all closed. No value/range/polynomial invariant
  (B1.04) and no `stride = 1` claim (B1.07): σ stays symbolic with the
  explicit non-overflow premises `768*σ`, `3*σ`, `v1*σ`, `ht*σ < 2^64`.
- **`t*m=n` was not used** anywhere in this window or module (B1.04
  boundary, forbidden premise list respected).

### 1.2 Evidence pins (verified MATCH against current files)

- Job `keygen_ntt_middle_rounds_002`: 1/1 accepted, logs 0/0, 3.071s,
  one module over the 353-entry reused closure. RECEIPTS.json SHA256
  `3dbc0cfa444608dc8c77d5d9c6ce95a25c0f94ce9587c02cf18e8bee41d0a274`;
  SOURCE_INPUTS.json SHA256
  `17b98f3715de911247daa54d8326b736b68bba9f956d7c9d205d84d7ff4af52e`.
- Committed file SHA256: `KeygenNttMiddleRounds.lean`
  `dd66ac1a7c3691a63718c97bc7209fea3f0de0bc3fa570bfafbd726583b403a8`.
- Input pins re-verified BEFORE new work (resume protocol step 2):
  all 18 named BATCH_011 pins MATCH (two jobs' RECEIPTS/SOURCE_INPUTS,
  two committed modules, the runner, six previous-window jobs), and the
  five full source closures re-verified byte-exact: 352/352
  (`keygen_ntt_butterfly_calls_009`), 353/353
  (`keygen_ntt_middle_loops_006`), 349/349, 350/350, 351/351 (the
  three BATCH_010 jobs) — 0 drift, 0 missing; the documented
  `C99ModularParser` drift of `keygen_ntt_frontend_004` is unchanged.
- Retained FAILED attempt (do not cite as PASS):
  `keygen_ntt_middle_rounds_001`. The pinned runner `tools/job.py`
  remains byte-identical (sha256 `3bc29bf7…`); its hardcoded PREFLIGHT
  `model`/`session` fields remain historical labels.

## 2. In flight — exact types and state

Nothing is in flight at this boundary: B1.02 is CLOSED at its
Acceptance. The exact closed interface is the section 1.1 list; its
consumers (B1.04 range/evaluation) may take the per-round counter and
position facts and the single `2^18*σ < 2^64` fit discharge as
conclusions. The boundary items remain explicit: stride=1 wrapper
binding is B1.07, `t*m=n`, canonical ranges and polynomial evaluation
are B1.04.

## 3. Remaining work — order from `KEYGEN_SOURCE_TO_FIBER_001_EXECUTION_PLAN.md`

1. **B1.03** — twiddle-table generation and memory layout (`modp_mkgm3`):
   modp_R/modp_R2, REV10, per-row exponent/order law, Montgomery scale,
   generator order 9216/4608 as proof obligations (not assumptions),
   `igm = ft` overwrite, table extents.
2. **B1.04** — NTT canonical range and polynomial evaluation (6
   sub-proofs; `t*m=n` lives here and ONLY here).
3. **B1.05** — solver success to exact integer NTRU; **B1.06** — public
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

1..25 (carried from previous checkpoints; the failed-job, region
numbering, Montgomery scale, constructor/consumer, `size_t`, MKN,
shared-`main`, region sub-parse, call-premise, attempt-cap, elaborator,
`end` keyword, cases-absorption, simpa defeq, simp no-op, Exec
induction, List.Mem, warningAsError, `∃`-binder, `*Calls`-are-Type,
cases binder absorption, `theorem`-data, `rw` chain bookkeeping,
`decide`/`omega` free-variable premises, `Ne` direction families all
still apply).
New this window:
26. **`≤i` is a single token** (`InitialSeg` notation `α ≤i β`):
    `8≤i` breaks the parser ("unexpected token ':='" + phantom
    `InitialSeg`/`sorry` goals). Space relational operators away from
    identifiers starting with `i`.
27. **`subst` cannot eliminate projections** (`out.state = …`): destruct
    the constructor equation `out = ⟨state,flow⟩` and `subst out`.
28. **`resolve_right` + `subst r`**: the surviving name is the
    `seq_inv` OUT argument (`result`/`inner`/`out`), not `r`.
29. **`omega` sees only context hypotheses**, not structure fields:
    hoist `have hjle := inv.bound` before `by omega` goals on `j`.
30. **`rw` cannot match under the `USlot`/`PSlot` abbreviations**:
    expose projections with `show` (defeq check) instead of `rw`
    through the abbreviation.
31. **`.base (.scalar (.update …))` exit-elimination** uses
    `normal_base`, not `normal_assign` (only `.assign` steps take the
    latter).

## 5. Carried facts (earlier checkpoints, still true)

- B1.01 word algebra adapter; grammar with five consumers patched and
  earlier pinned parses re-proved; `KeygenNttForwardPrograms`
  (body_source, four region pins); `KeygenNttForwardExec`
  (prologue_result, ready_n_slot, ready_hn_slot, guard_value logn0);
  `KeygenNttLoopSupport`/`KeygenNttFirstLoop`/`KeygenNttTripleLoop`
  (first/triple counters+positions); `KeygenNttButterflyCalls`
  (call-observation extraction); `KeygenNttMiddleLoops` (v-loop and
  u1Inner bindPtr-chain positions). Jobs/pins in BATCH_009/010/011/012.
- `KeygenResidueVectors.source_vectors` and the residue conversion
  family, `KeygenCheckOutcome.accepted`, certificate suffix/prefix
  results, STABLE_BINARY_004 and the frozen stage dependencies: all
  unchanged (previous checkpoint section 5).
- Sage probes remain finite diagnostics, not kernel results.

## 6. Resume protocol (next window)

1. Read `WORK_STATE.md` (live), this file, the EXECUTION_PLAN and
   `run2/notes/B1_STAGED_ROADMAP.md`. The next window starts **B1.03**
   (twiddle-table generation and memory layout) — one stage per
   window; do not start B1.04 in the same window.
2. Verify current pins against SOURCE_INPUTS.json of
   `keygen_ntt_middle_rounds_002` (plus `keygen_ntt_butterfly_calls_009`
   and `keygen_ntt_middle_loops_006` and the six previous-window jobs)
   before any new claim.
3. One proof job at a time (`tools/job_when_available.py`), unique
   labels, guarded serial compiles, logs 0/0, limits unchanged. Rebuild
   the FULL cached descendant closure of any changed module in one job;
   `KeygenNttMiddleRounds` currently has no descendants beyond itself.
4. Small logical local commits on `main` with exact pathspecs after
   each verified step; NO push until an explicit owner signal. One Git
   writer at a time.

`emitted_to_actual_fiber` is still uninhabited. Nothing in this package
is REVIEWED; REVIEWED is never self-declared.
