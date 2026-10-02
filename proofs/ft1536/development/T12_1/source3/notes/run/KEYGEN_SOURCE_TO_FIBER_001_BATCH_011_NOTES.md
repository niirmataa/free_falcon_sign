# BATCH_011 — 2.1.2 closed; 2.1.1-second part 1 (v/u1Inner positions)

Window scope (owner): EXCLUSIVELY B1.02 remainder 2.1.2 and 2.1.1-second,
with staged-roadmap iron rule 3 (close at Acceptance or a recoverable
mid-point with a fresh checkpoint). This window froze at the latter:
2.1.2 is complete, 2.1.1-second delivered its bindPtr-chain positions,
and the u1/m/t counter composition is written down as the exact
remaining obligation. `t*m=n` was not used (B1.04 boundary).

## What is proved (kernel, no sorries, no oracle)

1. **2.1.2 — butterfly call-observation extraction: CLOSED.**
   `KeygenNttButterflyCalls.first_calls / binary_calls / triple_calls`:
   from an execution of the parsed `block firstBody`/`block binaryBody`/
   `block tripleBody` at the pinned r1/r2 (and gm) positions one extracts
   `FirstCalls`/`BinaryCalls`/`TripleCalls` (the KeygenNttButterflyAlgebra
   structures) together with `Load32` witnesses for every input word and
   chained `Store32` witnesses for the outputs (heaps chain exactly:
   `Store32 before.heap p1 low h1`, `Store32 h1 p2 high h2`, triple with
   three stride-spaced stores). The call observations are now
   CONCLUSIONS, not interface premises — the call-premise leakage of
   checkpoint section 2.1 item 2 is removed at these three bodies.
   Words stay symbolic; no value/range claim (B1.04).
2. **2.1.1 second bullet, part 1 — positions from the bindPtr chain.**
   `KeygenNttMiddleLoops.u1_inner_result` plus `v_result`/`loop_trace`/
   `VInv`/`VTrace`: executing `block u1Inner` yields a v-loop trace whose
   every node carries `v ↦ k`, `r1 = a + v1*stride + k*stride`,
   `r2 = a + v1*stride + ht*stride + k*stride` (i.e. `r2 = r1 + ht*stride
   + v*stride` at u1-entry), with r2 re-derived from r1 every u1 round
   via `htBind`. Explicit non-overflow premises `v1*σ < 2^64` and
   `ht*σ < 2^64` cover the executed `size_t` products; nothing claims
   `stride = 1` (B1.07).

## Exact remaining obligations (2.1.1 second bullet, part 2)

- `u1Loop` counters: `u1 ↦ j`, `v1 ↦ j*t` per round with `j ≤ m`, from
  the executed `u1Step` (`u1 ++, v1 += t`).
- Outer `mLoop` counters: `m ↦ 2^(i+1)`, `t ↦ 768/2^i` per round i with
  `t = ht = t >> 1`, guards `u1 < m` and `t > 1+(full<<1)`.
- Derived bounds from `m ≤ 2^8` and `t ≤ 768` (round count from the t
  halving): `v1 ≤ 2^18`-class, discharging the two fit premises above
  from a single `2^18*σ < 2^64` at the pass level. `t*m=n` stays B1.04
  and must NOT be used.
- Compositions `u1_result`, `round_result`, `intermediate_result` (the
  trace carrying the nested v-traces per round), closing 2.1.1-second.

## Evidence

- Jobs (accepted, logs 0/0): `keygen_ntt_butterfly_calls_009` (27.527s,
  maxRSS 2584180 KiB) and `keygen_ntt_middle_loops_006` (5.429s, maxRSS
  2572244 KiB). RECEIPTS/SOURCE_INPUTS SHA256s in the batch JSON.
- Retained FAILED attempts: `keygen_ntt_butterfly_calls_001..008`,
  `keygen_ntt_middle_loops_001..005`. Not cited as PASS.
- Input pins re-verified before new work: all six previous-window jobs
  MATCH (the single documented `C99ModularParser` drift of frontend_004
  unchanged).
- Commits: `aa86ba27` (2.1.2), `d81c257c` (2.1.1 part 1). Local, no push.

## Traps met (new, recorded in the checkpoint)

`∃`-notation binder restriction (no mixed bare/typed binders — nest the
typed binder); `*Calls` structures are Type, not Prop (they carry BitVec
data — lift them into `∃` binders, not `∧` chains); `cases ... with`
binder absorption of fields unifying with context variables (name the
binder after the existing variable or invert through a lemma);
`theorem` cannot declare data (`def` for name lists); `rw` chain
bookkeeping through `⟨state,.normal⟩.state` projections (works by defeq
matching, but wrong-chain order fails loudly); `decide`/`omega` on free
variables need real premises (`Nat.zero_le`, explicit `htp<2^64`).
