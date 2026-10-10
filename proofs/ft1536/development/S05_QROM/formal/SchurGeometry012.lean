import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.Algebra.Order.Star.Real
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

/- Q-SAMPLER / proof obligation K-SCHUR-FIBER. Generic exact real matrices;
   not yet the spectral/source instance of the FT1536 coefficient Gram. -/
namespace FT1536.S05.SchurGeometry012
open Matrix Finset
open scoped Matrix

variable {m n : Type} [Fintype m] [Fintype n] [DecidableEq m]

noncomputable def energy {i : Type} [Fintype i] (G : Matrix i i ℝ) (x : i → ℝ) : ℝ :=
  star x ⬝ᵥ (G *ᵥ x)

noncomputable def complement (A : Matrix m m ℝ) (B : Matrix m n ℝ)
    (D : Matrix n n ℝ) : Matrix n n ℝ := D-Bᴴ*A⁻¹*B

noncomputable def shifted (A : Matrix m m ℝ) (B : Matrix m n ℝ)
    (x : m → ℝ) (y : n → ℝ) : m → ℝ := x+(A⁻¹*B)*ᵥ y

theorem energy_split (A : Matrix m m ℝ) (B : Matrix m n ℝ) (D : Matrix n n ℝ)
    (hA : A.PosDef) (x : m → ℝ) (y : n → ℝ) :
    energy (fromBlocks A B Bᴴ D) (Sum.elim x y)=
      energy A (shifted A B x y)+energy (complement A B D) y := by
  let : Invertible A := hA.isUnit.invertible
  simp only [energy,shifted,complement,dotProduct_mulVec]
  exact Matrix.schur_complement_eq₁₁ B D x y hA.isHermitian

theorem complement_posDef (A : Matrix m m ℝ) (B : Matrix m n ℝ) (D : Matrix n n ℝ)
    (hA : A.PosDef) (hG : (fromBlocks A B Bᴴ D).PosDef) :
    (complement A B D).PosDef := by
  let : Invertible A := hA.isUnit.invertible
  have hHerm : (complement A B D).IsHermitian :=
    (Matrix.IsHermitian.fromBlocks₁₁ B D hA.isHermitian).mp hG.isHermitian
  apply Matrix.PosDef.of_dotProduct_mulVec_pos hHerm
  intro y hy
  let x : m → ℝ := -((A⁻¹*B)*ᵥ y)
  have hxy : Sum.elim x y≠0 := by
    intro hz
    apply hy
    funext i
    exact congrFun hz (Sum.inr i)
  have positive := hG.dotProduct_mulVec_pos hxy
  change 0<energy (fromBlocks A B Bᴴ D) (Sum.elim x y) at positive
  rw [energy_split A B D hA x y] at positive
  simpa only [shifted,x,neg_add_cancel,energy,star_zero,mulVec_zero,dotProduct_zero,zero_add]
    using positive

omit [Fintype n] [DecidableEq m] in
theorem congruence_diagonal (A : Matrix m m ℝ) (B : Matrix m n ℝ) (j : n) :
    (Bᴴ*A*B) j j=energy A (fun i => B i j) := by
  simp only [energy,Matrix.mul_apply,Matrix.conjTranspose_apply,mulVec,dotProduct,
    Pi.star_apply]
  simp_rw [sum_mul,mul_sum,mul_assoc]
  rw [sum_comm]

omit [Fintype n] in
theorem complement_diagonal_le (A : Matrix m m ℝ) (B : Matrix m n ℝ)
    (D : Matrix n n ℝ) (hA : A.PosDef) (j : n) :
    complement A B D j j≤D j j := by
  have hn := hA.inv.posSemidef.dotProduct_mulVec_nonneg (fun i => B i j)
  change 0≤energy A⁻¹ (fun i => B i j) at hn
  rw [← congruence_diagonal] at hn
  exact sub_le_self _ hn

theorem gaussian_atom_split (A : Matrix m m ℝ) (B : Matrix m n ℝ)
    (D : Matrix n n ℝ) (hA : A.PosDef) (k : ℝ) (x : m → ℝ) (y : n → ℝ) :
    Real.exp (-k*energy (fromBlocks A B Bᴴ D) (Sum.elim x y))=
      Real.exp (-k*energy A (shifted A B x y))*
      Real.exp (-k*energy (complement A B D) y) := by
  rw [energy_split A B D hA x y,mul_add,Real.exp_add]

theorem gaussian_affine_atom_split (A : Matrix m m ℝ) (B : Matrix m n ℝ)
    (D : Matrix n n ℝ) (hA : A.PosDef) (k : ℝ)
    (x u : m → ℝ) (y v : n → ℝ) :
    Real.exp (-k*energy (fromBlocks A B Bᴴ D) (Sum.elim (x+u) (y+v)))=
      Real.exp (-k*energy A (shifted A B (x+u) (y+v)))*
      Real.exp (-k*energy (complement A B D) (y+v)) :=
  gaussian_atom_split A B D hA k (x+u) (y+v)

section ScalarElimination

abbrev FinMatrix (k : ℕ) := Matrix (Fin k) (Fin k) ℝ

def headTailEquiv (k : ℕ) : (Unit ⊕ Fin k) ≃ Fin (k+1) where
  toFun := Sum.elim (fun _ => 0) Fin.succ
  invFun := Fin.cases (Sum.inl ()) Sum.inr
  left_inv z := by cases z with | inl u => cases u; rfl | inr i => rfl
  right_inv i := by induction i using Fin.cases <;> rfl

noncomputable def headMatrix {k : ℕ} (G : FinMatrix (k+1)) : Matrix Unit Unit ℝ :=
  diagonal (fun _ => G 0 0)
noncomputable def rowMatrix {k : ℕ} (G : FinMatrix (k+1)) : Matrix Unit (Fin k) ℝ :=
  fun _ j => G 0 j.succ
noncomputable def tailMatrix {k : ℕ} (G : FinMatrix (k+1)) : FinMatrix k :=
  G.submatrix Fin.succ Fin.succ
noncomputable def scalarSchur {k : ℕ} (G : FinMatrix (k+1)) : FinMatrix k :=
  fun i j => G i.succ j.succ-G 0 i.succ*G 0 j.succ/G 0 0

theorem block_view {k : ℕ} (G : FinMatrix (k+1)) (hG : G.PosDef) :
    G.submatrix (headTailEquiv k) (headTailEquiv k)=
      fromBlocks (headMatrix G) (rowMatrix G) (rowMatrix G)ᴴ (tailMatrix G) := by
  ext i j
  cases i with
  | inl u =>
    cases u
    cases j with
    | inl v => cases v; rfl
    | inr j => rfl
  | inr i =>
    cases j with
    | inl v =>
      cases v
      simpa [headTailEquiv,rowMatrix] using hG.isHermitian.apply 0 i.succ
    | inr j => rfl

theorem scalarSchur_eq_complement {k : ℕ} (G : FinMatrix (k+1)) :
    scalarSchur G=complement (headMatrix G) (rowMatrix G) (tailMatrix G) := by
  ext i j
  simp [scalarSchur,complement,headMatrix,rowMatrix,tailMatrix,
    Matrix.mul_apply,div_eq_mul_inv,mul_assoc,mul_left_comm,mul_comm]

theorem scalarSchur_posDef {k : ℕ} (G : FinMatrix (k+1)) (hG : G.PosDef) :
    (scalarSchur G).PosDef := by
  have head : (headMatrix G).PosDef := Matrix.PosDef.diagonal (fun _ => hG.diag_pos)
  have full := hG.submatrix (headTailEquiv k).injective
  rw [block_view G hG] at full
  rw [scalarSchur_eq_complement]
  exact complement_posDef _ _ _ head full

theorem scalarSchur_diagonal_le {k : ℕ} (G : FinMatrix (k+1))
    (hG : G.PosDef) (i : Fin k) : scalarSchur G i i≤G i.succ i.succ := by
  have hpos : 0<G 0 0 := hG.diag_pos
  have term : 0≤G 0 i.succ*G 0 i.succ/G 0 0 :=
    div_nonneg (mul_self_nonneg _) hpos.le
  exact sub_le_self _ term

noncomputable def pivots : {k : ℕ} → FinMatrix k → List ℝ
  | 0,_ => []
  | _+1,G => G 0 0 :: pivots (scalarSchur G)

theorem pivots_length : ∀ {k : ℕ} (G : FinMatrix k), (pivots G).length=k
  | 0,_ => rfl
  | k+1,G => by simp only [pivots,List.length_cons,pivots_length]

theorem pivots_bounded : ∀ {k : ℕ} (G : FinMatrix k) (L : ℝ),
    G.PosDef → (∀ i, G i i≤L) → ∀ d∈pivots G, 0<d ∧ d≤L
  | 0,G,L,_,_,d,hd => by simp [pivots] at hd
  | k+1,G,L,hG,hbound,d,hd => by
    rcases List.mem_cons.mp hd with equal | rest
    · subst d
      exact ⟨hG.diag_pos,hbound 0⟩
    · exact pivots_bounded (scalarSchur G) L (scalarSchur_posDef G hG)
        (fun i => (scalarSchur_diagonal_le G hG i).trans (hbound i.succ)) d rest

theorem block_pivots_bounded {k l : ℕ} (A : FinMatrix k)
    (B : Matrix (Fin k) (Fin l) ℝ) (D : FinMatrix l) (L : ℝ)
    (hA : A.PosDef) (hG : (fromBlocks A B Bᴴ D).PosDef)
    (hFirst : ∀ i, A i i≤L) (hSecond : ∀ j, complement A B D j j≤L) :
    ∀ d∈pivots A ++ pivots (complement A B D), 0<d ∧ d≤L := by
  intro d hd
  rcases List.mem_append.mp hd with first | second
  · exact pivots_bounded A L hA hFirst d first
  · exact pivots_bounded _ L (complement_posDef A B D hA hG) hSecond d second

theorem energy_reindex {a b : Type} [Fintype a] [Fintype b]
    (G : Matrix a a ℝ) (e : b ≃ a) (x : a → ℝ) :
    energy (G.submatrix e e) (x ∘ e)=energy G x := by
  unfold energy
  rw [Matrix.submatrix_mulVec_equiv]
  have inverse : (x ∘ e) ∘ e.symm=x := by funext i; simp
  rw [inverse]
  have stars : star (x ∘ e)=(star x) ∘ e := rfl
  rw [stars]
  exact comp_equiv_dotProduct_comp_equiv (star x) (G *ᵥ x) e

noncomputable def scalarOffset {k : ℕ} (G : FinMatrix (k+1)) (y : Fin k → ℝ) : ℝ :=
  (((headMatrix G)⁻¹*rowMatrix G) *ᵥ y) ()

theorem energy_scalar_step {k : ℕ} (G : FinMatrix (k+1)) (hG : G.PosDef)
    (x : Fin (k+1) → ℝ) :
    energy G x=G 0 0*(x 0+scalarOffset G (fun j => x j.succ))^2+
      energy (scalarSchur G) (fun j => x j.succ) := by
  have head : (headMatrix G).PosDef := Matrix.PosDef.diagonal (fun _ => hG.diag_pos)
  have points : x ∘ headTailEquiv k=Sum.elim (fun _ : Unit => x 0) (fun j => x j.succ) := by
    funext i
    cases i <;> rfl
  rw [← energy_reindex G (headTailEquiv k) x,points,block_view G hG,
    energy_split _ _ _ head,← scalarSchur_eq_complement]
  congr 1
  simp [energy,headMatrix,shifted,scalarOffset,mulVec,dotProduct,pow_two,
    mul_comm,mul_left_comm]

noncomputable def squareExpansion : {k : ℕ} → FinMatrix k → (Fin k → ℝ) → ℝ
  | 0,_,_ => 0
  | _+1,G,x => G 0 0*(x 0+scalarOffset G (fun j => x j.succ))^2+
      squareExpansion (scalarSchur G) (fun j => x j.succ)

theorem energy_eq_squareExpansion : ∀ {k : ℕ} (G : FinMatrix k),
    G.PosDef → ∀ x, energy G x=squareExpansion G x
  | 0,G,_,x => by simp [energy,dotProduct,squareExpansion]
  | k+1,G,hG,x => by
    rw [energy_scalar_step G hG x]
    change _+energy (scalarSchur G) _=_+squareExpansion (scalarSchur G) _
    rw [energy_eq_squareExpansion _ (scalarSchur_posDef G hG)]

theorem gaussian_squareExpansion {k : ℕ} (G : FinMatrix k) (hG : G.PosDef)
    (coefficient : ℝ) (x : Fin k → ℝ) :
    Real.exp (-coefficient*energy G x)=Real.exp (-coefficient*squareExpansion G x) := by
  rw [energy_eq_squareExpansion G hG]

end ScalarElimination

#print axioms energy_reindex
#print axioms energy_scalar_step
#print axioms energy_eq_squareExpansion
#print axioms gaussian_squareExpansion

#print axioms block_view
#print axioms scalarSchur_eq_complement
#print axioms scalarSchur_posDef
#print axioms scalarSchur_diagonal_le
#print axioms pivots_length
#print axioms pivots_bounded
#print axioms block_pivots_bounded
#print axioms energy_split
#print axioms complement_posDef
#print axioms congruence_diagonal
#print axioms complement_diagonal_le
#print axioms gaussian_atom_split
#print axioms gaussian_affine_atom_split
end FT1536.S05.SchurGeometry012
