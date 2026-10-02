import HacGlue

/-! # ONoneGeometry — the fiber geometry of `Relation.A` (window O-NONE)

Window O-NONE of the remaining B4 scope (`notes/B4_SYNTHESIS.md`, named
premise 4 of `HacGlue.localJointCertificate_of_named_premises`): discharge
`hone : ∀ h, ONone (syndrome h)` — positive `none` mass of
`signBody (syndrome h) c` at every challenge (consumed through
`HacGlue.signBody_none_pos_of_ONone` and pinned exactly by
`HacGlue.attempt_miss_satisfiable_iff_onone`).

Batch 1 (the algebraic half): the fiber
`F_c = {z : BoxPair | Relation.A h (decode z) = c}` is a coset of a RESIDUE
lattice — `Relation.A h` sees the decoded halves only through
`Relation.reduceVec`, i.e. through the coordinate residues mod `q = 18433`
(`A_eq_of_reduceVec`, `qPeriodic_syndrome`) — and `liftFin` / `liftVec` /
`liftPair` move any box point along that lattice to the top of its box
(`reduceVec_decode_liftVec`) without leaving the fiber.

No NTRU equation (`fG - gF = q`, `h * f = g`) is used or needed here: the
key-side geometry of rung B1 is NOT consumed by this window. All statements
are on the pinned types (`FT1536.Relation`, `FT1536.PublicSimulation`,
`FT1536.Geometry`, `FT1536.SigmaMath`, `FT1536.HacGlue`); nothing is
assumed. Pinned numbers: decode box `Fin 131071` per stored coordinate
(decoded coordinate `|x| ≤ 65535`, `PublicSimulation.decodeVec`), modulus
`18433`.
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

end FT1536.ONoneGeometry
