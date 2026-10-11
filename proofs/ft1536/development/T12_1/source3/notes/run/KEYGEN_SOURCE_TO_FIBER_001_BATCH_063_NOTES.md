# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_063 notes

**B1.07: PARTIAL_PROOF / Acceptance NOT MET / NOT_REVIEWED.**
**Package: IN_PROGRESS / WORKING_NOT_FROZEN.**
2026-10-11, BATCH_063, MiMo V2.6 Pro (`xiaomi-token-plan-ams`).
Window: the §42R continuation — the concrete statement-chain extraction of
`SkeCellWord` along the nine pre-loop statements to the four-segment loop
entry and the first encoder call site, then the codec-persistence seam
(B1.08/09). Exactly one close this window.

## 1. Entry state (verified BEFORE edits/jobs)

```sh
mkdir -p .build/levels_063
python3 -B tools/keygen_make_certificate_premises_batch.py verify \
  5fea1a8cdf3f233aad0cce939405f8a8648d29c3cabde27f471e17984adec1c2 \
  c42e82107d9b32b049d5c13dec57fe44dc7236d4c79fcde40147e30415bff5a7 \
  .build/levels_063/ENTRY_PINS_063.json
```

- `ENTRY_PINS_063.json` (`4403201aac8e9542f6563a90ea7d7b11d8747dacbb1aed9ac0d71fa6238510aa`):
  BATCH_015-062, **12249 pinned files / 147 current source inputs**, with
  the two RECORDED 061 supersessions carried (accepted, not re-derived) and
  NO further supersession. No pin mismatch occurred.
- The first proof job (063_001) waited on a foreign lane's Lean process
  (F04 ROM review; environment race recorded in
  `.build/waits/keygen_make_ske_chain_063_001/WAIT.jsonl`), then ran.

## 2. What this window proved (NEW module)

### 2.1 `Source3.KeygenMakeSkeChain` — the concrete statement-chain extraction

The `ske` cell history along the nine pre-loop statements of the encoding
tail (the 060 `Head`/`Encoding` machine over the kernel-checked tail list):

- `chain` — the nine statements (`klen` read, `skbuf` bind, the private
  capacity test, the `skbuf[0]` header byte store, `skoff=1`, the four
  `ske[i]=...` pointer-array stores); `chain_source` ties it to
  `KeygenMakeProgram.encoding.take 9`.
- `skeName_ne_skbuf` + `mat_at_head` — the material cells survive every
  tail statement (`head_cells` on the distinct cell names).
- `bindSke_step` — ONE executed `ske[i]=...` store CREATES the cell word of
  segment `i` (`ske_word_of_bind`) and PRESERVES the earlier segments'
  words (`ske_word_of_store_frame` over the disjoint extents); word bounds
  counted in `Nat` (`k` completed stores) so the walk composes without
  arithmetic on `Fin` literals.
- `encoding_cons_normal` — a normal-flow step decomposes into its head edge
  and the remaining run (the exit edge dies on normal flow).
- `prefix_ske_chain` — THE extraction: executing the nine statements
  creates ALL FOUR words; at the four-segment loop entry every `ske` cell
  holds the LP64 word of its segment's material pointer. Nothing before the
  first store creates a word (the header store predates them all).
- `chain_words_at_loop`, `initCounter_words` — the words at the loop
  statement's entry state (`i=0` touches only locals).
- `segments_first_site` — at `i=0` the loop body executes its
  `falcon_encode_small` call site first, so the segment-0 call boundary is
  the loop-entry state.
- `first_site_history` — the `ske[0]=f` word reaches the segment-0 call
  boundary with no codec call in between.
- `first_site_liveness` — the 062 derived liveness
  (`small_site_src_live`) and source tie (`small_site_material_extended`)
  instantiated at the concrete segment-0 call site: `site.src.block∈env.live`
  and `site.src=inputOf env 0`, under the pinned explicit live-set
  extension, no readable-word hypothesis.

Accepted job: `keygen_make_ske_chain_063_005` (clean 0/0 log, no forbidden
markers). The B1.08/09 seam is stated in the module docstring as the exact
boundary; no codec outcome, exact encoded length or codec write frame
appears as a premise of any export.

## 3. Traps met (retained, with causes)

- Compact comparisons `j.val<i.val` break the parser (the lexer merges
  `val<i.val`; produces `PrincipalSeg`/unknown-identifier cascades) —
  space all comparisons (`j.val < i.val`) (063_001).
- `Encoding`/`Head` results are `Result`, not `State`: `encoding_cons_normal`
  must take `(s : State) (out : Result)` (063_001).
- `cases` on `Head` with a computed statement index
  (`Head env (skeBind i.val (skeName i)) ...`) FAILS dependent elimination
  (`i✝.1 = i.1`): invert over a VARIABLE statement plus a shape equation
  `stmt = skeBind i.val (skeName i)`, and refute the 14 non-bind cases by
  `simp [defs] at shape` (063_001-002).
- NEW trap — index-field binder naming: when a constructor field REALIZES a
  variable index of the major premise (`bindSke`'s `(s : State)` for the
  `s` index), the case binder keeps the INDEX variable's name; a renamed
  pattern binder (`sb`/`s0`) is silently unbound. Name that binder as the
  index and rename the lemma's binders instead (063_002-003, resolved 063_005).
- `KeygenMakeInvocation.zeroCapacity` — the statement defs `privkeyLenWrite`,
  `pubkeyLenRead`, `pkHeader`, `zeroCapacity`, `pubkeyLenWrite`, `retOne`
  live in `KeygenMakeInvocation`, not `KeygenMakeProgram` (063_002).
- `returnOne` never appears in a `.normal`-flow case (its edge is
  `.returned 1`): "Alternative returnOne is not needed" (063_002).
- `SmallSite` is a STRUCTURE (Type): an `∃` needs a Prop tail (`Nonempty`
  or `True`); a bare `∃ ... , SmallSite ...` does not elaborate (063_002).
- `omega` does not see through `Fin.val` literals (`↑↑⟨1, ⋯⟩` abstracted as
  an atom): count the walk bounds in `Nat` instead of `Fin` (063_002).
- Unused-tactic linter flags dead `first | exact same.1 | exact same`
  fallback — keep the single working alternative (063_004).

Retained attempts: four rejected elaboration snapshots (063_001-004) with
sealed causes; no runner aborts; one entry-time slot wait on the foreign
lane's Lean process (environment race, no source bytes). Accepted job:
`keygen_make_ske_chain_063_005`. Limits unchanged (Lean j1/-M6144,
maxHeartbeats 2000000, 0/0 streams).

## 4. Open obligations (honest, named, plan order)

1. **The survival of the cell words through the codec calls of segments 1-3
   (the B1.08/09 seam)**: the call boundaries of segments 1-3 require the
   words to survive the heap effects of the earlier codec calls. The 060
   call events carry their heap effect open (`SmallSite`'s `after`), so the
   survival is exactly the codec write-frame item: bind the codec bodies
   (`falcon_encode_small` dispatch to `compress_none`/`compress_static`,
   the public encoders) to source executions, derive their write
   confinement to the destination window, then the `ske` cells
   (block `env.blocks 5`, offsets `8*i`) lie outside every destination
   window. Known grammar gaps to close for the body binding (exact, probed
   this window): `while`/`switch` statement forms, compound assignments
   `|=`/`&=`/`<<=`, `U`-suffix numerals, pre/postfix `++` inside
   expressions (`*x++`, `++u`), and byte stores in the generic
   `C99ArrayParser`/`C99ProcedureParser` fragment (only `store64`/`store32`
   exist there). Never insert codec outcomes, exact encoded lengths or
   codec write frames as premises.
2. The B1.08/09 items in plan order: encoder/decoder body binding,
   dispatcher, q18433/logn10 branch, exact encoded lengths, persistence of
   the stored length words and source arrays through later encoder calls,
   bytewise round-trips (B1.08) and the public 15-bit packing (B1.09).
3. Batch-063 tooling continuation at the next entry: the audit producer +
   `KeygenMakeSkeChainAudit` full-terms audit, the Sage scripted PUBLIC
   controls and the 063 batch tool/seal were NOT run in this window (the
   window closed at the mandated midpoint after the accepted proof job);
   they precede any further edits and the commands are fixed by the 062
   pattern (`keygen_make_certificate_premises_audit.py`/`_batch.py`
   templates).
4. Residue pin "globals/common call ID/snapshots": an EXPLICIT identifier
   value beyond the shared derivation stays OPEN (unchanged).
5. The literal refutation status of the all-state `LegalWorkspace`
   quantifier is NOT consumed (unchanged).

These are missing source composition proofs, NOT C/numerical
counterexamples. Acceptance NOT met; Codecs B1.08/09 and B4/B5 laws stay
outside. Not a review, not a codec claim, not a law claim.
