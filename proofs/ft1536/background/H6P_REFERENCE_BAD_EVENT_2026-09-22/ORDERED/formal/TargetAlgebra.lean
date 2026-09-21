import TargetWords
namespace InitialTarget
theorem basis_determinant (f g F G : Int) : g*(-F)-(-f)*G=f*G-g*F := by grind
theorem target_numerator_identity (f g F G c q : Int) (h : f*G-g*F=q) :
    (-c*F)*g+(c*f)*G=c*q ∧ (-c*F)*(-f)+(c*f)*(-F)=0 := by
  constructor <;> grind
def convolutionCount (d : Nat) := if d<1536 then d+1 else 3071-d
def reducedCount (k : Nat) := if k<768 then
  convolutionCount k+convolutionCount (1536+k)+convolutionCount (2304+k)
  else convolutionCount k+convolutionCount (768+k)
theorem reduced_low_count (k : Nat) (hk : k<768) : reducedCount k=2303-k := by
  simp only [reducedCount,ite_eq_left hk,convolutionCount]
  split <;> split <;> split <;> omega
theorem reduced_high_count (k : Nat) (hk : 768≤k ∧ k<1536) : reducedCount k=2304 := by
  simp only [reducedCount,ite_eq_right (show ¬k<768 by omega),convolutionCount]
  split <;> split <;> omega
theorem reduced_row_bound (k : Nat) (hk : k<1536) : reducedCount k≤2304 := by
  by_cases h : k<768
  · rw [reduced_low_count k h];omega
  · rw [reduced_high_count k (by omega)];omega
theorem gram_pair_identities (a b : Int) :
    2*(a*a+b*b+a*b)=(a*a+b*b)+(a+b)*(a+b) ∧
    2*(a*a+b*b+a*b)=3*(a*a+b*b)-(a-b)*(a-b) := by constructor <;> grind
theorem gram_pair_bounds (a b : Int) :
    a*a+b*b≤2*(a*a+b*b+a*b) ∧ 2*(a*a+b*b+a*b)≤3*(a*a+b*b) := by
  have nonneg (z : Int) : 0≤z*z := by
    by_cases h : 0≤z
    · exact Int.mul_nonneg h h
    · have hn : 0≤-z := by omega
      have hp:=Int.mul_nonneg hn hn
      have he : (-z)*(-z)=z*z := by grind
      rw [he] at hp;exact hp
  have hs:=nonneg (a+b)
  have hd:=nonneg (a-b)
  have hi:=gram_pair_identities a b
  omega
theorem two_error_layers (source rounded ideal er ef : Int)
    (hr : -er≤source-rounded ∧ source-rounded≤er)
    (hf : -ef≤rounded-ideal ∧ rounded-ideal≤ef) :
    -(er+ef)≤source-ideal ∧ source-ideal≤er+ef := by omega
theorem inverse_eval_energy_transport (coefSq freqSq errorSq : Int)
    (h : 1536*coefSq≤4*freqSq) (he : freqSq≤1536*errorSq) : coefSq≤4*errorSq := by omega
end InitialTarget
