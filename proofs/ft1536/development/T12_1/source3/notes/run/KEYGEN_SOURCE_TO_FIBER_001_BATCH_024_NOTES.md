# BATCH_024 — search dependencies and sampled-resultant transport

**B1.05 / PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
**CLOSED_AT_RECOVERABLE_MIDPOINT. B1.05 Acceptance NOT MET.**
Owner-requested BIG continuation of checkpoint section6,2026-10-08.
Harness: GPT-6 Astra Ultrafast (`openai/gpt-6-astra-ultrafast`). Historical
runner model/session labels remain provenance.

JSON SHA256:
`fbfe3b1c6c297b20b31d92370963c89aa1a0fe3cedfbfb5b0b799f1b3a72d365`.
Proof HEAD: `3663e509`; preceding source commits `4f787baf`, `60eb842b`,
`dfff8cd4`. Main as niirmataa, exact owned paths under archive.lock.
The pair/live checkpoint receives a separate documentation commit.

## Checked additions

1. **All-depth modular byte frame and complete inverse NTT.**
   `KeygenLevelNtt` binds3143–3245, including the mixed declaration,
   logn0 return, full/non-full paths, corrective division and every loop/store.
   Five parsed statement-boundary pieces share actual state. Fixed
   forward/inverse/generator calls execute full pinned bodies and restore
   caller slots. Frames do not assume canonical residues, evaluations or
   a prime/numerical result. The stride-one inverse macro is separately bound.
2. **Complete make_fg_ternary_top.**
   `KeygenMakeFgTop` binds5579–5668. It executes actual prime-struct loads,
   memmove, generator, forward/inverse calls and stores. Both out_ntt paths
   remain. The frame transports any material separated from data/static
   objects. Prime fields use actual32-bit reads at offsets0/4/8 of12-byte
   elements; the enclosing static table environment remains a caller seam.
3. **Seven complete bigint leaves.**
   `KeygenZintLeaves` covers zint_add, zint_sub, zint_mul_small,
   zint_add_mul_small, zint_rshift1, zint_mod_small_unsigned and zint_ucmp.
   Headers/bodies/closing braces are checked. Memory reads inside arithmetic
   retain casts, promotions, signedness, actual stores and returns.
   Post-decrement includes the final failed-test update. Frames follow
   source writes; no bigint arithmetic correctness is assumed or concluded.
4. **Complete resultant helper and actual caller gates.**
   `KeygenResultantSource` covers541–772: fresh b[96], literal memset,
   packing, all switch cases11 through2, fallthrough, break and actual return.
   After local-object disposal all caller bytes are preserved.
   `KeygenResultantGate` binds M0-selected7931–7948, with both continue
   outcomes and accepted fallthrough, then composes with MODE1 two_calls.
5. **Active raw-norm computation and gate.**
   `KeygenNormFrame` binds M0-selected7969–7990. It executes small-to-fpr,
   FFT3, word-level FPEMU norm accumulation and the actual object-copy
   comparator via `C99CompareObjects.Exec`. The derived frame preserves
   separated f/g on rejection or acceptance. Incoming bound/local/profile
   and scratch/static bindings remain explicit; bound initialization and
   the link from preceding gates are still open.

## Exact new sampled-material boundary

`KeygenResultantGate.sampled_material` consumes:

```text
ctx : ShakeExtractSource.Layout
before, middle, sampled : State
out : Result
f, g : ArrayPointer
ctx.block != f.block; ctx.block != g.block; f.block != g.block
positive live f/g object sizes; f/g elementBytes = 2
before.n = uint64 1536; before.f = f; before.g = g
KeygenSamplerCalls.Call ctx before (arguments "f") middle
KeygenSamplerCalls.Call ctx middle (arguments "g") sampled
KeygenResultantGate.Exec sampled out
```

It concludes:

```text
exists fv gv : Geometry.Vec,
  Represents out.state.heap f fv and Bound fv 1
  and Represents out.state.heap g gv and Bound gv 1
```

The bounds and final-byte identity are conclusions. There is no incoming
f/g bound, resultant-value, gate-success or assumed frame premise. Rejection
is included. The typed RNG layout/actual fk binding remain the inherited
caller seam. This result does not pass through the later norm/GS/public/
solver code automatically.

## Evidence and preserved routes

- Preflight verified BATCH_015–023,2595 distinct pinned files,445 final
  BATCH_023 inputs and2317 predecessor pins. No live proof job.
  `.build/levels_024/PREFLIGHT.json`:
  `baa5c4d6a850a2f4ae13977212614c2628678884753468544b46a3859aa994e8`.
- Fourteen current accepted Lean modules,0/0 logs; max accepted cumulative
  RSS5102368KiB. All459 final-audit inputs and2595 predecessor pins match.
- Final audit236 entries: all216 new named def/theorem/inductive/structure
  declarations plus20 inherited interfaces;206 complete terms and30
  inductives/structures with constructor types. Only propext,
  Classical.choice and Quot.sound; no elisions. Audit458751 bytes,
  reproduced by the tracked generator/audit source.
- `keygen_levels_audit_024_001/RECEIPTS.json` SHA256
  `33835fd69282bcce3256fa0e58e4614a52e2679cb9935698561f11d1737fb229`;
  SOURCE_INPUTS `9e36c96005d1d49dc7ae1508c7962650b83866f57b539236cd289c16d8913efd`;
  LEVELS_AUDIT `c58f8974f6aff9583775aedd804428ab7d4f20f64bbba5ed056af6185e20d5c5`.
- Fourteen attempts:9 wholly accepted,3 failed retained,2 accepted by the
  runner but superseded for scope. Individual accepted steps of a job with
  a later failing module are bound separately in the JSON.
- Failed routes: nested-list DecidableEq derivation; byte-equality composition
  across memset; C control harness misleading-indentation warning. Fixed
  arity, explicit equality transport and braces resolved them, respectively.
- **Scope correction1:** initial NormFrame covered binary poly_small_sqnorm,
  not the active M0 path. Its accepted snapshot is retained but superseded.
- **Scope correction2:** the first parsed M0 norm gate used a generic scalar
  table lacking fpr_lt. Runner acceptance did not establish complete call
  closure. Current `_active_norm_024_002` separates the actual comparator
  execution, with inherited source decomposition and exists_execution audited.
  No false full-closure result from the earlier route is consumed.

## Exact finite controls

`sage/check_keygen_levels.sage`, standard Sage preparser, ZZ/GF(2).
Job `keygen_levels_checks_024_002`:14 normal/UBSan runs, each covering:

- 35 bigint operation/length cases;
- 38 forward/inverse dimension/stride cases, including untouched gaps;
- 5 public resultant pairs against independent GF(2) polynomial gcd;
- 10 ternary-top norm pairs against exact ZZ
  `a^3 + X*b^3 + X^2*c^3 - 3*X*a*b*c mod (X^512-X^256+1)`;
- 15 raw-norm gate/frame cases, checked against the actual integer-word
  comparator expression, with f/g retained;
- small_prime physical layout12/0/4/8.

All six mutations detected in both modes: inverse scale, top g alias,
multiply carry, subtract mask, resultant f write and raw-norm g write.
The C input is the pinned full source; only public synthetic arrays are
executed. Full key generation/private material is not run. The controls do
not execute complete deepest/intermediate/root or prove a compiler theorem,
termination, probability law or real-arithmetic norm bound.

RECEIPTS SHA256 `dcc25eb7f7c710d636da9c2ee2dbc151873be854ea0eb37ff610082d6a26c453`;
LEVELS_CHECK `8060e5b70c1588e23d916451d118f09629dd1ec79fcf7de39739e67fbaf1b7e2`;
PUBLIC_FIXTURE `ac6b9c5ef5bf67ecb44827f4e6bd3e0c6a5f9176ab517109703208d22d811172`.
All paths above are under `.build/jobs/` where a job name is given.

## Next owner window

Resume B1.05 checkpoint section6: complete make_fg_step/CRT/Bezout and
remaining intermediate dependencies, instantiate deepest/intermediate and
the full solve_NTRU caller, then finish sampled f/g transport through bound
initialization, GS/public/search into the existing depth0/gate/validation
suffix. Static/member/alias/profile/common-heap bindings must be derived.
Do not replace missing execution by an arbitrary callee/frame, or promote
these local frames into the full successful-solver theorem.

No active job or unfinished Lean draft remains. Limits unchanged. No new
broad-project replay, independent review, push, stages import or migration.
