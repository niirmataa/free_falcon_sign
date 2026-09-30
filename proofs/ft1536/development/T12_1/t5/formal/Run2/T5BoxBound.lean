import Run2.T5CholeskyCert
import Run2.GaussianFiberTilt

set_option exponentiation.threshold 100000
set_option maxRecDepth 65536

namespace FT1536.Run2.T5BoxBound
open TriangularGaussian T5GateBudget T5TowerMass GaussianFiberTilt
open FT1536.Relation FT1536.Geometry FT1536.PublicSimulation
open CoefficientQuotient ActualNTRUFiber

/- Kernel part of the finite proposal-box transport (obligation (c)): the
   finite-box fiber mass never exceeds the infinite coset mass. The
   infinite side is summable through the tower representation; the finite
   side is a restriction of the same nonnegative function. -/

theorem atom_exp_eq (T : Tower 3072) : ∀ w : Points 3072,
    atom T w = Real.exp (-Real.pi*quad T w) := atom_eq_exp T

theorem infFiberMass_summable {h c : Rq} {a : ℝ} (hr : TowerRep h c a) :
    Summable (fun w : {z : Vec×Vec // A h z = c} => Real.exp (-a*(Q w.val : ℝ))) := by
  have hr0 : (0 : ℝ) < gateRatio := by unfold gateRatio; positivity
  have hr1 : gateRatio < 1 := by unfold gateRatio; norm_num
  have hts := tower_summable hr.T gateRatio hr0 hr1 hr.localExp
  have hfun : (fun w : Points 3072 => Real.exp (-Real.pi*quad hr.T w)) = atom hr.T :=
    funext (fun w => (atom_exp_eq hr.T w).symm)
  have hs1 : Summable (fun w : Points 3072 => Real.exp (-Real.pi*quad hr.T w)) :=
    Eq.mpr (congrArg Summable hfun) hts
  have hs2 : Summable (fun u : Vec×Vec => Real.exp (-Real.pi*quad hr.T (hr.idx u))) :=
    hs1.comp_injective hr.idx.injective
  have hform : ∀ u : Vec×Vec,
      Real.exp (-a*(Q (coordinates hr.f hr.g hr.bigF hr.bigG h hr.fInv c
          hr.ntru hr.public_eq hr.inverse_eq u).val : ℝ))
        = Real.exp (-Real.pi*quad hr.T (hr.idx u)) := by
    intro u
    congr 1
    rw [← hr.quadEq u, coordinates_formula hr.f hr.g hr.bigF hr.bigG h hr.fInv c
      hr.ntru hr.public_eq hr.inverse_eq u]
    field_simp
  have hfun2 : (fun u : Vec×Vec => Real.exp (-a*
        (Q (coordinates hr.f hr.g hr.bigF hr.bigG h hr.fInv c
          hr.ntru hr.public_eq hr.inverse_eq u).val : ℝ)))
      = (fun u : Vec×Vec => Real.exp (-Real.pi*quad hr.T (hr.idx u))) :=
    funext hform
  have hs3 : Summable (fun u : Vec×Vec => Real.exp (-a*
      (Q (coordinates hr.f hr.g hr.bigF hr.bigG h hr.fInv c
        hr.ntru hr.public_eq hr.inverse_eq u).val : ℝ))) :=
    Eq.mpr (congrArg Summable hfun2) hs2
  have hinj : Function.Injective
      (coordinates hr.f hr.g hr.bigF hr.bigG h hr.fInv c
        hr.ntru hr.public_eq hr.inverse_eq).symm :=
    (coordinates hr.f hr.g hr.bigF hr.bigG h hr.fInv c
      hr.ntru hr.public_eq hr.inverse_eq).symm.injective
  have hs4 := hs3.comp_injective hinj
  have hfun3 : (fun w : {z : Vec×Vec // A h z = c} => Real.exp (-a*
        (Q ((coordinates hr.f hr.g hr.bigF hr.bigG h hr.fInv c
          hr.ntru hr.public_eq hr.inverse_eq)
            ((coordinates hr.f hr.g hr.bigF hr.bigG h hr.fInv c
              hr.ntru hr.public_eq hr.inverse_eq).symm w)).val : ℝ)))
      = (fun w : {z : Vec×Vec // A h z = c} => Real.exp (-a*(Q w.val : ℝ))) := by
    funext w
    congr 1
    rw [(coordinates hr.f hr.g hr.bigF hr.bigG h hr.fInv c
      hr.ntru hr.public_eq hr.inverse_eq).apply_symm_apply w]
  exact Eq.mp (congrArg Summable hfun3) hs4

/- The tilted tower representation is derived from the base certificate;
   no second algebraic input is needed at the Chernoff scale. -/
noncomputable def tiltedTowerRep {h c : Rq} {a : ℝ} (hr : TowerRep h c a) :
    TowerRep h c ((7/8 : ℝ)*a) where
  f := hr.f
  g := hr.g
  bigF := hr.bigF
  bigG := hr.bigG
  fInv := hr.fInv
  ntru := hr.ntru
  public_eq := hr.public_eq
  inverse_eq := hr.inverse_eq
  T := tiltTower (7/8) hr.T
  idx := hr.idx
  quadEq := by
    intro u
    rw [quad_tiltTower, ← hr.quadEq u]
    field_simp
  localExp := localExponent_tiltTower (7/8) (by norm_num) (by norm_num) hr.localExp

theorem decodeVec_injective : Function.Injective decodeVec := by
  intro v w h
  funext i
  have hi := congrFun h i
  refine Prod.ext ?_ ?_
  · have hp : ((v i).1.val - (65535 : ℤ)) = ((w i).1.val - (65535 : ℤ)) :=
      congrArg Prod.fst hi
    have h1 : ((v i).1.val : ℤ) = ((w i).1.val : ℤ) := by linarith
    exact Fin.val_injective (by exact_mod_cast h1)
  · have hp : ((v i).2.val - (65535 : ℤ)) = ((w i).2.val - (65535 : ℤ)) :=
      congrArg Prod.snd hi
    have h2 : ((v i).2.val : ℤ) = ((w i).2.val : ℤ) := by linarith
    exact Fin.val_injective (by exact_mod_cast h2)

theorem decode_injective : Function.Injective (decode : BoxPair → Vec×Vec) := by
  intro z w h
  have h1 : decodeVec z.1 = decodeVec w.1 := congrArg Prod.fst h
  have h2 : decodeVec z.2 = decodeVec w.2 := congrArg Prod.snd h
  exact Prod.ext (decodeVec_injective h1) (decodeVec_injective h2)

def fiberEmbed (h c : Rq) :
    {z : BoxPair // z ∈ Finset.univ.filter (fun z : BoxPair => FT1536.Relation.A h (decode z) = c)}
      ↪ {z : Vec×Vec // A h z = c} where
  toFun z := ⟨decode z.val, (Finset.mem_filter.mp z.prop).2⟩
  inj' := by
    intro x y he
    apply Subtype.ext
    exact decode_injective (congrArg Subtype.val he)

theorem fiberMass_le_infFiberMass {h c : Rq} {a : ℝ} (hr : TowerRep h c a) :
    fiberMass h c a ≤ infFiberMass h c a := by
  classical
  have hkey : (fun z : BoxPair => SigmaMath.syndrome h z = c)
      = (fun z : BoxPair => FT1536.Relation.A h (decode z) = c) := rfl
  have hsum : fiberMass h c a =
      ∑ z ∈ (Finset.univ.filter (fun z : BoxPair => SigmaMath.syndrome h z = c)),
        weight a z := by
    unfold fiberMass
    rw [← Finset.sum_filter]
  rw [hsum]
  simp only [hkey]
  have hmap : (∑ z ∈ (Finset.univ.filter (fun z : BoxPair => FT1536.Relation.A h (decode z) = c)),
        weight a z)
      = ∑ w ∈ (Finset.univ.filter (fun z : BoxPair => FT1536.Relation.A h (decode z) = c)).attach.map
          (fiberEmbed h c), Real.exp (-a*(Q w.val : ℝ)) := by
    rw [Finset.sum_map, ← Finset.sum_attach]
    apply Finset.sum_congr rfl
    intro z _
    show weight a z = Real.exp (-a*(Q (decode z.val) : ℝ))
    unfold weight
    rfl
  rw [hmap]
  exact Summable.sum_le_tsum _
    (fun w _ => (Real.exp_pos _).le) (infFiberMass_summable hr)

end FT1536.Run2.T5BoxBound
