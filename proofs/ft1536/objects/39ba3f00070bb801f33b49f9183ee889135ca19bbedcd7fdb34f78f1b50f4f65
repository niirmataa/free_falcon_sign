import Run2.UniformErrorBound
namespace FT1536.Run2.NumericCertificate
theorem arithmetic : (18433 : ℕ) ≤ 2^15 ∧ (131071 : ℕ) ≤ 2^17 ∧
  (2051350378 : ℚ)/1179648 < 1740 ∧ (2*1740+75264 : ℕ)=78744 := by norm_num
theorem uniform_envelope (h : FT1536.Relation.Rq) :
  (1 : ℝ)/2^78744 ≤ CorrectnessProbability.delta h ∧
  CorrectnessProbability.delta h ≤ 1-(1 : ℝ)/2^75264 :=
  UniformErrorBound.binary_envelope h
end FT1536.Run2.NumericCertificate
