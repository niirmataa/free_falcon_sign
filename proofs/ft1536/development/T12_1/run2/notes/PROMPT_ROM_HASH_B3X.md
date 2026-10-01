# PROMPT — continuation for the MiMo window: rung B3/X, hashTo ROM interface

Context: your B3 package (StaticCodec/ByteCodec/Verdict/Audit) is accepted
pending the lead's batch review. This is your continuation task for the
owner's long-run window. Workspace, hard rules, file ownership and the
compile discipline are unchanged from your first prompt (own files under
`formal/VerifyBind/` + own notes; everything else READ-ONLY; zero
`sorry` incl. placeholders; defs-first; guarded compiles 0/0; local
commits via `git commit --only -- <paths>`; NO push, NO reviewers).

## Goal — the hashTo ROM interface (the item YOU flagged as open)

`verdict` takes `hashTo` as a parameter. Make that interface precise and
usable by the B5 assembly:

1. **Pin the C-side shape**: `falcon-vrfy.c` derives the challenge `c` from
   the signature context via SHAKE (the hash-to-point step). Extract the
   EXACT input/output shape and domain of that call chain (bytes in ->
   challenge polynomial out) from the pinned sources — the same
   source-bound style as your codec lemmas (cite exact lines).
2. **Formal interface** (`formal/VerifyBind/HashTo.lean` or your own
   naming): a named structure capturing the hashTo contract as an
   explicit, axiom-shaped parameter (input domain, output range, the
   deterministic map), WITHOUT assuming its security. State the ROM
   assumption as a single named predicate (the challenge law is uniform
   on Rq) so B5/assumptions can reference exactly one name.
3. **Consistency lemmas**: your `verdict_valid_iff` with `hashTo`
   instantiated becomes the concrete byte-level verdict; prove the
   composition (the theorem re-run with the pinned C-side shape) and keep
   the earlier general form. Key decoding stays OUT (rung B1, other lane).
4. **Honest notes**: what the interface assumes (SHA-3/SHAKE as a random
   oracle = an A-side assumption to be recorded, not proven), and what B5
   must instantiate.

## Deliverables

- `formal/VerifyBind/HashTo.lean` (+ any small helper modules), 0/0 logs;
- update your `notes/VERIFY_BIND_WORK_STATE.md` per batch;
- a short Polish handoff summary (what shown, what assumed, what B5 gets).

If the package closes early: extend the same style to the SIGN-side
encoder entry (`falcon-sign.c:3412` producer path) formalization notes —
but ONLY in your own files, and record everything you do NOT cover.
