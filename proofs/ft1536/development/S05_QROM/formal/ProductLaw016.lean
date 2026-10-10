import FiniteLaw016
import Run2.RawProductLaw

set_option maxRecDepth 8192
attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

namespace FT1536.S05.ProductLaw016
open Finset FT1536.Run2 FT1536.Run2.FiberBinding FiniteLaw016
variable {A B : Type} [Fintype A] [Fintype B]

noncomputable def product (p : Law A) (n : ℕ) : Law (Fin n → A) where
  mass v := ∏ i,p.mass (v i)
  nonneg v := prod_nonneg (fun i _ => p.nonneg (v i))
  total := by
    rw [←Fintype.prod_sum]
    simp only [p.total,prod_const_one]

theorem product_uniform [Nonempty A] (n : ℕ) :
    product (Law.uniform : Law A) n=Law.uniform := by
  apply law_ext
  intro v
  simp [product,Law.uniform]

theorem product_map [DecidableEq B] (p : Law A) (f : A → B) (n : ℕ) :
    (product p n).map (fun v i => f (v i))=product (p.map f) n := by
  classical
  apply law_ext
  intro v
  rw [map_mass]
  change (∑ x : Fin n → A, if (fun i => f (x i))=v then ∏ i,p.mass (x i) else 0)=
    ∏ i,(p.map f).mass (v i)
  simp_rw [map_mass]
  rw [Fintype.prod_sum]
  apply sum_congr rfl
  intro x _
  by_cases hx : (fun i => f (x i))=v
  · have hi : ∀ i,f (x i)=v i := congrFun hx
    simp [hi]
  · have hi : ∃ i,f (x i)≠v i := by
      by_contra hh
      push Not at hh
      exact hx (funext hh)
    obtain ⟨i,hi⟩ := hi
    rw [ite_eq_right hx]
    symm
    exact prod_eq_zero (mem_univ i) (by simp [hi])

theorem independent_code [Nonempty A] [DecidableEq B] (f : A → B) (n : ℕ) :
    (Law.uniform : Law (Fin n → A)).map (fun v i => f (v i))=
      product ((Law.uniform : Law A).map f) n := by
  rw [←product_uniform]
  exact product_map _ _ _

theorem product_domination (p q : Law A) (K : ℝ)
    (hd : ∀ a,p.mass a≤K*q.mass a) (n : ℕ) (v : Fin n → A) :
    (product p n).mass v≤K^n*(product q n).mass v := by
  change (∏ i,p.mass (v i))≤K^n*∏ i,q.mass (v i)
  calc
    _ ≤ ∏ i,K*q.mass (v i) := prod_le_prod₀ (fun i _ => p.nonneg (v i)) (fun i _ => hd (v i))
    _ = _ := by rw [prod_mul_distrib]; simp

/- Reuse the ROM Gaussian tensor identity on the actual two 768-pair halves. -/
noncomputable def vectorPair (p : Law RawProductLaw.Block) : Law PublicSimulation.BoxPair :=
  Divergence.joint (product p 768) (fun _ => product p 768)

theorem gaussian_vectorPair : vectorPair RawProductLaw.blockLaw=RawProductLaw.rawLaw := by
  apply law_ext
  intro z
  rw [RawProductLaw.actual_mass_product]
  rfl

theorem vectorPair_domination (p : Law RawProductLaw.Block) (K : ℝ) (hK : 0≤K)
    (hd : ∀ a,p.mass a≤K*RawProductLaw.blockLaw.mass a) (z : PublicSimulation.BoxPair) :
    (vectorPair p).mass z≤K^1536*RawProductLaw.rawLaw.mass z := by
  rw [←gaussian_vectorPair]
  change (product p 768).mass z.1*(product p 768).mass z.2≤
    K^1536*((product RawProductLaw.blockLaw 768).mass z.1*(product RawProductLaw.blockLaw 768).mass z.2)
  have hh := mul_le_mul (product_domination p _ K hd 768 z.1)
    (product_domination p _ K hd 768 z.2) ((product p 768).nonneg z.2)
    (mul_nonneg (pow_nonneg hK _) ((product _ 768).nonneg z.1))
  convert hh using 1; ring

#print axioms product_uniform
#print axioms product_map
#print axioms independent_code
#print axioms product_domination
#print axioms gaussian_vectorPair
#print axioms vectorPair_domination
end FT1536.S05.ProductLaw016
