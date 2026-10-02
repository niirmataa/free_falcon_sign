# B5 — assembly skeleton (`end_to_end_assembled_theorem_statement`)

Task: `notes/PROMPT_B5_ASSEMBLY.md` (window B5; the Section-1 bound of
`development/T12_1/END_TO_END_SCOPE.md` assembled over
`Run2/ConcreteReduction` + `ONoneGeometry.localJointCertificate_of_attemptFactor`
per `notes/B4_SYNTHESIS.md`). Workspace
`proofs/ft1536/development/T12_1/run2/`. Own files only:
`formal/Assembly.lean` + this entry. Recorded 2026-10-02.

## Status

**DONE — `formal/Assembly.lean` builds 0/0** (EMPTY log = 0 errors/0
warnings, guarded serial compile `tools/original/run_lean_guarded.sh`, exit 0,
6s). Axiom audit: **20/20 audited declarations (3 defs + 17 theorems) depend
only on `[propext, Classical.choice, Quot.sound]`**. Zero unfinished-proof
markers. The `#print`-style argument lists are in the audit log
(`.build/audit/AssemblyAudit.log`) — they show the EXACT final argument list
below and nothing else.

## 1. THE FINAL ARGUMENT LIST of `end_to_end_assembled_theorem_statement`
(= the closing checklist of the whole project; binder order)

Objects (witnesses/data, not assumptions): `SK`, `beta`, `muKey`, `A`, `S`,
`jatt`, `k`, `tau`, `deltaPRG`, `keyIdent`. Then EXACTLY the named
assumptions:

| # | Binder | Type | Owner / status |
|---|---|---|---|
| 0 | `hk : 1 ≤ k` | arithmetic side condition (house style of `HacGlue.localJointCertificate_of_named_premises`) | PROVED at the candidate factor: `SignLayerSupport.attemptFactor_one_le` |
| 1 | `huc : HacGlue.UniformChallengeAt S` | Layer-1 ROM identification (`d1 = 0`) | **DELIVERED** (B3/X, `VerifyBind/HashTo.lean`); content stays an assumption (scope A2) |
| 2 | `hshape : HacGlue.ReplyShapeAt S jatt` | source binding of the attempt law (`SIGN_MAX_ATTEMPTS=16`, emission `Extra/c/falcon-sign.c:3412-3418`) | **OWED by B1/source3** (B1.01 closed; B1.02 prepared in `KEYGEN_RESIDUE_CHECKPOINT.md` §2) |
| 3 | `hattempt : HacGlue.AttemptPointwiseAt jatt k` | the one-attempt mass comparison at factor `k` | **OWED by B4/3a** (the two named analytic bounds `AttemptShape` + `AttemptWeights`) |
| 4 | `hkey : keyIdent` | the emitted-key law identification | **OWED by B1.10** (`KeygenSourceToFiber001.emitted_to_actual_fiber`) |
| 5 | `hprg : AdvPRG tau ≤ deltaPRG` | the D2 route-(b) tape seam | **OWED by B2** (`Adv_PRG(ChaCha20)` accounting of `Extra/c/frng.c`, SHAKE-256 seeding) |

Nothing else is assumed. `e = k^32 - 1 = SignLayerSupport.e2 k` is PROVED
(`Assembly.e2_eq`) and is the SIGN sampler's chi-square constant of
`Run2.LocalJointCertificate` (`second ≤ 1 + e`), NOT a key-law constant (S3
correction — kept straight in the statement).

Operational assumptions (task item 6) — explicit WHERE THEY BITE, with scope
names (`END_TO_END_SCOPE.md` §3):

- **A2** bites at `huc` (its named predicate IS `huc`);
- **A1** bites at `hkey` (D1 refinement (ii)); at MODEL scope pinned by the
  proved identity `a1_no_retry_interface` (the whole key material enters
  `Games.runEUF` through the single atom `Dist.draw muKey`; the adversary
  interface carries `(Rq, coins)` only). Deployment-side retry leakage stays
  recorded as out of scope;
- **A5** bites INSIDE the exact type of `emitted_to_actual_fiber`
  (`ProfileM0`/`LegalEntry`/`PinnedExec` of PLAN §1 = the LP64/wrapping
  contracts) = inside `hkey`;
- **A3/A4** bite at the BYTE BRIDGE — explicitly NOT a theorem argument
  (established B4 boundary; open, recorded). Owed by rung B3.

`hkey`'s exact-type slot: `keyIdent : Prop` is a named parameter = the type
of `emitted_to_actual_fiber` (exact type transcribed in
`source3/notes/run/KEYGEN_SOURCE_TO_FIBER_001_PLAN.md` §1; its carrier types
`KeygenM0.*`/`C99MemoryReference.Memory` are source3's in-progress
interface). This is the faithful reading of the task's "take its exact type
as a named parameter; B1 delivers the content": at B1 delivery `keyIdent` is
instantiated with that exact type at the same binder name. Its bite: it
identifies `muKey` — and `SigmaMath.muH muKey`, the exact law the MT-ISIS
hardness is assumed for — with the D1 CONDITIONAL emitted-key law
`Law(attempt | Accept)` (per-attempt conditioning; `1/p_accept` accounting
resolved in `notes/S1_P_ACCEPT_FACTS.md`, cited, not redone).

## 2. The D2 route-(b) seam and the named hybrid lemma

The task's `Games.Sampler.code` runs on a fair uniform tape
(`Law.uniform.map` = `Run2.samplerLaw`), the real system on the ChaCha20
stream. Modeled as:

- `samplerLawAt S tau h st m r := tau.map (S.code h st m r)` (def; `= samplerLaw` at
  `tau = Law.uniform` PROVED `rfl`, `samplerLawAt_uniform`);
- `TV p q := (∑ x, |p.mass x - q.mass x|) / 2` and **`AdvPRG tau := TV tau Law.uniform`**
  — the explicit additive term. Recorded refinement of the task's literal
  `AdvPRG S`: the seam quantity needs the tape law, so `tau : Law (Fin S.bits → Bool)`
  is an OBJECT binder (the tie to `S` is in the tape width) and `AdvPRG` takes
  `tau`; `hprg` keeps the task's shape `AdvPRG … ≤ deltaPRG`;
- **the hybrid lemma** — the standard game-hop shape at the tape law, stated
  law-level over `Dist`/`Law` comparisons and PROVED:
  `tape_game_hop_abs` (two-sided: event gap ≤ `AdvPRG tau`),
  `tape_game_hop` ("AdvEUF(real stream) ≤ AdvEUF(uniform tape) + AdvPRG"),
  **`tape_game_hop_delta`** (the delta form "… + deltaPRG" from `hprg`), and
  `tape_game_hop_map_abs` (the `Law.uniform.map` seam at `S.code`, via
  `map_eq_bind_pure` + `LawBinding.draw_pushforward` shape).
- the outer bound carries `deltaPRG` (task: "let the outer bound carry
  deltaPRG"): `end_to_end_assembled_theorem_statement` concludes `… + deltaPRG`
  with `hprg : AdvPRG tau ≤ deltaPRG` among its arguments (it pins the carried
  budget above the seam, in particular `0 ≤ deltaPRG`). The display-literal
  variant with the additive term `AdvPRG tau` itself is provided as
  `end_to_end_assembled_theorem_statement_prgTerm`.

Proof chain of the main theorem (nothing else): the named B4 certificate
`HacGlue.localJointCertificate_of_named_premises_e` at `e = e2 k` (O-NONE
discharged unconditionally by `ONoneGeometry.hone`) →
`Run2.concrete_euf_cma_to_mt_isis` over `Reduction.build` → `e2_eq` rewrite →
carried `deltaPRG` (`le_add_of_nonneg_right`).

## 3. Exports and pins

- `end_to_end_assembled_theorem_attemptFactor` — candidate-factor export via
  `ONoneGeometry.localJointCertificate_of_attemptFactor`; `hk` drops (proved),
  `e = attemptFactor^32 - 1 < 2^-32` (`e_at_attemptFactor` +
  `SignLayerSupport.e2_attemptFactor_lt`);
- `exists_assembled_reducer` — the `exists_concrete_reducer`-style export
  (`B = Reduction.build beta A S` with the defining equation);
- `assembled_hardness_substitution` — the
  `concrete_hardness_substitution`-style corollary (plug `AdvMT … ≤ epsilon`,
  `epsilon ≤ 1`);
- `e2_eq`, `e_at_attemptFactor`, `a1_no_retry_interface` (above).

NOT theorem arguments (open, recorded, never assumed): the byte bridge (mass
outside the `emit` image ⇒ chi² infinite —
`SignLayerSupport.chi2_top_of_out_of_support`) and the additive-error mass
floor (an `Adv_PRG`-shaped term needs `mu ≤ (trial A c).mass (some z)` to
enter the multiplicative `AttemptPointwise` shape — it stays additive in the
outer bound and never enters `e`).

## 4. Receipts

- Deps built first (were missing from `.build/check_lib`), guarded serial,
  all exit 0 / empty logs: `Run2/{TargetLaw,MTBinding,ExecutionComparison,
  ReaderBinding,StoppedComparison,LazyEventBinding,StoppingLoss,
  ConcreteReduction}.olean` (1-2s each).
- `bash tools/original/run_lean_guarded.sh formal/Assembly.lean
  .build/check_lib/Assembly.olean 900 3600` — exit 0, 6s, log EMPTY (0/0).
- Axiom audit `bash tools/original/run_lean_guarded.sh
  .build/audit/AssemblyAudit.lean .build/audit/AssemblyAudit.olean 900 3600` —
  exit 0, 2s; **20/20 declarations, axioms `[propext, Classical.choice,
  Quot.sound]` only**; the `#print` blocks print the exact binder lists of the
  main theorem, its three exports and `tape_game_hop_delta`.
- Hashes (sha256/16): `formal/Assembly.lean` `1a0cc416fd63fdbf…`,
  `Assembly.log` `e3b0c44298fc1c14…` (= empty),
  `AssemblyAudit.log` `592c39bcdb5f9b51…`.

## 5. Workstate lessons (for the next window)

- `∑ x, a - b` parses as `(∑ x, a) - b` — the binder body does NOT include a
  top-level `-`; parenthesize differences inside sums (a real trap here).
- `Dist` is ambiguous in binder positions (a `_root_.Dist` from the pinned
  Mathlib closure coexists with `Run2.Dist`) — qualify `FT1536.Run2.Dist` in
  binders; dot-notation `Dist.foo` resolves fine.
- `conv_lhs => simp_rw […]` is rejected by the parser here ("expected '{' or
  conv") — plain `simp_rw [mul_sub]`/`simp_rw [sub_mul]` at goal level is
  one-sided enough in these shapes.
- `initial` lives in `FT1536.Run2` (NOT in `Games`).
- An unused named premise (`hkey`) is carried through a `have gate : keyIdent → bound`
  closed by `gate hkey` — the statement stays gated on the identification and
  the binder is genuinely consumed.

## 6. What each argument's owner still owes (handoff checklist)

1. `huc` — NOTHING (delivered B3/X; content stays the ROM assumption).
2. `hshape` — B1/source3: close `ReplyShape` (B1.02: region map `3046..91`,
   the five consumers to patch per `KEYGEN_RESIDUE_CHECKPOINT.md` §2).
3. `hattempt` — B4/3a: the two named analytic bounds `AttemptShape` +
   `AttemptWeights` at `k = attemptFactor` (or any `k ≥ 1` with its `hk`).
4. `hkey` — B1.10: `emitted_to_actual_fiber`; instantiate `keyIdent` with its
   exact type (PLAN §1) at this binder.
5. `hprg` — B2: identify the real tape law `tau` (frng ChaCha20 stream,
   SHAKE-256 seeding) and prove `AdvPRG tau ≤ deltaPRG`.
6. A3/A4 (byte bridge, B3) and the additive-error mass floor stay OPEN and
   are recorded as non-arguments; A1 deployment-side caveat stays recorded.
