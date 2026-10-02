# B4/4 — O-NONE: the fiber geometry of `Relation.A` (the box-point premise)

Task: `notes/PROMPT_ONONE_FIBER_GEOMETRY.md` (window O-NONE = named premise 4
of `HacGlue.localJointCertificate_of_named_premises`, per the §obligations
list of `notes/B4_SYNTHESIS.md`). Workspace `proofs/ft1536/development/T12_1/run2/`.
Own files only: `formal/ONoneGeometry.lean` + this note. Recorded 2026-10-02.

## Status

**DONE — `formal/ONoneGeometry.lean` builds 0/0** (empty log, guarded serial
compile `tools/original/run_lean_guarded.sh`, exit 0). Axiom audit: 25/25
audited declarations (21 theorems + 4 defs) within
`[propext, Classical.choice, Quot.sound]` (10 of them without
`Classical.choice`). No unfinished-proof markers (strict grep clean).

**`hone` is PROVED — UNCONDITIONALLY. No named hypothesis is left for this
premise and rung B1 owes nothing for it.**

Batch commits on `main` (NO push — owner signal):

- `bf6a1501` — batch 1, fiber algebra: defs `liftFin`/`liftVec`/`liftPair`/
  `qPeriodic`, residue preservation (`liftFin_emod`, `cast_liftFin`,
  `reduceVec_decode_liftVec`), residue factorization of `Relation.A`
  (`A_eq_of_reduceVec`, `syndrome_eq_of_reduceVec`, `qPeriodic_syndrome`);
- `5ad41523` — batch 2, the spread and the discharge: `block_two_coords`,
  `liftPair_norm_ge`, `liftPair_out_of_box`, `onone_of_qPeriodic`,
  `onone_syndrome`, `hone`, and the three consumption corollaries;
- (this note).

## 1. Verdict on the prompt's routes (spread vs. named hypothesis)

The prompt expected "a coset of an ideal-lattice-like structure" spreading
beyond `Q < B`, with rung B1's `fG - gF = q` / `h * f = g` as named
parameters (step 2) and a possible named spread hypothesis if achievability
alone were too weak (step 4). Reality is stronger and simpler — NEITHER the
NTRU ideal-lattice structure NOR any spread hypothesis is needed:

1. `Relation.A h (decode z)` sees `z` ONLY through `Relation.reduceVec`,
   i.e. through the coordinate residues mod `q = 18433` (definition of
   `Relation.A`/`reduceVec`). So every fiber `F_c` is invariant under the
   rank-1536 residue lattice `18433 * Z` of each decoded half —
   `qPeriodic_syndrome` / `reduceVec_decode_liftVec`. This is a residue
   coset, a much coarser structure than the NTRU lattice coset; no key
   equation constrains it.
2. The finite box is wide enough for the residue lattice to reach out of the
   norm gate INSIDE the box: `liftFin` moves each stored coordinate to the
   top of its residue class (`≤ 131070`), so its decoded coordinate is
   `≥ 131070 - 18432 - 65535 = 47103` (`liftFin_decode_ge`), and one decoded
   pair with both coordinates `≥ 47103` already carries
   `block x y ≥ 2 * 47103 ^ 2 = 4437385218 > 2093922385 = B`
   (`block_two_coords`, `liftPair_norm_ge`).

Prompt steps vs. delivery (prompt's numbering):

1. `F_c` stated on the pinned types exactly (`SigmaMath.syndrome` =
   `Relation.A h ∘ decode`; `decode`, `Geometry.Q`/`Q0`, `block`, `B`,
   the `Fin 131071` box of `PublicSimulation.decodeVec`) — see the module
   docstring and `liftPair_norm_ge`.
2. Fiber algebra characterized (`qPeriodic` = factorization through
   `reduceVec`); the NTRU parameters were **not needed** — they are neither
   assumed nor consumed anywhere in the module.
3. Spread quantified EXACTLY: **fiber nonemptiness suffices** (the
   achievability antecedent already built into `HacGlue.ONone`). No
   `|F_c| ≥ 2`, no nontrivial lattice direction. The prompt's line-spread
   idea (`z0 + k*(z1-z0)` escaping `Q < B`) is NOT needed, and its warned
   finite-box caveat does not bite: the witness is constructed inside the box
   coordinate-by-coordinate, not by running along a line.
4. Nothing is missing: `hone` needs no named hypothesis at all.

## 2. Definitions (defs first)

| def | Meaning |
|---|---|
| `liftFin (a : Fin 131071) : Fin 131071` | top-of-box representative of `a`'s residue class mod `18433`: `131070 - ((131070 - a.val) % 18433)` |
| `liftVec (v : BoxVec) : BoxVec` | coordinatewise `liftFin` of one box half (both stored coordinates of every pair) |
| `liftPair (z : BoxPair) : BoxPair` | `(liftVec z.1, z.2)` — THE O-NONE witness map |
| `qPeriodic (A : BoxPair → Relation.Rq) : Prop` | `A`'s first-half residues-only dependence: `reduceVec (decodeVec u) = reduceVec (decodeVec v) → A (u, w) = A (v, w)` |

## 3. What is in the kernel (theorems)

- **Lift arithmetic**: `liftFin_val` (rfl), `liftFin_add_mul` (the move is a
  multiple of `18433`), `liftFin_ge` (`≥ 112638` stored),
  `liftFin_decode_ge` (`≥ 47103` decoded), `liftFin_emod`, `cast_liftFin`,
  `cast_liftFin_sub`, `decodeVec_liftVec_apply` (rfl);
- **Fiber invariance**: `reduceVec_decode_liftVec` (the lift is a
  same-residue move), `A_eq_of_reduceVec`, `syndrome_eq_of_reduceVec`,
  `qPeriodic_syndrome` (every `syndrome h` is `qPeriodic` — every `h`, no
  key hypothesis);
- **The spread**: `block_two_coords` (`0 ≤ t ≤ x`, `t ≤ y` force
  `2 * t^2 ≤ block x y`), `liftPair_norm_ge`
  (`B ≤ Q (decode (liftPair z))` for EVERY `z`), `liftPair_out_of_box`
  (`¬ Q (decode (liftPair z)) < B`);
- **The discharge**: `onone_of_qPeriodic` (the exact reusable criterion:
  `qPeriodic A → HacGlue.ONone A`), `onone_syndrome`, and THE final form
  `hone` (below);
- **Consumption**: `signBody_none_pos_syndrome`
  (`0 < (signBody (syndrome h) c).mass none` for EVERY `h`, `c` — kills the
  MISS-POINT CAVEAT of Part 2 in `notes/B4_LAYER2_WORK_STATE.md` on the
  support route), `attempt_miss_satisfiable` (the RHS of
  `HacGlue.attempt_miss_satisfiable_iff_onone` is now always inhabited: a
  miss-capable attempt law fits the `none`-side at every achievable
  challenge), `localJointCertificate_of_attemptFactor` (the B4 certificate at
  the candidate factor with O-NONE DISCHARGED — see §4).

## 4. The exact final form of `hone` — and what B1 must supply

```lean
theorem hone : ∀ h : FT1536.Relation.Rq, HacGlue.ONone (FT1536.SigmaMath.syndrome h)
```

**Named hypothesis: NONE.** The statement is exactly the `hone` binder of
`HacGlue.localJointCertificate_of_named_premises` /
`..._attemptFactor`; it is now a theorem of `ONoneGeometry`, standard axioms
only. Its one algebraic hypothesis in the general route (`qPeriodic A`) is
itself PROVED for `syndrome h` at every `h` (`qPeriodic_syndrome`), so the
chain `onone_of_qPeriodic → onone_syndrome → hone` is closed.

**What B1 must supply to discharge O-NONE: nothing.** B1/source3 keeps its
own inputs to the OTHER two Layer-2 premises (unchanged by this window):

| remaining premise | content | owner lane |
|---|---|---|
| `UniformChallengeAt S` | ROM identification `d1 = 0` | B3/X `VerifyBind.HashTo` (delivered) |
| `ReplyShapeAt S jatt` | attempt law shape bound to pinned C (`SIGN_MAX_ATTEMPTS=16`, emission `:3412-3418`), incl. `S.code` binding | B1/source3 |
| `AttemptPointwiseAt jatt attemptFactor` | the analytic core (`AttemptShape` + `AttemptWeights`, the 4-stage sandwich) | B4/3a names, B1/source3 binding |

`localJointCertificate_of_attemptFactor` packages exactly this: with
`hone` discharged, the named input list drops to those three. Outside the
theorem's scope (unchanged): the byte-bridge swallow and the additive-error
caveat (`Adv_PRG` mass floor).

## 5. Compile receipt

- Source: `formal/ONoneGeometry.lean`; module `ONoneGeometry`; command
  `bash tools/original/run_lean_guarded.sh formal/ONoneGeometry.lean
  .build/check_lib/ONoneGeometry.olean 900 3600` — exit 0.
- Log `.build/check_lib/ONoneGeometry.log`: **empty** = 0 errors / 0 warnings.
- Axiom audit `.build/audit/ONoneGeometryAudit.lean` + `.log` (scratch under
  ignored `.build/`, nothing else touched): **25/25 declarations (21
  theorems + 4 defs), axioms ⊆ `[propext, Classical.choice, Quot.sound]`**;
  `liftFin*`, `decodeVec_liftVec_apply` and the 4 defs need not even
  `Classical.choice`.
- Marker check: no `sorry`/`admit`/`native_decide`/placeholders (strict
  word-boundary grep; the prose word "admits" was reworded to keep naive
  greps clean).
- Dependencies (REUSE, unmodified): `HacGlue` (`ONone`,
  `signBody_none_pos_of_ONone`, `attempt_miss_satisfiable_iff_onone`,
  `localJointCertificate_of_named_premises_attemptFactor`), pinned
  `FT1536.Relation` (`A`, `reduceVec`, `mulRq`, `Rq`),
  `FT1536.SigmaMath.syndrome`, `FT1536.PublicSimulation`
  (`BoxPair`/`BoxVec`, `decodeVec`, `decode`, `signBody`),
  `FT1536.Geometry` (`block`, `Q0`, `Q`, `B`, `block_nonneg`),
  `FT1536.SignLayerSupport` (`AttemptPointwise`, `attemptFactor`, `e2`),
  `FT1536.Run2` (`Sampler`, `LocalJointCertificate`).

## 6. Lessons (toolchain, for the next batch)

- **`ZMod` numerals break `rw [CharP.cast_eq_zero ...]`**: the goal numeral
  is `OfNat.ofNat 18433`, while the lemma's pattern is `Nat.cast 18433`, and
  simp's `Nat.cast_ofNat` normalizes towards the `OfNat` form — the pattern
  never matches. Route the congruence through `ZMod.intCast_mod` +
  `congr 1` + an `Int`-level `%` fact closed by `omega` (also avoids
  `push_cast` numeral archaeology); `exact` (defeq) works where `rw`
  (syntactic) fails.
- **`single_le_sum` with underscore holes** (`block_nonneg _ _`) loops in
  unification (`?f ?j` flex-flex) and dies with `maximum recursion depth`;
  pass the pointwise arguments explicitly (as `Geometry.coord_bound` does).
- `omega` closed all the lift arithmetic in one line each: Nat identities
  with `%`/`/` by the constant `18433` (`liftFin_add_mul`, `liftFin_emod`,
  `liftFin_ge`) and a mixed ℕ/ℤ cast goal (`liftFin_decode_ge`).
- `Prod` eta is definitional: `A (liftPair z) = A z` unifies with
  `hp (liftVec z.1) z.1 z.2 _ : A (liftVec z.1, z.2) = A (z.1, z.2)` — no
  destructuring needed in `onone_of_qPeriodic`.
- `not_lt.mpr : a ≤ b → ¬ b < a` is the clean bridge from a `B ≤ Q` bound to
  the `¬ Q < B` form of `ONone`.

## 7. Polish handoff note (skrót dla właściciela)

**Co udało się wykazać:** przesłanka O-NONE jest dowiedziona w całości i bez
żadnych założeń nazwanych. Końcowa forma (kompatybilna z binderem `hone`
`HacGlue.localJointCertificate_of_named_premises`):

```lean
theorem hone : ∀ h : FT1536.Relation.Rq, HacGlue.ONone (FT1536.SigmaMath.syndrome h)
```

Dla każdego klucza `h` i każdego osiągalnego celu `c` fiber `Relation.A h`
zawiera punkt poza bramką normy (`B ≤ Q`), w środku skończonego boxu — czyli
`signBody (syndrome h) c` ma dodatnią masę w `none`
(`signBody_none_pos_syndrome`). Mechanizm jest prostszy niż zakładano w
promptcie: `Relation.A` zależy wyłącznie od reszt współrzędnych mod 18433,
więc fiber jest kosetem siatki resztowej `18433·Z` (ranga 1536 na połówkę),
a szerokość boxu (65535) pozwala przesunąć punkt do współrzędnej ≥ 47103,
gdzie `block ≥ 2·47103² = 4437385218 > 2093922385 = B`. Nie są potrzebne
równania NTRU (`fG−gF=q`, `h*f=g`) ani żadna hipoteza „rozprzestrzeniania
siatki” — osiągalność (niepusty fiber) wystarcza.

**Co B1 ma dostarczyć dla O-NONE: nic.** Rung B1/source3 zachowuje swoje
wejścia tylko dla pozostałych dwóch przesłanek Layer 2: `ReplyShape`
(kształt prawa próby związany z pinned C) i `AttemptPointwise` przy
`attemptFactor` (rdzeń analityczny B4/3a). Po rozładowaniu O-NONE lista
argumentów certyfikatu B4 spada do trzech nazwanych przesłanek —
`UniformChallenge`, `ReplyShape`, `AttemptPointwise` (gotowy pakiet:
`localJointCertificate_of_attemptFactor`, `e < 2^-32`).

**Co zostaje otwarte (poza zakresem tego okna, bez zmian):** most bajtowy
(masa poza obrazem `emit` psuje AC) i zastrzeżenie o błędach addytywnych
(`Adv_PRG` wymaga podłogi masy). O-NONE mówi wyłącznie o dodatniej masie
`none` — nie jest to twierdzenie o bezpieczeństwie ani o korektności.

**Następny krok:** B5 może montować szkielet z
`localJointCertificate_of_attemptFactor`; do domknięcia pełnej listy potrzeba
już tylko `ReplyShape` (B1/source3) i `AttemptPointwise` (zależności
analityczne B4/3a: `AttemptShape`, `AttemptWeights`).
