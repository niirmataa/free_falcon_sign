# BATCH_039 — SAME-material public caller domains and first polynomial-value refinement

2026-10-09,GPT-6.1 Sol Fast (`openai/gpt-6.1-sol-fast`).
**CLOSED_AT_RECOVERABLE_MIDPOINT / PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED.**
**B1.06 Acceptance NOT MET.** One midpoint this window;B1.05 stays032;
B1.07 is not entered. Scope follows checkpoint18R,not a new plan.

## 1. Entry and unchanged predecessors

BEFORE proof edits/jobs,the exact committed038 verifier checked all
**6438 BATCH_015–038 pins /607 literal source bindings**,no supersession/job.
Entry `.build/levels_039/ENTRY_PINS_039.json`,SHA256
`cb73d864e35991b4815d930a370e70d383057a30657508a825b6c04265593044`.
Initial PRESEAL `.build/levels_039/PRESEAL_PREDECESSOR.json`,SHA256
`b674d5df20bc415f07db69ca2109b37ccc72524ee6e24e7d6025536a59eef946`,
re-hashed exactly the same6438 pins after all new proof/control jobs.
Intermediate PRESEAL after the owner's header-binding decision:
`.build/levels_039/PRESEAL_PREDECESSOR_002.json`,SHA256
`aedbdce46207dc4d7ed9440a39c3665e18c00820f8899d471ac7d806bd404bb0`,
again the identical6438 pins. The original organizer version is retained as
`PRESEAL_VERIFIER_001.py` (`b2fb2d94…`),exactly matching the original receipt's
verifier SHA. Reversible recovery from the retained header-decision version
is checked by `tools/keygen_public_input_verifier_history.py`;no old receipt
was rewritten when final control/header-binding fields were added.
Final PRESEAL after the own metadata repair:
`.build/levels_039/PRESEAL_PREDECESSOR_003.json`,SHA256
`51ab0ca3bd1f2b999caf5caa53fc55e90e7cf283b62cc7c012073b5ff01d87db`,
again the unchanged6438 pins,607 literal inputs,no job/supersession.
No predecessor source,receipt,pair,failed stream or counter was rewritten.
Reference C was read from `Extra/c/falcon-vrfy.c` and `Extra/c/internal.h`,
then checked byte-for-byte against the pinned M0 profile. Frozen W remains
read-only provenance,not an instruction or a replacement source checkout.

## 2. Exact closed source boundary — no range/image premise

`KeygenPublicInputLifetime.source_same_material_front`:

```text
s : State; out : Result; f,g,h : ArrayPointer; fv,gv : Geometry.Vec
Slot s "logn" 10; actual int32 ternary slot1
s.globals=(fun _ => none)
s.arrays "f"=some f; "g"=some g; "h"=some h
Legal s.heap f/g/h: width2 and allocated cells0..1535
KeygenMaterial.Represents s.heap f fv / g gv
KeygenIntegerLift.Bound fv 1 / gv 1
h.block≠f.block; h.block≠g.block
h.count≤h.index+1536
all bound static-table blocks live; static tables disjoint from h.block
Exec fixedPublicProgram ["f","g"] (code compute) s out
------------------------------------------------------------------
Front s out h
```

`Front` is a CONCLUSION extracted from that SAME execution:

```text
exists actual block, afterT : State, inner : Result:
  Fresh s.heap block
  Image afterT.heap h 1536
  Image afterT.heap (localPointer block 3072) 1536
  Exec fixedPublicProgram ["f","g"] sourceRemainingSuffix afterT inner
  out.flow=inner.flow
  out.state.heap=disposed s.heap inner.state.heap block
```

`Image` means actual initialized unsigned16 words,each<18433. Neither
canonical input,canonical output,initialized NTT image,generated table,
transform correctness,ninv/solver correctness,numeric test success,nor any
equation is a premise. No return1 is needed to reach this BEFORE-nonzero
midpoint;the SAME later suffix may return0. No claim about canonical h AFTER
division/inverse is made. t's image is an interior live-object image,not a
load from its disposed final object.

### Actual derivation

1. Complete compute body1521–1547 is partitioned in the kernel. Actual
   size_t/int32/uint32 MKN yields1536;the ternary branch assigns q18433.
2. Actual automatic t has3072 cells,not1536. Fresh plus input/output liveness
   derives its separation. It starts empty;there is no defined load admitted
   from its untouched1536..3071 tail.
3. Actual signed f/g loads,promotions,mq_conv_small parameter binding and
   narrowing yield ORDINARY residues of the SAME original coefficients.
   The complete loop derives all3072 t/h stores,original input preservation,
   final counter1536,initialized images and t's empty tail. Initial h values
   may be arbitrary;they are overwritten,not assumed canonical.
4. The actual h call then t call use actual Bind/dispatch. Callee scalar
   locals inherit globals,not stale caller locals. Empty scalar globals
   yield the required residue-local domain. The source038 range theorem is
   consumed ONLY AFTER these domains have been derived.
5. Defined-load Domain for h follows its actual1536 extent. Domain for t
   uses the proved empty tail despite its3072 extent. h's complete forward
   call preserves t before the latter is transformed;the t call preserves
   h. Actual disposal is tied to the observed complete result.

These are local legal-profile/memory/material source theorems. The
enclosing KeyGen caller must later supply the exact typed extents,static
global footprint,non-aliasing and retained MODE1 material. This is not a
complete frontend/compiler/whole-KeyGen theorem. The declared empty scalar
global environment is a legal-entry restriction,not an assumed residue
bound;static array tables remain separately bound and live.

## 3. Independent value and polynomial obligations actually proved

`KeygenPublicValueExpr.Evaluates s e z` records BOTH:

```text
forall actual v, Eval [] s e v ->
  (0<=v.integer AND v.integer<18433) AND (v.integer : ZMod18433)=z
```

Source mq_add/mq_sub/Montgomery calls independently derive these equations.
Integer conversion and unsigned16 narrowing preserve the derived field
value. No lemma infers a value merely from a canonical range.

`KeygenPublicFirstValues.source_body` consumes the actual first-butterfly
body1003–1009,its current pointer/counter/hn768,ordinary input cells x/y,
width2 and the LOCAL r word scaled as radix*z. It concludes:

```text
Cell out.heap a i (x+y*z)
Cell out.heap a (i+768) (x+y-y*z)
exists middleHeap,lowWord,highWord:
  Store16 before.heap a[i] lowWord middleHeap
  Store16 middleHeap a[i+768] highWord out.heap
```

The body includes actual block declaration/restoration and both
chronological writes. The source partition of the complete tail at1001 is
checked;this does NOT yet fold the768-body loop or derive its initial r.

`KeygenPublicFirstPolynomial` uses the existing
`CoefficientQuotient.polynomial(Relation.reduceVec original)`:

```text
low(v,z) = sum_i C((v i).1+(v i).2*z)*X^i
high(v,z)=low(v,1-z)
degree low(v,z)<768
x^768=z -> polynomial(v).eval x=low(v,z).eval x
```

`source_original_coefficients` derives both stored first-split polynomial
coefficients from the SAME original reduced input cells and SAME actual
body. `original_reduced_coefficient` ties physical coefficients to the
original paired Vec. Both evaluation branches (firstRoot and1-firstRoot)
are proved mathematically. These are UNIVERSAL kernel lemmas,but LOCAL
first-body/value premises remain to be extracted/folded through the full
transform. No universal physical1536-point evaluation theorem is claimed.

## 4. Accepted proof sources and audit

Twelve proof modules:

`KeygenPublicInputProgram`, `KeygenPublicInputCells`, `KeygenPublicInputAtoms`,
`KeygenPublicInputLoop`, `KeygenPublicInputMaterial`, `KeygenPublicInputSetup`,
`KeygenPublicInputCalls`, `KeygenPublicInputBridge`, `KeygenPublicInputLifetime`,
`KeygenPublicValueExpr`, `KeygenPublicFirstValues`, `KeygenPublicFirstPolynomial`.

All have accepted0/0 module streams. `KeygenPublicInputProbe` is a retained
parser diagnostic ONLY;it writes the complete AST to a job-local file and
exports no correctness theorem. The full internal producer is
`KeygenPublicInputAudit`,generated by `tools/keygen_public_input_audit_source.py`.

- **311 entries=154 named own declarations+157 inherited interfaces.**
- **277 full terms+34 inductives with constructor types;standard axioms;
  zero elisions.** Type/body/axiom audit is internal,not independent review.
- Audit `.build/jobs/keygen_public_input_audit_039_001/PUBLIC_INPUT_AUDIT.json`,
  SHA256 `356e838a85d9bc24fc1de9c227a8c1f399938d69097a7dae442b849f7c4d759d`;
  receipt `360151524c42ed0da90013d1c6bea68e290f6e4e0c015220ad739fbbbc5437b1`.
- Literal final audit inventory **621 sources/reused entries=607 inherited
  literal bindings+14 new modules (12 proofs+producer+diagnostic).**
  No historical counter is rewritten.

## 5. Exact finite Sage/C controls — supplement,not full evaluation proof

`sage check_keygen_public_input.sage`,standard preparser/ZZ:
**12 normal/UBSan runs,eight public synthetic SAME f/g pairs per run**.
Each run checks16 conversion snapshots,16 actual first-pass snapshots,
eight t-tail sentinels and eight original-input/subobject-sentinel rows.
Each case executes3072 conversion stores;both first passes are checked.
Five mutations per mode are detected:wrong same material,unsigned input,
wrong complement,wrong scaled root,swapped first halves. A mutation may
remain canonical while changing the polynomial value.

**96 exact finite polynomial split evaluations** are diagnostic controls,
not the missing universal full-transform proof. The diagnostic initializes
t's entire object to60000 to observe its untouched tail;the kernel proof
instead keeps those actual source cells UNINITIALIZED. No private KeyGen,
private seed or production C edit was used. All generated C,compiler/run
streams and results are job-local and pinned.

Final control `.build/jobs/keygen_public_input_checks_039_005/PUBLIC_INPUT_CHECK.json`,
SHA256 `a12b57bab8186f9e223e9d58529ac1644bd52c3c95513b91ee8eabc4506f661b`;
receipt `207bffbe5a00bfb48aff627d608336ae0775b1610c208d328b8a105931216e0e`.
Repository include closure: compiler-generated GCC dependencies are checked
in every run,with pins for vrfy.c,internal.h,falcon.h,shake.h,fpr-emulated.h.
Header binding `PUBLIC_INPUT_HEADERS.json` (identical004/005),SHA256
`db8efd20dc0810fac9f07094f8274dcbe05f0f331f5461c2e4df60e06292d56e`.

**Owner-approved diagnostic boundary:** the actual FPR header is
`6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f`,
NOT historical M0
`242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa`.
All four other repository source/header pins match M0. Before seal,the worker
stopped and reported this extra compile-dependency mismatch. Owner chose
"pin live headers" and repeated that choice after asking for the question
again. Runs004/005 pin the actually used closure and retain the explicit delta;
it is a local public-arithmetic diagnostic,NOT a complete historical M0 build
or compiler proof. Old M0/proof pins are unchanged. Earlier successful003,
its old result `7b144d72…` and receipt `481b6bb9…` remain exact historical
bytes;they are not relabeled retroactively as having complete header binding.

## 6. All attempts retained;new traps206–217

**36 unique039 directories/38 steps:**15 wholly accepted directories,
21 with a failed step. Program was accepted before Cells failed in
`input_039_003`;Material before Setup failed in `input_material_039_002`.
Every current final source has a matching accepted immutable snapshot,
artifact,receipt and0/0 streams. No receipt-less or unresolved attempt.
Maximum cumulative child RSS **5098508KiB**;limits unchanged:
Lean-j1/-M6144,AS12GiB/RSS8GiB,wall1800s,heartbeats2000000,print200000.

206. `initialize`,`prefix`,`protected`,`local` are reserved tokens;use
     `initial`,`inputPrefix`,`saved`,`fact`. Early atom/program/call/value
     syntax failures are retained (`input_001/002`,`calls_001`,`value_expr_001`).
207. The actual parsed for statement is `.seq initial loop`,NOT an extra
     `.seq loop skip`. Appending a prefix can flatten this grouping and
     change syntactic equality. Retain exact AST;prove append inversion/
     introduction on execution instead. `calls_002` failed the over-flattened
     seam;`InputProbe` explains the actual complete source shape.
208. t's extent3072 cannot be truncated to1536 to reuse a range theorem.
     Domain uses source emptiness of its tail. Allocation changes metadata;
     transport reads block-locally and conclude only a LIVE interior image.
209. Signed promotion is int32;literal18433 is int32 BEFORE assignment or
     uint32 helper parameter conversion. Do not identify it with uint32 by
     reflexivity. Atom signed-word/rewrite and Setup assignment failures stay
     in `atoms_001/002`,`material_002`.
210. Structure fields named f/g shadow material parameters;Lean4.34 uses
     `structure S : Prop extends P`. Unused branch names are errors under
     the clean-log policy. Preserve `loop_001`,`material_001`;no linter is muted.
211. A field value of `v.integer` and `value(word v)` needs a proved cast
     equality,not an assumed type match. U32 is a named proposition that must
     be unfolded before rewriting the actual assignment. `value_expr_002/003`
     are retained;`_004` is the clean final proof.
212. Let-bound states hide the actual declaration in syntactic rewrites;
     provide a named entry-state equality. `lifetime_001/002/003` retain the
     failed rewrite/syntax attempts;`_004` derives all actual entry facts.
213. Empty signed-name lists still leave a Bool-coerced if until reduced.
     Preserve `first_values_001`;the corrected typed change is not a new
     unsigned-load premise. Namespace opening differs from constant opening;
     use Mathlib's current eval_finsetSum. Preserve `first_polynomial_001`.
214. A checker replacement spanning the rest of vrfy.c also matches the
     private completion routine. `checks_001` failed strict uniqueness;the
     corrected instrumentation targets ONLY the exact public body. No guard
     was weakened and no unrelated code replaced.
215. Removing g's read in a mutation triggers -Werror=unused-parameter.
     `checks_002` preserves the clean baseline and failed mutant compilation.
     The corrected MUTANT adds only `(void)g`,not disabled diagnostics.
     `checks_003` passes all12 runs with clean outer streams.
216. A passed C run and matching vrfy.c/internal.h do not establish its full
     include binding. The live FPR header differs from M0;stop-and-report,
     owner decision and explicit004 dependency pins above resolve only the
     LOCAL diagnostic scope. Never change historical M0 pins or promote this
     to a full M0 replay. All compiler dependency files and five live pins
     are retained;the predecessor closure is unchanged.
217. The first seal STOPPED on a new own checker metadata bug. The loop's
     expected vector shadowed its initial expected-header dictionary;004
     has clean streams and valid finite arithmetic comparisons,but its
     result.historical_m0_pins is a1536-entry vector,not the five-entry map.
     The unchanged strict seal guard rejected it BEFORE writing a pair.
     Preserve004 and `SEAL_ATTEMPT_001.json` (`aab501e5…`),the exact committed
     organizer source,original preseal002 and the manually archived shell
     error transcription (not claimed to be an automatically captured raw
     job stream). This was reported before the narrow own-code repair.
     New005 names the vector separately and asserts header-map identity
     before writing. All12 runs/96 finite evaluations pass;the historical
     header map,compiler dependencies and five live pins now agree. No guard
     or old pin was weakened;no004 output was overwritten or retroactively
     described as a valid final packaging result.

Raw failed logs may contain compiler-generated recovery terms after syntax
errors;the actual proof sources contain zero unfinished-proof markers.
No failed term is accepted or consumed. Earlier accepted versions are
resolved by module+artifact SHA+source SHA against immutable job snapshots,
never by identifying overwritten cache paths with old source bytes.

## 7. Exact remaining B1.06 obligations,in inherited plan order

1. **Item2 remains PARTIAL:** actual first-pass entry/seed r from the SAME
   full generator/forward invocation;fold all768 butterflies with the
   ORIGINAL polynomial and byte/table/material frames. Current local target:
   source firstLoop from the derived u0/hn768 entry plus SAME converted input
   cells implies all low/high polynomial coefficient cells at counter768.
2. All actual radix2/triple value invariants and physical source ordering.
   Final target for each i:Fin1536 is the SAME retained f/g polynomial
   evaluated at `KeygenPublicRoots.point i` in its actual loaded word.
   Canonicality and finite controls cannot supply that equation.
3. **Item3 OPEN,not entered:** from SAME successful public path derive all
   nonzero tests,division,actual inverse and normalization to canonical h.
   No assumed forward/inverse round-trip.
4. **Item4 OPEN,not entered:** fInv from nonzero evaluations/proved evaluation
   isomorphism;BOTH SAME f/g/h mulRq equations. No equation premise.
5. **Item5 current ceremony DONE:** full own audit,controls,unchanged
   predecessor re-hash and dedicated039 seal/verify closure accompany this
   midpoint. Pair JSON contains the exact post-source commit and all pins.

This is a remaining proof/composition gap,not a code/numerical
counterexample. Full KeyGen/emitted-to-fiber/compiler/laws/PRG/security and
independent review remain outside. Small own local main commits only;
foreign work/staging preserved. No push/review/subagent/worker/session/relay/
migration/import/broad replay. The next window verifies015–039 BEFORE work,
then resumes this first-loop/value seam,not nonzero/division prematurely.
