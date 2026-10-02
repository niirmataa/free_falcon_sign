# PROMPT — new window: B5 assembly skeleton (`end_to_end_assembled_theorem_statement`)

Workspace: `proofs/ft1536/development/T12_1/run2/`. Small local commits via
`git commit --only -- <paths>`; NO push (owner signal); one Git writer at a
time. English crypto register in code. OWN FILES ONLY: create
`formal/Assembly.lean` + `notes/B5_WORK_STATE.md`. Everything else
READ-ONLY (parallel lanes: `formal/AttemptPointwise.lean` may appear,
`source3/` is B1's active lane). Zero unfinished-proof markers; defs-first;
guarded compiles; logs 0/0; axiom audit your module.

**Read first:** `END_TO_END_SCOPE.md` (Section 1 — THE target statement,
decisions D1-D3, A1-A5), `notes/B4_SYNTHESIS.md` (the packaged
`localJointCertificate_of_attemptFactor` and its remaining arguments),
`formal/HacGlue.lean` + `formal/ONoneGeometry.lean` (what is discharged),
`formal/Run2/ConcreteReduction.lean` (the assembled conditional reduction
you instantiate), `notes/S3_E_PROVENANCE.md` (the accounting identities).

## Goal — the final theorem skeleton, complete except its named premises

State and prove `end_to_end_assembled_theorem_statement`: the Section-1
bound of the scope

    AdvEUF beta muKey A
      <= min 1 (epsColl beta + EventTransfer.phi ((1+e)^beta.qs - 1)
                  (AdvMT (beta.qh+1) (SigmaMath.muH muKey)
                     (Reduction.build beta A S)))
        + AdvPRG

with, as EXACTLY named arguments (nothing else — the axiom audit and an
`#print`-style argument list must make this evident):

1. `huc : UniformChallengeAt S` (B3/X; the single ROM assumption);
2. `hshape : ReplyShapeAt S jatt` (B1/source3 — in progress);
3. `hattempt : AttemptPointwiseAt jatt k` (the two named analytic bounds —
   in progress) -> `e = k^32 - 1` via `localJointCertificate_of_attemptFactor`;
4. `hkey : emitted-key law identification` — the interface of B1.10's
   `emitted_to_actual_fiber` (take its exact type as a named parameter;
   B1 delivers the content);
5. `hprg : AdvPRG S <= deltaPRG` — the D2-route-(b) seam: the
   `Games.Sampler.code` runs on a fair uniform tape
   (`Law.uniform.map`), the real system on the ChaCha20 stream
   (`Extra/c/frng.c`, SHAKE-256 seeding). Model `AdvPRG` as an explicit
   additive term: prove the hybrid lemma `AdvEUF(real stream) <=
   AdvEUF(uniform tape) + deltaPRG` (the standard game-hop shape at the
   tape law; state it as a named law-level lemma over
   `Dist`/`Law` comparisons) and let the outer bound carry `deltaPRG`;
6. the operational assumptions stay as explicit hypotheses where they
   bite (A1-A5 style) — cite their scope names.

Also prove the `exists_concrete_reducer`-style export (the reducer is
`Reduction.build beta A S`) and the `concrete_hardness_substitution`-style
corollary (plug an `AdvMT` bound epsilon).

## Traps and rules

- Do NOT assume `solver_correct`, serializer correctness, certificate
  acceptance, or any B1/B4 content beyond the named parameters above.
- The key law is the D1 CONDITIONAL law (per-attempt conditioning,
  `1/p_accept` accounting is already resolved — cite, don't redo).
- `e` is the SIGN sampler's chi-square constant (`second <= 1+e`), NOT a
  key-law constant (S3 correction — keep the roles straight in the
  statement).
- Workstate lessons: `field_simp` closes field identities alone; `sum_div`
  direction; `show` before `rw` on beta/def forms; annotated `have` for
  `Finset.sum_le_sum`; no long inline expressions.

## Deliverables

`formal/Assembly.lean` (0/0 + axiom audit + the printed argument list),
`notes/B5_WORK_STATE.md` per batch, Polish handoff summary: the FINAL
argument list of the assembled theorem (= the closing checklist of the
whole project) and what each argument's owner still owes.
