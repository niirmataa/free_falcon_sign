# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_026 (B1.05, member access + reduce family)

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
2026-10-08: BIG B1.05 window (harness: MiMo V2.6 Pro) closed at a
recoverable midpoint under `run2/notes/B1_STAGED_ROADMAP.md`.
**B1.05 Acceptance NOT MET.** B1.06 not entered.

Owner order this window: (1) member-access tokenization closing the
zint_rebuild_CRT parse; (2) co-reduce/reduce with `*(int32_t*)&tt` bitcasts
and the `#define M` macro; (3) make_fg_step with binary bodies. Steps (1)
and (2) minus Bezout are closed; (3) and Bezout remain.

Closed:

- **(1) zint_rebuild_CRT parse closure** (commit `1eb416f0`): the member
  access tokenization rule (dot token) lives in `KeygenZintCall.tokens`, so
  the checked primeRead/storePrime productions reach `primes[0].p` and
  `primes[u].p/s` without moving any shared pinned parse or cache closure.
  The COMPLETE body region 3581-3633 parses: `rebuild_crt_pending` is gone;
  `rebuild_crt_shape (4,0,3,0)` and `rebuild_crt_audit` are kernel-checked
  and `Call .rebuildCrt` executes the parsed body (modp calls stay
  word-embedded with pinned ModCall bodies).
- **(2) co-reduce/reduce family** (commit `61d3e3f8`): the same-width
  `*(T*)&local` type-pun statement (cast target `T*`) with an explicit
  `Value.reinterpret` rule (uint32<->int32, uint64<->int64 only), and
  C-textual `#define`/`#undef` macro scope as token substitution in the
  family lexer. Complete bodies: zint_co_reduce 3670-3724 (bitcasts 2),
  zint_co_reduce_mod 3735-3801 (macro M, bitcasts 2, shape (4,2,0,0)),
  zint_reduce 3811-3844 (bitcast 1), zint_reduce_mod 3855-3888 (bitcast 1,
  shape (2,1,0,0)). `code_checked` covers all ten Callee members. These are
  operational/frame results: NO Bezout, reduction or Montgomery claim.

Entry pins: `tools/keygen_zint_entry_pins.py` verified BATCH_015-025
(11 external pair pins + full ENTRY_PINS_025 closure of 2847 files +
BATCH_025 modules/17 receipts/2 receipt-less dirs) = 2889 distinct pins,
receipt `.build/levels_026/ENTRY_PINS_026.json` sha
`e628ced648ea005663e65961f63a156ad473daa43aa40481836985251d9547de`.

Attempts: 10 jobs retained (7 with RECEIPTS pinned in the JSON, 3 stale-cache
refusals kept without invented streams). Final closure job
`keygen_zint_reduce_026_010`: KeygenZintCall 2.67s, KeygenZintProbe 1.82s
(DIAGNOSTIC nonempty stdout), KeygenZintCore 128.6s, all accepted, logs 0/0,
limits unchanged.

Open (execution-plan order): zint_bezout (3908-4200; ternary `?:`,
memcpy/memset `sizeof *element` lowering, `for (;;)`, its four bitcasts reuse
the committed rule), bitlength/zint_get_top/poly_max_bitlength/poly_big_to_fp
and scaled subtraction, make_fg_step 5379-5569 with the binary mkgm2/NTT2
family (2778-2908 including the stride-one macros), complete make_fg,
deepest/intermediate/root closure and full material transport.

New traps 111-115 in the JSON. Named sub-stages B1.05a/b/c proposed in the
roadmap. No push, review, stages import, migration, worker or relay.
