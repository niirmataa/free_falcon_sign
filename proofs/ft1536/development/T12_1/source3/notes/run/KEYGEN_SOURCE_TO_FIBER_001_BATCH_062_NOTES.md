# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_062 notes

**B1.07: PARTIAL_PROOF / Acceptance NOT MET / NOT_REVIEWED.**
**Package: IN_PROGRESS / WORKING_NOT_FROZEN.**
2026-10-11, BATCH_062, MiMo V2.6 Pro (`xiaomi-token-plan-ams`).
Window: the §41R continuation — (a) the `invocation_certificate`
premise repair (reachable states instead of the all-state quantifiers),
then (b) the derived call-site liveness `site.src.block∈env.live` from the
`ske` cell history. B1.08/09 NOT entered. Exactly one close this window.

## 1. Entry state (verified BEFORE edits/jobs)

```sh
mkdir -p .build/levels_062
python3 -B tools/keygen_make_loop_chronology_batch.py verify \
  17868bb652d0b3e90c2ca72f800348adbe720d014c9a775f541c2dab6be23f65 \
  65b23cf70ebd09d9f82cdddc50967d5e951cb4d68191f8e9ee3bf62fa1ddeb67 \
  .build/levels_062/ENTRY_PINS_062.json
```

- `ENTRY_PINS_062.json` (`e6f33de2b0bdf4172750eea00c9af550b88b73cdf14d629ab508b82082ad7a54`):
  BATCH_015-061, **12164 pinned files / 333 current source inputs**, with
  exactly the two RECORDED supersessions (the 061 VirtualLegal repair of
  `KeygenMakeInvocation.lean` and its cache artifact) and no further
  supersession. The 062 batch tool ACCEPTS the recorded `superseded` map.
- The first verify attempt hit the global `job.active()` guard on the
  parallel S05 lane's Lean process (environment race, no source bytes);
  re-run per the handoff note. No pin mismatch occurred.

## 2. What this window proved (NEW modules)

### 2.1 `Source3.KeygenMakeCertificatePremises` — the premise repair

The 060/061 `invocation_certificate` consumed the two global quantifiers

    (dimensions : (s : State) → KeygenMakeSearchPrefix.Dimensions s)
    (workspace  : (s : State) → KeygenMakeCertMaterial.LegalWorkspace s env.ctx)

The first is UNSATISFIABLE — `empty_locals_not_dimensions` /
`no_global_dimensions` (kernel, in-module) refute it exactly as the S05
cross-lane witness `GlobalDimensionsObstruction017.lean` (commit
`ef354c48`, pinned READ-ONLY, never imported) — so the success branch was
vacuous. The repair replaces both with reachable-state derivations:

- `attempt_gate_dimensions` — THE attempt-level `Remaining` transport to
  the certificate-gate state: the sampled prefix of a `throughCertificate`
  attempt carries `Remaining out.state (i+1)`, so `Dimensions raw.state`
  holds at the gate state (`sampled_remaining`, `.2.1.2.1`).
- `attempt_gate_reachable` — on the accepted break of one attempt the
  gate call exists (`accepted_break_requires_call` under the derived
  `Profile`), with `Dimensions` DERIVED and `Initial`/`EntryFrame`
  transported to the gate state (`sampled_entry`). Early five-gate
  rejections die on the flow equation.
- `loop_gate_reachable` — the loop-fold on the successful edge of a whole
  `LoopTrace`: rejected attempts chain to the accepted final attempt,
  carrying `Remaining` (advanced per attempt), `Initial`/legal/static
  facts and the automatic-object space to the final attempt's gate state.
- `space_of_frame` — `C99Automatic32.Space` (a function of the block-0
  heap size) transports along `EntryFrame.sizes`.
- `gate_workspace` — the reachable-state derivation of `LegalWorkspace`:
  transported scratch legality + space + the gate bind's OWN bridge field
  (`KeygenMakeCertMaterial.workspace_scratch_block` fixes
  `ctx.scratch.block=0` per bind — never assumed) + the allocation
  `Shape` → `legalWorkspace_of_shape`. No quantifier over states.
- `invocation_certificate_reachable` — the decomposition-level repaired
  export: the accepted certificate call and its complete `CertPackage` at
  the gate call of THIS invocation; premises = reachable entry facts
  (`KeygenMakeEntry.Original` + `C99Automatic32.Space` at the
  readiness-prefix boundary, supplied by `entry_of_allocation`/
  `entry_dimensions`/`entry_remaining` over the pinned prologue), the
  workspace `Shape`, the named `CertEntryFrame` residual and the loop
  chronology. The loop chronology/`TailCells` of
  `Source3.KeygenMakeLoopChronology` are consumed, never re-derived by
  assumption.
- `invocation_certificate_of_entry` — the whole-invocation level: given
  `Invocation` + success + the reachable entry facts at the invocation's
  own readiness-prefix boundary (achievable: the executed prologue), the
  same conclusion; the `capped` edge dies on `close_flow`/`abortFlow`.

Every remaining premise class is reachable and achievable; no all-state
quantifier, no codec outcome, no exact encoded length and no codec write
frame appears as a premise.

### 2.2 `Source3.KeygenMakeSkeCells` — the cell history and derived liveness

- `SkeCellWord env i s` — the write-then-read content of the `ske` cell of
  segment `i` (the LP64 word of the material pointer `inputOf env i`).
- `load64_of_store_frame` — a 64-bit load survives any store whose byte
  extent misses the loaded cell (the `Store64` byte-extent frame).
- `skeElem_disjoint` — distinct `ske` cells (offsets `8*i`) have disjoint
  byte extents.
- `ske_word_of_bind` — the executed `ske[i]=...` store CREATES the cell
  history at the post-store state (write-then-read with the material cell
  of `TailCells.material`).
- `ske_word_of_store_frame` — foreign `ske` stores preserve the cell word.
- `small_site_src_live` — THE derived call-site liveness: from the cell
  history and the PINNED explicit live-set extension
  (`VirtualLegal (site.src.block::env.live) env.vb` — the 061 module's own
  prescription "consumers needing a further block extend the live set
  explicitly"), the word round-trip decides the read pointer
  (`canonical_word_eq` on the extended set) and
  `site.src.block∈env.live` FOLLOWS from `inputOf_mem_live`. The 061 side
  condition is no longer a hypothesis.
- `small_site_material_extended` — the source tie
  `site.src=inputOf env i` under the same derived premises (no
  readable-word hypothesis).
- `small_site_legal_exists` — achievability witness of the extension class
  (`virtualLegal_identity`/`virtualLegal_exists` on the extended list).

Word-level aliasing outside the live set is real (`VirtualLegal` leaves
such blocks unconstrained), so the live-set extension is EXPLICIT and
required — never hidden in the decode.

## 3. Entry pins, audit, controls

- Entry pins 015–061 **12164 pins** verified with the sealed 061 pair
  (`17868bb6…`/`65b23cf7…`) into `.build/levels_062/ENTRY_PINS_062.json`
  (`e6f33de2…`) BEFORE edits.
- One proof+audit 0/0: **82 entries = 17 new declarations + 65 inherited
  interfaces** (`KeygenMakeCertificatePremises`: 9 declarations incl. the
  kernel trap record; `KeygenMakeSkeCells`: 8); full terms + kernel
  inductives, standard axioms (`propext`/`Classical.choice`/`Quot.sound`),
  ZERO elisions; `⋯`-free full-term audit (SEARCH_AUDIT + JSONL).
- Native Sage scripted PUBLIC controls
  (`sage/check_keygen_make_certificate_premises.sage`): 5 families × 4
  mutations, all detected (EXPLICIT MOCK SEMANTICS; the transcription
  family reads the reference C certificate-gate/encoding-tail region:
  `ft_keygen_leaf_certificate`, the `ske[0..3]=f,g,F,G` bindings, the
  four-segment loop and the `*privkey_len = skoff` tail store; no real
  KeyGen/solver/certificate/codec, no law claim).

## 4. Traps met (retained, with causes)

- `cases` index-filling binders bind NOTHING: the `gateOut` slot of
  `AttemptExec.throughCertificate` and the `h`/`p` slots of `Load64.load`
  are result indices — names there are discarded; use the theorem's
  index variable (attempt 001/002, retained).
- `KeygenMakeCertMaterial.workspace_scratch_block` (not
  `KeygenMakeCertCall.*`) hosts the bridge-field block numbering (001).
- `⟨s with heap := after⟩` is invalid anonymous-constructor syntax — the
  structure update form is `{s with heap := after}` (002).
- `List.mem_cons_self`/`List.mem_cons_of_mem` take implicit arguments in
  this Mathlib closure; use `List.mem_cons.mpr` (003).
- Unused signature binders trip the linter (001): dropped `caller` from
  the decomposition-level export and reduced the entry premise to the
  reachable `Prefix`-conditioned arrow form.

Retained attempts: three rejected elaboration snapshots (062_001,
062_002, 062_003) with sealed causes; no runner aborts, no guard
rejections beyond the entry-time environment race (recorded above).
Accepted jobs: `keygen_make_certificate_premises_062_002` (premises
module), `keygen_make_ske_cells_062_004`, `..._audit_062_005`,
`..._sage_062_006`. Limits unchanged (Lean j1/-M6144, maxHeartbeats
2000000, 0/0 streams; Sage preparser).

## 5. Open obligations (honest, named, plan order)

1. The concrete statement-chain extraction of `SkeCellWord` at the four
   call sites (the nine pre-loop statements reaching the four-segment loop
   entry) and the persistence of the cell words through the earlier codec
   calls of segments 1–3 — the codec write-frame item (B1.08/09). The
   store-level creation/transport and the derived liveness are closed
   here; the chain tie and the codec persistence are its two remaining
   legs.
2. The codec bodies and their write frames (B1.08/09): the exact encoded
   lengths, the persistence of the stored length words and of the source
   arrays through later encoder calls, and the bytewise round-trips.
3. Residue pin of "globals/common call ID/snapshots": instantiated and
   tied to the same invocation (060/061); an EXPLICIT identifier value
   beyond the shared derivation stays OPEN with its intended shape.
4. The literal refutation status of the all-state `LegalWorkspace`
   quantifier is NOT consumed: the repair replaces it with the reachable
   derivation `gate_workspace` either way.

These are missing source composition proofs, NOT C/numerical
counterexamples. Acceptance NOT met; Codecs B1.08/09 and B4/B5 laws stay
outside. Not a review, not a codec claim, not a law claim.
