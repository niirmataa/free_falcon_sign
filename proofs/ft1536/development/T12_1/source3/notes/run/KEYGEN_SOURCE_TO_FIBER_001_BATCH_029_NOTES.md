# BATCH_029 — complete intermediate and static initializer midpoint

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
**CLOSED_AT_RECOVERABLE_MIDPOINT. B1.05 Acceptance NOT MET.**
Owner continuation: checkpoint section 8R; harness GPT-6 Astra Ultrafast.
The long window ends here under the staged-roadmap context discipline.

## Exact new contract

```text
ctx : KeygenSearchContext.Context
before, after : C99ArrayReference.State
v : C99IntegerReference.Value
source : KeygenIntermediateSource.Call ctx before after v
input : C99MemoryReference.ArrayPointer
separated : KeygenIntermediateSource.Protected ctx before input.block
vector : Geometry.Vec
represented : KeygenMaterial.Represents before.heap input vector
-------------------------------------------------------------------
KeygenMaterial.Represents after.heap input vector
```

Protected means scratch and static-table object separation. Call binds the
actual fk/f/g/depth arguments, executes the fixed complete body and converts
the actual return. Caller slots/tables are restored. The theorem covers
either finite defined return. It does not assume a callee transition, heap
frame, successful reduction, NTRU equation or bound on generated F/G.

The caller must still deliver the sampled f/g to this entry. This is not
the complete successful solve_NTRU theorem.

## Closed source obligations

- Complete `poly_sub_scaled_ntt` (4601–4674): both transform families,
  signed32 k reads, dereferenced zint-call destination, CRT, division by 31
  and scaled subtraction; source counts and derived byte frame.
- Complete `align_u32`, cast-before-add and same-array pointer comparison.
- Seven complete binary FFT helpers, with actual signatures and bodies;
  discarded for-update decrement and the exact signed fpr_scaled argument.
- Closed intermediate callee table: actual member/prime reads, conversions
  at their original parameter positions, fixed make_fg, extraction, both
  subtraction and NTT/FFT families. No arbitrary callee.
- Complete intermediate body, 5805–6389 (585 physical lines), header/close,
  two nested-loop scopes and every early return/break/continue outcome.
  Line, lexical and statement-boundary certificates retain all source text.
  A lexer part starts with whitespace, ends with newline and must lex fully,
  including closing any block comment. Concatenation cannot split a word,
  operator or comment. This is the explicitly defined chunked lexical
  reference; the failed monolithic flat-lexer reductions are not evidence.
- Non-vacuous piece audits, source/declaration partitions, fixed-call
  coverage and rewrite composition. Unknown word-call fallbacks are rejected.
- All 522 PRIMES2 and 1101 PRIMES3 records, including both sentinels, in 102
  bounded kernel chunks; all four exact size_t tables. Actual 12-byte struct
  members and 8-byte size-table object relations, qualified bitlength.vv.
- Indexed source-value and actual `PrimeRead` binding, with the first M0
  p/g/s values derived from the complete initializer. Primality of subsequent
  rows is neither needed for the frame nor asserted.

## Pins and checks

BEFORE work, the committed BATCH_028 verifier checked BATCH_015–028:
3202 distinct pins, 471 current inputs, exact historical supersessions and
no active job. Entry receipt `.build/levels_029/ENTRY_PINS_029.json`:
`68dca17afa1685f9f4d31c022defd52f652c791c1429b9aeb399889e17986f58`.
No predecessor source or pin was weakened or changed by this batch.

53 current accepted Lean modules, all stdout/stderr 0/0; full terms/types/
axioms audit 4174 entries (4156 named declarations, 18 inherited interfaces,
4145 terms, 29 inductives with full constructor types). Standard axioms
only, zero elisions; maximum accepted cumulative RSS 5050244 KiB.

- Intermediate material source:
  `e629cad43c776acf2f0806c980eb89f09bc832a46c1759dce5c3b93a6e5bae82`.
- Audit JSON:
  `8c4ff3e27cdfaf00d0cf5f697d1e6d1b26f961babc20e303fb760eb17a6f29f6`.
- Audit receipt:
  `2fbb46e1ad06283504102b7dd777395694f37d281a1aa6c1f20cdacb0b8db4c4`.
- Audit SOURCE_INPUTS:
  `feced4ee7db839636eeee0f0246a4b3b9422b6912f7bac260eba0ccbefed33fd`.

The structured pair records exact source/snapshot/artifact/receipt bindings
and every attempt. The 43111035-byte audit stays in the durable job directory;
`tools/keygen_intermediate_audit_source.py` regenerates its Lean producer.
Run it with `python3 -B`, then use the unchanged guarded runner with a new
label and `Source3.KeygenIntermediateAudit`. The pair pins the complete input
closure, generator, output and toolchain provenance. Large output is not
committed as an opaque binary/blob.

Sage `check_keygen_intermediate.sage`, standard preparser/ZZ, accepted
`keygen_zint_checks_029_001` (77.378s, 0/0). Ten normal/UBSan runs:
each baseline has 15 independent polynomial subtraction cases, six deepest
entries, 25 intermediate calls through complete depth traces, four diagnostic
root calls, all 1623 static prime records and four size tables. Four mutations
detected in both modes: signed k, intermediate return, intermediate output
word, last prime word. Public constant fixtures include inputs outside
MODE1's bound; they are helper tests, not production sampled keys. These
finite controls establish no universal solver/compiler/probability claim.

## Preserved failures and lessons (132–141)

132. Const uint32 pointer declaration and `*x = zint_...` need explicit
     productions; a generic scalar fallback is not a call implementation.
133. The inherited FFT for-clause grammar lacks discarded `u--`. The new
     binary stratum lowers that exact update to subtraction by one.
134. The inherited array expression parser mistakes `-(int)logn` for a
     function call. Parenthesize that same argument and check its signed
     tree. Renaming `int` to `int32_t` was a failed route, not a fix.
135. `open ... (Blocks)` does not re-export an imported name. `macro` is a
     Lean keyword. Both failed elaborations are retained.
136. Large direct source/lexer reductions exhausted resources. Separate
     source-line/lexical/statement certificates. `decide +kernel` uses the
     actual kernel, with no additional axiom or native-evaluation bridge.
137. Asynchronous theorem elaboration exhausted address-space/thread resources
     even with j1. `Elab.async=false` serializes new certificate modules;
     no process, memory, recursion, heartbeat, wall or print limit was raised.
138. Slice proofs need explicit arguments. Broad rewrite/unfold of a parser
     causes avoidable normalization. Use exact source partitions and small
     generic list identities; retain all OOM/thread failures.
139. Select every changed cached module. One stale-cache refusal produced no
     receipt/step streams; its directory is retained honestly. Other jobs
     that later failed may contain accepted earlier modules, pinned separately.
140. The first full audit truncated `TokensLift4.entries`. Per-line cons-slice
     proofs replace the large Fin-case term; the final complete audit passes
     at the unchanged pp.maxSteps. The failed 42MB partial audit is retained.
     The new audit also writes an append-only entry stream, avoiding repeated
     whole-array rewrites while preserving each completed entry.
141. Diagnostic probes are not proof evidence, including three nonempty-stdout
     runs marked accepted by the historical runner. Labels/session fields in
     inherited runner receipts remain provenance. Server interruptions did
     not authorize another worker or relay; process ownership was rechecked.

44 attempts: 33 failed jobs, seven wholly accepted jobs, three diagnostic
jobs and one receipt-less preflight refusal; 136 recorded steps. All failed
snapshots, available raw streams and partial products are retained.

## Remaining obligations, in plan order

1. Full root solve_NTRU, including actual logn/MKN initialization, M0 branch
   selection, deepest call, post-decrement intermediate loop, final depth0
   call and rejection control. Reuse the now complete fixed search closure.
2. Instantiate complete static/global/profile/scratch environments at that
   caller. Source initializer objects and their reads are now available;
   their arrival/preservation in the full root is still an obligation.
3. Transport actual sampled f/g through resultants, raw/GS/public operations
   and every search call, preserving their actual pointers and Bound1.
4. Derive output-gate and Validation entry fields from that same root
   execution; consume existing output bounds, transforms, comparison and
   integer lift. No local initializer/range/equation/source-completeness or
   arbitrary-frame premise may be substituted for the missing composition.
5. B1.05 Acceptance: exact integer NTRU about the same retained material.
   B1.06 remains unentered. Whole KeyGen/compiler/termination/probability and
   independent review are not supplied by this operational/frame midpoint.

Small commits on main as niirmataa, shared archive.lock and exact owned paths.
Source commits and the pair are not REVIEWED. This worker performed no push,
stages import, migration, model start, reviewer, subagent or relay.
