import JointInterface019

/- Finite classical postprocessing of BOTH laws. This is not a quantum
   channel or QROM composition theorem and does not change the reference law
   on only one side. It keeps every response/failure atom in the input law. -/
namespace FT1536.S05.ObservationMoment019
open Finset JointInterface019 FT1536.Divergence
variable {A B : Type} [Fintype A] [Fintype B] [DecidableEq B]

noncomputable def fiberEnergy (j p : Law A) (f : A → B) (b : B) : ℝ :=
  ∑ a,if f a=b then j.mass a^2/p.mass a else 0

omit [Fintype B] in
theorem fiberEnergy_nonneg (j p : Law A) (f : A → B) (b : B) :
    0≤fiberEnergy j p f b := by
  apply sum_nonneg
  intro a _
  split_ifs
  · exact div_nonneg (sq_nonneg _) (p.nonneg _)
  · exact le_rfl

theorem mapped_cauchy (j p : Law A) (ac : AC j p) (f : A → B) (b : B) :
    (j.map f).mass b^2≤fiberEnergy j p f b*(p.map f).mass b := by
  rw [map_mass,map_mass]
  unfold fiberEnergy
  apply sum_sq_le_sum_mul_sum_of_sq_le_mul
  · intro a _
    split_ifs
    · exact div_nonneg (sq_nonneg _) (p.nonneg _)
    · exact le_rfl
  · intro a _
    split_ifs
    · exact p.nonneg _
    · exact le_rfl
  · intro a _
    by_cases hf : f a=b
    · simp only [hf,ite_true]
      by_cases hp : p.mass a=0
      · simp [hp,ac a hp]
      · exact le_of_eq (by field_simp)
    · simp [hf]

theorem map_ac (j p : Law A) (ac : AC j p) (f : A → B) : AC (j.map f) (p.map f) := by
  intro b hb
  have h := mapped_cauchy j p ac f b
  rw [hb,mul_zero] at h
  nlinarith [sq_nonneg ((j.map f).mass b)]

theorem mapped_atom_bound (j p : Law A) (ac : AC j p) (f : A → B) (b : B) :
    (j.map f).mass b^2/(p.map f).mass b≤fiberEnergy j p f b := by
  by_cases hz : (p.map f).mass b=0
  · simp only [hz,div_zero]
    exact fiberEnergy_nonneg j p f b
  · have hp : 0<(p.map f).mass b := lt_of_le_of_ne ((p.map f).nonneg b) (Ne.symm hz)
    exact (div_le_iff₀ hp).2 (mapped_cauchy j p ac f b)

theorem sum_fiberEnergy (j p : Law A) (f : A → B) :
    (∑ b,fiberEnergy j p f b)=second j p := by
  unfold fiberEnergy second
  rw [Finset.sum_comm]
  simp

theorem map_second (j p : Law A) (ac : AC j p) (f : A → B) :
    second (j.map f) (p.map f)≤second j p := by
  calc
    _ ≤ ∑ b,fiberEnergy j p f b := sum_le_sum (fun b _ => mapped_atom_bound j p ac f b)
    _ = _ := sum_fiberEnergy j p f

theorem full_observation (j p : Law A) (e : ℝ) (ac : AC j p)
    (moment : second j p≤1+e) (f : A → B) :
    AC (j.map f) (p.map f) ∧ second (j.map f) (p.map f)≤1+e :=
  ⟨map_ac j p ac f,(map_second j p ac f).trans moment⟩

#print axioms fiberEnergy_nonneg
#print axioms mapped_cauchy
#print axioms map_ac
#print axioms mapped_atom_bound
#print axioms sum_fiberEnergy
#print axioms map_second
#print axioms full_observation
end FT1536.S05.ObservationMoment019
