# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_064 notes

2026-10-11, Codex. B1.07 / B1.08–09 seam.
**PARTIAL_PROOF / Acceptance NOT MET / NOT_REVIEWED.**
**IN_PROGRESS / WORKING_NOT_FROZEN.**
One recoverable midpoint at the end of this window. The resolved entry
incident was not a separate midpoint.

## 1. Entry ceremony — completed BEFORE codec edits

063 tooling was completed from the 062 templates: full audit 87 entries
(12 new + 75 inherited; 57 complete terms + 30 kernel inductives), standard
axioms only, no elisions, byte-exact producer reproduction; native Sage
PUBLIC synthetic controls, 3 families / 12 mutations detected. New failed
attempts 006 (outer sandbox bwrap denial) and 008 (Sage Integer metadata
serialization) remain with snapshots/logs. Accepted 007 audit / 009 Sage.

Strict preseal found one stale internal notes pin in the original 063
pair: JSON expected `2c06bc86…`/8212 bytes, current notes `e71f8140…`/8330
bytes after provenance annotation commit835dfc6b. All other recursive063
pins matched. Work stopped, and the owner explicitly authorized:
"Zatwierdzam korektę w suplemencie i kontynuację". The new supplement
checks both historical Git versions and records only this one notes-pin
supersession. Original JSON/notes remain unchanged. Incident history:
`KEYGEN_SOURCE_TO_FIBER_001_BATCH_064_STOP_001{.json,_NOTES.md}` and the
pinned runtime RESOLUTION/REPAIR_PROPOSAL; initial stop drafts retained.

Tooling supplement sealed:
`KEYGEN_SOURCE_TO_FIBER_001_BATCH_063_TOOLING_001.json`
SHA256 `2f84dee824ca78ba96872fba9442ec54064590380061a82ea94141539261b987`;
notes SHA256
`56980509418197aeaa69dbe8a87d251636be94c1198ce1e08a1a8b1b2e46cc7d`.
Verify then passed **12350 predecessor pins** and wrote
`.build/levels_064/ENTRY_PINS_064.json`, SHA256
`e472e2a382f5b5d4096951c4738bcc078d93d9c3cce3d62905628fae723e8c75`,
BEFORE codec source edits. First verify lacked the target directory and
wrote no receipt; the unchanged checker passed after directory creation.

## 2. Complete bound bodies and exact grammar boundary

NEW modules only; original `KeygenMakeSyntax`, `KeygenMakeSkeChain`, their
audits and predecessor bytes are unchanged. Reference input is live
`Extra/c/falcon-enc.c`, pinned SHA256
`0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05`,
and `Extra/c/falcon.h`. The generator reads neither an archived C copy nor
another worker's W. Complete source fragments retain comments/header;
the lexical witnesses are kernel equalities over those characters.

- `KeygenCodecSyntax`/`KeygenCodecGrammar`: the rejecting codec grammar
  retains `while`, unsigned U numerals, |=/&=/<<=/-=, pre/post ++/--,
  byte lvalues and both dispatch cases/default. Qualifier `const` remains
  in the type syntax. The compositional switch grammar is deliberately
  limited to the exact three returning arms in this source; the old
  monolithic statement parser is not advertised as parsing switch.
- `KeygenCodecNoneBinding`, `KeygenCodecStaticBinding`,
  `KeygenCodecDispatchBinding` and their small parts bind the COMPLETE
  compress_none, compress_static and falcon_encode_small bodies.
  Each exports `lexical_source`, `complete_tokens_source`, `source_bound`;
  all atomic statements/tests, scopes and delimiters are checked in the
  kernel. NONE/STATIC expansion is fixed to the source header's0/1.
- Syntax, body/source and audit producers reproduce current files
  byte-for-byte, recorded by GENERATOR_CHECK. The initial dispatcher
  reproduction differed only in declaration order/progress markers/line
  wrapping; its generated files and pre-fix generator remain in runtime.
  Generator formatting was corrected, with no accepted Lean byte change.

## 3. Proved frame and survival — actual premises and scope

`KeygenCodecFootprint.project` rejects unknown heap effects/calls. Complete
projection facts `none_complete`, `static_complete`, `dispatch_complete`
are kernel proofs; the getD fallback is not an assumed coverage condition.
The projection conservatively erases scalar values, guard decisions,
cursor bounds and return values, retaining all finite control paths and
all buf[index] stores. This is MEMORY-EFFECT semantics, not the full typed
value interpreter. Fixed calls execute the projected bound source bodies.
There is no arbitrary callee callback or supplied codec frame.

Actual exported type (full types/terms are in SEARCH_AUDIT):

```lean
KeygenCodecFootprint.run_frame
    (dst : ArrayPointer) (before after : Memory)
    (source : KeygenCodecFootprint.Run dst before after) :
    KeygenCodecFootprint.Frame dst before after
```

`Run` is an independent execution of the fixed projected dispatcher from
an initially unbound buf. `Frame` preserves sizes, permissions and EVERY
byte in blocks different from dst.block. buf's destination block follows
its executed declaration/buf=out binding; individual stores use the
existing StoreByte rule. `exec_frame` proves the pointer invariant and
frame together. All return paths, partial output and rejected capacity
paths are covered by this coarse semantics; no successful result, encoded
length or capacity-window frame is an input.

`load64_frame` transports word allocation and all eight initialized bytes
on any other block. `KeygenCodecSkeSurvival.word_after_call` instantiates it
at the actual destination `byteOff env.args.privkey site.skoff.toNat`.
The geometric condition private destination block != ske block comes from
executed allocation freshness plus a live external destination via
`separate_of_allocation`; it is an input-memory non-aliasing condition,
not a codec write-frame assumption.

The new `KeygenCodecSkeSurvival.Segments` records concrete call sites with
independent projected-body executions. `erase` maps it to the original
caller Segments. `call_histories` folds the derived frame through all
preceding calls: words are retained at the call boundaries of segments
1–3 (also0). `chain_call_histories` CONSUMES063's concrete nine-statement
word creation, never assumes four words at loop entry. No assumed codec
outcome, length or write-frame is introduced.

**Crucial remaining source composition:** the original caller SmallSite
still allows an unrestricted after heap. This window does NOT derive the
new body-bound trace from that old relation. Nor does it prove refinement
of full scalar/value C execution to the projection. Projected-body traces
are a genuine independently defined partial interface, not a claim that
the original entire invocation already satisfies it. Hence B1.07
Acceptance remains NOT MET. The proved write frame is a destination BLOCK
frame; confinement to the exact capacity WINDOW is still open.

## 4. Validation and retained attempts

Guarded current source steps accepted with diagnostic streams0/0;
limits unchanged j1/-M6144, AS12GiB/RSS8GiB/wall1800s, maxHeartbeats2000000.
Current complete audit: **735 entries = 721 explicitly declared source
interfaces + 14 inherited interfaces**, **711 complete terms +24 kernel
inductives**, standard axioms only, zero elisions;435065 bytes. Final job
`keygen_codec_audit_064_008` accepted both survival and audit. Survival's
cold restart took218.002s (observed file-page I/O waits); audit3.475s.
No broad replay of unchanged dependencies or independent review occurred.

Retained attempts and causes:

- 001: syntax accepted; grammar rejected reserved `at` binder; renamed
  firstTokens, 002 accepted.
- 003: source/none/static bindings accepted; own dispatcher elaboration
  stopped by TERM near the unchanged cap (exit143,748.268s); exact process
  verification/status saved in DISPATCH_STOP_003. No foreign job stopped.
- 004: explicit constructor alone still exhausted memory (INTERNAL PANIC
  out of memory,134.398s); no raised limit.
- 005: separate closed decide+kernel dispatcher atoms accepted; footprint
  rejected compact `n!=` tokenization and bind-case inversion syntax.
- 006: footprint accepted; survival rejected compact `4≤i` parsing.
- 007: user interrupted the turn after the survival step accepted1.519s;
  audit had begun, whole-job receipt absent. Raw step receipt, products,
  sources and available streams are retained, not fabricated. Rebuilt008.

Historical runner identity/session labels are preserved as provenance;
new work author is Codex. These are elaboration/resource/environment
failures, not mathematical or C counterexamples.

Native Sage PUBLIC synthetic actual-source controls are recorded by the
batch's Sage receipt/result. They compare exact ZZ-derived bit streams
and 16-bit encodings with real C normal/UBSan, including partial capacity
outputs, NULL dry-run, default dispatch, input preservation and canaries.
Finite controls do not prove projection adequacy or universal codec laws.

## 5. Exact remaining obligations, plan order

1. The missing bridge is a FULL VALUE SOURCE EXECUTION -> the fixed
   `KeygenCodecFootprint.Exec`/Run projection, with actual evaluated
   out/max_out_len/comp/q/x/logn and same before/after heap. A full typed
   codec expression/control interpreter is not yet implemented here; do
   not substitute readEffect=true or finite controls for that theorem.
2. Instantiate the body-bound call table/trace in the original whole
   invocation: derive the new `Segments` witness from actual codec body
   executions at its SmallSite boundaries, retaining observed return
   values and chronology. `erase` only supplies the reverse direction.
   Then use the proved chain_call_histories to discharge actual segments
   1–3. This gap is explicitly OPEN, never a hidden frame hypothesis.
3. B1.08 in plan order: exact capacity-window write confinement, uint32
   low-suffix accumulator invariant, post-decrement terminal ne=-2,
   independent padding, exact encoded/consumed lengths and bytewise
   segment decoder round-trips; final four-segment caller composition.
4. B1.09: public encoder/decoder bodies, canonical15-bit packing, same h,
  2880 payload bytes/header and actual emitted length; no invented
   trailing-byte rejection.
5. Inherited explicit common call ID/snapshots and all-state LegalWorkspace
   refutation status; the full B1.07/B1.10 target remains open. B4/B5 laws,
   security, compiler/OS refinement and acceptance/review are outside.

A next owner-started window verifies the sealed064 pair before edits and
resumes with item1, not with a claim of completed source codec correctness.
Small local source commits `7f862f94`,`85a7ba0b`,`9c457984`,`cb98b9bf` and
closing receipt commit; foreign S05 commits/working tree preserved.
No push, review/delegation/relay, migration, stage import or production C
change. Exactly one final midpoint, no Acceptance.

## Final control/evidence supplement

Sage011 accepted in5.881s:32 baseline cases in each of normal and UBSan
(64 total), six mutation kinds detected in BOTH modes (12 detections).
Sage009 retained: link failed on the unreachable hash-to-point function's
shake_extract dependency; function/data sections plus linker garbage
collection limited linking to the called codec graph. Sage010 retained:
the initial global shift-store mutation hit an unused public encoder;
mutators now target only the named function body. No production C changed.

A version1 computation context manifest (e5bb460c… at creation) validates
with the mathbox validator and explicit legacy provenance limitations.
The hashed custom receipts retain actual argv/isolation/caps/source
snapshots; this context record does not claim v2 before/after instrumentation
for every compiler/header input. Exact encoded lengths observed in these
finite controls are not supplied as premises to the kernel proofs.

Final self-review corrected one footprint docstring: x++ reads are
RECOGNIZED as read-only but their values/read-validity checks/local pointer
updates are ERASED, not executed by the projection. No mathematical token
or proof changed. The affected footprint/survival/audit bindings are rebuilt
under012 before sealing, so the current source has fresh exact receipts.
