# PROMPT — new window: B4/1, marginal-joint decomposition and the joint-bounds constructor

Workspace: `proofs/ft1536/development/T12_1/run2/`. Small local commits via
`git commit --only -- <paths>`; NO push (owner signal), one Git writer at a
time. English crypto register in code. OWN FILES ONLY: create
`formal/JointDecomp.lean` (+ own notes entry `notes/B4_JOINT_DECOMP_WORK_STATE.md`).
Everything else READ-ONLY (esp. `formal/SecondMoment.lean`, `formal/VerifyBind/*`,
`formal/Run2/*`). Zero unfinished-proof markers incl. placeholders; defs-first;
guarded compiles via `tools/original/run_lean_guarded.sh`; logs 0/0.

**Read first:** `notes/S3_E_PROVENANCE.md` (the B4 composition plan — your
deliverables are its "next kernel pieces" 1-2), `formal/SecondMoment.lean`
(the toolkit you build on: `second_le_of_pointwise`, `second_joint_le`,
`LawCond`/`second_cond_le`, `localJointCertificate_of_pointwise`),
`notes/GAME_BINDING_WORK_STATE.md` (hard rules + traps list).

## Goal

1. **Marginal-joint decomposition**: every `Law (α × β)` equals
   `Divergence.joint (p.map Prod.fst) (fun x => conditional of p on x)`
   — define the conditional family (with the zero-mass case handled by an
   explicit fallback law, `Law.pure`-style; document the choice) and prove
   the decomposition identity.
2. **Second transport across the decomposition**:
   `second p (Divergence.joint k l) = second (p.map Prod.fst) k * (1 + e)`-style
   relation via the pinned `Divergence.joint_chi2` — exact identity first,
   inequalities as corollaries.
3. **`localJointCertificate_of_joint_bounds`**: a constructor consuming two
   layer bounds directly — if the sampler's challenge marginal is within
   `(1+d1)` of `Law.uniform` (or satisfies `UniformChallenge` from
   `formal/VerifyBind/HashTo.lean` for the exact case `d1 = 0`) and each
   per-challenge reply law is within `(1+d2)` of `FT1536.SigmaMath.freshHonest`'s
   conditionals, then `FT1536.Run2.LocalJointCertificate S ((1+d1)*(1+d2)-1)`.
   Binder types: infer from `FT1536.Run2.samplerLaw`'s signature (see the
   pattern in `SecondMoment.localJointCertificate_of_pointwise`).

## Key type facts (verified; do not re-derive)

- `Law α := {mass; nonneg; total : ∑ x, mass x = 1}` (FT1536.Basic),
  `Law.event p E = ∑ x, if E x then p.mass x else 0`, `Law.map`, `Law.bind`,
  `Law.pure`, `Law.uniform`.
- `Divergence.second j p = ∑ x, j.mass x^2 / p.mass x`; `AC j p :=
  ∀ x, p.mass x = 0 → j.mass x = 0`; `Divergence.joint j l` (product law);
  `Divergence.joint_chi2 : second (joint j l) (joint p k) =
  ∑ x, (j.mass x^2/p.mass x) * second (l x) (k x)`.
- `FT1536.Run2.samplerLaw S h st m r := Law.uniform.map (S.code h st m r)`;
  `LocalJointCertificate S e := {nonnegative; ac; moment}` (LawBinding.lean:33).
- `SigmaMath.freshHonest h = honestJoint (syndrome h) =
  Divergence.joint Law.uniform (signBody (syndrome h))` (Model.lean:16);
  `signBody A c = (MathSign.cap (trial A c) 16).map (MathSign.emit emit)`.

## Traps (from WORK_STATE)

`field_simp` closes field identities alone (no `ring` after); `sum_div` runs
quot-of-sums = sum-of-quotients (folding needs `.symm`); annotated `have`
for `sum_le_sum`; `show` the unfolded form before `rw` on goals with
beta/def forms; `rw` rejects defeq-typed sides (use `Eq.trans`/`exact`);
LawCond-style definitions need the positive-mass hypothesis.

## Deliverables

`formal/JointDecomp.lean` (0/0), own WORK_STATE entry per batch, Polish
handoff summary (what shown / what assumed / what B5 gets).
