# Internal batch008 — parsed solver-check suffix

Status: **IN_PROGRESS / NOT_REVIEWED**.
Fresh replay:14/14 clean,20 type/term/axiom audits,29.379s,
maxRSS2731312KiB. Receipt SHA256:
`64198d2e86af3f48c650cde4868f4db3bad73ae3494233f03a8f70fdd9cf455a`.

## What is derived

`KeygenCheckOutcome.accepted` starts with execution of the parsed complete
suffix7386--7396 and its observed return1. From actual uint32 loads and the
closed source bodies of modp_montymul/sub it derives all1536 pointwise
residue equalities. Declarations, local z restoration, counter0/increments,
comparison, early return0 and the final return1 are part of the execution.
The former KeygenFinalCheck.Loop premise is now a derived conclusion.
The entire suffix preserves heap bytes and pointer bindings, so the same
equalities describe the words observable after it returns.

Inputs still explicit at this suffix boundary: n1536 and the actual
ft/gt/Ft/Gt/p/p0i/r bindings, canonical transform words, and executions of
the earlier p0i/r initializers. The full solver must derive these inputs.
They are not approved extra premises for emitted_to_actual_fiber.

The expression has an existence theorem for legal initialized operand
reads, executing the pinned primitive bodies. Three kernel mutations
reject swapping F/G, omitting the last check and returning1 inside the loop.
These are local source-binding mutations, not whole-KeyGen mutation coverage.

`KeygenModpSet.source_contract` additionally derives canonical range and
integer congruence for the actual signed32-to-modular conversion under
-p<x<p and p<2^31. Its frontend explicitly normalizes the M0 int32_t typedef
token to int, since the inherited parser recognizes only the latter.
The diagnostic probe records that the unextended grammar returns none;
all earlier failed sources/logs are retained. No warning was suppressed.

## Next enclosing links

Source coefficient conversion and NTT stores/ranges/evaluations must connect
the pointwise equations to the same integer material before transformation.
The complete KeyGen caller, source attempt trace/gates, serializers/decoders,
public/inverse equations and final fiber composition remain in progress.
The batch does not assert those equations or a complete B1 result.
