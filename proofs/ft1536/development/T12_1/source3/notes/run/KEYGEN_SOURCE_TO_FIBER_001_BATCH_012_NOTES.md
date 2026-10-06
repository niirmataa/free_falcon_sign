# BATCH_012 — 2.1.1-second part 2 (u1/m/t counters and bounds)

Window scope (owner): EXCLUSIVELY 2.1.1-bullet2 part 2 — the u1/m/t
counter composition and the derived bounds. Closed with the staged-
roadmap iron rule 3 clean-close: the stage Acceptance is met, so this
window closes as complete and the checkpoint below hands the next
window B1.03. `t*m=n` was not used (B1.04 boundary).

## What is proved (kernel, no sorries, no oracle)

1. **u1-loop counters.** `KeygenNttMiddleRounds.U1Inv`/`U1Trace` and
   `u1_result`: executing the parsed `u1Loop` yields a u1-loop trace
   whose nodes carry `u1 ↦ j`, `v1 ↦ j*t`, `j ≤ m` from the executed
   `u1Step` (`u1 ++, v1 += t`), and each iteration carries its nested
   v-loop run (`U1Run`, extracted through `KeygenNttMiddleLoops.
   u1_inner_result`) at `v1 = j*t`.
2. **Outer doubling rounds.** `MInv`/`MTrace`/`RoundRun` and
   `round_result`/`m_loop_trace`: `m ↦ 2^(i+1)`, `t ↦ 768/2^i` per
   round i, with the executed `t = ht = t >> 1` halving carried as
   `t ↦ 768/2^(i+1)` across the block, guards `u1 < m` and
   `mGuard : t > 1+(full<<1)` (evaluated to `3 < t` on the M0 path
   through `KeygenNttForwardExec.plus_three_value`).
3. **Bounds from the round count (never t*m=n).** `3 < 768/2^i` forces
   `4*2^i ≤ 768`, hence `i ≤ 7` (`round_index_bound`) and `m = 2^(i+1)
   ≤ 2^8` (`m_round_bound`), `t = 768/2^i ≤ 768` (`t_round_bound`);
   `v1 = j*t ≤ 2^8*768 ≤ 2^18` (`v1_class`/`v1_round_bound`) and
   `ht = t/2 ≤ 2^18` (`ht_round_bound`). A single pass-level premise
   `2^18*σ < 2^64` then discharges both executed-product fits
   (`fit18`/`lt64_18`).
4. **Composition.** `intermediate_result` executes the whole parsed
   `intermediatePass` (`t = hn`, `m = 2`, the `mGuard` loop of
   `block mInner` rounds) and concludes the `MTrace` carrying the
   nested u1 traces and their per-iteration v-runs. Together with the
   previous first/triple results this closes 2.1.1 and therefore the
   B1.02 remainder: the stage Acceptance is met.

## Evidence

- Job `keygen_ntt_middle_rounds_002` accepted, logs 0/0, 3.071s, one
  module over the 353-entry reused closure. RECEIPTS SHA256
  `3dbc0cfa444608dc8c77d5d9c6ce95a25c0f94ce9587c02cf18e8bee41d0a274`;
  SOURCE_INPUTS SHA256
  `17b98f3715de911247daa54d8326b736b68bba9f956d7c9d205d84d7ff4af52e`.
  Committed file SHA256 `KeygenNttMiddleRounds.lean`
  `dd66ac1a7c3691a63718c97bc7209fea3f0de0bc3fa570bfafbd726583b403a8`.
- Retained FAILED attempt: `keygen_ntt_middle_rounds_001` (never cited
  as PASS). Input pins re-verified before new work: all 18 named
  BATCH_011 pins MATCH and the five full closures MATCH byte-exact
  (352/352, 353/353, 349/349, 350/350, 351/351; 0 drift).
- Commits: the proof module and this receipt/checkpoint pair, local on
  `main`, no push (owner signal absent).

## Traps met (new, recorded in the checkpoint)

`≤i` is a single token (`InitialSeg` notation) — `8≤i` breaks the
parser, space the operator from such identifiers; `subst` cannot
eliminate projections like `out.state = ...` (destruct `out = ⟨...⟩`
instead); in `resolve_right` eliminations the name surviving `subst r`
is the `seq_inv` OUT argument (`result`/`inner`/`out`), not `r`;
`omega` sees only context hypotheses, so structure fields must be
hoisted (`have hjle := inv.bound`) before `by omega` goals; `rw` cannot
match patterns under the `USlot`/`PSlot` abbreviations — expose the
projection with `show` (defeq) instead; `.base (.scalar (.update ...))`
steps exit-eliminate via `normal_base`, not `normal_assign`.
