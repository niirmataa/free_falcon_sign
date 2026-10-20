import Run2.Games
import FT1536.Certificate

namespace FT1536.Run2.BadVerify
open Finset PublicSimulation Geometry
open FT1536.Relation

theorem map_mass_ge {α β : Type} [Fintype α] [Fintype β] [DecidableEq β]
    (p : Law α) (f : α → β) (x : α) : p.mass x ≤ (p.map f).mass (f x) := by
  change p.mass x ≤ ∑ y, p.mass y * (Law.pure (f y)).mass (f x)
  have hs := single_le_sum (s := univ) (f := fun y => p.mass y * (Law.pure (f y)).mass (f x))
    (fun y _ => mul_nonneg (p.nonneg y) ((Law.pure (f y)).nonneg (f x))) (mem_univ x)
  simpa only [Law.pure, ite_true, mul_one] using hs

theorem cap_first_positive {α : Type} [Fintype α] [DecidableEq α]
    (trial : Law (Option α)) (x : α) (hx : 0 < trial.mass (some x)) (n : ℕ) :
    0 < (MathSign.cap trial (n+1)).mass (some x) := by
  rw [MathSign.cap_some]
  apply mul_pos _ hx
  apply sum_pos'
  · intro i _; exact pow_nonneg (trial.nonneg none) _
  · exact ⟨0, mem_range.mpr (Nat.zero_lt_succ n), by simp⟩

theorem trial_positive {C : Type} [DecidableEq C] (A : BoxPair → C) (z : BoxPair)
    (hz : Q (decode z) < B) : 0 < (trial A (A z)).mass (some z) := by
  classical
  have hw : 0 < fiberWeight A (A z) z := by simp [fiberWeight, gaussianWeight, Real.exp_pos]
  have hs : 0 < ∑ y, fiberWeight A (A z) y :=
    sum_pos' (fun y _ => fiberWeight_nonneg A (A z) y) ⟨z,mem_univ z,hw⟩
  simp only [trial, dite_eq_left hs]
  have hp : 0 < (Law.weighted (fiberWeight A (A z)) (fiberWeight_nonneg A (A z)) hs).mass z :=
    div_pos hw hs
  have hm := map_mass_ge (Law.weighted _ (fiberWeight_nonneg A (A z)) hs)
    (fun y => if Q (decode y) < B then some y else none) z
  simpa only [ite_eq_left hz] using hp.trans_le hm

def v : Vec := spike 9217 (-5000)
def w : Vec := spike 32767 18000

theorem w_signed : FT1536.Relation.signed16 w := by
  intro i
  by_cases hi : i=0 <;> norm_num [w,spike,hi]

theorem center_reduce_v : centerRq (reduceVec v) = centerVec v := by
  have hc (x : ℤ) : center (x : ZMod 18433).val = center x := by
    unfold center
    rw [ZMod.val_intCast]
    omega
  funext i
  exact Prod.ext (hc (v i).1) (hc (v i).2)

theorem rejects (h : Rq) : ¬ Verify h (A h (v,w)) w := by
  intro hv
  have hh := hv.2
  simp only [extract, A, add_sub_cancel_right, center_reduce_v] at hh
  exact centering_can_break_acceptance.2 hh

theorem emitted_bad_mass (h : Rq) :
    ∃ c s, 0 < (SigmaMath.freshHonest h).mass (c,some s) ∧
      ¬ Verify h c (decodeVec s) := by
  classical
  have hn : Q (v,w) < B := centering_can_break_acceptance.1
  obtain ⟨z,hz⟩ := full_norm_support_in_box v w hn
  have hz2 : decodeVec z.2 = w := congrArg Prod.snd hz
  have hem : emit z = some z.2 := by
    have hs : PublicSimulation.signed16 z.2 := by
      simpa only [PublicSimulation.signed16, FT1536.Relation.signed16, hz2] using w_signed
    simp [emit,hs]
  have ht := trial_positive (SigmaMath.syndrome h) z (by simpa [hz] using hn)
  have hc := cap_first_positive (trial (SigmaMath.syndrome h) (SigmaMath.syndrome h z)) z ht 15
  have hm := map_mass_ge (MathSign.cap (trial (SigmaMath.syndrome h) (SigmaMath.syndrome h z)) 16)
    (MathSign.emit emit) (some z)
  have hb : 0 < (signBody (SigmaMath.syndrome h) (SigmaMath.syndrome h z)).mass (some z.2) := by
    simpa only [signBody, MathSign.emit, hem] using hc.trans_le hm
  refine ⟨SigmaMath.syndrome h z,z.2,?_,?_⟩
  · change 0 < (Law.uniform : Law Rq).mass _ * _
    apply mul_pos _ hb
    change 0 < 1/(Fintype.card Rq : ℝ)
    positivity
  · rw [hz2]
    simpa only [SigmaMath.syndrome, hz] using rejects h

noncomputable def Bad (h : Rq) (co : Rq × Option BoxVec) : Prop :=
  ∃ s, co.2 = some s ∧ ¬ Verify h co.1 (decodeVec s)

noncomputable instance (h : Rq) : DecidablePred (Bad h) := Classical.decPred _

theorem freshHonest_badVerify_positive (h : Rq) :
    0 < (SigmaMath.freshHonest h).event (Bad h) := by
  classical
  obtain ⟨c,s,hp,hv⟩ := emitted_bad_mass h
  have he : Bad h (c,some s) := ⟨s,rfl,hv⟩
  apply hp.trans_le
  change (SigmaMath.freshHonest h).mass (c,some s) ≤
    ∑ co, if Bad h co then (SigmaMath.freshHonest h).mass co else 0
  calc
    _ = (if Bad h (c,some s) then (SigmaMath.freshHonest h).mass (c,some s) else 0) := by simp [he]
    _ ≤ _ := single_le_sum (s := univ)
      (f := fun co => if Bad h co then (SigmaMath.freshHonest h).mass co else 0)
      (fun co _ => by split_ifs; exact (SigmaMath.freshHonest h).nonneg co; rfl)
      (mem_univ (c,some s))

end FT1536.Run2.BadVerify
