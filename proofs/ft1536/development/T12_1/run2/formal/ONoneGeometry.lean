import HacGlue

/-! # ONoneGeometry — the fiber geometry of `Relation.A` (window O-NONE)

Window O-NONE of the remaining B4 scope (`notes/B4_SYNTHESIS.md`, named
premise 4 of `HacGlue.localJointCertificate_of_named_premises`): discharge
`hone : ∀ h, ONone (syndrome h)` — positive `none` mass of
`signBody (syndrome h) c` at every challenge (consumed through
`HacGlue.signBody_none_pos_of_ONone` and pinned exactly by
`HacGlue.attempt_miss_satisfiable_iff_onone`).

Deliverables of THIS module (kernel-checked, no unfinished-proof markers,
standard axioms only):

1. **Fiber algebra (batch 1).** The fiber
   `F_c = {z : BoxPair | Relation.A h (decode z) = c}` is a coset of a
   RESIDUE lattice — `Relation.A h` sees the decoded halves only through
   `Relation.reduceVec`, i.e. through the coordinate residues mod
   `q = 18433` (`A_eq_of_reduceVec`, `qPeriodic_syndrome`) — and `liftFin` /
   `liftVec` / `liftPair` move any box point along that lattice to the top
   of its box (`reduceVec_decode_liftVec`) without leaving the fiber.
2. **The finite spread (batch 2).** Every nonempty fiber contains an
   out-of-box point INSIDE the decode box (`liftPair_norm_ge`,
   `liftPair_out_of_box`): the lift pushes both stored coordinates of every
   pair to the top of their residue class (decoded coordinate `≥ 47103`,
   `liftFin_decode_ge`), and `block_two_coords` gives
   `block x y ≥ 2 * 47103 ^ 2 = 4437385218 > 2093922385 = B`. The exact
   finite input is fiber NONEMPTINESS only (the achievability antecedent
   already built into `HacGlue.ONone`) — no `|F_c| ≥ 2`, no nondegenerate
   lattice direction.
3. **The discharge and its consumption (batch 2).** `onone_of_qPeriodic`,
   `onone_syndrome`, `hone`: O-NONE holds for `syndrome h` at EVERY `h`,
   UNCONDITIONALLY — no named hypothesis is left for this premise and rung
   B1 owes nothing for it. Consumption: `signBody_none_pos_syndrome`
   (positive `none` mass at every challenge),
   `attempt_miss_satisfiable` (the exactness pin of
   `HacGlue.attempt_miss_satisfiable_iff_onone`) and
   `localJointCertificate_of_attemptFactor` (the B4 certificate at the
   candidate factor with O-NONE DISCHARGED; its remaining named inputs are
   exactly `UniformChallenge`, `ReplyShape`, `AttemptPointwise`).

No NTRU equation (`fG - gF = q`, `h * f = g`) is used or needed here: the
key-side geometry of rung B1 is NOT consumed by this window. All statements
are on the pinned types (`FT1536.Relation`, `FT1536.PublicSimulation`,
`FT1536.Geometry`, `FT1536.SigmaMath`, `FT1536.HacGlue`,
`FT1536.SignLayerSupport`, `FT1536.Run2`); nothing is assumed. Pinned
numbers: decode box `Fin 131071` per stored coordinate (decoded coordinate
`|x| ≤ 65535`, `PublicSimulation.decodeVec`), modulus `18433`, norm gate
`Q < B` with `B = 2093922385`, `block x y = x^2 + x*y + y^2`.
-/

namespace FT1536.ONoneGeometry
open Finset FT1536 FT1536.PublicSimulation FT1536.Geometry

/-! ## 0. Definitions (the lift and the residue-periodicity interface) -/

/-- Top-of-box representative of the residue class of a stored coordinate:
the largest stored value `≤ 131070` congruent to `a` modulo `18433`. In
decoded coordinates (value minus `65535`, `PublicSimulation.decodeVec`) the
result is `≥ 131070 - 18432 - 65535 = 47103` (`liftFin_decode_ge`) — this
one-sided bound is the entire numeric input of the spread step. -/
def liftFin (a : Fin 131071) : Fin 131071 :=
  ⟨131070 - ((131070 - a.val) % 18433), by
    have h := a.isLt
    omega⟩

/-- Coordinatewise lift of one box half: every stored pair moves to the top
of its residue class mod `18433`, so `Relation.reduceVec` of the decoded half
is unchanged (`reduceVec_decode_liftVec`) while the coordinates grow towards
the box wall. -/
def liftVec (v : BoxVec) : BoxVec := fun i => (liftFin (v i).1, liftFin (v i).2)

/-- THE O-NONE box-point witness map: lift the first half of `z`, keep the
second half in place. -/
def liftPair (z : BoxPair) : BoxPair := (liftVec z.1, z.2)

/-- Residue-periodicity of `A : BoxPair → Relation.Rq` in its first half: the
value depends on the decoded first half only through `Relation.reduceVec`,
i.e. only through the coordinate residues mod `18433`. This is the exact
algebraic input of the O-NONE discharge; `SigmaMath.syndrome h` has it for
every `h` (`qPeriodic_syndrome`) by the definition of `Relation.A`. -/
def qPeriodic (A : BoxPair → FT1536.Relation.Rq) : Prop :=
  ∀ u v w : BoxVec,
    FT1536.Relation.reduceVec (decodeVec u) = FT1536.Relation.reduceVec (decodeVec v) →
    A (u, w) = A (v, w)

/-! ## 1. The lift: exact form, residue preservation, top-of-box bound -/

theorem liftFin_val (a : Fin 131071) :
    (liftFin a).val = 131070 - ((131070 - a.val) % 18433) := rfl

/-- The lift is a residue move: the stored value changes by a multiple of
`18433`, so its residue class mod `18433` is preserved. -/
theorem liftFin_add_mul (a : Fin 131071) :
    (liftFin a).val = a.val + 18433 * ((131070 - a.val) / 18433) := by
  rw [liftFin_val]
  omega

/-- The lift reaches the top region of the box wall: stored value `≥ 112638`
(`131070 - 18432`), i.e. decoded coordinate `≥ 47103`. -/
theorem liftFin_ge (a : Fin 131071) : 112638 ≤ (liftFin a).val := by
  rw [liftFin_val]
  omega

/-- Decoded-coordinate form of the top-of-box bound. -/
theorem liftFin_decode_ge (a : Fin 131071) :
    (47103 : ℤ) ≤ ((liftFin a).val : ℤ) - 65535 := by
  have h := liftFin_ge a
  omega

/-- Residue preservation at the `Int` level (from `liftFin_add_mul`). -/
theorem liftFin_emod (a : Fin 131071) :
    ((liftFin a).val : ℤ) % (18433 : ℤ) = (a.val : ℤ) % (18433 : ℤ) := by
  rw [liftFin_add_mul a]
  omega

/-- Residue preservation at the `Relation.reduceVec` level: the lifted stored
coordinate has the same image in `ZMod 18433`. -/
theorem cast_liftFin (a : Fin 131071) :
    (((liftFin a).val : ℤ) : ZMod 18433) = ((a.val : ℤ) : ZMod 18433) := by
  rw [← ZMod.intCast_mod ((liftFin a).val : ℤ) 18433,
    ← ZMod.intCast_mod (a.val : ℤ) 18433]
  congr 1
  exact liftFin_emod a

/-- Residue preservation of a whole decoded coordinate (the `- 65535` box
offset cancels on both sides). -/
theorem cast_liftFin_sub (x : Fin 131071) :
    (((((liftFin x).val : ℤ) - 65535 : ℤ) : ZMod 18433)) =
      (((((x.val : ℤ) - 65535 : ℤ)) : ZMod 18433)) := by
  have h := cast_liftFin x
  push_cast at h ⊢
  rw [h]

/-- The decoded coordinates of a lifted half (exact form). -/
theorem decodeVec_liftVec_apply (v : BoxVec) (i : Fin 768) :
    decodeVec (liftVec v) i =
      (((liftFin (v i).1).val : ℤ) - 65535, ((liftFin (v i).2).val : ℤ) - 65535) := rfl

/-- THE algebraic structure fact: lifting a box half preserves its
`Relation.reduceVec`, i.e. its coordinate residues mod `18433`. Hence every
fiber `F_c` of `Relation.A h` (of any `qPeriodic A`) is invariant under the
rank-1536 residue lattice `18433 * Z` of each half. -/
theorem reduceVec_decode_liftVec (v : BoxVec) :
    FT1536.Relation.reduceVec (decodeVec (liftVec v))
      = FT1536.Relation.reduceVec (decodeVec v) := by
  funext i
  simp only [Relation.reduceVec, decodeVec, liftVec]
  rw [cast_liftFin_sub (v i).1, cast_liftFin_sub (v i).2]

/-! ## 2. Fiber algebra: `Relation.A` sees only residues -/

theorem A_eq_of_reduceVec {h : FT1536.Relation.Rq} {u u' w : FT1536.Geometry.Vec}
    (hres : FT1536.Relation.reduceVec u = FT1536.Relation.reduceVec u') :
    FT1536.Relation.A h (u, w) = FT1536.Relation.A h (u', w) := by
  show FT1536.Relation.reduceVec u + FT1536.Relation.mulRq h (FT1536.Relation.reduceVec w)
      = FT1536.Relation.reduceVec u' + FT1536.Relation.mulRq h (FT1536.Relation.reduceVec w)
  rw [hres]

/-- Residue-periodicity of the pinned syndrome map `syndrome h = Relation.A h
∘ decode` at EVERY key `h` — no NTRU equation involved. -/
theorem syndrome_eq_of_reduceVec (h : FT1536.Relation.Rq) (u v w : BoxVec)
    (hres : FT1536.Relation.reduceVec (decodeVec u) = FT1536.Relation.reduceVec (decodeVec v)) :
    FT1536.SigmaMath.syndrome h (u, w) = FT1536.SigmaMath.syndrome h (v, w) := by
  show FT1536.Relation.A h (decodeVec u, decodeVec w)
      = FT1536.Relation.A h (decodeVec v, decodeVec w)
  exact A_eq_of_reduceVec hres

theorem qPeriodic_syndrome (h : FT1536.Relation.Rq) :
    qPeriodic (FT1536.SigmaMath.syndrome h) :=
  fun u v w hres => syndrome_eq_of_reduceVec h u v w hres

/-! ## 3. The finite spread: the lifted point is out of the norm gate -/

/-- Exact spread of the norm form: two coordinates of one decoded pair at
`t` or above force `2 * t ^ 2 ≤ block x y = x^2 + x*y + y^2` (the cross term
is nonnegative there, and each square dominates `t ^ 2`). -/
theorem block_two_coords {t x y : ℤ} (ht : 0 ≤ t) (hx : t ≤ x) (hy : t ≤ y) :
    2 * t ^ 2 ≤ block x y := by
  rw [pow_two]
  have hxs : t * t ≤ x * x := mul_self_le_mul_self ht hx
  have hys : t * t ≤ y * y := mul_self_le_mul_self ht hy
  have hxy : 0 ≤ x * y := mul_nonneg (le_trans ht hx) (le_trans ht hy)
  unfold block
  nlinarith

/-- THE finite spread of the fiber geometry: the lift of ANY box point is
outside the norm gate — `B ≤ Q (decode (liftPair z))` — while staying inside
the decode box and (by `reduceVec_decode_liftVec`) inside the fiber. Numeric
margin (exact): `2 * 47103 ^ 2 = 4437385218 > 2093922385 = B`. -/
theorem liftPair_norm_ge (z : BoxPair) : B ≤ Q (decode (liftPair z)) := by
  have ht : (2 * 47103 ^ 2 : ℤ) ≤ block (((liftFin (z.1 0).1).val : ℤ) - 65535)
      (((liftFin (z.1 0).2).val : ℤ) - 65535) :=
    block_two_coords (by norm_num) (liftFin_decode_ge (z.1 0).1)
      (liftFin_decode_ge (z.1 0).2)
  have hterm : block (((liftFin (z.1 0).1).val : ℤ) - 65535)
      (((liftFin (z.1 0).2).val : ℤ) - 65535) ≤ Q0 (decodeVec (liftVec z.1)) := by
    have hbase : block ((decodeVec (liftVec z.1) (0 : Fin 768)).1)
        ((decodeVec (liftVec z.1) (0 : Fin 768)).2) ≤ Q0 (decodeVec (liftVec z.1)) :=
      single_le_sum
        (fun j _ => block_nonneg (decodeVec (liftVec z.1) j).1 (decodeVec (liftVec z.1) j).2)
        (mem_univ (0 : Fin 768))
    rw [decodeVec_liftVec_apply] at hbase
    exact hbase
  have hB : B < 2 * 47103 ^ 2 := by norm_num [B]
  have heq : Q (decode (liftPair z)) = Q0 (decodeVec (liftVec z.1)) + Q0 (decodeVec z.2) := rfl
  rw [heq]
  linarith [Q0_nonneg (decodeVec z.2)]

/-- THE O-NONE box point: every box point has a same-fiber partner outside
the norm gate (`¬ Q (decode z') < B`) — the trial law's miss point `none` is
always reachable. -/
theorem liftPair_out_of_box (z : BoxPair) : ¬ Q (decode (liftPair z)) < B :=
  not_lt.mpr (liftPair_norm_ge z)

/-! ## 4. The O-NONE discharge and its consumption -/

/-- O-NONE from residue-periodicity: the lift is a same-fiber move to the
out-of-box region, so every achievable target has an out-of-box fiber
point. -/
theorem onone_of_qPeriodic (A : BoxPair → FT1536.Relation.Rq) (hp : qPeriodic A) :
    HacGlue.ONone A := by
  intro c hc
  obtain ⟨z, hz⟩ := hc
  refine ⟨liftPair z, ?_, liftPair_out_of_box z⟩
  rw [← hz]
  exact hp (liftVec z.1) z.1 z.2 (reduceVec_decode_liftVec z.1)

/-- O-NONE for the pinned syndrome map at every key `h` — unconditional. -/
theorem onone_syndrome (h : FT1536.Relation.Rq) :
    HacGlue.ONone (FT1536.SigmaMath.syndrome h) :=
  onone_of_qPeriodic _ (qPeriodic_syndrome h)

/-- THE final form of named premise `O-NONE` (`hone`) of
`HacGlue.localJointCertificate_of_named_premises` — PROVED with NO named
hypothesis attached: for every key `h` and every ACHIEVABLE target `c` the
fiber of `syndrome h` over `c` contains an out-of-box point (`B ≤ Q`), so
`signBody (syndrome h) c` carries positive `none` mass. Nothing is assumed
and nothing remains for rung B1 to supply for THIS premise (the remaining
B1 input is `ReplyShape` and the `AttemptPointwise` core). -/
theorem hone : ∀ h : FT1536.Relation.Rq, HacGlue.ONone (FT1536.SigmaMath.syndrome h) :=
  fun h => onone_syndrome h

/-- Consumption (support route of `HacGlue.hac_of_support`): positive `none`
mass of the honest body at EVERY challenge under every key. -/
theorem signBody_none_pos_syndrome (h c : FT1536.Relation.Rq) :
    0 < (signBody (FT1536.SigmaMath.syndrome h) c).mass none :=
  HacGlue.signBody_none_pos_of_ONone _ (hone h) c

/-- Consumption (the exactness pin `HacGlue.attempt_miss_satisfiable_iff_onone`):
at every ACHIEVABLE challenge the `none`-side of
`SignLayerSupport.AttemptPointwise` supports a MISS-CAPABLE attempt law — the
real sampler's positive miss budget (`FT1536.CenteringClosure.rejB`) can
always be placed. -/
theorem attempt_miss_satisfiable (h c : FT1536.Relation.Rq)
    (hach : ∃ z : BoxPair, FT1536.SigmaMath.syndrome h z = c) :
    ∃ (jT : Law (Option BoxPair)) (k : ℝ),
      SignLayerSupport.AttemptPointwise jT (FT1536.SigmaMath.syndrome h) c k ∧
        0 < jT.mass none :=
  (HacGlue.attempt_miss_satisfiable_iff_onone _ c hach).2 (hone h c hach)

/-- THE B4 certificate at the candidate factor with O-NONE DISCHARGED: the
remaining named inputs are exactly `UniformChallenge` (Layer 1, the ROM
assumption), `ReplyShape` (source binding, B1/source3) and `AttemptPointwise`
(the analytic core, window B4/3a). -/
theorem localJointCertificate_of_attemptFactor (S : FT1536.Run2.Sampler)
    (jatt : HacGlue.AttemptFamily) (huc : HacGlue.UniformChallengeAt S)
    (hshape : HacGlue.ReplyShapeAt S jatt)
    (hattempt : HacGlue.AttemptPointwiseAt jatt SignLayerSupport.attemptFactor) :
    FT1536.Run2.LocalJointCertificate S (SignLayerSupport.e2 SignLayerSupport.attemptFactor) :=
  HacGlue.localJointCertificate_of_named_premises_attemptFactor S jatt huc hshape hattempt hone

end FT1536.ONoneGeometry
