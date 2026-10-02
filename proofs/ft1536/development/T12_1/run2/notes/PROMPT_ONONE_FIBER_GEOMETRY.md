# PROMPT — new window: O-NONE, the fiber geometry of `Relation.A` (the box-point premise)

Workspace: `proofs/ft1536/development/T12_1/run2/`. Small local commits via
`git commit --only -- <paths>`; NO push (owner signal); one Git writer at a
time (other lanes commit concurrently). English crypto register in code.
OWN FILES ONLY: create `formal/ONoneGeometry.lean` +
`notes/B4_ONONE_WORK_STATE.md`. Everything else READ-ONLY. Zero
unfinished-proof markers incl. placeholders; defs-first; guarded compiles
(`tools/original/run_lean_guarded.sh`); logs 0/0; axiom-audit your module.

**Read first:** `notes/B4_SYNTHESIS.md` (premise 4 of the remaining four),
`formal/SignLayerSupport.lean` + `notes/B4_LAYER2_WORK_STATE.md` (the exact
statement of `ONone` and the `signBody_none_pos_iff` condition),
`formal/HacGlue.lean` (how `hone` is consumed and pinned by
`attempt_miss_satisfiable_iff_onone`), `formal/JointDecomp.lean` boundary
notes.

## Goal — `hone : ∀ h, ONone (syndrome h)` (under achievability)

`ONone c` = the `none` point of `signBody A c` carries positive mass. By
B4/2's `signBody_none_pos_iff` this reduces to the geometry: at any
achievable challenge `c`, the fiber

    F_c = { z : BoxPair | Relation.A h (decode z) = c }

contains a point that the trial maps to `none` — i.e. a point with
`Q (decode z) >= B` (out-of-box for the norm gate) or one failing the
`signed16` encoding gate. The geometric content: a fiber of the NTRU
syndrome map inside the decoded box is a coset of an ideal-lattice-like
structure; it cannot fit entirely inside the tiny acceptance ball
`Q < B` (= `B = 2093922385`, `Geometry.block x y = x*x + x*y + y*y`).
Prove this — the spread of a nondegenerate lattice coset versus a
fixed-norm ball.

Work in small steps:
1. state `F_c` and the achievability hypothesis EXACTLY as the pinned
   types give them (`Relation.A`, `decode`, `Geometry.Q`/`Q0`, `Block`);
2. characterize the fiber's algebraic structure for a key `h` satisfying
   the NTRU equations — if you need `fG-gF=q` / `h*f=g` facts (rung B1's
   deliverables, currently in progress in `source3/`), take them as a
   NAMED parameter with the exact type; never assume their content;
3. the spread lemma: any fiber with >= 2 distinct points (or one
   nontrivial lattice direction) has a point with `Q >= B` OR an encoding
   failure — quantify what is really needed (maybe: |F_c| >= 2 suffices,
   since two decoded points in the box at distance d force one of
   `z0 + k*(z1-z0)` out of the norm ball for large k — but the box is
   finite, so state the exact finite geometry, do not hand-wave);
4. if achievability alone is too weak (a fiber could in principle be a
   single in-box point), record the exact missing input as a named
   hypothesis and prove everything conditional on it — honest names only.

## Known facts you may cite (verified)

- `Geometry.block x y = x*x + x*y + y*y`; `Q`/`Q0` the quadratic forms of
  `PublicSimulation`; `B = 2093922385`; the decode box: coordinates
  `-65535..=65535` (`blockDecode` convention), `signed16` encoding gate.
- `trial A c` = weighted `fiberWeight A c` mapped `z -> if Q (decode z) < B
  then some z else none` (PublicSimulation.lean:114-117);
  `signBody = (cap (trial A c) 16).map (emit emit)`.
- The wrap-error channel stays INSIDE the support (B4/2) — your premise is
  only about `none`-mass positivity.

## Deliverables

`formal/ONoneGeometry.lean` (0/0 + axiom audit), `notes/B4_ONONE_WORK_STATE.md`
per batch, Polish handoff summary (the exact final form of `hone` — with
any named hypothesis spelled out — and what B1 must supply to discharge
them).
