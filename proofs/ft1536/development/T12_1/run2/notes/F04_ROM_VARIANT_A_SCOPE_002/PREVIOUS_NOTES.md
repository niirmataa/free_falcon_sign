# F04 repair (variant A) — ROM challenge outside the sampler tape; F05 on the same window

Window: `run2` (development/T12_1/run2), 2026-10-11. Owner decision: F04 is
repaired in **variant A** — `c = H(r‖m)` is drawn from the ROM hash OUTSIDE
the sampler's fair-bit tape; the sampler draws only the noise (matches the
real `to_sign`). Costs and `hprg` follow variant A. F05 rides the same
window. Guardrails observed: no proof replaced by an A2 label, no new name
on the same false premise, `AssemblyComp.advMT_ge_of_public_sim_stream_win`
untouched (outside the charge), the DO-NOT-CONSUME list updated per
repaired consumer, attempts retained, no push, Source3 (lane 062) untouched.

Pins of the pair: `notes/F04_ROM_VARIANT_A_001.json` (this file's companion).
Build runtime: `.build/f04_rom_a_001/` (ignored), guarded Lean 4.34.0 +
Mathlib, `run_lean_guarded.sh` sha
`76a4a4a0e0bbf61a5d400d54aae1847687826b9aeef1e0b073fc456d673ca0bb`.
Every attempt is retained under `.build/f04_rom_a_001/attempts/run_*/` with
source snapshots, logs and `RECEIPT.json` (module, source sha, exit, output
olean sha).

## 1. Model change (the F04 obstruction and its dissolution)

Pre-audit model: `Sampler.code : Rq → State → Bytes → Nonce → (Fin bits →
Bool) → Rq × Option BoxVec` — the challenge was a function of the fair-bit
tape. `UniformChallengeAt` (challenge marginal `= Law.uniform`) then needs a
uniform-preserving map `2^bits → 18433^1536`; impossible (18433 ∤ 2^bits),
kernel-rejected (premise-audit F04, `no_uniform_challenge_at`). NO sampler
realized it; 12 exports went on the DO-NOT-CONSUME list.

Variant A: the challenge is the ROM hash answer at the signed name and is an
INPUT of the noise map; the tape realizes the reply only.

* `Games.Sampler.code : Rq → State → Bytes → Nonce → Rq → (Fin bits → Bool)
  → Option BoxVec`.
* `Games.sample` draws the joint signing pair: lazy ROM answer
  `c ~ Law.uniform` (outside the tape) then `S.code h st m r c` on the noise
  tape. `Games.signSim` keeps its exact shape.
* `LawBinding.replyLaw` = the noise reply law at `c`;
  `samplerLaw = Divergence.joint Law.uniform (replyLaw ...)`.
* `JointDecomp.samplerLaw_marginal_uniform`: the challenge marginal IS
  `Law.uniform` — a kernel theorem (`marginal_joint`), `d1 = 0` exactly.
* `HacGlue.UniformChallengeAt` deleted; `HacGlue.RomChallengeAt` +
  `HacGlue.romChallengeAt` (realization, not an assumption) +
  `replyAt_eq_replyLaw` take its place.

## 2. The 12 consumers (all rewritten; `huc` binder removed)

| # | export | new binder list |
|---|---|---|
| 1 | `HacGlue.localJointCertificate_of_named_premises` | S, k, hk, jatt, hshape, hattempt, hone |
| 2 | `HacGlue.localJointCertificate_of_named_premises_e` | S, k, hk, jatt, hshape, hattempt, hone |
| 3 | `HacGlue.localJointCertificate_of_pointwise_premises` | S, k, hk, jatt, hshape, hattempt |
| 4 | `HacGlue.localJointCertificate_of_named_premises_attemptFactor` | S, jatt, hshape, hattempt, hone |
| 5 | `ONoneGeometry.localJointCertificate_of_attemptFactor` | S, jatt, hshape, hattempt |
| 6 | `Assembly.end_to_end_assembled_theorem_statement` | …, hk, hshape, hattempt, hkey, hprg |
| 7 | `Assembly.end_to_end_assembled_theorem_statement_prgTerm` | …, hk, hshape, hattempt, hkey |
| 8 | `Assembly.end_to_end_assembled_theorem_attemptFactor` | …, hshape, hattempt, hkey, hprg |
| 9 | `Assembly.exists_assembled_reducer` | …, hk, hshape, hattempt, hkey, hprg |
| 10 | `Assembly.assembled_hardness_substitution` | …, hk, hshape, hattempt, hkey, hprg, hepsilon, hardness |
| 11 | `AdvPrg.assembled_hardness_substitution_chacha` | …, hk, hshape, hattempt, hkey, hprg, hepsilon, hardness |
| 12 | `AdvPrg.end_to_end_assembled_theorem_statement_chacha` | …, hk, hshape, hattempt, hkey, hprg |

Exact printed types: `.build/f04_rom_a_001/audit/F04ConsumersAudit.lean` +
its log (binder lists and `#print axioms` of all 12, of `romChallengeAt`, of
`JointDecomp.samplerLaw_marginal_uniform`, and of the untouched
`AssemblyComp.advMT_ge_of_public_sim_stream_win`). Standard axioms only; no
new axioms, no `native_decide`, no warning suppression.

## 3. Costs and hprg (variant A)

* `PublicEncoding.samplerInput` = field h ++ state ++ bytes m ++ nonce r ++
  **field c** ++ coins; `samplerOutput` = **reply only** (≤ 26113 bits).
* `SamplerMachine.inputCap` = 49476 + stateCap + 9·bytes + S.bits;
  `cost` at the 26113 output cap; `SamplerCertificate.code : Code (Option
  BoxVec)`.
* `MeteredExecution.challengeCost` (ROM-hash challenge production, outside
  the tape) charged in `signAfter`; `drawCost S.bits` = noise tape only;
  `turnBound` matches (`sign_go_cost` closed by the same omega shape).
* `MachineExecution.run` / `MeteredExecution.run` draw the ROM challenge
  like the nonce (outside the tape), then the noise tape; `run_binding` and
  `erasure` re-proved at the two-draw shape.
* `CompPrg.signSimAt`: window drives the noise map only; challenge is a ROM
  draw outside the tape. `signSimAt_uniform` re-proved (uniform window
  average identifies the kernels). `tapeWidth = qs · S.bits` and
  `hprg : AdvPRG tau ≤ deltaPRG` are the NOISE-tape seam only — the
  challenge is not on the tape (the exact variant-A difference versus
  B/C). `ChaCha20PRFBound` stays the named standard assumption.
* `Assembly.samplerLawAt` = ROM joint with the noise reply under `tau`;
  `samplerLawAt_uniform` by `rfl`.

## 4. F05 (same window)

`T5Pointwise`:

* `machineStage_of_absErr_floor_support` — floor restricted to the PROPER
  SUPPORT (`0 < target z`); zeros outside the fiber handled SEPARATELY
  (`hzero : target z = 0 → mach z = 0`), never conflated with the floor;
* `machineStage_of_relErr` — relative pointwise estimate
  (`|mach z − target z| ≤ eps · target z`), no floor at all;
* `machineStage_of_absErr_fiberFloor` — consistency pin: on the actual
  `TowerWhole` target the support floor coexists with the forced fiber
  support (the audit's conditional conflict is dissolved, not papered
  over; `gaussianWeight_pos` + `towerWhole_iff` give on-fiber positivity).

The global-floor form `machineStage_of_absErr_floor` is KEPT as recorded
history (its scope note now points to the repair).

## 5. Untouched / excluded (recorded, not fixed here)

* `AssemblyComp.advMT_ge_of_public_sim_stream_win` — outside the F04 charge
  (no `huc` in its type); whole `AssemblyComp` closure compiles.
* `Run2/rawBadEnclosure.lean`, `Run2/Scratch.lean`, `Probe.lean` —
  historical scratch of commit `3396e8e0`, imported by nothing, broken
  before this window (Lean-3 `hypothesis` syntax / stale `#check` names).
* `FftBind/FftGeometry.lean`, `FftBind/FftSemantics.lean`,
  `FftBind/NttSemantics.lean` — cross-lane BINBIND material importing
  `Source3.*`; Source3 is the separate repair lane 062.
* Frozen stages/objects untouched; the pre-audit bytes stay the record of
  what the audit rejected.

## 6. Reproduction

```
cd proofs/ft1536/development/T12_1/run2/.build/f04_rom_a_001
python3 -B build.py run_011 <module list>        # guarded closure build
bash tools/original/run_lean_guarded.sh audit/F04ConsumersAudit.lean \
  audit/F04ConsumersAudit.olean 600 60           # binder/axiom evidence
```

## 7. Open items (unchanged, recorded)

`ReplyShape`/`S.code` source binding (B1/source3), the byte bridge, the
additive-error caveat, F06 statistical/computational distinction
(`chacha20PRFBound_delta_ge` stands), and F05's `hzero` (machine fiber
support — a named premise of the source side, never assumed).
