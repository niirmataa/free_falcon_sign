import SamplerMassCondition014
import Run2.T5BoxBound
import Run2.CenteringTriangle

/- Q-SAMPLER proof obligation. Exact finite restriction of the full integer
   fiber. Summability follows from the positive lower bound in M, with no
   additional temperature or stronger tower gate. -/
namespace FT1536.S05.BoxSupport015
open FT1536.Geometry FT1536.Relation FT1536.PublicSimulation
open FT1536.Run2 FT1536.Run2.GaussianFiberTilt
open SamplerMassCondition014

abbrev Fiber (h c : Rq) := {z : Vec × Vec // FT1536.Relation.A h z=c}
noncomputable def atom (a : ℝ) (z : Fiber h c) : ℝ := Real.exp (-a*(Q z.val : ℝ))
noncomputable def boxFiber (h c : Rq) : Finset (Fiber h c) := by
  classical
  exact (Finset.univ.filter (fun z : BoxPair => FT1536.Relation.A h (decode z)=c)).attach.map
    (T5BoxBound.fiberEmbed h c)

theorem summable_of_mass (h : Rq) (hm : MassCondition h) (c : Rq)
    (t : ℝ) (ht : Temperature t) : Summable (atom (h:=h) (c:=c) (t/1179648)) := by
  obtain ⟨K,hK,bounds⟩ := hm
  have ht0 := (temperature_range t ht).1
  have hlo := (bounds c t ht).1
  have hp : 0<(1-(1/2^34 : ℝ))*(t⁻¹)^1536*K := by
    have : 0<(1-(1/2^34 : ℝ)) := by norm_num
    positivity
  by_contra hn
  have hz := tsum_eq_zero_of_not_summable hn
  change ActualMass014.fullMass h c (t/1179648)=0 at hz
  linarith

theorem fiberMass_eq_sum (h c : Rq) (a : ℝ) :
    fiberMass h c a=∑ z ∈ boxFiber h c, atom a z := by
  classical
  unfold fiberMass boxFiber
  rw [←Finset.sum_filter,Finset.sum_map,←Finset.sum_attach]
  rfl

theorem finite_le_full (h c : Rq) (a : ℝ) (hs : Summable (atom (h:=h) (c:=c) a)) :
    fiberMass h c a≤ActualMass014.fullMass h c a := by
  rw [fiberMass_eq_sum]
  exact hs.sum_le_tsum _ (fun z _ => (Real.exp_pos _).le)

theorem finite_add_tail (h c : Rq) (a : ℝ) (hs : Summable (atom (h:=h) (c:=c) a)) :
    fiberMass h c a+(∑' z : {z : Fiber h c // z ∉ boxFiber h c}, atom a z.val)=
      ActualMass014.fullMass h c a := by
  rw [fiberMass_eq_sum]
  exact hs.sum_add_tsum_compl

theorem coord_bounds_of_block (x y : ℤ) (hb : block x y<3221225472) :
    (-65535≤x ∧ x≤65535) ∧ (-65535≤y ∧ y≤65535) := by
  have hx := CenteringTriangle.three_square x y
  have hy := CenteringTriangle.three_square y x
  rw [CenteringTriangle.block_swap] at hy
  constructor <;> constructor
  · by_contra hh
    have : x≤ -65536 := by omega
    nlinarith [sq_nonneg (x+65536)]
  · by_contra hh
    have : 65536≤x := by omega
    nlinarith [sq_nonneg (x-65536)]
  · by_contra hh
    have : y≤ -65536 := by omega
    nlinarith [sq_nonneg (y+65536)]
  · by_contra hh
    have : 65536≤y := by omega
    nlinarith [sq_nonneg (y-65536)]

theorem block_le_Q0 (v : Vec) (i : Fin 768) : block (v i).1 (v i).2≤Q0 v :=
  Finset.single_le_sum (fun j _ => block_nonneg (v j).1 (v j).2) (Finset.mem_univ i)

theorem below_cutoff_in_box (z : Vec×Vec) (hz : Q z<3221225472) :
    ∃ b : BoxPair, decode b=z := by
  have h1 : ∀ i, block (z.1 i).1 (z.1 i).2<3221225472 := by
    intro i
    have := block_le_Q0 z.1 i
    have := Q0_nonneg z.2
    unfold Q at hz
    omega
  have h2 : ∀ i, block (z.2 i).1 (z.2 i).2<3221225472 := by
    intro i
    have := block_le_Q0 z.2 i
    have := Q0_nonneg z.1
    unfold Q at hz
    omega
  refine ⟨(encodeVec z.1 (fun i => coord_bounds_of_block _ _ (h1 i)),
    encodeVec z.2 (fun i => coord_bounds_of_block _ _ (h2 i))),?_⟩
  simp only [decode,decode_encodeVec]

theorem mem_box_iff (h c : Rq) (z : Fiber h c) :
    z ∈ boxFiber h c ↔ ∃ b : BoxPair, decode b=z.val := by
  classical
  constructor
  · intro hz
    obtain ⟨b,_,hb⟩ := Finset.mem_map.mp hz
    exact ⟨b.val,congrArg Subtype.val hb⟩
  · rintro ⟨b,hb⟩
    have hc : FT1536.Relation.A h (decode b)=c := hb ▸ z.prop
    apply Finset.mem_map.mpr
    refine ⟨⟨b,Finset.mem_filter.mpr ⟨Finset.mem_univ _,hc⟩⟩,Finset.mem_attach _ _,?_⟩
    exact Subtype.ext hb

theorem outside_energy (h c : Rq) (z : Fiber h c) (hz : z ∉ boxFiber h c) :
    (3221225472 : ℤ)≤Q z.val := by
  by_contra hh
  exact hz ((mem_box_iff h c z).mpr (below_cutoff_in_box z.val (by omega)))

#print axioms summable_of_mass
#print axioms fiberMass_eq_sum
#print axioms finite_le_full
#print axioms finite_add_tail
#print axioms coord_bounds_of_block
#print axioms block_le_Q0
#print axioms below_cutoff_in_box
#print axioms mem_box_iff
#print axioms outside_energy
end FT1536.S05.BoxSupport015
