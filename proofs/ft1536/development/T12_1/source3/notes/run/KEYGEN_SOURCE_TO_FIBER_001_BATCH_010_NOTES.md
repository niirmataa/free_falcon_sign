# Internal batch010 — first/triple pass loop counters and pointer positions from execution

Status: **IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN**. This window
executed EXCLUSIVELY sections 2.1/2.2 of the B1.02 remainder
(`KEYGEN_RESIDUE_CHECKPOINT.md` section 6 resume protocol) and closed at a
recoverable mid-point per `run2/notes/B1_STAGED_ROADMAP.md` iron rule 3.
Session harness: **MiMo V2.6 Pro**, B1 continuation window.

Resume protocol compliance: pins of `keygen_ntt_frontend_004`,
`keygen_ntt_forward_programs_003` and `keygen_ntt_forward_exec_005`
re-verified against SOURCE_INPUTS.json BEFORE any new claim (the single
frontend_004 drift is the documented parser supersession; its full
descendant closure was re-proved in `_forward_programs_003`). One proof
job at a time through `tools/job_when_available.py`, unique labels,
guarded serial compiles, logs 0/0, limits unchanged. Small local commits
with exact pathspecs after each verified step; NO push.

Passing evidence (all logs 0/0, limits unchanged, no push):

- `keygen_ntt_loop_support_006` — 1/1 accepted. RECEIPTS.json
  `d67240e2c195d475cbdef065e7b7579e1369b5b59bc00294d44a47c0a5335b02`.
- `keygen_ntt_first_loop_005` — 1/1 accepted. RECEIPTS.json
  `ee6b5593b62ba444cf7a9e7193c69953bc0856481e407e0be4169360b91c0496`.
- `keygen_ntt_triple_loop_006` — 1/1 accepted. RECEIPTS.json
  `67b9b545fd86e4b141dbdb318c3ff0c2dc9e21df50fd42ad291cdf6d1e70e000`.

## What is derived (2.1, two of three loop families)

1. **Shared support (`KeygenNttLoopSupport`, commit `e81051c4`).**
   Statement inversions (bindPtr/store32/scope/assign/update) in
   var-major shapes; uint64 counter/offset arithmetic FORCED by executed
   evaluations (`plus_u64`, `add_one_literal`, `add_three_literal`,
   `times_u64`, `shr_one_u64`, `shl_one_u64`, `convert_u64_self`); the
   generic pointer-position equation `pointer_root` (the executed bind is
   the root plus the evaluated index offset); and the local-write frame
   fold `atom_frame`/`chain_frame`/`block_frame` (a `block` scope over
   local-only atoms preserves flow, the pointer map and ALL locals).
2. **First pass (`KeygenNttFirstLoop`, commit `6343029e`).**
   `FirstInv`/`FirstTrace` + `first_result`: from an Exec derivation of
   the parsed `firstLoop`, after k iterations `u ↦ k`,
   `r1 = a + k*stride`, `r2 = a + (hn+k)*stride` with `k ≤ 768`, where
   hn=768 comes from the prologue `ready` state and the guard values come
   from the actual `u`/`hn` slots. Positions come from the executed
   `bindPtr` chain; the single non-overflow premise is `768*σ < 2^64` for
   the executed `hn*stride` index product.
3. **Triple pass (`KeygenNttTripleLoop`, commit `05ef631f`).**
   `TripleInv`/`TripleTrace` + `triple_result`: after k iterations
   `u ↦ 3k`, `r ↦ 2^9+k` (the executed `(size_t)1 << (logn-1)` = 2^9 at
   logn=10), `r1 = a + k*(3*stride)` with `k ≤ 512`. The guard `u < n` is
   exactly `C99CountedWords.condition` with n=1536. Non-overflow premise:
   `3*σ < 2^64` for the executed `3*stride` index product.

## What remains open in B1.02 (exact obligations, plan order)

1. **2.1.1 second bullet — intermediate passes.** Counters m,t,u1,v1,v
   (m/t doubling with `t = ht = t >> 1` per outer round) and positions
   `r1 = a + v1*stride + v*stride`, `r2 = r1 + ht*stride + v*stride` from
   the executed `bindPtr` chain (r2 re-derived from r1 each u1 round via
   `htBind`). The nested u1Loop/vLoop structure composes from the same
   support lemmas; the per-round bind products `v1*stride`/`ht*stride`
   need their own non-overflow premises (derive v1 ≤ 2^18-style bounds
   from m ≤ 2^8 and t ≤ 768 in-window, since `t*m=n` is B1.04 scope).
2. **2.1.2 — butterfly call-observation extraction.** Extract
   `FirstCalls`/`BinaryCalls`/`TripleCalls` from the parsed memory/
   control bodies `firstBody`/`binaryBody`/`tripleBody` (same shape as
   `KeygenCheckOutcome.accepted`). Until then the call premises stay
   interface, not conclusion.

## Boundaries kept (2.2 and the premise boundary)

- **2.2 stride=1:** bound to the pinned wrapper argument
  (`wrapper_source`); instantiating it through the actual call frame is
  B1.07 work and is NOT claimed here. All new theorems quantify over a
  symbolic stride magnitude σ.
- No value/range/polynomial invariant is claimed (B1.04 scope).
- All facts derive from Exec derivations with the fixed Call table (the
  actual pinned scalar bodies); no NTT oracle and no success constructor
  carries evaluations.

## Traps met this window (carried + new)

Carried traps all re-confirmed (region off-by-three, `size_t` not a
typeToken, MKN macro, elaborator shapes, shared main with exact
pathspecs and no push). New this window:

1. **A binder named `end` is a syntax error** (Lean keyword): it broke
   the `FirstTrace` inductive and cascaded into `autoImplicit` mysteries.
2. **`cases ... with` binder lists lose fields that unify with existing
   context variables** (they display as the existing name); reference the
   state/result variables directly or use var-major inversion lemmas.
3. **`simpa [...] using h` fails when only one side normalizes** (the
   defeq match is lost after simplification); prefer `show`-then-`exact`
   or `rw`-then-`exact` for transports through record updates and `u64`.
4. **`simp [key]` silently no-ops when simp pre-normalizes both sides of
   `key`** (e.g. Nat distributivity): use `rw [key]` instead.
5. **`induction` on an Exec derivation needs a variable statement index**
   with an explicit `shape` equation (as in `KeygenCheckLoopBridge.complete`);
   a concrete `.loop ...` index rejects `induction` (use the shape pattern).
6. **`List.Mem` is not `Or`**: bridge with `List.mem_cons`/
   `List.mem_append` and `contains_iff`, not bare `Or.inl/inr`.
7. **unusedSimpArgs/unusedTactic/unusedVariables are errors** under
   warningAsError: drop no-op `change`s, prefer `split_ifs` over
   `simp [set, hn]` when the hypothesis form does not match syntactically.

Nothing in this package is REVIEWED; REVIEWED is never self-declared.
`emitted_to_actual_fiber` remains uninhabited.
