# PROMPT — new window: B4/2, Layer-2 support and the emit/cap analysis (delta -> e core)

Workspace: `proofs/ft1536/development/T12_1/run2/`. Small local commits via
`git commit --only -- <paths>`; NO push (owner signal), one Git writer at a
time. English crypto register in code. OWN FILES ONLY: create
`formal/SignLayerSupport.lean` + `notes/B4_LAYER2_WORK_STATE.md`.
Everything else READ-ONLY. Zero unfinished-proof markers incl. placeholders;
defs-first; guarded compiles; logs 0/0.

**Read first:** `notes/S3_E_PROVENANCE.md` (the B4 composition plan — your
deliverable is its "next kernel piece" 3, Layer 2), `notes/S1_P_ACCEPT_FACTS.md`
(methodology model), `formal/CenteringClosure.lean` (the delta bounds + the
two named premises + budgets tauB/rejB/boxB), `formal/SecondMoment.lean`
(the toolkit: `second_le_of_pointwise`, `second_cond_le`, `second_joint_le`).

## Goal — the support/AC question of Layer 2 (the delta -> e core)

The comparison pair (pinned, MTISIS stage `PublicSimulation.lean`):

    signBody A c = (MathSign.cap (trial A c) 16).map (MathSign.emit emit)
    trial A c    = (Law.weighted (fiberWeight A c) ...).map (fun z =>
                     if Q (decode z) < B then some z else none)

Prove kernel-side, in small steps:

1. **Support map for `emit`/`cap`**: characterize the support of
   `signBody A c` exactly (which `Option BoxVec` points carry mass) — the
   `cap 16` retry combinator and the `emit` encoding, including the `none`
   cases of `trial` (out-of-box) and of `cap` (all attempts missed).
2. **AC feasibility lemma**: conditions on a sampler reply law `j` under
   which `Divergence.AC j (signBody (syndrome h) c)` holds — in particular
   settle the wrap-error question: the real sampler leaks `delta` mass on
   replies that mathematical Verify rejects (CenteringClosure: "delta =
   probability that a positive Sign reply is rejected"). Is that mass on
   points where `signBody` has positive mass (e.g. the `some z` image of
   `emit` over in-box z) or outside the support? The answer decides whether
   the pointwise route or the conservative `second_cond_le` route applies —
   record it honestly either way.
3. **Mass comparison pieces**: per-challenge multiplicative bound
   `j.mass z <= (1+d) * (signBody (syndrome h) c).mass z` reduced to the
   available analytic inputs (T5 multiplicative mass bounds `t5g00 < 1/64`
   family in `CenteringClosure.lean`, the a2Tower/triangular mass bounds at
   error ~2^-46, the wrap-error budgets `tauB = 2^-40`, `rejB = 2^-24`,
   `boxB = 1e-1000`). State the EXACT remaining analytic obligations with
   types if any input is missing — never assume them.

## Boundaries (honest scope)

- The real `S.code` (C-side sign sampler) binding is source3's B1 territory
  — you work the MODEL side (`signBody`/`trial`/`cap`/`emit` over
  `fiberWeight`); source-bound facts may be cited from
  `notes/VERIFY_BIND_SIGN_SIDE_NOTES.md` (norm gate = `falcon_is_short`
  both sides; emission :3412-3418 = normalized `encodeSig`).
- `delta` bounds are already kernelized (`all_keys_bridge_closure` with
  exactly two named premises) — consume, do not rebuild.
- If a real blocker appears: record the exact missing type/obligation and
  continue other parts; never turn a blocker into an assumption.

## Deliverables

`formal/SignLayerSupport.lean` (0/0), `notes/B4_LAYER2_WORK_STATE.md` per
batch, Polish handoff summary (support characterization, the AC verdict,
what remains of the delta -> e composition).
