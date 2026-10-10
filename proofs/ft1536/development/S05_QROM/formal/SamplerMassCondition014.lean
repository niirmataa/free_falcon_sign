import ReciprocalSchur014

/- Q-SAMPLER: exact three-temperature infinite-mass input M from sampler007.
   This certificate is not the finite-box J/P law or executable sampler. -/
namespace FT1536.S05.SamplerMassCondition014
open FT1536.Geometry FT1536.Relation FT1536.Run2.CoefficientQuotient
open PrimaryBlock014 Evaluation014 ReciprocalSchur014

def Temperature (t : ℝ) : Prop :=
  t=1 ∨ t=1811939328/2093922385 ∨ t=9/16

theorem temperature_range (t : ℝ) (ht : Temperature t) : 0<t ∧ t≤1 := by
  rcases ht with rfl | rfl | rfl <;> norm_num

def MassCondition (h : Rq) : Prop :=
  ∃ K : ℝ, 0<K ∧ ∀ c : Rq, ∀ t : ℝ, Temperature t →
    (1-(1/2^34 : ℝ))*(t⁻¹)^1536*K≤ActualMass014.fullMass h c (t/1179648) ∧
    ActualMass014.fullMass h c (t/1179648)≤(1+(1/2^34 : ℝ))*(t⁻¹)^1536*K

theorem profile_rate (t : ℝ) : t*HarmonicMass012.rate=t/1179648 := by
  unfold HarmonicMass012.rate
  norm_num
  ring

theorem sampler007_mass_condition (f g bigF bigG : Vec) (h fInv : Rq)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ))
    (public_eq : mulRq h (reduceVec f)=reduceVec g)
    (inverse_eq : mulRq fInv (reduceVec f)=constantCoeffs (1 : ZMod 18433))
    (hf : Ternary f) (hg : Ternary g)
    (harmonic : 991≤SpectralDiagonal012.harmonic (Evaluation014.weight f g)) :
    MassCondition h := by
  obtain ⟨K,hK,bounds⟩ := mass_from_actual_harmonic f g bigF bigG h fInv ntru public_eq inverse_eq hf hg harmonic
  refine ⟨K,hK,?_⟩
  intro c t ht
  have range := temperature_range t ht
  simpa only [profile_rate,FT1536.Run2.T5ScalarMass.massBudget] using bounds t range.1 range.2 c

#print axioms temperature_range
#print axioms profile_rate
#print axioms sampler007_mass_condition
end FT1536.S05.SamplerMassCondition014
