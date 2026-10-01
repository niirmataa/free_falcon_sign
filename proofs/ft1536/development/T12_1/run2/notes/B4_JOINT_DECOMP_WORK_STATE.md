# B4/1 — marginal-joint decomposition and the joint-bounds constructor

Task: `notes/PROMPT_B4_JOINT_DECOMP.md` (window B4/1; prompt goals 1-3 of its
`## Goal`, i.e. "next kernel pieces" 1-2 of the plan in
`notes/S3_E_PROVENANCE.md`). Recorded 2026-10-01.

Own files only: `formal/JointDecomp.lean` + this entry. Everything else
read-only.

## Status

- `formal/JointDecomp.lean` — final build **0/0** (guarded runner
  `tools/original/run_lean_guarded.sh`, empty log, no `sorry`/`admit`/
  `native_decide`, standard axioms only; olean
  `.build/check_lib/JointDecomp.olean`).
- Batch of 2 source commits + this notes commit on `main`, no push (owner
  signal):
  - `6a5e4c45` — decomposition + second transport;
  - `6e343ace` — `localJointCertificate_of_joint_bounds` constructor family.
- Subagent batch review (2026-09-30 rhythm): verdict NEEDS_FIXES — 13 minor
  wording/name/markup findings, no formula or text-vs-code mismatches; all
  fixes applied to both files in the follow-up commit.

## What is in the kernel now (all on the pinned types)

1. **Marginal-joint decomposition** (prompt goal 1):
   - `fallbackLaw := Law.pure (default : β)` — the documented fallback for
     the zero-mass case (any fixed law works since the marginal factor is
     zero there; a `Law.pure`-style choice keeps it a genuine law with total
     mass one and no normalization argument);
   - `marginal p := p.map Prod.fst` (+ `marginal_eq`, `marginal_mass`), and
     the conditional family `condOf p x` with the two mass forms
     `condOf_mass_of_pos` / `condOf_mass_of_zero`;
   - `law_ext` (law equality from mass equality), `decomposition_mass` and
     **`decomposition : Divergence.joint (marginal p) (condOf p) = p`**;
   - `marginal_joint` and `condOf_joint` (a joint law decomposes back into
     its two factors; fallback never engaged at positive marginal mass).
2. **Second transport** (prompt goal 2), through the pinned
   `Divergence.joint_chi2`:
   - `second_self : Divergence.second p p = 1`;
   - **`second_eq_of_decomposition`** — the exact identity
     `Divergence.second q p = ∑ x, ((marginal q).mass x ^ 2 / (marginal p).mass x) * Divergence.second (condOf q x) (condOf p x)`;
   - `second_le_of_layers` — layer bounds `1 + e1` / `1 + e2` (given
     `0 ≤ 1 + e2`) compose to `(1 + e1) * (1 + e2)` (inequality corollary);
   - `second_joint_transport` / `second_joint_transport_le` —
     `Divergence.second q (Divergence.joint k l) = Divergence.second (marginal q) k * (1 + e)`
     (exact, when the conditional ratio is constant) and its `≤` form.
3. **Joint-bounds constructor** (prompt goal 3):
   - `honestReply h c := FT1536.PublicSimulation.signBody (FT1536.SigmaMath.syndrome h) c`, with
     `freshHonest_eq_joint` (pinned joint form of `SigmaMath.freshHonest`)
     and `freshHonest_condOf` (`honestReply h c` IS the conditional of
     `freshHonest h` at `c`), `uniform_mass_pos` + `ac_uniform`;
   - **`localJointCertificate_of_joint_bounds`**:
     `FT1536.Run2.LocalJointCertificate S ((1+d1)*(1+d2)-1)` from the two layer
     bounds (challenge marginal vs `Law.uniform` in `second`; per-challenge
     conditional vs `honestReply h c` in `second`) plus the support/AC part
     of layer 2 (`hac`) as an explicit premise — a pure second-moment bound
     does not see points where the honest mass is zero;
   - `localJointCertificate_of_uniform_challenge` — the exact case `d1 = 0`
     with `FT1536.VerifyBind.UniformChallenge` on the challenge marginal
     gives `e = d2`;
   - `localJointCertificate_of_pointwise_bounds` — the per-pointwise
     shortcut `e = (1+d1)^2 * (1+d2)^2 - 1`, with AC for free from
     `SecondMoment.ac_of_pointwise`.

Binder types follow `FT1536.Run2.samplerLaw`'s signature
(`h : FT1536.Relation.Rq`, `st : FT1536.Run2.State`,
`m : FT1536.Run2.Bytes`, `r : FT1536.Run2.Nonce`).

## What Layer 2 and the B5 assembly get

The delta -> e bridge is now a pure two-layer obligation: prove the layer-2
bounds (`second (condOf (samplerLaw S h st m r) c) (honestReply h c) ≤ 1 + e2`
and its AC part) for the concrete sampler, and layer 1 from the hashTo/ROM
interface (B3/X `HashTo`; exact case already covered by
`localJointCertificate_of_uniform_challenge`). The composed certificate
plugs into `GameLaw.LocalCert`'s `second_cert` with
`e = (1 + d1) * (1 + d2) - 1`. Still open and NOT claimed here: any numeric
value of `e`, the T5/cap-16 mass comparison (the heavy core of layer 2), the
box-condition/support check for the emit/cap map, and the delta -> e
accumulation of the single-change modular perturbations.

## Attempts log

(all errors preserved as text; the guarded runner writes one fixed log path
`.build/check_lib/JointDecomp.log`, so the raw first-attempt logs were
overwritten by the successful run)

- **Attempt 1** (exit 1): `FiberBinding.map_mass` pattern not found — its
  universes are `Type`, not `Type*` (fixed: `variable {α : Type} {β : Type}`);
  deprecated `if_pos`/`if_neg` warnings (fixed: core `ite_eq_left` /
  `ite_eq_right`); `Fintype ?m` stuck at `∑ y, fallbackLaw.mass y` (fixed:
  `∑ y : β, ...` ascriptions); `mul_div_cancel_left₀` argument order;
  `mul_div_cancel₀` shape is `b * (a / b) = a` (its first explicit argument
  is `a`); `(sum_mul _ _).symm` arity (3 explicit args; replaced by
  `rw [← sum_mul]`).
- **Probe 1/2** (`.build/tmp/`, scratch): settled section-variable
  behaviour — `marginal`'s signature keeps only the used instances, but
  THEOREMS auto-include instance variables mentioning their type variables
  (`linter.unusedSectionVars`); `omit [..] in` must precede the docstring
  (docstring before `omit` is a parse error); generic binders
  (`{γ : Type} [Fintype γ]`) avoid the lint entirely.
- **Attempt 2** (exit 1): `apply sum_congr rfl` cannot match sums over
  different index types (fixed: `hinner`/`houter` with same-index
  `sum_congr`, then `Finset.sum_ite_eq_of_mem'` for the single-point sum);
  `rw` does not rewrite `ite` leaves under a `∑` binder when the pattern
  metavariables mention the bound variable (fixed: push the rewrite to the
  leaf via `sum_congr` + `ite_eq_left/right`); `omit` after docstring parse
  errors (fixed: order swapped).
- **Attempts 3-4** (exit 0): full stage 1 and stage 2 builds, logs empty
  (0/0).

## New lessons (next to GAME_BINDING_WORK_STATE's list)

- Universe-polymorphic sources matter: `Run2.FiberBinding.map_mass` is
  `Type`-level; a `Type*`-generic lemma cannot consume it. Check the
  universe of any reused helper before writing the statement.
- This Mathlib deprecates `if_pos`/`if_neg` (use core `ite_eq_left` /
  `ite_eq_right`); `mul_div_cancel₀ (a) (hb : b ≠ 0) : b * (a / b) = a` vs
  `mul_div_cancel_left₀ (b) (ha : a ≠ 0) : a * b / a = b` — mind the shape.
- `rw` stops at binders: `∑`-under-`ite` leaves need `sum_congr` +
  leaf-level rewriting; cross-index-type `sum_congr rfl` never unifies
  (give both sides the same index type first).
- `linter.unusedSectionVars`: `omit [..] in` goes BEFORE the docstring;
  sparse theorems are cleaner with fresh generic binders (`γ`, `δ`).
