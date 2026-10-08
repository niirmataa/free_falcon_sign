# BATCH_028 — extraction, scaled arithmetic and deepest operational closure

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
**B1.05 Acceptance NOT MET. CLOSED_AT_RECOVERABLE_MIDPOINT.**
Harness: GPT-6 Astra Ultrafast (`openai/gpt-6-astra-ultrafast`), 2026-10-08.
Historical labels in the unchanged runner are provenance. This window
completes the owner's listed B1.05b dependencies and the deepest substep
of B1.05c. Intermediate/root and full material transport remain open.

## Entry and workflow

Checkpoint 7R was read before work. Physical shared main, staging, foreign
changes and job ownership checked; no active proof job at entry. The entry
verifier was extended to the committed BATCH_027 pair at `dba69ac1` and
its 14 receipts plus the retained receipt-less directory. All BATCH_015-027
pairs and 2917 distinct pins were checked, with 459 inherited current
inputs. Three exact supersessions were recorded (Call/Core/diagnostic
Probe). `.build/levels_028/ENTRY_PINS_028_002.json` SHA256:

`b9cec873c9440265d16347bfcb13104630dfeee33a14bf907699a13d87f1ce60`.

The first entry receipt (`821bd163db3248c0f14e081b525e5d2459d7ad6836c95ac7d45e0116df240ce8`)
is retained. The second reran the same checks after correcting only the
verifier docstring's count of superseded sources. Its source hash is the
committed verifier; the first receipt records its earlier comment version.
At sealing, only Call/Core supersede their pre-window pins; the exact old
and new hashes are in the batch JSON. Predecessor pairs are unchanged.

Small commits on main as niirmataa, exact owned paths under
`proofs/ft1536/work/archive.lock`: `8ca34465` entry pins, `a6250513`
bitlength/signed extraction, `18678871` top/polynomial conversion,
`5ed5c90e` scaled subtraction, `71da147c` binary/make_fg closure, followed
by the deepest/audit/control source commit and this final checkpoint.
No push, independent review, worker/relay, migration or stage import.

## Kernel-checked source closure

| Module | Complete source bodies / result |
|---|---|
| KeygenZintCall + KeygenZintExtract + KeygenZintCore | bitlength and zint_signed_bit_length, 3/5 pieces; static vv[] declaration, inferred 32 unsigned words, actual qualified object `bitlength.vv`, initializer/Load32 binding; returned value-level call and C addition. All previous core body audits rebuilt. |
| KeygenZintTop | zint_get_top, 4 pieces; uint32 division by 31 under the actual usual conversion, same-width int64 pun in return, fixed argument/return conversion and frame. |
| KeygenZintPoly | poly_max_bitlength/poly_big_to_fp, 4/3 pieces; f walk, MKN, ternary off, signed-helper call, nested top/scaled calls and Store64. The fpr parameter view is eight bytes. |
| KeygenZintScaled | zint_add_scaled_mul_small/zint_sub_scaled, 3 pieces each; fixed bodies, actual return, signed carry pun, custom bound backward pointer arguments. |
| KeygenPolySubScaled | poly_sub_scaled, 3 pieces; both branches, five call sites, three backward pointer sites, two signed32 k[u] loads, /31 and %31. Derived object-separated byte frame. |
| KeygenBinaryNtt | modp_mkgm2/modp_NTT2_ext/modp_iNTT2_ext, 4/3/4 pieces; actual uint16 REV10 read, right-to-left chained assignment, empty statement, pointer scopes, both stride-one macro definitions, all-depth byte frames. |
| KeygenMakeFgSource | make_fg_step/make_fg, 5/4 pieces; mixed declarations, pointer ternary, actual Load64 size-table/prime-member reads, signed16 f/g loads, memmove, complete binary/ternary/top/CRT closure. |
| KeygenDeepestSource | solve_NTRU_deepest, 5 pieces; actual fk fields, value-bound ternary argument, full make_fg, CRT, negated Bezout gate, two ordered short-circuit multiply calls, both returns; derived caller-slot and material preservation. |

All new body pieces have non-vacuous `map ... = some` audits, header/close
pins, complete line partitions and rewrite composition. The larger existing
core is shared rather than repeatedly expanded by later grammar strata.
No final call has an arbitrary callee or an assumed heap frame.

### Exact deepest material boundary

```text
ctx : KeygenSearchContext.Context
before, after : C99ArrayReference.State
v : C99IntegerReference.Value
source : KeygenDeepestSource.Call ctx before after v
input : C99MemoryReference.ArrayPointer
separated : KeygenDeepestSource.Protected ctx before input.block
vector : Geometry.Vec
represented : KeygenMaterial.Represents before.heap input vector
----------------------------------------------------------------
KeygenMaterial.Represents after.heap input vector
```

`Protected` is scratch/static-table object separation. The source call
binds the actual fk/f/g arguments and executes the complete fixed body.
`ReadLogn`, `ReadTernary`, `ReadTmp` consume actual context bytes, with the
inherited LP64 object/pointer layout. The `make_fg` member argument is
evaluated and converted without an invented caller local. The negated
Bezout test and multiply OR preserve real heap effects and failure flow.
The result covers finite defined calls on either return, not termination
or success probability. It preserves an incoming vector; it does not
initialize its bound or carry it through the remaining intermediate/root.

This is an operational/frame closure, not a bigint arithmetic, binary NTT
evaluation, numerical fpr approximation or Bezout identity theorem. Final
NTRU still comes from the existing validation suffix after its caller and
same-material obligations have been discharged.

## Audits and controls

Current proof modules plus `KeygenZintAudit` have accepted source/snapshot/
olean/receipt bindings, unchanged limits and empty stdout/stderr. Audit
`keygen_zint_audit_028_001`: 546 entries, covering all 528 declarations in
the ten covered source modules (including retained core declarations) and
18 inherited interfaces. 509 complete terms, 37 inductives/structures with
full constructor types, only `propext`, `Classical.choice`, `Quot.sound`,
zero elisions. The 843467-byte artifact is reproducible from the tracked
Lean audit and `tools/keygen_zint_audit_source.py`.

- Audit SHA256: `2a2a052d6b2019232cb8eae6e25dd7c92de5fa9da01ba9496ef5e3c9ee1ec7bc`.
- Audit receipts: `3a1709d02ac86b8b054292b851b0d2172d5166b7fe0ba5b3cb0df95aa7b862f8`.
- Audit SOURCE_INPUTS: `2fc0ea1d5aba73a133a85a08f65d829ae042ff183c56ca971faa86095d719af9`.
- Deepest receipt: `86868575d8eea10f19b5aa52f6a7030cc2d6340ea40323263355fe2b48662d78`.

`keygen_zint_checks_028_003` runs the standard Sage preparser with exact
ZZ polynomial norms/products and QQ nearest-even FPEMU expectations:
**16 C runs (normal/UBSan × baseline/seven mutations), 266 rows each**:
91 word-bitlength, 99 signed/top cases, 36 paired bigint scaled cases,
6 polynomial max/fpr cases, 9 polynomial subtractions, 14 make_fg RNS/NTT
cases, 11 deepest cases including logn10/ternary1. All seven mutations are
detected in both modes; baseline outputs, byte guards and retained inputs
match. The expected polynomial norms and arithmetic are computed in Sage,
not copied from C. These are finite controls, not a universal proof.

- Controls SHA256: `e9bcb791f1493c5dcdd82eae267fc9cc3f549f1145f36ff56d07623be1e1b621`.
- Controls receipt: `38e600270ec34ef6f1f365187c8665e790c36c29aad0ea8c59bca81eef5d14f8`.
- Public fixture: `93cb5f884824263c7b30e87cd783141e8fb8bdeb3ddecd8157c26b4a2d6d4561`.

## Retained failures and new traps (123–131)

123. The actual bitlength signature is `unsigned`, not `static unsigned`.
     The static storage qualifier belongs to vv. The array is declared
     unsized `vv[]`; 32 is inferred from its source initializer.
124. The generic `callee (` production catches `return (` unless return
     dispatch precedes it. The first extract attempt otherwise fell back
     to the closed ModCall language. Exact `retSum`/call-count audits caught
     it. Corrected before accepting any signed value-call evidence.
125. Preserve the right-to-left value and argument/return conversion of a
     value-level call. A scalar temporary inserted into the caller would
     require its own scope/state proof; this implementation inserts none.
126. In a result-indexed induction, change the table equality explicitly to
     `middle.tables=before.tables` before rewriting. Inducting a Bind indexed
     by a fixed params expression fails; prove the lemma for variable ps.
127. `F + j - off` is `(F+j)-off` in C, including the intermediate pointer
     bound. Grouping it into unsigned `j-off` loses that fact. The scaled
     argument relation executes both operations, and the frame uses object
     separation rather than assuming the result is forward of F.
128. k[u] is signed32; REV10 is unsigned16; MAX_BL_SMALL2/3 are LP64 size_t
     (64-bit). The generic word/modular parser's default Load32 must not
     substitute for any of these reads. The new productions are explicit.
129. The inverse binary NTT contains `;;`; the second semicolon is an
     executed empty statement. Chained x1=x2=modp_R evaluates the call once
     and assigns right-to-left. Local pointer scopes are restored.
130. The first C-control harness attempted auxiliary ternary table generation
     at logn0 while decoding a length-one transform. Final harness takes
     the identity path at n=1. The original nonzero child result, available
     partial stdout and empty stderr are retained; its exact child exit
     code/signal was not recorded. Later child return codes are recorded,
     stdout is unbuffered, and the corrected baseline passes both modes.
131. The first make_g mutation removed the last use of g and correctly failed
     `-Werror=unused-parameter`. Replace the mutation with g[u]+1, retaining
     all warning checks. Do not call this a baseline source failure.

15 guarded attempts are retained: 11 accepted, four failed (extract_001,
top_001, checks_001/002). Every attempt has its own snapshot, receipt and
raw streams; no receipt-less attempt this window. `_poly_001` is a clean
earlier source version, superseded by the additional call-count audits in
`_poly_002`. The older diagnostic Probe is not current proof evidence.

## Remaining order

1. Continue B1.05c at the full `solve_NTRU_intermediate` body and remaining
   active callees; inventory `poly_sub_scaled_ntt` and any unclosed branch
   dependencies before assigning coverage. Reuse this window's fixed
   extraction/scaled/make_fg/deepest closure.
2. Bind complete static PRIMES2/3 and size-table initialization and actual
   root context/profile/scratch aliases. Existing literal table reads and
   first-prime facts do not by themselves initialize every table object.
3. Instantiate the full root post-decrement intermediate loop and retain
   sampled f/g through all preceding GS/public/search operations. Feed the
   same material and actual caller fields to the existing complete depth0,
   output-bound gate and NTRU validation suffix.
4. Close B1.05 Acceptance, then enter B1.06. Do not relabel the deepest frame
   or suffix theorem as complete successful-solver correctness.
