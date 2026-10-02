# PROMPT — new MiMo window: B1 continuation (finish KEYGEN_SOURCE_TO_FIBER_001 per Astra's plan)

You continue rung B1 in `proofs/ft1536/development/T12_1/source3/` after
the previous author (GPT-6 Astra) stopped on a usage limit. The owner
instructed her to leave a complete execution plan; she did. **This is an
explicit handoff: you edit her files in `source3/` (formal/, notes/) — that
lane is yours now.**

## Read first, in this order

1. `source3/notes/run/KEYGEN_SOURCE_TO_FIBER_001_EXECUTION_PLAN.md` — THE
   plan (the remaining implementation, module/theorem targets, fixed
   boundaries). Follow it; do not invent another plan.
2. `source3/notes/run/KEYGEN_SOURCE_TO_FIBER_001_PLAN.md` (the final target
   type lives in its section 1), `KEYGEN_RESIDUE_CHECKPOINT.md` (the
   work-in-progress checkpoint — resume from it),
   `source3/notes/WORK_STATE.md`, `source3/SOURCE_BINDING_GAPS.md`.
3. `proofs/ft1536/development/T12_1/END_TO_END_SCOPE.md` (the binding
   scope; B1's deliverables are named in the cross-lane map) and
   `run2/notes/S1_P_ACCEPT_FACTS.md` (the six-gate attempt structure your
   predicates should mirror).

## Goal (unchanged — her section 1)

The final theorem `KeygenSourceToFiber001.emitted_to_actual_fiber`: every
finite defined execution of the pinned `falcon_keygen_make` (M0 profile,
legal memory) returning 1 with emitted sk/pk yields THE SAME decoded
f,g,F,G,h tied to that execution, the full accepted mandatory leaf
certificate, exact integer NTRU fG-gF=q over Phi, the public equation, the
f-inverses, and the ActualNTRUFiber instantiation — with NO forbidden
premises (no solver/serializer correctness assumptions, no NTRU or
certificate acceptance as premises, no unproved source completeness).

## Lane rules (hers + ours)

- Small logical local commits on main (`git commit --only -- <paths>`); NO
  push (owner signal). One Git writer at a time — other lanes commit too.
- Pinned M0 sources byte-exact (sha256s in her materials); never substitute
  live `Extra/c`. Keep batches with receipts (`notes/run/*_BATCH_*.json` +
  `*_NOTES.md` pairs), failed attempts recorded, raw logs preserved.
- Zero unfinished-proof markers including placeholders; drafts live in the
  conversation. No long inline expressions in statements (defs first).
- Guarded serial compiles (`tools/original/run_lean_guarded.sh`), logs 0/0;
  Sage via `sage <file>.sage` with asserts (exact ZZ/QQ).
- Limits unchanged; no monolithic reductions forced through; a real blocker
  gets recorded (exact missing type + attempt result) and you continue other
  parts — never turn a blocker into an assumption or a scoped PASS.
- Proposed names in the plan are targets, not completed proofs — verify
  every state claim against the actual files.

## What B4/B5 consume from you (keep the interfaces clean)

- the key law binding (`SigmaMath.muH muKey` with `muKey` = the emitted-key
  law of the successful execution — the D1 conditional law);
- `keyDecoder` contract for the B3 verdict (shape already pinned there);
- the attempt-loop predicates mirroring the six gates of
  `S1_P_ACCEPT_FACTS.md` (resultants, norm, Gram-Schmidt, invertibility,
  solve, certificate) + the attempt cap semantics.

## Deliverables

The plan's final artifacts (per her section on artifacts): the report
starting with the complete final type and its REAL premises, the closure
JSON, the review task file, updated WORK_STATE/ROADMAP. Polish handoff
summary to the owner: what closed, what remains, the source/model boundary.
Do not run reviewers/subagents yourself; do not mark REVIEWED.
