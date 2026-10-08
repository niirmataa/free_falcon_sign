# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_027 (B1.05b): complete zint_bezout

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
2026-10-08 window (harness: MiMo V2.6 Pro) closed at a recoverable
midpoint of sub-stage B1.05b. **B1.05 Acceptance NOT MET; B1.06 not
entered.** The complete `zint_bezout` body is now kernel-checked; the
extraction family (bitlength/get_top/poly_big_to_fp), scaled subtraction
and make_fg remain open with analyzed grammar needs (see
`KEYGEN_RESIDUE_CHECKPOINT.md` 7R).

## What was delivered

`KeygenZintCall` (accepted, sha `b2d01551...`) extends the zint word layer
with exactly the grammar zint_bezout (3908-4200) exercises:

- **ternary `?:`** assignments lowered to an explicit branch of two whole
  assignments evaluated from the same pre-assignment state
  (`ternaryAssign`; both arms stay explicit statements);
- **memcpy** through the sealed byte-copy statement and **memset** through
  the new `Memzero` zero-byte rule, both with `sizeof *element` width-4
  limb lowering via the checked `KeygenSearchParser.sizes` normalizer
  (`copyCount`; nonzero memset byte values are rejected, not approximated);
- **`for (;;)`** with constant-one condition, and **`continue`/`break`**
  with faithful loop flow (`loopContinue` runs the increment;
  `loopBreak` exits to normal);
- **statement-position pointer binds** (`pointerStmt`, consuming `;`)
  kept separate from **for-clause binds** (`pointerClause`, ending left
  for `clauses`) — rebuild_CRT's `x = xx`/`x += xstride` loop clauses
  depend on the latter;
- **six-pointer walk declaration** (`uint32_t *u0, *u1, *v0, *v1, *a, *b;`)
  with pointer widths threaded through `env`, `size_t` scalar
  declarations (`zintTypeToken`), and the `v1[0] &= ~(uint32_t)1`
  compound store through the sealed word grammar.

`KeygenZintCore` (accepted, sha `4a5df8f6...`) binds the COMPLETE body:
header/close pins, a line partition of all 291 body lines into eight
statement-boundary pieces (`bezoutParsed`), and **non-vacuous** per-piece
audits (`map ... = some`, so a failed parse cannot pass as `skip`), then
composes them by pure rewriting into `only(bezoutCode)=true`,
`callShape = (28,2,0,0)`, `bitcastCount = 6` and the three
`calleeParsed .bezout` exports feeding the global `code_checked`. The six
`*(int32_t*)&ux*` pun statements reuse the committed bitcast rule. All
ten previously pinned zint bodies were re-verified under the extended
grammar (no parse regressions).

These are operational/frame results only: no Bezout identity, GCD,
parity, range or termination claim. `Call .bezout`/`call_frame`/
`material` are ready for the deepest-caller composition (B1.05c).

## Entry pins

`tools/keygen_zint_entry_pins.py` extended to the BATCH_026 pair and its
7 attempt receipts (3 receipt-less dirs cross-checked against the pair);
`.build/levels_027/ENTRY_PINS_027.json` sha
`86aee101affed8c1e1e6459c1432429dad74aefab396d8cbdd24a730484c463e`,
2900 distinct pinned files, 459 current inputs, no active job. Two
closure pins (KeygenZintCall/KeygenZintCore pre-window-026 bytes) are
superseded **exactly** by the BATCH_026 accepted-module pins and listed
with both hashes in the receipt's `superseded` field; every other
mismatch fails.

## Retained attempts (15: 14 receipted, 1 receipt-less)

7 probe jobs (DIAGNOSTIC, nonempty stdout — localization of the piece
boundaries, statement-path parses and the monolithic-vs-piece split; two
probe compile failures and one stale-cache refusal retained) and 8 proof
jobs: the first three failed on kernel memory / vacuous piece-7 values
from a misaligned piece boundary (traps 116/121), the next three on
elaboration (`rw` closure, implicit `v`, `Eq.trans` direction) and one
on two remaining literal goals; `keygen_zint_bezout_027_007` is accepted
with 0/0 logs (Call 2.8s, Core 270.9s, max RSS 6044296KiB). All failed
snapshots/raw streams remain.

## Honest scope

The body-level binding is the accepted Depth0/ShakeBlock standard: line
partition + per-piece kernel parses + chained scaffold. The monolithic
single-decision parse of all 291 lines exceeds kernel memory (retained
failure `_027_001`); it is probe-confirmed but not kernel-reduced. No
Sage work, no push, no review, no worker/relay, no stages import this
window.
