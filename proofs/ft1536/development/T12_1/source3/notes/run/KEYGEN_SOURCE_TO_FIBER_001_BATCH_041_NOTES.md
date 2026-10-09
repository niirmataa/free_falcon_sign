# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_041: derived first domains / inner radix remainders

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
2026-10-09, GPT-6 Astra Ultrafast (`openai/gpt-6-astra-ultrafast`).
**CLOSED_AT_RECOVERABLE_MIDPOINT. B1.06 Acceptance NOT MET.**
One midpoint in this window; B1.05 stays BATCH_032; B1.07 is not entered.
The owner handed this new window checkpoint20R and the iron roadmap rules.
Historical model/session constants inside the unchanged runner are provenance,
not the identity of this window's worker.

## 1. Complete first-domain derivation from the SAME invocation

`KeygenPublicFirstMaterial.source_same_material` has the checked boundary:

```text
s : State; out : Result; f,g,h : ArrayPointer; fv,gv : Geometry.Vec
Slot s "logn" 10; Ternary s
arrays: actual f/g/h bindings
Legal s.heap f; Legal s.heap g; Legal s.heap h
Represents s.heap f fv; Represents s.heap g gv
Bound fv 1; Bound gv 1
h.block != f.block; h.block != g.block
LiveTables s
Exec fixedPublicProgram ["f","g"] (code compute) s out
-------------------------------------------------------------------
Front s out h fv gv
```

`Front` is an existential over the actual t allocation block, converted,
afterH, afterT and remaining public-call result. It records:

- `Fresh s.heap block`, t's actual3072-cell descriptor;
- `Cells converted.heap h 1536 (reduced gv)` and
  `Cells converted.heap (localPointer block 3072) 1536 (reduced fv)`;
- actual h-forward and then t-forward executions from those SAME states;
- `Outcome gv h <afterH,normal>` and
  `Outcome fv (localPointer block 3072) <afterT,normal>`;
- the actual public suffix afterT→inner, observed flow and exact final
  `disposed s.heap inner.state.heap block` heap equation.

The h/g and t/f association follows the source conversion; it is not a
renaming or a separately executed synthetic transform.

`Outcome original a out` exposes an inner result with `FirstRun original a
inner`, matching flow, and a block-local equality from the inner heap to the
observed out heap. `FirstRun` in turn gives actual entry/after states:

```text
Inv original a 0 entry
Exec fixedPublicProgram [] firstLoop entry <after,normal>
Inv original a 768 after
Exec fixedPublicProgram [] remaining after inner
```

Thus `Inv0` supplies u=0, hn=768, pointer/width, `Local "r"
(radix*firstRoot)` and ORIGINAL reduced input cells; `Inv768` supplies all
low/high coefficient cells. They are conclusions. The actual remaining
radix/triple execution is retained. Neither `Outcome` nor `Front` asserts
that the first-fold cells survive the later transform unchanged.

### Source composition

- `KeygenPublicFirstTables.generate_values`: actual generator Call/Bind,
  `source_complete_tables`, every gm cell0..1023 with its scaled root value
  and byte frame. `dynamic_values` carries those VALUES across both aliases.
- `KeygenPublicFirstEntry`: source n/hn word operations, `gm_square[1]`
  promotion/load, declared-r assignment, u initializer, first-loop fold.
  `ready_first` consumes the actual dynamic generator dispatch.
- `KeygenPublicFirstInvocation.source_first`: complete forward source,
  actual declarations, both automatic arrays, Fresh-derived nonaliasing,
  original cells across allocation/generation, and both final disposals.
- `KeygenPublicFirstCalls`: both source argument bindings, selected ternary
  dispatch, h/g first then t/f, and t's original converted cells preserved
  across the h transform using the existing source footprint theorem.
- `KeygenPublicFirstMaterial`: actual complete compute conversion and t
  lifetime, with all inputs tied to the same source derivation.

No generated table, n/hn/u/r value, residue-domain/image, first-fold result,
forward correctness, empty-global, nonzero or public equation is a premise
of `source_same_material`. Legal memory/profile/material/bounds1 and static
table liveness remain explicit obligations of the later enclosing KeyGen.
No return1 is needed for this before-test result; its SAME suffix may reject.

## 2. Executed inner radix-2 values and polynomial remainders

`KeygenPublicRadixValues.source_body` derives both physical writes at i and
i+h, with ordinary values `x+y*z` and `x-y*z` and actual chronological
Store16 witnesses. The twiddle is a separate scaled local `radix*z`.
The source fragment1027–1033 and exact subtree occurrence are kernel checked.

`KeygenPublicRadixFold.source_loop` folds the WHOLE inner v-loop:

```text
a : Nat -> R; p : ArrayPointer; base,h : Nat; z : R
0<h; base+2*h<=1536; p.elementBytes=2; s.arrays "a"=some p
USlot s "ht" h; USlot s "v2" (base+h); USlot s "v" base
Local s "s" (radix*z); Cells s.heap p 1536 a
Exec fixedPublicProgram [] loop s out
-------------------------------------------------------------------
out.flow=normal AND Inv a p base h z h out.state
```

The image invariant uses source addresses: processed low cells in
[base,base+k), processed high cells in [base+h,base+h+k), and original
values everywhere else among all1536 cells. Guard comparison, increment,
promotion, narrowing, paired-store preservation and terminal counter are
proved from execution. The source v-loop fragment1026–1034 is checked.

`KeygenPublicSplitPolynomial.source_remainders` concludes, for every i<h,
that cells base+i and base+h+i are the coefficients of the block polynomial
modulo `X^h-z` and `X^h+z`, respectively. `eval_low`/`eval_high` universally
preserve this block's evaluation at x with x^h=z/-z. The sum/decomposition
argument parallels the older NTT block algebra, but is checked anew in
q18433 and bound here to public uint16 execution, not borrowed as another
model's transform theorem.

**Remaining local boundary:** the surrounding u1/m loops must derive these
base/h/limit/counter/twiddle domains from the same continuation and compose
all blocks/stages. This inner-loop theorem does not establish that nesting.

## 3. Universal physical triple geometry — exact scope

`KeygenPublicTripleOrder.triple_order` proves for all j<512,k<3:

```text
KeygenPublicRoots.point (3*j+k)
  = root^(tableExponent (512+j)) * unity^k
unity = firstRoot^2; unity^3=1
```

The three formulas are in their actual physical order:

```text
k=0: A + B*x        + C*x^2
k=1: A + B*x*unity  + C*x^2*unity^2
k=2: A + B*x*unity^2+ C*x^2*unity
```

`all_physical_evaluations` quantifies **every i:Fin1536** and identifies
these formulas with evaluation of the corresponding degree<3 block
polynomial at `KeygenPublicRoots.point i`. It does NOT say these are the
ORIGINAL f/g polynomial evaluations: the radix invariant and source triple
execution connecting those blocks to the original polynomial remain open.
Do not consume its name as a full source-transform theorem.

## 4. Audit, controls and exact pins

Before proof edits/jobs, the unchanged039 verifier checked7048 predecessor
pins/621 literal bindings. The separate040 rehash also checked its committed
pair, explicit pins and all seven job snapshots/products/receipts/raw
streams, extending the entry closure to **7113 files**, no supersession/job.
Entry `.build/levels_041/ENTRY_PINS_041.json`:
`d544a10f8f23325d47e6082ffd0332b242ad625cb87cb8a9b9ef66ab7673f183`.

Internal audit `keygen_public_first_audit_041_001`: **436 entries**,125 named
declarations across nine new modules plus the040 fold,311 inherited
interfaces;396 complete terms,40 inductives with constructor types,zero
elisions,only `propext`, `Classical.choice`, `Quot.sound`. Audit producer and
all nine proof modules accepted with0/0 streams and warningAsError. Literal
audit inventory **633**. This also supplies a full declaration audit of the
preserved040 fold; it does not rewrite040's historically narrower readout.

- Audit JSON: `8a0e4e369e4478c1eff28d6fdec774431cbe171063acb46672e206b77d162e15`.
- Audit receipt: `3c5268ebed37cc342830b8ad4c2155d19f305b5819f000bcaaeb6ff625234565`.
- SAME-material headline source: `be561c8553c0493116db7b1f0334d9e2bcfbdbd71e403f745b2fbf692a9fc66a`;
  receipt `cc37685ebce982247b9b5d5c94eafb7bf31a7bdf5563f64f1ce61eda7dd4356a`.
- Radix fold source: `44cb13207ed7e9197e88a70fce4786a3b78c61bb6e7950329140aed4b6eb0471`;
  receipt `b6048f9faa1671f4be2bbcbb1a36083ab2a48143ce82d4dc91785675a6155776`.
- Physical-order source: `fa8c39244842b548ac5ead01d88f910f72d7265a2be483988773c114f2eafc90`;
  receipt `bb8e7a4ef9a1bc237651e7a705b8b14407e6e3f967e8ac8c0186683b2b1692a7`.

Sage `keygen_public_first_checks_041_003`: **12 normal/UBSan runs**, four
public synthetic f/g pairs (eight vectors), signed conversion, actual
generator/aliases/n/hn/r, first pass, all eight radix snapshots and final
physical triples. Five mutations per mode all detected at their target
phase. Original-polynomial finite controls check **12288 evaluations**.
The live Extra/c header map, GCC include dependencies and object sentinels
are checked. The039 owner-approved FPR-header delta is unchanged; this is
local public-arithmetic diagnostic C, not a complete historical M0 build.

- Sage source: `cc8707c3368a564e2d0e6b21db41300218dc4b110e35f752cf667669a9e2c133`.
- Control result: `e6261d6a83ea371e94f10aeef7470c7b110c0c38f543ade329adaafc38f4b4fc`.
- Control receipt: `162e1fe2f2a5a1f1f846edcd97994c059fc19dbb38a0a7accfa59ea2c93fb00a`.
- Header map: `617f0f8c69cde0b82df627e49cd7b5d5764b3ed0be2cd04975ca62711f35c6d8`.
- Fixture: `8e7b6aaec74cac032ef688734e74910408d08b3e4e37521143e8d6cb0b296808`.

The pair JSON records every accepted source/snapshot/product/raw stream,
audit,control,tool and attempt pin. Dedicated041 seal/verify rehashes the
entire unchanged015–040 closure. Entry/POSTSEAL pins and the resume command
are recorded in the live checkpoint without making a circular pair hash.

## 5. Retained attempts and traps218–223

All16 job directories/17 steps remain:10 wholly accepted directories,six
with failure;11 accepted steps/six rejected steps. Max cumulative child
RSS4633812KiB. No limits changed and no unresolved current source.

1. **218 — Invocation001:** `Types s` is indexed by the whole State, even
   though its fields only mention locals. Passing that structure directly
   across allocation is not definitional transport. Rebuild it from its four
   unchanged fields; Invocation002 is accepted.
2. **219 — RadixValues001:** destructuring the `a1` Local proof consumed its
   name before `local_value`. Retain a copy for the declared-slot extraction;
   RadixValues002 is accepted.
3. **220 — RadixFold001:** simp-only conjunction hypotheses reduce to
   `True ∧ True`; include `and_self`. Normalize `Nat.add_assoc` before matching
   the exact u64 conversion argument. RadixFold002 is accepted, no linter
   suppression.
4. **221 — SplitOrder001:** SplitPolynomial accepted in the first step;
   TripleOrder's zero branch retained an associativity goal after simp.
   Explicit `ring` closes it; TripleOrder001 is the accepted separate job.
5. **222 — Checks001:** first-loop mutation anchor was not unique in the
   complete C file. Strict `once` stopped before compilation. Restrict this
   mutation to mq_NTT_ternary; preserve the failed source/receipt/fixture.
6. **223 — Checks002:** a one-sided C-contribution mutation left fC2 unused
   under `-Werror`. Swap both C contributions instead. Checks003 is accepted;
   the earlier compile stderr and completed earlier variants are retained.

## 6. Next window — same plan order

1. Reverify BATCH_015–041 before edits/jobs, using the dedicated041 verifier
   and exact pair hashes from checkpoint21R; no pin weakening/supersession.
2. **Item2:** outer radix entry/control and table/material frames. Carry
   actual n1536/hn768/logn10, both gm aliases, table values and a-pointer
   through the first loop, then derive t=hn,m=2,ht=t/2,u1/v1/v2/v domains.
   Consume `source_loop`/`source_remainders` for every executed inner loop;
   compose all u1 rows and eight m stages with t*m=1536. Public-field
   twiddle/root-tree laws must connect these stages to the ORIGINAL
   CoefficientQuotient polynomial; natural REV10/index facts are reusable,
   another modulus's transform theorem is not this source proof.
3. **Item2:** actual triple body/loop, deriving scaled w,x,x2, ordinary
   coefficient values, stores and frames. Combine `physical_evaluation` with
   the ORIGINAL-polynomial invariant to get every i:Fin1536 source value.
   `FirstRun.remaining` is the actual suffix seam; its current type does not
   yet export all the outer-loop header/table invariants. Strengthen the
   source composition in a new module rather than assuming them as final
   public-call premises.
4. **Only after item2:** SAME successful path all nonzero tests,division,
   actual inverse/normalization and canonical h. No assumed round-trip.
5. **Then:** fInv from nonzero evaluations/proved evaluation isomorphism;
   BOTH SAME-material `mulRq` equations.

This is a remaining universal source-composition proof, not a numerical
counterexample or a code bug. Finite diagnostics, root-count injectivity,
canonical range and physical triple algebra cannot fill that gap. Complete
KeyGen/emitted-to-fiber,compiler,laws/PRG/security and independent review
remain outside this midpoint. Small local own main commits under the
shared writer lock; foreign work/staging preserved. No push or stages import.
