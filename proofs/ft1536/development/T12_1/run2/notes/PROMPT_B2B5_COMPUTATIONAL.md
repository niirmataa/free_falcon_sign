# PROMPT — new window: B2/B5 computational fix (the last conceptual seam)

Workspace: `proofs/ft1536/development/T12_1/run2/`. Small local commits via
`git commit --only -- <paths>`; NO push (owner signal); one Git writer at a
time (parallel lane: B1 in `source3/`). English crypto register in code.
OWN FILES ONLY: create `formal/CompPrg.lean`, `formal/AssemblyComp.lean`,
`notes/B2B5_COMPUTATIONAL_WORK_STATE.md`. Everything else READ-ONLY
(including `AdvPrg.lean` and `Assembly.lean` — you IMPORT and extend, never
edit). Zero unfinished-proof markers; defs-first; guarded compiles; logs
0/0; axiom audit.

**Read first:** `notes/PROMPT_B2_ADVPRG.md` + `notes/B2_ADVPRG_WORK_STATE.md`
(the current seam and its recorded caveats), `formal/AdvPrg.lean`
(`ChaCha20PRFBound`, `distinguishingAdv`, `route_a_closed`,
`chacha20PRFBound_delta_ge`), `formal/Assembly.lean` (`AdvPRG = TV`,
`tape_game_hop` family, `end_to_end_assembled_theorem_statement` and the
seam `hbase.trans (le_add_of_nonneg_right hseam)`), and the independent
review in the owner's hands (2026-10-06) — its diagnosis is VERIFIED
against the code and is your contract.

## The two verified gaps this window closes

1. **Statistical quantifier in a computational claim.** `ChaCha20PRFBound`
   quantifies over ALL events (`distinguishingAdv` = point TV distance) —
   and `chacha20PRFBound_delta_ge` proves any valid `delta` on the real
   tape is `>= 1 - 2^448/2^n` (~1 at real `n`). The predicate is therefore
   VACUOUS for small `delta` on the real stream. The B2 note's
   "computational reading" is a comment, not a quantifier.
2. **The PRG term is appended, not hopped.** The final proof adds
   `0 <= deltaPRG` to the RHS of the ideal-game bound; the LHS experiment
   (`Games.AdvEUF`) never changes tape. The `tape_game_hop*` lemmas are not
   chained into the export.

## Goal — one named computational assumption + one real game, honestly
connected

1. **`CompPRGBound` (the `UniformChallenge` pattern, computational
   shape):** a predicate quantifying over an ADMITTED CLASS of tests, e.g.
   `CompPRGBound (C : Set ((Fin n -> Bool) -> Prop)) (tau) (delta) :=
   forall E in C, distinguishingAdv tau E <= delta`, where `C` is the
   cost-bounded class (a PARAMETER — no Turing machines). The class shape
   must support exactly what the hop needs: membership of the game's
   winning event for a composed adversary, stated as a NAMED PREMISE with
   resource accounting (cost of the composed test <= T(A) + q * cost of one
   ChaCha20 block — record the accounting shape, do not invent a cost
   model beyond what the seam needs).
2. **The real game on the LHS, the hop CHAINED:** define the tape-parametrized
   EUF game (`Games.AdvEUF` with the sampler law mapped through `tau` — the
   `Law.uniform.map` seam of `Games.Sampler.code` is already understood),
   and prove the hop `AdvEUF_stream tau A <= AdvEUF A + CompPRG-term` by
   applying the existing `tape_game_hop_abs` to the WINNING EVENT of `A`
   (membership in `C` as premise). Then re-export the assembled bound with
   the real-stream game on the LHS and `deltaPRG` arriving VIA THE HOP.
   The old export stays as the abstract shape (do not touch `Assembly.lean`).
3. **The Phi inversion, kernelized.** The repo's `Phi` bounds EUF advantage
   FROM MT-ISIS advantage. Export the inverse direction actually needed by
   the security claim: `Adv_MT(B) >= f(epsilon_real, D, deltaPRG, ...)`.
   Derive the EXACT inversion from the repo's `Phi` (the review's
   `max{0, a - sqrt(D*a*(1-a))}` is a hypothesis to check, not a given).
   Also export the boundary fact `Phi(D, 0) = D/(1+D)` style sanity if not
   already present.
4. **Scope/notation cleanup, recorded:** `n = beta.qs * S.bits` (`beta.qs`
   is a record FIELD — the notation `beta.qs * S.bits` is not a product of
   two multipliers); the per-call tape width `S.bits` vs the whole-run
   horizon — join them in ONE game definition (whole-run tape law with
   per-call projection, or an explicit horizon-level assumption — choose
   the cleanest exact form and record the choice). Keep all TV lemmas and
   `route_a_closed` (they are the recorded death of the statistical route).

## Honesty rules specific to this task

- Do NOT derive small TV from the computational assumption (impossible —
  `route_a_closed` proves it). The hop works at winning-probability level
  for the admitted class only.
- Do NOT weaken `CompPRGBound` to the unbounded form to "make proofs go
  through". If a step genuinely needs a class-closure fact, state it as a
  named premise with its exact type.
- The seed/SHAKE boundary (A2) and the byte bridge (A3/A4) stay outside,
  as recorded. `keyIdent` stays the exact-type slot (B1.10 owns it) — but
  in the new export, USE `hkey` structurally (the statement must not be
  instantiable by `True` without changing meaning: keep the slot, bind the
  consumer so that the final identification is the ONLY free point).

## Deliverables

`formal/CompPrg.lean` + `formal/AssemblyComp.lean` (0/0 + axiom audits),
`notes/B2B5_COMPUTATIONAL_WORK_STATE.md` per batch, Polish handoff: the
final assumption sentence (one predicate name + one resource line), the
chained-game statement, the inverted Phi formula (exact), and what a
reader of the public description may now honestly claim.
