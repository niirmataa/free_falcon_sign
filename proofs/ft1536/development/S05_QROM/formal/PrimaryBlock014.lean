import MonomialIsometry014

set_option maxRecDepth 32768

/- Q-SAMPLER: the ACTUAL primary block of the coefficient Gram, with its
   exact diagonal and ternary cap. No FFT or desired LDL-shape hypothesis. -/
namespace FT1536.S05.PrimaryBlock014
open Matrix Finset
open FT1536.Geometry FT1536.Run2.CoefficientQuotient FT1536.Run2.ActualNTRUFiber
open CoefficientGram013 MonomialIsometry014 SchurGeometry012

theorem Q0_neg (v : Vec) : Q0 (-v)=Q0 v := by
  unfold Q0
  apply sum_congr rfl
  intro i _
  simp only [Pi.neg_apply,Prod.fst_neg,Prod.snd_neg,block]
  ring

theorem primary_unit (high : Bool) (j : Fin 768) :
    realPack (unitVec high j,0)=Pi.single (high,false,j) (1 : ℝ) := by
  funext i
  rcases i with ⟨b,c,k⟩
  by_cases hkj : k=j
  · subst k
    cases high <;> cases b <;> cases c <;> simp [realPack,pack,unitVec]
  · cases high <;> cases b <;> cases c <;>
      simp [realPack,pack,unitVec,hkj]

theorem energy_single (M : Matrix Coord Coord ℝ) (i : Coord) :
    energy M (Pi.single i 1)=M i i := by
  simp [energy,Matrix.mulVec,dotProduct,Pi.single_apply]

theorem primary_diagonal (f g bigF bigG : Vec) (high : Bool) (j : Fin 768) :
    gram f g bigF bigG (high,false,j) (high,false,j)=(Q0 f+Q0 g : ℤ) := by
  rw [← energy_single (CoefficientGram013.gram f g bigF bigG) (high,false,j),
    ← primary_unit,actual_gram_energy]
  have hq : Geometry.Q (coefficientBasis f g bigF bigG (unitVec high j,0))=Q0 g+Q0 f := by
    simp only [coefficientBasis,multiply_zero_right,add_zero,sub_zero,Geometry.Q,Q0_neg,Q0_multiply_unit]
  rw [hq,add_comm]

theorem ternary_block_cap (x y : ℤ) (hx : |x|≤1) (hy : |y|≤1) : block x y≤3 := by
  obtain ⟨hx0,hx1⟩ := abs_le.mp hx
  obtain ⟨hy0,hy1⟩ := abs_le.mp hy
  interval_cases x <;> interval_cases y <;> norm_num [block]

def Ternary (v : Vec) : Prop := ∀ i, |(v i).1|≤1 ∧ |(v i).2|≤1

theorem ternary_Q0_cap (v : Vec) (hv : Ternary v) : Q0 v≤2304 := by
  calc
    Q0 v ≤ ∑ i : Fin 768, (3 : ℤ) :=
      sum_le_sum (fun i _ => ternary_block_cap _ _ (hv i).1 (hv i).2)
    _ = 2304 := by
      rw [sum_const,card_univ,Fintype.card_fin,nsmul_eq_mul]
      norm_num

theorem primary_diagonal_cap (f g bigF bigG : Vec) (hf : Ternary f) (hg : Ternary g)
    (high : Bool) (j : Fin 768) : gram f g bigF bigG (high,false,j) (high,false,j)≤4608 := by
  rw [primary_diagonal]
  exact_mod_cast add_le_add (ternary_Q0_cap f hf) (ternary_Q0_cap g hg)

abbrev LocalCoord := Bool × Fin 768

def primary (i : LocalCoord) : Coord := (i.1,false,i.2)
def secondary (i : LocalCoord) : Coord := (i.1,true,i.2)

def grouping : (LocalCoord ⊕ LocalCoord) ≃ Coord where
  toFun := Sum.elim primary secondary
  invFun i := if i.2.1 then Sum.inr (i.1,i.2.2) else Sum.inl (i.1,i.2.2)
  left_inv i := by cases i <;> rfl
  right_inv i := by rcases i with ⟨b,c,j⟩; cases c <;> rfl

noncomputable def localIndex : Fin 1536 ≃ LocalCoord :=
  (Fintype.equivFinOfCardEq (show Fintype.card LocalCoord=1536 by norm_num [LocalCoord])).symm

noncomputable def blockIndex : (Fin 1536 ⊕ Fin 1536) ≃ Coord :=
  (localIndex.sumCongr localIndex).trans grouping

noncomputable def first (i : Fin 1536) : Coord := primary (localIndex i)
noncomputable def second (i : Fin 1536) : Coord := secondary (localIndex i)

theorem first_injective : Function.Injective first := by
  intro i j equal
  have same : (Sum.inl i : Fin 1536 ⊕ Fin 1536)=Sum.inl j := blockIndex.injective equal
  exact Sum.inl.inj same

noncomputable def A (f g bigF bigG : Vec) : FinMatrix 1536 :=
  (gram f g bigF bigG).submatrix first first
noncomputable def C (f g bigF bigG : Vec) : FinMatrix 1536 :=
  (gram f g bigF bigG).submatrix first second
noncomputable def D (f g bigF bigG : Vec) : FinMatrix 1536 :=
  (gram f g bigF bigG).submatrix second second

theorem A_diagonal (f g bigF bigG : Vec) (i : Fin 1536) :
    A f g bigF bigG i i=(Q0 f+Q0 g : ℤ) :=
  primary_diagonal f g bigF bigG (localIndex i).1 (localIndex i).2

theorem A_cap (f g bigF bigG : Vec) (hf : Ternary f) (hg : Ternary g) :
    ∀ i, A f g bigF bigG i i≤4608 :=
  fun i => primary_diagonal_cap f g bigF bigG hf hg (localIndex i).1 (localIndex i).2

theorem A_posDef (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) :
    (A f g bigF bigG).PosDef :=
  (actual_gram_posDef f g bigF bigG ntru).submatrix first_injective

theorem block_gram (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) :
    (gram f g bigF bigG).submatrix blockIndex blockIndex=
      fromBlocks (A f g bigF bigG) (C f g bigF bigG) (C f g bigF bigG)ᴴ (D f g bigF bigG) := by
  ext i j
  cases i with
  | inl i => cases j <;> rfl
  | inr i =>
    cases j with
    | inl j =>
      exact (actual_gram_posDef f g bigF bigG ntru).isHermitian.apply (first j) (second i)
    | inr j => rfl

theorem block_posDef (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) :
    (fromBlocks (A f g bigF bigG) (C f g bigF bigG) (C f g bigF bigG)ᴴ (D f g bigF bigG)).PosDef := by
  rw [← block_gram f g bigF bigG ntru]
  exact (actual_gram_posDef f g bigF bigG ntru).submatrix blockIndex.injective

theorem grouped_energy (f g bigF bigG : Vec)
    (ntru : multiply f bigG-multiply g bigF=constantCoeffs (18433 : ℤ)) (x : Coord → ℝ) :
    energy (fromBlocks (A f g bigF bigG) (C f g bigF bigG) (C f g bigF bigG)ᴴ (D f g bigF bigG))
      (x ∘ blockIndex)=energy (gram f g bigF bigG) x := by
  rw [← block_gram f g bigF bigG ntru]
  exact energy_reindex _ blockIndex x

#print axioms Q0_neg
#print axioms primary_unit
#print axioms energy_single
#print axioms primary_diagonal
#print axioms ternary_block_cap
#print axioms ternary_Q0_cap
#print axioms primary_diagonal_cap
#print axioms first_injective
#print axioms A_diagonal
#print axioms A_cap
#print axioms A_posDef
#print axioms block_gram
#print axioms block_posDef
#print axioms grouped_energy
end FT1536.S05.PrimaryBlock014
