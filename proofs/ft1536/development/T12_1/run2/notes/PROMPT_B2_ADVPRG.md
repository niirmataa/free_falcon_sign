# PROMPT — new window: B2/AdvPRG, the ChaCha20 stream accounting (the last named assumption)

Workspace: `proofs/ft1536/development/T12_1/run2/`. Small local commits via
`git commit --only -- <paths>`; NO push (owner signal); one Git writer at a
time (parallel lanes: B1 in `source3/`, AttemptWeights in
`formal/AttemptWeights.lean`). English crypto register in code. OWN FILES
ONLY: create `formal/AdvPrg.lean` + `notes/B2_ADVPRG_WORK_STATE.md`.
Everything else READ-ONLY. Zero unfinished-proof markers; defs-first;
guarded compiles; logs 0/0; axiom audit.

**Read first:** `notes/B4_SYNTHESIS.md` (the closing list — you own `hprg`),
`formal/Assembly.lean` + `notes/B5_WORK_STATE.md` (the exact type of
`hprg`/`AdvPRG tau` and the `tape_game_hop` hybrid you plug into),
`notes/PROMPT_KEYGEN_FIBER_B1_ADAPTED.md` §0 and `END_TO_END_SCOPE.md` D2
(route (b), decided: explicit `Adv_PRG(ChaCha20)` term, no silent
idealization), pinned source `Extra/c/frng.c`
(sha256 `4b1289adf0c902abe9408d989b4eb8d292cbb6ea86b92e1325a10fd9c5dfc644`).

## Goal — make `hprg` the LAST, smallest, named assumption

The assembled theorem takes `hprg : AdvPRG S <= deltaPRG` with `tau :
Law (Fin S.bits -> Bool)` the tape law. Your job is NOT to prove ChaCha20
secure (impossible) — it is to shrink the assumption to its canonical
standard form and bind everything around it:

1. **Model the real stream**: the pinned `frng.c` semantics (ChaCha20
   stream, SHAKE-256 seeding over `/dev/urandom` + user seed) as the tape
   law `tau`. Source-bound in the B3/VerifyBind style (cite exact lines:
   the generator block, the seeding chain, the counter/block structure).
   Compute the exact tape consumption `S.bits` per sampler call and the
   total consumption over `beta`-budget games (the security parameter of
   the PRG claim!).
2. **The standard assumption as ONE named predicate** (the
   `UniformChallenge` pattern): `ChaCha20PRFBound (tau : Law (Fin n -> Bool))
   (delta : ℝ)` in the standard distinguishing-game form against the
   uniform tape — with the seeding reduction chain noted (SHAKE-256 +
   `/dev/urandom` = A2 territory; state what the seed boundary assumes).
3. **The composition**: prove `hprg` follows from
   `ChaCha20PRFBound tau deltaPRG` exactly (it should be nearly immediate
   once both are stated correctly — the point is the SHAPE), and plug it
   into `Assembly.assembled_hardness_substitution`'s consumer.
4. **The honest ledger**: what this assumption costs in the final claim
   (the bound is CONDITIONAL on standard PRF security of ChaCha20 at the
   stated consumption), why route (a) is closed (statistical distance of a
   ChaCha20 stream from uniform is ~1 at real lengths — cite the recorded
   D2 finding), and what a future ideal-PRG theorem would gain.

## Deliverables

`formal/AdvPrg.lean` (0/0 + axiom audit), `notes/B2_ADVPRG_WORK_STATE.md`
per batch, Polish handoff summary: the final assumption statement (one
sentence + one predicate name) and the consumption numbers.
