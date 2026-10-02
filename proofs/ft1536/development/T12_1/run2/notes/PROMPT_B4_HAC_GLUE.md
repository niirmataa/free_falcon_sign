# PROMPT — new window: B4/3b, the hac glue and O-NONE (assembling the three B4 deliveries)

Workspace: `proofs/ft1536/development/T12_1/run2/`. Small local commits via
`git commit --only -- <paths>`; NO push (owner signal); one Git writer at a
time. English crypto register in code. OWN FILES ONLY: create
`formal/HacGlue.lean` + `notes/B4_GLUE_WORK_STATE.md`.
Everything else READ-ONLY (note: a parallel window edits
`formal/AttemptPointwise.lean` — do not touch). Zero unfinished-proof
markers; defs-first; guarded compiles; logs 0/0.

**Read first:** `notes/B4_SYNTHESIS.md` (the assembly map — this window
builds its glue), `formal/JointDecomp.lean` +
`notes/B4_JOINT_DECOMP_WORK_STATE.md` (the constructor with the `hac`
premise), `formal/SignLayerSupport.lean` +
`notes/B4_LAYER2_WORK_STATE.md` (the support/AC results that discharge
`hac`), `formal/SecondMoment.lean` (toolkit).

## Goal — three pieces, all small and exact

1. **Discharge `hac`.** `JointDecomp.localJointCertificate_of_joint_bounds`
   takes the Layer-2 support/AC as an explicit premise `hac`. B4/2 proved
   exactly that content (`emitted_reply_supported`, `wrap_channel_in_support`,
   the support characterization, `chi2_top_of_out_of_support` as the
   recorded converse). Match the premise SHAPE (careful: the premise is
   about the sampler's reply law vs `signBody (syndrome h) c`; B4/2's
   results are about `signBodyOf`/`emit`/`cap` — state and prove the
   bridging lemma) and produce the constructor WITHOUT the `hac` premise.
2. **`O-NONE`**: positive `none`-mass of `signBody (syndrome h) c` for every
   achievable challenge — B4/2 computed the exact condition
   (`signBody_none_pos_iff`); prove it under the natural achievability
   hypothesis (or record the exact hypothesis as a named premise if it
   needs source-side facts).
3. **The assembled theorem** `localJointCertificate_of_named_premises`:
   the full `FT1536.Run2.LocalJointCertificate S ((1+d1)*(1+d2)-1)` where
   the ONLY remaining arguments are the named premises of the synthesis
   (`AttemptPointwise` as a parameter with its exact interface — coordinate
   with `notes/B4_SYNTHESIS.md` §obligations, do NOT prove it, the parallel
   window does — and `ReplyShape` if needed) plus `UniformChallenge` for
   the `d1 = 0` variant (`e = d2`). The theorem must make crystal clear:
   nothing else is assumed. Axiom-audit your module (the `#print axioms`
   pattern of `formal/VerifyBind/Audit.lean`).

## Deliverables

`formal/HacGlue.lean` (0/0), `notes/B4_GLUE_WORK_STATE.md` per batch,
Polish handoff summary (the exact final argument list of the assembled
certificate — that list IS the remaining project scope for B4).
