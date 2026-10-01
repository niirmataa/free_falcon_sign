# PROMPT — new MiMo window: rung B3, verify-path binding (`verdict = Relation.Verify`)

Workspace: `proofs/ft1536/development/T12_1/run2/` (confirmed working
directory). Small local commits; **push only after an explicit owner
signal**; one Git writer at a time (coordinate commit windows with the
owner — other lanes commit too). Commit messages in English, standard
cryptography register. WORK_STATE (notes/GAME_BINDING_WORK_STATE.md)
updated per batch.

**Read first:** `proofs/ft1536/development/T12_1/END_TO_END_SCOPE.md`
(pin: commit 1ec29f7b or the later HEAD — record which) — the binding
target shape (decisions D1-D3 incl. the D1 refinements, assumptions A1-A5,
the missing-implication ladder B1-B5) — and
`notes/GAME_BINDING_WORK_STATE.md` (hard working rules + the known-traps
list: `neg_mul` direction, `rw` vs defeq-typed sides, `funext`/`show`,
per-piece casts, `open` lists, `subst` before `simp`, no extra tactics).

**File ownership (avoid conflicts):** create and edit ONLY your own new
files under `formal/VerifyBind/`, `sage/` (new names) and your own notes
entries. Treat `formal/ConvStruct.lean`, `formal/FinalDelta.lean`,
`formal/ConvolutionCert.lean`, `formal/FinalTails.lean`, all of
`formal/Run2/` and `source3/` as READ-ONLY dependencies.

## Goal — rung B3 of the ladder (game/implementation binding, Verify side)

Prove, kernel-side, that the real C verify path IS the formal verifier:

1. **`verdict = Relation.Verify` (assumption A3 becomes a theorem):** for
   all byte inputs `(pkBytes, msg, sigBytes)` in the pinned profile, the C
   verifier `falcon_vrfy` accepts iff `Relation.Verify` holds of the
   decoded key material and signature. Malformed inputs must be covered:
   decoder rejection on malformed bytes is a modeled outcome (no UB, no
   silent success).
2. **Signature serialization round-trip (assumption A4, signature side):**
   encode/decode of the compressed hint format (`falcon-enc.c` signature
   codec) is injective and consistent with what `falcon-sign.c` produces
   and `falcon-vrfy.c` consumes.
3. **Clean split with rung B1** (source3/Astra, see the cross-lane map in
   the scope): key-material encoding/decoding (sk/pk) is Astra's (source3); the
   signature/hint path and the verdict function are THIS window's. Do not
   duplicate key-codec lemmas; consume hers once they land.

## Pinned sources (byte-exact; do not substitute live edits)

- `Extra/c/falcon-vrfy.c`  sha256=3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42
- `Extra/c/falcon-enc.c`   sha256=0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05
- `Extra/c/falcon-sign.c`  sha256=eee8d7dc503e007cb76bcc157094b2a2de481075ac3f67426848f7a8cae6efd8
  (producer-side reference only — the sampling law itself is rung B4,
  out of scope here)
- `Extra/c/falcon.h`       sha256=657ad2b2d45b8932c3b9a703ac718c1f23dad78523036c1a934b8e21cf0f4519
- `Extra/c/internal.h`     sha256=512629d3b79fa5bd74131ed2ecde06e1d157f5ac58db3f758db96b19131f1ba5

## REUSE (read-only, pinned; do not build parallel models)

- `Run2/ByteMachine`, `Run2/FileVerifier`, `Run2/FileArithmetic`,
  `Run2/VerifierAllocation` (byte/memory semantics of the verify path);
- `formal/FftBind/*` (FftGeometry, FftPin, FftSemantics, NttSemantics);
- `FT1536.Relation` from the committed stages (the `Relation.Verify`,
  `Relation.A h`, `Relation.Rq` names) — reference the stage bytes, never
  copy a second ring model (same rule as the B1 package);
- `Run2/RawProductLaw` (`blockDecode`/`Geometry.block`) for key-material
  shape where needed.

## First step (do this before proving anything)

Write the EXACT final type into your live notes and let it drive the work
(discipline from the B1 package). Suggested shape — adjust names to the
real ones, do not invent a parallel model:

    for all pkBytes msg sigBytes in the pinned profile:
      legal memory, source execution of falcon_vrfy
        -> (verdict bytes = true <-> Relation.Verify (decode pkBytes)
              msg (decodeSig sigBytes))

plus the two round-trip lemmas (encoder/decoder consistency, injectivity)
and a decoder-totality lemma (every byte string yields either a decoded
object or a modeled reject — no third outcome). Success/verdict must come
from source semantics and observed bytes, never be defined through the
expected theorem.

## Hard rules (non-negotiable)

1. ZERO `sorry`/`admit`/`native_decide` — **including placeholders in
   drafts**; drafts live in the conversation, never in the file. On any
   garbage in an edit: restore the clean state immediately.
2. No long inline expressions in theorem statements: define helpers (`def`)
   first, then small pointwise identities, then compose (see WORK_STATE).
3. Compile serially through `tools/original/run_lean_guarded.sh` (it waits
   for free CPU windows; the lanes share the machine); grep for forbidden
   tactics before EVERY compile; logs 0 err / 0 warn (error counter must
   match `error(\(|:)`).
4. Sage via `sage <file>.sage` with asserts (only if numeric work appears);
   exact ZZ/QQ or rigorous intervals.
5. Tests are not proofs: public synthetic inputs only, no secret reads, no
   real key generation, no production signing.
6. If a real blocker appears: record the exact missing type, dependencies
   and the attempt result; continue other parts of the package; never turn
   a blocker into an assumption or a scoped PASS.

## Deliverables

1. `formal/VerifyBind/*.lean` — the verdict-equivalence and round-trip
   lemmas in small verified steps, 0/0 logs, standard axioms only.
2. Your own WORK_STATE entry per batch (what closed, what remains, the
   source/model boundary).
3. Handoff summary in Polish for the owner: what is actually shown, what
   stays open, what it changes for the end-to-end ladder (rung B3 status).

Coordination: report milestone state to the owner; the B5 assembly
consumes your `verdict = Relation.Verify` together with Astra's B1 and the
B4 certificate. Do not start reviewers/subagents/new sessions yourself.
