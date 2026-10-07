# BATCH_022 — B1.05 sampler/refill and output-validation midpoint

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
Owner-requested BIG recoverable midpoint,2026-10-07. **B1.05 Acceptance NOT
MET; B1.06 not entered.** The full search/solver/root-caller execution is
still absent. No owned job or unresolved Lean draft remains.

Harness: GPT-6 Astra Ultrafast, `openai/gpt-6-astra-ultrafast`. Historical
runner model/session labels are provenance. Three local source commits on
main as niirmataa: `7a1d5bc2`, `e617e098`, `9f0e5ef8`; a final documentation
commit seals this pair/checkpoint. Shared writer lock: `archive.lock`.

## Exact new contracts

### Full local sampler bound

`KeygenSamplerBounds.source_material` takes:

```text
ctx : ShakeExtractSource.Layout
before, after : C99ArrayReference.State
dst : C99MemoryReference.ArrayPointer
ctx.block != dst.block
0 < before.heap.size dst.block
dst.elementBytes = 2
C99CountedWords.Limit before              -- actual n slot is uint64 1536
before.arrays "v" = some dst
KeygenSamplerSource.Exec ctx before after
```

It concludes:

```text
exists v : Geometry.Vec,
  KeygenMaterial.Represents after.heap dst v
  and KeygenIntegerLift.Bound v 1
```

The fixed MODE1 execution covers the selected complete body: declarations,
rb/rbits initialization, u initialization, both loops, guard/increment,
rejected draws, refill, bounded store, break and x-scope restoration.
Its write trace explicitly permits RNG-context changes between stores and
proves retention of every earlier coefficient. It does not assume a word
oracle, a coefficient bound, a distribution or termination.

`KeygenSamplerCalls.two_calls` consumes the two actual v/n argument Bind
derivations, both full sampler executions and legal distinct f/g/context
objects. It yields the same-final-heap f/g vectors, each with Bound1, and
preserves f across sampling g. **The enclosing caller still must resolve
the actual fk pointer to this typed rng Layout and derive n1536.**

### Real deterministic refill

- `ShakeBlock`/`ShakeBlockProgram`: complete `process_block`, all388 physical
  loop-body lines in49 checked chunks; actual C word operations and Load64/
  Store64, no Keccak oracle. Pointer provenance yields the outside-A frame.
- `ShakeEncode`: the actual eight unsigned-char stores and caller restoration.
- `ShakeExtractSource`/`ShakeExtractBinding`: complete extraction loop,
  actual dptr/rate reads, process call,25 encodes with the six lane
  complements, memcpy, pointer/length/cursor updates and final dptr store.
- `ShakeRcBinding`: all24 source RC words,12 source/token/initializer pairs.
  The fixed read-only program table is required by the Process execution
  constructor and has complete kernel source binding.
- `KeygenRngSource`: M0 LE path with an explicit fresh local8-byte object,
  actual extract8, Load64 of those same bytes, teardown and caller frame.

The LP64 typed shake_context view is explicit: dbuf0, dptr200, rate208,
A216, total416 bytes. Actual enclosing fk/member/global-table/profile
binding remains part of the full source caller. The compiler layout and
active FALCON_LE_U controls below support this view; they do not prove a
compiler or the missing caller derivation.

### F/G gate and BATCH_020

`KeygenOutputGateSource` parses7342–7346 with actual short-circuit control,
member expressions, F then G, tmp then tmp+n and actual failure return.
Both calls execute the full BATCH_021 small-output body. `binding_entry`
derives parameter profiles, destinations and source indices0/1536.
`gate_material` derives retained F/G and Bound2047, preserving disjoint f/g.
The typed read-only Context and caller logn/n/F/G bindings remain local
entry inputs, not a proved full-solver context.

`KeygenOutputGateValidation.gate_validated` feeds this gate into BATCH_020:

```text
exists F G,
  Bounds ![f,g,F,G]
  and multiply f G - multiply g F = constantCoeffs 18433
  and all four vectors are represented by the same final retained arrays
```

Its inputs still include incoming f/g Represents/Bound1, typed caller
fields, legal source-validation entry, fixed generation/conversion/four-NTT/
comparison executions and common-heap equalities. F/G bounds are conclusions.
The `Validation` record exposes the inherited premises, all audited in full.
There is no arbitrary search transition/frame in place of the missing code.
**The sampler and suffix are ready to connect through the actual search;
that intervening execution/preservation proof remains open.**

## Evidence and pins

Preflight verified BATCH_015–021,1840 distinct file pins,415 final BATCH_021
inputs and1594 predecessor pins. No live proof job. `.build/execution_022/`
`PREFLIGHT.json`: `5947df262145b87a5cbb2c8ccbf79b6a7b2938965c13bb255dd40771be0fa3fc`.
All1840 predecessor files and433 current final-audit inputs match at sealing.

- BATCH_022 JSON: `e891df0f07b936c594130ec258afc31e2d18a0af1d30b63833d2b1b1481a52a8`.
- Complete sampler-bound source: `51957a9fded82953d70f92093e851451369d2b7fac190792000fff7efa78647a`.
- Two-call source: `0659c5b6ac5aeba16d68c5de5186ebae1abc63cea98f4bad0637216702102b10`.
- Gate/validation source: `2f400bd7bfcc3e304765accac5f5c0e8c23fd176607046a0922945525114cc85`.
- `keygen_execution_audit_022_001/RECEIPTS.json`: `b6ead6d515b08eb6100397c5a1487f1cb632b2363781132842d38ebb384c32d1`.
- Same job `SOURCE_INPUTS.json`: `9184313d3af8650bed8415ba2fe9b6297fb8958f4dd83bf4410327ea92dc6910`.
- Same job `EXECUTION_AUDIT.json`: `6a28556d3881f75e3a2f5ba6d9642f1a2aed4e95bf13d64cfb0256da3d7ef878`.
- `keygen_sampler_checks_022_002/RECEIPTS.json`: `c96de5a9cfd4dfa88b209d0c419e29b515c0b48ce72f21fab03f2364c11e34c4`.
- Same job `SAMPLER_REFILL_CHECK.json`: `b447349319d14d9ddabfe3dd45c8e1b15180e8ab97ec96b04448a495252a707b`.

Jobs live under `.build/jobs/`. The batch pins every accepted source,
snapshot, artifact, receipt, raw stream and generator/control product.
18 current modules have accepted0/0 logs; max accepted RSS3850748KiB.
Audit423 entries covers all409 new named declarations plus14 inherited
interfaces:393 full flat terms and30 inductives/structures with complete
constructor types. Standard axioms only, no elisions. The3074907-byte audit
is regenerated by the tracked source and audit-source generator.

Sage standard-preparser ZZ controls:14 normal/UBSan runs ×8 independent
FIPS202 Keccak cases and24 two-call sampler cases. The independent reference
generates round constants with the LFSR and theta/rho/pi/chi/iota directly.
It checks a known zero-state anchor. The C fixture uses the actual pinned
full falcon_keygen struct and SHAKE source, public labelled SHAKE256 inputs,
exact coefficients/draws/rejections/cursor and protected arrays/context
fields. All six mutations are detected in both modes: RNG byte order,
refill bit count, omitted last store, lane complement, round constant and
accepting draw3. These finite controls supplement the source proofs.

## Retained attempts and limits

45 attempts:21 wholly accepted,23 failed, one stale-cache preflight refusal
before a receipt/SOURCE_INPUTS. Some current module records occur in a job
whose later module failed; their individual accepted record, snapshot and
olean are checked explicitly. All failed drafts/raw runner streams remain.
The preflight refusal has its preflight/runner copies and an explicitly
labelled transcription in `.build/execution_022/PREFLIGHT_REFUSAL.md`, not
invented raw logs.

The400-line monolithic parse exceeded recursion/memory budgets. Linewise
parsing,49 small source chunks and the checked source partition resolved it.
Aggregate RC normalization and rewrite elaboration also exhausted memory;
small source/token/initializer equalities composed with congrArg resolved
that route. Additional failures include reserved identifiers, dependent
constructor binder counts, explicit-state inference, scope simplification,
the unsupported diagnostic appendFile and Sage's `~ZZ` inversion operator.
The corrected exact complement is mask xor.

No proof limit, warning policy or guard was relaxed. Accepted limits:
Lean-j1/-M6144, recursion32768, heartbeats2000000, wall1800s, AS12GiB/RSS8GiB;
pp.maxSteps200000 is only for audit printing. Standard-preparser Sage and
all runtime/cache/HOME/TMPDIR data stay in the durable component `.build`.
Affected descendants were rebuilt; no unchanged whole-project replay.

## Resume

Read `KEYGEN_RESIDUE_CHECKPOINT.md` §6. Resume B1.05 only: full active
solver/search and root caller, concrete member/alias/global-table/profile
bindings, and f/g preservation through the actual intervening source.
Then instantiate the proved gate/validation suffix on that same execution.
No push, review, import, migration or second worker was started.
