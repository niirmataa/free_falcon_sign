# BATCH_017 — B1.03(c): source gm rows and caller layout

**PROVED_KERNEL_SCOPED / NOT_REVIEWED. Stage (c) CLOSED.**
The package remains **IN_PROGRESS / WORKING_NOT_FROZEN**. This owner-scoped
window ends after (c); the next owner step is **Acceptance B1.03**. B1.04
and its `t*m=n` invariant were not entered.

Harness: GPT-6 Astra Ultrafast (`openai/gpt-6-astra-ultrafast`). The runner's
hardcoded historical model/session labels were retained. No second worker,
reviewer or relay was started. All Git writes used exact paths on `main`
under `proofs/ft1536/work/archive.lock`, as `niirmataa`; no push.

## 1. Final source contract and actual premises

Checked export: `FT1536.Source3.KeygenMkgm3.source_contract`:

```lean
∀ (s : C99ArrayReference.State) (out : C99ProcedureReference.Result)
  (p0i : BitVec 32) (scratch rev : C99MemoryReference.ArrayPointer),
  KeygenMkgm3.Entry s p0i scratch rev →
  KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i) →
  C99ModularReference.Exec KeygenMkgm3Program.code s out →
  KeygenMkgm3.Contract s out scratch rev
```

`Entry` expands to ordinary entry facts:

- scalar bindings `p=2147355649`, `g=1907584673`, `logn=10`, `full=1` and
  the supplied `p0i` word; its inverse property comes from the executed
  `modp_ninv31`, not an extra arithmetic hypothesis;
- `gm=scratch+6144` words, `igm=scratch`, and a bound REV10 pointer;
- read-only REV10 bytes initialized from the actual parsed static table;
- a legal, writable, 4-byte-aligned scratch descriptor, with at least
  7168 words available after its initial index, within the allocated
  object and the existing 64-bit address bound.

`Contract` concludes normal return/fallthrough, initialized gm memory,
canonical ranges and exact scaled root/order laws for all 1024 positions,
preserved allocation/writability and bytes outside the scratch object,
retained legal scratch allocation and read-only REV10. `parsed_contract`
consumes the parser binding of source region2945/91 explicitly.

The proof consumes the existing `GenExec ModCall` relation and its fixed
source callees. The execution relation was not altered in this window.
There is no canonical gm, root identity, generator order, abstract NTT,
arbitrary callee or source-completeness premise. Entry and the static-table
initialization describe caller/global memory; the enclosing allocator and
complete call-frame assembly remain B1.07 obligations. This is the pinned
C-fragment reference semantics, not a compiler or whole-ISO-C theorem.

## 2. Exact rows and Montgomery representation

Let `R=2^31` in `ZMod 2147355649`, `g=1907584673` and `h=g^2`. The new
bridge proves `orderOf g=9216`, `orderOf h=4608` from the inherited kernel
power certificates. The source conversion uses the BATCH_016 R2 law.
The actual post-increment loop squares the converted generator once.

For physical row `2^k+j`, `0≤k≤9`, `j<2^k`, put
`u=bitrev(k,j)` and `e(u)=3*u+1+(u%2)`. Then:

```text
gm[2^k+j] = R * h^(c(k)*e(u))    in ZMod p
c(9) = 1
c(k) = 3*2^(8-k)                for k<9
gm[0] = gm[1]
```

Every stored word is `<p`. The order of the **unscaled** root is 4608 in
row9 and `6*2^k` in rows0–8; position0 has order6. The Montgomery factor
is explicit, rather than being silently attached to an ordinary residue.

`KeygenMkgm3IndexCert` checks all1024 index/exponent/order obligations in
64 bounded16-entry kernel chunks. The generator uses Sage `ZZ`, emits
untrusted candidates and checks the same finite indexing facts. The kernel
certificate, not Sage, supplies the formal result. In particular it proves
the last-row bit-reversal coverage/injectivity and the cube/square exponent
recurrences used by the store proofs.

Source refinement consumes:

1. declarations, R/R2 calls, conversion, `k=logn`, the inactive non-full
   branch, exactly one squaring and both post-increment effects;
2. the actual last-row branch and its256 paired iterations;
3. the full-case256 cube iterations, including both nested products;
4. the255 descending square iterations;
5. the final `gm[0]=gm[1]` copy and the inverse-table suffix.

The loop exits derive `u=512`, `u=512`, `u=0`. The inverse-table calls and
stores remain actual source operations. Their inverse-value correctness is
unneeded here and is not claimed; that storage is subsequently overwritten.

## 3. Memory layout and overwrite

The parsed/executed caller aliases yield, relative to `ft=fk->tmp`:

| Array | Word offset | Words | Byte interval |
|---|---:|---:|---|
| ft | 0 | 1536 | [0,6144) |
| gt | 1536 | 1536 | [6144,12288) |
| Ft | 3072 | 1536 | [12288,18432) |
| Gt | 4608 | 1536 | [18432,24576) |
| gm | 6144 | 1024 | [24576,28672) |
| temporary igm=ft | 0 | 1024 | [0,4096) |

The required span is7168 words/28672 bytes. The exports derive allocated
cells, pairwise separation of the four coefficient arrays, their separation
from gm, disjoint gm/igm tables and containment of igm in ft. The legal
descriptor may describe a larger caller allocation; no exact claim about
the enclosing `temp_size`/`malloc` execution is added.

`KeygenMkgm3Frame.source_material` preserves the original16-bit coefficient
objects outside the scratch object, including same-block disjoint
subobjects. `source_then_overwrite` composes generation and the existing
source conversion loop, retaining both gm rows and the same four original
`Geometry.Vec` witnesses. Its explicit local interfaces are the equal
cross-call heap, actual conversion pointer/scalar bindings, separate legal
input objects and their original representation. It does not assume the
desired table or preservation result. Full caller instantiation is later.

## 4. Checked evidence and pins

Preflight verified BATCH_015/016 against committed bytes, their dependent
receipts/artifacts and all364 current inputs of the final R2 audit:
774 distinct file checks, no active proof job. Preflight SHA256:
`40445fdd9597426d93a942030f6f6e2abe6a8cf5e1ca415933d9529e3af125c6`.

Predecessors:

- BATCH_015 JSON `b5bb63f5ddfb423ff6a4742dfd2893bcc7587b4cb50f51877b9b3910285be134`;
  notes `aec981ffab3f9065ac10d6d99f4f931ceccd852f237382e3b0240b64fbe53cd8`.
- BATCH_016 JSON `cc28381bb1188400d0ea1d15e3c83ba045a2e5476a9644ee4dd0585c58e2b25f`;
  notes `e323ac9783e41e2143638088af6cfb0453b756a8418273b62bd961c1b0695419`.
- Pinned M0 C: `0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf`.
- Runner unchanged: `3bc29bf7aef246bcd49bcd1bafe0120f26225252f505208a9563d76919cafba5`.

The paired JSON pins all18 current modules, immutable job snapshots and
oleans, RECEIPTS/SOURCE_INPUTS, individual logs and direct import hashes.
All accepted module streams are0/0 bytes. Maximum recorded RSS among those
checks:2851084KiB. The inherited proof limits and warnings-as-errors remain
unchanged. Checking was incremental, dependency-ordered, not a fresh replay
of the whole project. In `rowinit_001`, Loops and Prelude passed, then the
new RowInit child failed; RowInit passed `_002`. The JSON reports that
partial-job distinction explicitly. The final contract/audit closure was
checked together in `keygen_mkgm3_contract_002`.

Final pins:

- `KeygenMkgm3.lean`:
  `a231c2edc71db67aca245cc658898f498caf66799fdad2ce0470ba742ba15772`.
- `KeygenMkgm3IndexCert.lean`:
  `c3bdd7bc6a10a750c7cb6723256eae3abf2cfccbdd5621ca02d1f6818b7b2d2c`.
- Final RECEIPTS:
  `c41c8831073ea330e59a69dbb3d298bf827eef8223cd750432ac88fa99fc38d5`.
- Final SOURCE_INPUTS (382 inputs):
  `b3a02328e85434615b575be1ce56771fce265bf73107b491b7f2fec693c69377`.
- `.build/jobs/keygen_mkgm3_contract_002/MKGM3_AUDIT.json`:
  `9235ffa4c4170591d5c81af56e82da378aaf68a93d30d576429dbe19c60cd52b`.
  **57 entries:14 definitions/43 theorems, full types/terms, zero elisions**;
  only `propext`, `Classical.choice`, `Quot.sound` or subsets.
- `.build/jobs/keygen_mkgm3_checks_002/MKGM3_CHECK.json`:
  `01341f2a4faf797ba3a0046b65f87c19406e76249dbd4eda413bbe3c0ab208df`.
- This batch JSON:
  `50f35519c32d1d16dd6987b781ac43e59cc835dd076ce15f146a1fe9ac9cbc0b`.

Sage/C controls (`sage check_keygen_mkgm3.sage`,2.671s) check all1024
words before/after the pinned overwrite fragment. Both normal and UBSan
baselines match independent Sage modular powers. All six mutation families
are detected in both modes: wrong Montgomery scale, last-row increment2
instead of4, square instead of cube, wrong permutation, wrong top copy and
overlapping gm/output layout. All14 executions retain the original public
synthetic inputs and scratch guards. These finite observations supplement
the kernel result; no NTT or private KeyGen was executed.

Sage imports no Lean. Its generic input inventory contains the earlier
contract/audit versions preceding the last three layout exports. Those
historical snapshots/products remain retained. The final57-export audit
has its own current pins; no historical inventory was rewritten.

## 5. Failed attempts and recoverability

All49 guarded attempts are retained, including28 failed jobs and accepted
intermediate versions. The JSON pins every receipt, source inventory and
raw stream; failures are not counted as passes.

Important failure families:

- Explicit cast/modulus normalization and natural exponent elaboration;
  the existing generator-certificate threshold32768 is reused, with no
  memory, heartbeat, recursion or wall-limit increase.
- Pointer alias parsing needs its pointer-name context. Dependent state
  parameters must be supplied before a size/slot proof infers the wrong
  earlier state. Normalize result/record projections before rewriting.
- `while`, `prefix`, `meta` are reserved Lean tokens; `<i`/`≤i` can be
  notation tokens without whitespace. Boolean conjunction uses `_iff`.
- Remove redundant simplifier arguments/tactics and deprecated spellings;
  no warning suppression was introduced. `convert` can already close the
  arithmetic goal. `BitVec.toInt_ofInt_eq_self` takes three premises.
- The first Sage generator completed its checks but failed to serialize
  Sage integers to JSON; explicit serialization conversions fixed it.
- Audit `_001` rejected a truncated cube proof print. `pp.deepTerms=true`
  exposes the complete term without changing proof limits. Final output
  explicitly rejects any remaining elision.
- The first C mutation made g4 unused under `-Werror`. The repaired mutation
  changes g4's computed exponent instead, retaining the strict compiler
  flags. Its failed source/compiler logs remain in `_checks_001`.

## 6. Commits, window close and next step

Small local proof commits:

1. `9c9f75fe755dd09562006f503d6071b408c64539` — scaled algebra/caller layout;
2. `8e132c168cb80a82d15426207c37ffbc88d34c41` — indices/upward store laws;
3. `fa9388366c5cb574e9b8e8f1d1130010edc38103` — initialization/row loops;
4. `159386b306ecdbcb6980235b90015b2ccaa38d5c` — full contract/overwrite/audit.

This pair and the expanded checkpoint receive a separate local documentation
commit. Foreign onboarding/audit preparation changes are preserved. No
owned proof job remains running. The (c) window is closed; hand off to the
owner for **Acceptance B1.03**. Later: B1.04's range/evaluation proofs, then
B1.05–B1.11. `emitted_to_actual_fiber` remains uninhabited.
