# KEYGEN_SOURCE_TO_FIBER_001 — residue checkpoint (expanded)

Package status: **IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN**.
Checkpoint written 2026-10-02 at the B1.02 2.1/2.2 window close
(staged-roadmap iron rule 3: the stage is BIG and froze at a recoverable
mid-point with exact remaining obligations; not a failure). Session
harness: **MiMo V2.6 Pro** (B1 continuation window). Batch receipt pair:
`KEYGEN_SOURCE_TO_FIBER_001_BATCH_010.json` + `_BATCH_010_NOTES.md`.
This file supersedes the previous expanded checkpoint; carried facts are
in section 5. The window executed EXCLUSIVELY sections 2.1/2.2 of the
then-current remainder, per the section 6 resume protocol.

## 1. Closed — commits, modules, evidence (verified before commit)

Three local commits on `main` this window (no push, owner signal absent),
on top of the previous window's `a2679fc5`/`5ec12a55`/`c4d02bac`:

| Commit | Scope | Checked by |
|---|---|---|
| `e81051c4` | `KeygenNttLoopSupport` (new): statement inversions, uint64 counter/offset arithmetic from executed evaluations, pointer-root position equations, local-write frame fold | job `keygen_ntt_loop_support_006` |
| `6343029e` | `KeygenNttFirstLoop` (new): first-pass loop counters/positions — `u ↦ k`, `r1 = a + k*stride`, `r2 = a + (hn+k)*stride`, `k ≤ 768` | job `keygen_ntt_first_loop_005` |
| `05ef631f` | `KeygenNttTripleLoop` (new): triple-pass loop counters/positions — `u ↦ 3k`, `r ↦ 2^9+k`, `r1 = a + k*(3*stride)`, `k ≤ 512` | job `keygen_ntt_triple_loop_006` |

### 1.1 What is proved (kernel, no sorries, no oracle)

- **2.1.1 first bullet — first pass, from execution.**
  `KeygenNttFirstLoop.first_result`: from `Exec firstLoop before result`
  plus entry slots (u declared, `hn ↦ 768`, symbolic `stride ↦ σ`,
  `a ↦ aP`) and `768*σ < 2^64`, one gets `result.flow = .normal` and an
  initial state with `FirstInv aP σ 0 s0` and a `FirstTrace` whose every
  node carries `FirstInv aP σ k s`: `u ↦ k`, `r1 = aP + k*σ`,
  `r2 = aP + (768+k)*σ` (i.e. `a + (hn+k)*stride` at the evaluated
  stride), `k ≤ 768` derived from the executed guard. Positions come
  from the executed `bindPtr` chain (`pointer_root`); guard verdicts from
  the actual `u`/`hn` slots; the butterfly body preserves the loop state
  (`block_frame`: block-local writes only).
- **2.1.1 third bullet — triple pass, from execution.**
  `KeygenNttTripleLoop.triple_result`: from `Exec tripleLoop before
  result` plus entry slots (u/r declared, `lognAt` (logn=10),
  `n ↦ 1536`, `stride ↦ σ`, `a ↦ aP`) and `3*σ < 2^64`, one gets a
  `TripleTrace` whose nodes carry `u ↦ 3k`, `r ↦ 2^9+k` (the executed
  `(size_t)1 << (logn-1)` value 512, derived by `rinit_value`), and
  `r1 = aP + k*(3*σ)`, `k ≤ 512` from the executed `u < n` guard (which
  is literally `C99CountedWords.condition`).
- **2.2 stride=1 boundary — kept, not claimed.** All new theorems
  quantify over symbolic σ with explicit non-overflow premises for the
  executed `size_t` index products only; nothing instantiates stride=1
  and the wrapper/call-frame binding stays B1.07 work.
- No value/range/polynomial invariant anywhere in these modules (B1.04).
  No success constructor carries evaluations; calls execute the pinned
  `Call` bodies only.

### 1.2 Evidence pins (verified MATCH against current files)

- Job `keygen_ntt_loop_support_006`: 1/1 accepted, logs 0/0,
  maxRSS 2513828 KiB. RECEIPTS.json SHA256
  `d67240e2c195d475cbdef065e7b7579e1369b5b59bc00294d44a47c0a5335b02`;
  SOURCE_INPUTS.json SHA256
  `e28cbff75bc9cb6eb81dbeb0cd119e34d1b3f330b0d872e87c9dee7d19632a8f`.
- Job `keygen_ntt_first_loop_005`: 1/1 accepted, logs 0/0,
  maxRSS 2510248 KiB. RECEIPTS.json SHA256
  `ee6b5593b62ba444cf7a9e7193c69953bc0856481e407e0be4169360b91c0496`;
  SOURCE_INPUTS.json SHA256
  `70e4e64ec7d70630fe792a5e331c3f021485705f2526156bc640cdef3707086e`.
- Job `keygen_ntt_triple_loop_006`: 1/1 accepted, logs 0/0,
  maxRSS 2518000 KiB. RECEIPTS.json SHA256
  `67b9b545fd86e4b141dbdb318c3ff0c2dc9e21df50fd42ad291cdf6d1e70e000`;
  SOURCE_INPUTS.json SHA256
  `1a7bcb934cfb098a9d93ffe9024b52e1e5ef9ddb4a31d8a79d4c2a33a9dda9ad`.
- Committed file SHA256s: `KeygenNttLoopSupport.lean`
  `c305a4e46491b5570f2a64123727ac321b15a04192da948ef3bd743c5c798e7d`;
  `KeygenNttFirstLoop.lean`
  `1ce8e0634366a1db380f43946af7eb802eabdf015f2b91545a89824673e84c3a`;
  `KeygenNttTripleLoop.lean`
  `aeec1c131af214234a8165dacb41f82b5727a06d61cc182ec57de92d3e86a0da`.
- Input pins re-verified BEFORE new work (resume protocol step 2):
  `keygen_ntt_frontend_004` RECEIPTS `f2efa0ee…` / SOURCE_INPUTS
  `63764e25…` (22/23 MATCH; the single drift is `C99ModularParser`, the
  documented regionContext supersession whose full descendant closure
  was re-proved in `keygen_ntt_forward_programs_003`),
  `keygen_ntt_forward_programs_003` RECEIPTS `12beedee…` / SOURCE_INPUTS
  `5b733410…` (24/24 MATCH) and `keygen_ntt_forward_exec_005` RECEIPTS
  `87fd901f…` / SOURCE_INPUTS `9dffe32c…` (1/1 MATCH). All nine
  committed-file pins of the previous checkpoint section 1.2 re-verified
  MATCH.
- Retained FAILED attempts (do not cite as PASS):
  `keygen_ntt_loop_support_001..005`, `keygen_ntt_first_loop_001..004`,
  `keygen_ntt_triple_loop_001..005`. The pinned runner `tools/job.py` is
  byte-identical (sha256 `3bc29bf7…`); its hardcoded PREFLIGHT
  `model`/`session` fields are historical labels, not this window's
  harness (documented in BATCH_009/010, not silently edited).

## 2. In flight — exact types and state

B1.02 is at its Acceptance boundary minus two derived-observation
obligations (below). Grammar, complete-body execution relation, prologue
values AND the first/triple pass counter+position extraction are closed
(section 1). The relation `C99ModularReference.Exec` over `forwardBody`
is source-bound with the fixed `Call` table; the remaining parts of the
goal bullets are exactly 2.1.1-second and 2.1.2.

### 2.1 B1.02 remainder — exact obligations

1. **Loop counters and pointer positions from execution** — PARTIAL:
   - first pass (`firstLoop`, `u < hn`, `u ++, r1 += stride,
     r2 += stride`): **CLOSED** (`KeygenNttFirstLoop.first_result`:
     `u ↦ k`, `r1 = a + k*stride`, `r2 = a + (hn+k)*stride`, `k ≤ 768`);
   - intermediate passes (`u1Loop`/`vLoop`, `m/t` doubling with
     `t = ht = t >> 1` per outer round): counters m,t,u1,v1,v and the
     positions `r1 = a + v1*stride + v*stride`, `r2 = r1 + ht*stride +
     v*stride` from the executed `bindPtr` chain (r2 re-derived from r1
     each u1 round via `htBind`) — **OPEN**. The nested u1Loop/vLoop
     composition uses the same support lemmas (`update_result`,
     `pointer_root`, `block_frame`-style frames for `u1Inner`'s bindPtr
     atoms, `C99CountedWords`-style guards for `u1 < m`/`v < ht`). The
     `v1*stride`/`ht*stride` bind products need explicit non-overflow
     premises; derive `v1 ≤ 2^18`-class bounds from `m ≤ 2^8` and
     `t ≤ 768` (the round count follows from `t` halving; `t*m=n` stays
     B1.04 scope and must NOT be used);
   - triple pass (`tripleLoop`, `u < n`, `u += 3, r ++, r1 += 3*stride`):
     **CLOSED** (`KeygenNttTripleLoop.triple_result`: `u ↦ 3k`,
     `r ↦ 2^9+k`, `r1 = a + k*(3*stride)`).
   No value/range/polynomial invariant belongs to this obligation (those
   are B1.04).
2. **Butterfly call-observation extraction (old 2.4)**: extract
   `FirstCalls`/`BinaryCalls`/`TripleCalls` from the parsed memory/
   control bodies `firstBody`/`binaryBody`/`tripleBody` (same shape as
   `KeygenCheckOutcome.accepted`) — **OPEN**. Until then the call
   premises stay interface, not conclusion. The extraction walks each
   fixed chain with `eval_scalar`/`eval_arith` inversions and
   `store32_result`, assembling the `KeygenNttButterflyAlgebra` call
   structures with `Load32`/`Store32` witnesses at the current r1/r2
   positions (which sections 2.1.1 now pin per iteration).

### 2.2 stride=1 boundary

`stride = 1` is bound to the pinned wrapper argument
(`wrapper_source`, literal `1` at the macro's second position).
Instantiating it through the actual call frame is B1.07 work; this batch
does not claim it as a derived execution fact. All counter/position
theorems are parameterized by the evaluated stride magnitude σ with
explicit non-overflow premises on executed `size_t` products
(`768*σ < 2^64` first pass, `3*σ < 2^64` triple pass), which the B1.07
call frame discharges trivially.

## 3. Remaining work — order from `KEYGEN_SOURCE_TO_FIBER_001_EXECUTION_PLAN.md`

1. **B1.02 (finish)**: 2.1.1-second (intermediate passes) and 2.1.2
   above; then the stage Acceptance is fully met and its window may
   close as complete.
2. **B1.03** — source twiddle-table generation and memory layout
   (`modp_mkgm3`): `modp_R`/`modp_R2`, division body, REV10 data;
   per-row exponent/order law and Montgomery scale from executed stores;
   generator order at logn10 (expected g order 9216, M0 squaring 4608 —
   **proof obligation, not an assumption**); alias `igm = ft` overwrite
   with gm and source material preserved; allocation, table extents,
   access discipline and non-overlap from the caller's layout. Save
   finite-table certificates via generator/pin if too large.
3. **B1.04** — NTT canonical range and polynomial evaluation for the
   SAME transform execution (6 sub-proofs; passes committed separately);
   first-pass formulas incl. `w^2 - w + 1 = 0`, radix-2 invariant
   `t*m = n`, triple-pass emission order from source indices/REV10,
   `CoefficientQuotient.polynomial` link, 1536 distinct roots of Phi and
   the quotient injectivity step.
4. **B1.05** — source solver success to exact integer NTRU (full active
   call graph source-bound; `poly_big_to_small`/`zint_one_to_plain`
   bodies; MODE1 sampler bounds 1; material preservation;
   `exact_ntru_of_modular_check` with residual bound 37748737).
5. **B1.06** — source public computation and inverse
   (`falcon_compute_public` ternary q18433 branch, `mulRq` equations,
   fInv witness from nonzero evaluations).
6. **B1.07** — whole KeyGen control, attempts, final invocation (six
   gates of `run2/notes/S1_P_ACCEPT_FACTS.md` + attempt-cap semantics;
   LAW BOUNDARY: loop acceptance precedes capacity checks; call-level
   return 1 ≠ per-attempt acceptance; `1-(1-p_accept)^cap` needs a
   probability law). Includes the wrapper/stride=1 call-frame binding.
7. **B1.08** — source secret-key serialization/decoding (accumulator
   low-suffix invariant; terminal `ne = -2`; four segments, header 0xaa;
   length formulas proved, not borrowed).
8. **B1.09** — source public-key serialization/decoding (15-bit packing,
   2880+1 bytes, header 0x8a; the decoder returns its supplied length).
9. **B1.10** — the one `emitted_to_actual_fiber` theorem with the exact
   allowed premise boundary and the B4/B5 contract table.
10. **B1.11** — complete replay, mutations, final artifacts.

Forbidden in all remaining steps (final premise boundary): solver or
serializer correctness assumptions; NTRU or certificate acceptance as
premises; unproved source completeness; arbitrary callee contracts;
success constructors containing evaluations.

## 4. Traps encountered (do not re-trigger)

1. **Failed job records look like evidence.** Re-hash the working tree
   against SOURCE_INPUTS before citing a receipt (carried). New: a
   passing job's twin with one superseded module (`frontend_004`'s
   parser) must be read as historical step, not mismatch panic — check
   the later job that rebuilt the closure.
2. **Region numbering off-by-three** (carried).
3. **Montgomery scale confusion** (carried).
4. **Adding a Stmt/Exec constructor breaks five consumers** (carried).
5. **`size_t` is not a `typeToken`** (carried).
6. **`MKN` is a macro, not a call** (carried).
7. **Shared `main`, several writers** (carried): exact pathspecs,
   `-m` before `--`, no amend/force-push, **no push** without an explicit
   owner signal. Foreign commits landed mid-batch again
   (`4daec033`, `3870dc50`, `7e72e5ea`, `b36b3180`, `7307ca7a`,
   `cb679213`, others); none were touched.
8. **Region sub-parses need their continuation context** (carried).
9. **Call-premise leakage** (carried): `FirstCalls`/`BinaryCalls`/
   `TripleCalls` remain interface until 2.1.2 extraction exists.
10. **Attempt-cap law boundary** (carried, B1.07).
11. **Elaborator shapes** (carried).
12. **A binder named `end` is a Lean keyword** — it breaks inductive
    declarations and cascades into `autoImplicit` mysteries (new).
13. **`cases … with` binder lists silently absorb fields that unify
    with existing context variables** — reference the existing
    state/result variables or use var-major inversion lemmas (new).
14. **`simpa […] using h` loses defeq matching when only one side
    normalizes** — use `show`/`rw` then `exact` for transports through
    record updates, `u64` cells and `bindPointer` states (new).
15. **`simp [key]` no-ops when simp pre-normalizes both sides of `key`**
    (Nat distributivity/associativity) — use `rw [key]` (new).
16. **`induction` on `Exec` needs a variable statement index** plus an
    explicit `shape` equation (the `KeygenCheckLoopBridge.complete`
    pattern); a concrete `.loop …` index rejects `induction` (new).
17. **`List.Mem` is not `Or`** — bridge via `List.mem_cons`/
    `List.mem_append` and `contains_iff` (new).
18. **warningAsError makes unused simp args/tactic no-ops/variables hard
    errors** — prefer `split_ifs` over `simp [set, hn]` when hypothesis
    and goal forms differ syntactically (new).

## 5. Carried facts (earlier checkpoints, still true)

- B1.02 closed items (previous window): grammar extension with all five
  consumers patched and every earlier pinned parse re-proved unchanged;
  `KeygenNttForwardPrograms` (`body_source`, four contiguous region
  pins); `KeygenNttForwardExec` (`prologue_result`, `ready_n_slot`,
  `ready_hn_slot`, `guard_value` for logn0). Jobs
  `keygen_ntt_frontend_004` (23/23), `keygen_ntt_forward_programs_003`
  (24/24), `keygen_ntt_forward_exec_005` (1/1); pins in the previous
  checkpoint/BATCH_009. Retained FAILED:
  `keygen_ntt_frontend_003`, `keygen_ntt_forward_programs_001/002`,
  `keygen_ntt_forward_exec_001..004`.
- `KeygenResidueVectors.source_vectors` consumes the Geometry.Vec
  representation of the four input arrays and execution of the parsed
  source conversion loop 7367–7372: canonical output residues over the
  same integer coefficients. Input/output non-aliasing and source entry
  layout remain explicit local premises for the enclosing caller.
- Retained checks: `keygen_modular_memory_closure_009` (15/15),
  `keygen_residue_store_010`..`keygen_residue_vectors_016` (7 modules),
  `keygen_residue_audit_017` (20 type/term/axiom audits; RECEIPTS SHA256
  `98a4a770a4c28c515ae8e1b4716d73d1e5bf58cf9163c0b8da83db467a617101`),
  `keygen_modular_suffix_checks_002` (Sage ZZ diagnostics; result SHA256
  `ed336129760e5178d482150f8f4d34556663b7ac637fa053811867a2ba00327b`).
  The Sage probes are finite diagnostics, not replacements for kernel
  results.
- B1.01 closed earlier (commits `d5cae83e`, `e53bf9ee`, `aa40bc94`):
  `KeygenNttWordAlgebra`, `KeygenFirstPrime`, the pointer-dereference
  grammar step, the pinned butterfly bodies
  (`first_source`/`binary_source`/`triple_source`/`wrapper_source`) and
  `KeygenNttButterflyAlgebra` (`first_values`/`binary_values`/
  `triple_values` over explicit call-observation structures).

## 6. Resume protocol (next window)

1. Read `WORK_STATE.md` (live), this file, the EXECUTION_PLAN and
   `run2/notes/B1_STAGED_ROADMAP.md`. The next window FINISHES B1.02
   (section 2.1.1-second + 2.1.2) — one stage per window; do not start
   B1.03. Suggested order within the window: 2.1.2 extraction first
   (three fixed chains, mechanical now that positions are pinned), then
   the intermediate passes (the nested loop composition).
2. Verify current pins against SOURCE_INPUTS.json of
   `keygen_ntt_loop_support_006`, `keygen_ntt_first_loop_005` and
   `keygen_ntt_triple_loop_006` (plus the three previous-window jobs)
   before any new claim.
3. One proof job at a time (`tools/job_when_available.py`), unique
   labels, guarded serial compiles, logs 0/0, limits unchanged. Rebuild
   the FULL cached descendant closure of any changed module in one job
   (topological order) — e.g. a `KeygenNttLoopSupport` change rebuilds
   `KeygenNttFirstLoop` + `KeygenNttTripleLoop` in the same job.
4. Small logical local commits on `main` with exact pathspecs after each
   verified step; NO push until an explicit owner signal. One Git writer
   at a time.

`emitted_to_actual_fiber` is still uninhabited. Nothing in this package
is REVIEWED; REVIEWED is never self-declared.
