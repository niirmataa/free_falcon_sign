# KEYGEN_SOURCE_TO_FIBER_001 — residue checkpoint (expanded)

Package status: **IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN**.
Checkpoint written 2026-10-02 at the B1.02 window close (staged-roadmap
iron rule 3: the stage is BIG and froze at a recoverable mid-point with
exact remaining obligations; not a failure). Session harness:
**MiMo V2.6 Pro** (B1 continuation window; explicit handoff from GPT-6
Astra per `run2/notes/PROMPT_B1_CONTINUATION.md`). Batch receipt pair:
`KEYGEN_SOURCE_TO_FIBER_001_BATCH_009.json` + `_BATCH_009_NOTES.md`.
This file supersedes the previous expanded checkpoint; carried facts are
in section 5.

## 1. Closed — commits, modules, evidence (verified before commit)

Three local commits on `main`, no push (owner signal):

| Commit | Scope | Checked by |
|---|---|---|
| `a2679fc5` | `C99ModularReference` (retVoid), `C99ModularParser` (forward-NTT grammar), `C99ModularAnnotation`, `C99ModularFlow`, `C99ModularFrame`, `KeygenCheckLoopBridge`, `KeygenResidueLoop` | job `keygen_ntt_frontend_004` |
| `5ec12a55` | `C99ModularParser` (regionContext), `KeygenNttForwardPrograms` (new) | job `keygen_ntt_forward_programs_003` |
| `c4d02bac` | `KeygenNttForwardExec` (new) | job `keygen_ntt_forward_exec_005` |

### 1.1 What is proved (kernel, no sorries, no oracle)

- **Grammar extension (syntax/control, separate commit).**
  `C99ModularParser` accepts exactly the pinned `modp_NTT3_ext` control
  syntax: void `return;` (`Stmt.retVoid` + `Exec.retVoid`),
  `uint32_t *r1, *r2;` declarations (`declarePtr` chain), pointer
  assignment/advance through a threaded pointer-name `Context`
  (`bindPtr`: `r1 = a`, `r2 = a + hn * stride`, `r2 = r1 + ht * stride`,
  `r1 += stride`), comma-separated for-init/for-increment clauses
  (`clauses` with terminator token), compound updates (`m <<= 1`,
  `u += 3`, `v1 += t` via `updateOp`), and the **MKN macro expansion**
  (`C99ArrayParser.mkn`, never a Call). Pointer `++` is rejected, not
  mis-parsed. All five consumers of checkpoint 2.3 patched;
  `KeygenCheckGate.return_literal` needed no change. The full cached
  descendant closure (23 modules) rebuilt accepted/clean and **every
  earlier pinned parse is re-proved unchanged** (`region 7386 11`,
  `region 7367 6` incl. the signed annotation, `region 3070 7`,
  `region 3095 7`, `region 3115 20`, KeygenCheckMutations rejections).
- **Complete forward body.** `KeygenNttForwardPrograms` (new):
  `body_source : C99ModularParser.region 3046 91 = some forwardBody`
  with `forwardBody = glue prologue (glue firstPass (glue
  intermediatePass triplePass))` (`glue` = sequence composition modulo
  the parser's synthetic skip terminator). Parts pinned to their
  contiguous regions: `prologue_source` (`region 3046 9`),
  `first_source` (`regionContext ["r1","r2"] 3066 12`),
  `intermediate_source` (`… 3082 24`), `triple_source` (`… 3110 27`).
  Every guard retained, including `if (logn == 0) return;`. The wrapper
  macro `modp_NTT3(…,1,…)` → `modp_NTT3_ext` stays separately pinned
  (`KeygenNttButterflyPrograms.wrapper_source`).
- **Prologue execution derivation.** `KeygenNttForwardExec` (new):
  `prologue_result : lognAt before → fullAt before → Exec prologue before
  result → result = ⟨ready before, .normal⟩` with `ready_n_slot`
  (`n ↦ (.uint64, some (.uint64 1536))`) and `ready_hn_slot`
  (`hn ↦ (.uint64, some (.uint64 768))`). Values come FROM execution:
  `mkn_value` evaluates the expanded MKN macro through the `size_t` cast
  and both shifts (helpers `plus_three_value`, `minus_nine_value`,
  `shl_full_value`, `literal_value`), `half_value` evaluates `n >> 1`,
  `guard_value` derives the logn0 guard verdict from the actual `logn`
  slot (branchTrue contradicts the evaluated guard at logn=10). The
  statement-level extraction rests on var-major inversions
  (`eval_scalar/cast/arith/shift/compare`, `assign_inv`, `base_inv`,
  `scalar_inv`, `declarePtr_inv`, `seq_inv`, `branch_inv`,
  `shift_left_value`, `declarations_result`) so every constructor binder
  is explicit. No success constructor carries evaluations; calls execute
  the pinned `Call` bodies only (modp_montymul/add/sub), no NTT oracle.

### 1.2 Evidence pins (verified MATCH against current files)

- Job `keygen_ntt_frontend_004`: 23/23 accepted, logs 0/0
  (KeygenFiber008Audit/KeygenResidueAudit stdout = intended
  type/term/axiom audits), maxRSS 3118652 KiB. RECEIPTS.json SHA256
  `f2efa0ee078c3d84dc8754829a46ad8e5944d3372a58d2c468499904d9ba621c`;
  SOURCE_INPUTS.json SHA256
  `63764e25e351c007c512996ccac4270194575e76f3c839c37a7d95d6675237fe`.
- Job `keygen_ntt_forward_programs_003`: 24/24 accepted, logs 0/0,
  maxRSS 4462716 KiB. RECEIPTS.json SHA256
  `12beedee53807afa7fa9d329b5d776956bad43f9d38c9a9f5a6e2a02f633fdcc`;
  SOURCE_INPUTS.json SHA256
  `5b7334103f0ae61192e0a70d924667edc23e66ca01b95cc94d75473d9d60b230`.
- Job `keygen_ntt_forward_exec_005`: 1/1 accepted, logs 0/0.
  RECEIPTS.json SHA256
  `87fd901fed7228e3022469037c14f6cf6fb19230c87b19ae1bfb782d6a8fa958`;
  SOURCE_INPUTS.json SHA256
  `9dffe32ca8025e2344851c40f16bcc8596f2e52039a5429a7cfb95d681b67e53`.
- Committed file SHA256s: `C99ModularReference.lean`
  `2dd95f8162c5eebb340f3566fc47947bbbe3d5ace0443795b131bbb6df5be871`;
  `C99ModularParser.lean`
  `6f6c03e1c52955bac3b9c3ecefa41bb5bf3539ef3bcde69c89e848935c283fd2`;
  `C99ModularAnnotation.lean`
  `3d1e2e06ebe7c61406c696e168697cdfbfe4e66808e6e5e31d4e4f0701230315`;
  `C99ModularFlow.lean`
  `f1f3b83748211e854769768632f6b561c30e072234fb921c10a363274a04b3a4`;
  `C99ModularFrame.lean`
  `b13531594196b4d92b14c171b91306a6ad2b7bb54c6a45215428936a2076bce7`;
  `KeygenCheckLoopBridge.lean`
  `b81027ed026b1e7d28e154c2e488722391b7d1e600c4dd3ae15ae0a3d8b3e97a`;
  `KeygenResidueLoop.lean`
  `0f1a874a8d348965fa3c3f8cc1cf3492c94ea2340f6d042be889d076edd199fc`;
  `KeygenNttForwardPrograms.lean`
  `789d91a3881f9f9ea217c8a98d574560dde3cc4546da2e77c919e209d68e6513`;
  `KeygenNttForwardExec.lean`
  `df271c8494bc3656d5dc2f3ca4a83222f69dc220e70d5e3a01fdf682bf7afbb9`.
- Input pins re-verified before new work: `keygen_ntt_frontend_002`
  RECEIPTS `2103761326376591a723f89addd92a3fb1e3c6e07bc2d0d5499d55846f78f5d6`
  / SOURCE_INPUTS
  `314649f3121a3ffed190f2db9907b71e151c5124c71e155e67e2813fd9eb6f51`
  (23/23 sources MATCH) and `keygen_ntt_butterfly_algebra_004` RECEIPTS
  `38ba136a0b04a9c1e483f2475419591d8994002f0577b2e49542a5c8febc8948`
  / SOURCE_INPUTS
  `fcf73a35fab0b6359cea2b10495a126691947e8b38a88719d82266f3082bb8ca`
  (1/1 MATCH).
- Retained FAILED attempts (do not cite as PASS): `keygen_ntt_frontend_003`
  (1/24 then stop), `keygen_ntt_forward_programs_001/002`,
  `keygen_ntt_forward_exec_001..004`. NOTE: `_002` (failed overall)
  already contained successful `prologue_source`/`body_source`
  evaluations; cite the passing `_003` for those claims. The pinned
  runner `tools/job.py` is byte-identical (sha256 `3bc29bf7…`); its
  hardcoded PREFLIGHT `model`/`session` fields are historical labels,
  not this window's harness (documented in BATCH_009, not silently
  edited).

## 2. In flight — exact types and state

B1.02 is at its Acceptance boundary minus two derived-observation
obligations. Grammar, complete-body execution relation and prologue
values are closed (section 1). The relation `C99ModularReference.Exec`
over `forwardBody` is source-bound with the fixed `Call` table (actual
pinned scalar bodies), i.e. the "no abstract NTT oracle" part of the
Acceptance holds; the per-loop extraction listed below is the remaining
part of the goal bullets.

### 2.1 B1.02 remainder — exact obligations

1. **Loop counters and pointer positions from execution** (Trace shape of
   `KeygenResidueLoop.Trace` / `KeygenCheckLoopBridge.complete`, or the
   `SmallintsCounter` increment shape):
   - first pass (`firstLoop`, `u < hn`, `u ++, r1 += stride,
     r2 += stride`): after k iterations `u ↦ k`, `r1 = a + k*stride`,
     `r2 = a + (hn+k)*stride`, k ≤ 768 (hn from `ready`);
   - intermediate passes (`u1Loop`/`vLoop`, `m/t` doubling with
     `t = ht = t >> 1` per outer round): counters m,t,u1,v1,v and the
     positions `r1 = a + v1*stride + v*stride`, `r2 = r1 + ht*stride +
     v*stride` from the executed `bindPtr` chain (r2 re-derived from r1
     each u1 round via `htBind`);
   - triple pass (`tripleLoop`, `u < n`, `u += 3, r ++, r1 += 3*stride`):
     `u ↦ 3k`, `r ↦ 2^9+k`, `r1 = a + k*(3*stride)`.
   No value/range/polynomial invariant belongs to this obligation (those
   are B1.04). The increments are `bindPtr` advances; the exact `Exec`
   inversions are already in `KeygenNttForwardExec`.
2. **Butterfly call-observation extraction (old 2.4)**: extract
   `FirstCalls`/`BinaryCalls`/`TripleCalls` from the parsed memory/
   control bodies `firstBody`/`binaryBody`/`tripleBody` (same shape as
   `KeygenCheckOutcome.accepted`). Until then the call premises stay
   interface, not conclusion.

### 2.2 stride=1 boundary

`stride = 1` is bound to the pinned wrapper argument
(`wrapper_source`, literal `1` at the macro's second position). Instantiating
it through the actual call frame is B1.07 work; this batch does not
claim it as a derived execution fact.

## 3. Remaining work — order from `KEYGEN_SOURCE_TO_FIBER_001_EXECUTION_PLAN.md`

1. **B1.02 (finish)**: 2.1/2.2 above; then the stage Acceptance is fully
   met and its window may close as complete.
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
   bodies; MODE1 sampler bounds 1; material preservation; `exact_ntru_of_modular_check`
   with residual bound 37748737).
5. **B1.06** — source public computation and inverse
   (`falcon_compute_public` ternary q18433 branch, `mulRq` equations,
   fInv witness from nonzero evaluations).
6. **B1.07** — whole KeyGen control, attempts, final invocation (six
   gates of `run2/notes/S1_P_ACCEPT_FACTS.md` + attempt-cap semantics;
   LAW BOUNDARY: loop acceptance precedes capacity checks; call-level
   return 1 ≠ per-attempt acceptance; `1-(1-p_accept)^cap` needs a
   probability law).
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
   against SOURCE_INPUTS before citing a receipt (carried). New this
   batch: a FAILED job (`keygen_ntt_forward_programs_002`) contained
   passing sub-evaluations — cite the PASSING job for any claim.
2. **Region numbering off-by-three** (carried): region line i = file
   line i+3; synthetic `}` terminator; `take count` counts raw lines.
3. **Montgomery scale confusion** (carried).
4. **Adding a Stmt/Exec constructor breaks five consumers** (carried,
   list in old 2.3 — done this batch for retVoid; `return_literal` was
   the one needing no patch).
5. **`size_t` is not a `typeToken`** (carried).
6. **`MKN` is a macro, not a call** (carried; now enforced in
   `C99ModularParser.expr` as well).
7. **Shared `main`, several writers** (carried): exact pathspecs,
   `-m` before `--`, no amend/force-push, **no push** without an explicit
   owner signal. Foreign commits landed mid-batch (`559ef949`,
   `933f741a`, `132098c2`); none were touched.
8. **Region sub-parses need their continuation context.** Standalone
   `region` starts with an empty `Context`, so `r1 = a` parses as scalar
   assign outside the whole body. Pin sub-regions with
   `regionContext ["r1","r2"]`; keep `region` = `regionContext []` so
   older pins stay valid.
9. **Call-premise leakage** (carried): `FirstCalls`/`BinaryCalls`/
   `TripleCalls` remain interface until 2.1.2 extraction exists.
10. **Attempt-cap law boundary** (carried, B1.07).
11. **Elaborator shapes (new).** Parenthesize `names.map String.toList`
    in constructor applications; `chain` is `KeygenNttButterflyPrograms.chain`;
    `B20.C.Ty.i32` cannot be written `.i32` while `C99IntegerReference.Ty`
    is open; `((n:Nat):Int)` and Int literals are different terms for
    `rw`; `he : out = r` needs `subst r`, not `rw [he] at exit`, when
    the hypothesis mentions `r`; a final `rw` can leave a residual `rfl`
    goal behind a def (`ready`); `cases` binder lists follow FULL
    constructor arity when the major premise has variable indices — use
    var-major inversion lemmas to keep arities predictable.

## 5. Carried facts (earlier checkpoints, still true)

- `KeygenResidueVectors.source_vectors` consumes the Geometry.Vec
  representation of the four input arrays and execution of the parsed
  source conversion loop 7367–7372: canonical output residues over the
  same integer coefficients. Source declarations, signed16 promotion,
  modp_set calls, uint32 stores, all 1536 iterations and value-preserving
  frames connected. Input/output non-aliasing and source entry layout
  remain explicit local premises for the enclosing caller to derive.
- Retained checks: `keygen_modular_memory_closure_009` (15/15),
  `keygen_residue_store_010`..`keygen_residue_vectors_016` (7 modules),
  `keygen_residue_audit_017` (20 type/term/axiom audits; RECEIPTS SHA256
  `98a4a770a4c28c515ae8e1b4716d73d1e5bf58cf9163c0b8da83db467a617101`),
  `keygen_modular_suffix_checks_002` (Sage ZZ diagnostics; result SHA256
  `ed336129760e5178d482150f8f4d34556663b7ac637fa053811867a2ba00327b`).
  The previous `_001` JSON-serialization failure remains retained. The
  Sage probes are finite diagnostics, not replacements for kernel
  results.
- B1.01 closed earlier (commits `d5cae83e`, `e53bf9ee`, `aa40bc94`):
  `KeygenNttWordAlgebra` (radix 2^31 explicit, ordinary vs
  Montgomery-scaled words distinguished), `KeygenFirstPrime`
  (`first_entry` pin on the real PRIMES3 record), the
  pointer-dereference grammar step, the pinned butterfly bodies
  (`first_source`/`binary_source`/`triple_source`/`wrapper_source`) and
  `KeygenNttButterflyAlgebra` (`first_values`/`binary_values`/
  `triple_values` over explicit call-observation structures). PASS jobs:
  `keygen_ntt_frontend_002`, `keygen_ntt_butterfly_algebra_004` (pins in
  section 1.2). Retained failed: `keygen_ntt_word_algebra_001`,
  `keygen_ntt_butterfly_algebra_003`.

## 6. Resume protocol (next window)

1. Read `WORK_STATE.md` (live), this file, the EXECUTION_PLAN and
   `run2/notes/B1_STAGED_ROADMAP.md`. The next window FINISHES B1.02
   (section 2.1/2.2) — one stage per window; do not start B1.03.
2. Verify current pins against SOURCE_INPUTS.json of
   `keygen_ntt_frontend_004`, `keygen_ntt_forward_programs_003` and
   `keygen_ntt_forward_exec_005` before any new claim.
3. One proof job at a time (`tools/job_when_available.py`), unique
   labels, guarded serial compiles, logs 0/0, limits unchanged. Rebuild
   the FULL cached descendant closure of any changed module in one job
   (topological order) — the runner asserts stale caches otherwise.
4. Small logical local commits on `main` with exact pathspecs after each
   verified step; NO push until an explicit owner signal. One Git writer
   at a time.

`emitted_to_actual_fiber` is still uninhabited. Nothing in this package
is REVIEWED; REVIEWED is never self-declared.
