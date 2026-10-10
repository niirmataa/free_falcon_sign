import GaussianFromSchur012

/- Q-SAMPLER: two-block unnormalized mass. Only A and its Schur complement
   need small diagonals; large F/G entries in the whole Gram are permitted. -/
namespace FT1536.S05.BlockGaussian012
open Matrix Finset
open SchurGeometry012 GaussianFromSchur012
open FT1536.Run2.TriangularGaussian FT1536.Run2.T5ScalarMass

noncomputable def rowError : ℝ := 2*rowRatio/(1-rowRatio)
noncomputable def lower (n : ℕ) : ℝ := (1-rowError)^n
noncomputable def upper (n : ℕ) : ℝ := (1+rowError)^n
noncomputable def common {n : ℕ} (k : ℝ) (G : FinMatrix n) : ℝ := scale (tower k G (fun _ => 0))

theorem factors_nonneg (n : ℕ) : 0≤lower n ∧ 0≤upper n := by
  constructor <;> apply pow_nonneg <;> norm_num [rowError,rowRatio]

noncomputable def innerShift {m n : ℕ} (A : FinMatrix m) (B : Matrix (Fin m) (Fin n) ℝ)
    (s : Fin m → ℝ) (t : Fin n → ℝ) (y : Fin n → ℤ) : Fin m → ℝ :=
  s+(A⁻¹*B)*ᵥ (translated t y)

noncomputable def weight {m n : ℕ} (k : ℝ) (A : FinMatrix m)
    (B : Matrix (Fin m) (Fin n) ℝ) (D : FinMatrix n)
    (s : Fin m → ℝ) (t : Fin n → ℝ) (y : Fin n → ℤ) (x : Fin m → ℤ) : ℝ :=
  Real.exp (-k*energy (fromBlocks A B Bᴴ D) (Sum.elim (translated s x) (translated t y)))

/-- Tail coordinates are summed first in the index type. This is only the
    product-coordinate order, not a nonintegral change of the lattice. -/
noncomputable def blockMass {m n : ℕ} (k : ℝ) (A : FinMatrix m)
    (B : Matrix (Fin m) (Fin n) ℝ) (D : FinMatrix n)
    (s : Fin m → ℝ) (t : Fin n → ℝ) : ℝ :=
  ∑' z : (Fin n → ℤ)×(Fin m → ℤ), weight k A B D s t z.1 z.2

theorem weight_factor {m n : ℕ} (k : ℝ) (A : FinMatrix m)
    (B : Matrix (Fin m) (Fin n) ℝ) (D : FinMatrix n) (hA : A.PosDef)
    (s : Fin m → ℝ) (t : Fin n → ℝ) (y : Fin n → ℤ) (x : Fin m → ℤ) :
    weight k A B D s t y x=
      Real.exp (-k*energy (complement A B D) (translated t y))*
      Real.exp (-k*energy A (translated (innerShift A B s t y) x)) := by
  have shift : shifted A B (translated s x) (translated t y)=
      translated (innerShift A B s t y) x := by
    funext i
    simp only [shifted,innerShift,translated,Pi.add_apply]
    ring
  rw [weight,gaussian_atom_split A B D hA k,shift,mul_comm]

theorem row_mass {m n : ℕ} (k : ℝ) (A : FinMatrix m)
    (B : Matrix (Fin m) (Fin n) ℝ) (D : FinMatrix n) (hA : A.PosDef)
    (s : Fin m → ℝ) (t : Fin n → ℝ) (y : Fin n → ℤ) :
    (∑' x, weight k A B D s t y x)=
      Real.exp (-k*energy (complement A B D) (translated t y))*mass k A (innerShift A B s t y) := by
  simp_rw [weight_factor k A B D hA s t y]
  rw [tsum_mul_left]
  rfl

theorem block_summable {m n : ℕ} (k : ℝ) (A : FinMatrix m)
    (B : Matrix (Fin m) (Fin n) ℝ) (D : FinMatrix n) (L : ℝ)
    (hA : A.PosDef) (hG : (fromBlocks A B Bᴴ D).PosDef) (hk : 0<k)
    (capA : ∀ i, A i i≤L) (capS : ∀ i, complement A B D i i≤L)
    (limit : k*L/Real.pi≤maxCoefficient) (s : Fin m → ℝ) (t : Fin n → ℝ) :
    Summable (fun z : (Fin n → ℤ)×(Fin m → ℤ) => weight k A B D s t z.1 z.2) := by
  have hS := complement_posDef A B D hA hG
  have nonnegative : ∀ z : (Fin n → ℤ)×(Fin m → ℤ), 0≤weight k A B D s t z.1 z.2 :=
    fun _ => (Real.exp_pos _).le
  apply (summable_prod_of_nonneg nonnegative).2
  constructor
  · intro y
    have hs := (mass_summable k A (innerShift A B s t y) L hA hk capA limit).mul_left
      (Real.exp (-k*energy (complement A B D) (translated t y)))
    change Summable (fun x => weight k A B D s t y x)
    simp_rw [weight_factor k A B D hA s t y]
    exact hs
  · change Summable (fun y => ∑' x, weight k A B D s t y x)
    simp_rw [row_mass k A B D hA s t]
    refine ((mass_summable k (complement A B D) t L hS hk capS limit).mul_right
      (upper m*common k A)).of_nonneg_of_le ?_ ?_
    · intro y
      exact mul_nonneg (Real.exp_pos _).le (tsum_nonneg (fun _ => (Real.exp_pos _).le))
    · intro y
      exact mul_le_mul_of_nonneg_left
        (mass_bounds k A (innerShift A B s t y) L hA hk capA limit).2 (Real.exp_pos _).le

theorem block_mass_bounds {m n : ℕ} (k : ℝ) (A : FinMatrix m)
    (B : Matrix (Fin m) (Fin n) ℝ) (D : FinMatrix n) (L : ℝ)
    (hA : A.PosDef) (hG : (fromBlocks A B Bᴴ D).PosDef) (hk : 0<k)
    (capA : ∀ i, A i i≤L) (capS : ∀ i, complement A B D i i≤L)
    (limit : k*L/Real.pi≤maxCoefficient) (s : Fin m → ℝ) (t : Fin n → ℝ) :
    lower (m+n)*(common k A*common k (complement A B D))≤blockMass k A B D s t ∧
    blockMass k A B D s t≤upper (m+n)*(common k A*common k (complement A B D)) := by
  have hS := complement_posDef A B D hA hG
  have hs := block_summable k A B D L hA hG hk capA capS limit s t
  have rows := hs.prod
  simp_rw [row_mass k A B D hA s t] at rows
  have outer := mass_summable k (complement A B D) t L hS hk capS limit
  have bounds := mass_bounds k (complement A B D) t L hS hk capS limit
  have scA := (common_scale_pos k A L hA hk capA limit).le
  have loA : 0≤lower m*common k A := mul_nonneg (factors_nonneg m).1 scA
  have hiA : 0≤upper m*common k A := mul_nonneg (factors_nonneg m).2 scA
  have lowerRows := (outer.mul_right (lower m*common k A)).tsum_le_tsum
    (fun y => mul_le_mul_of_nonneg_left
      (mass_bounds k A (innerShift A B s t y) L hA hk capA limit).1 (Real.exp_pos _).le) rows
  have upperRows := rows.tsum_le_tsum
    (fun y => mul_le_mul_of_nonneg_left
      (mass_bounds k A (innerShift A B s t y) L hA hk capA limit).2 (Real.exp_pos _).le)
    (outer.mul_right (upper m*common k A))
  have rowTotal : blockMass k A B D s t=
      ∑' y, Real.exp (-k*energy (complement A B D) (translated t y))*
        mass k A (innerShift A B s t y) := by
    rw [blockMass,hs.tsum_prod]
    simp_rw [row_mass k A B D hA s t]
  rw [tsum_mul_right] at lowerRows upperRows
  change mass k (complement A B D) t*(lower m*common k A)≤_ at lowerRows
  change _≤mass k (complement A B D) t*(upper m*common k A) at upperRows
  rw [← rowTotal] at lowerRows upperRows
  have lowerOuter := mul_le_mul_of_nonneg_right bounds.1 loA
  have upperOuter := mul_le_mul_of_nonneg_right bounds.2 hiA
  constructor
  · convert lowerOuter.trans lowerRows using 1
    simp only [lower,common,rowError,pow_add]
    ring
  · convert upperRows.trans upperOuter using 1
    simp only [upper,common,rowError,pow_add]
    ring

#print axioms factors_nonneg
#print axioms weight_factor
#print axioms row_mass
#print axioms block_summable
#print axioms block_mass_bounds
end FT1536.S05.BlockGaussian012
