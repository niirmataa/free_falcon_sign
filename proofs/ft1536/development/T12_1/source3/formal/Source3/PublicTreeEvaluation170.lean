import Source3.SelectedEvaluation169

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicTreeEvaluation170
open KeygenPublicAlgebra (R)
open KeygenPublicInputMaterial (reduced)

structure Vector where
  size : Nat
  data : C99FiniteMap114.Tree Nat

def value (a : Vector) (i : Nat) : R := (C99FiniteMap114.lookup a.data i).getD 0

def Represents (a : Vector) (f : Nat → R) : Prop :=
  a.size=1536 ∧ ∀ i, i<1536 → value a i=f i

def firstValue (a : Vector) (z : R) (i : Nat) : R :=
  if i<768 then value a i+value a (i+768)*z
  else value a (i-768)+value a i-value a i*z

def FirstCheck (a b : Vector) (z : R) : Prop :=
  b.size=1536 ∧ ∀ i : Fin 1536, value b i.val=firstValue a z i.val

instance firstCheckDecidable (a b : Vector) (z : R) : Decidable (FirstCheck a b z) := by
  unfold FirstCheck
  infer_instance

theorem first_sound (a b : Vector) (original : Geometry.Vec)
    (input : Represents a (reduced original)) (checked : FirstCheck a b KeygenPublicRoots.firstRoot) :
    Represents b (KeygenPublicFirstFold.image original 768) := by
  refine ⟨checked.1,?_⟩
  intro i hi
  rw [checked.2 ⟨i,hi⟩]
  by_cases low : i<768
  · rw [firstValue,ite_eq_left low,KeygenPublicFirstFold.image_low original 768 i low low,
      KeygenPublicFirstFold.lowP_coeff original i low,input.2 i hi,input.2 (i+768) (by omega)]
    rfl
  · rw [firstValue,ite_eq_right low,KeygenPublicFirstFold.image_high original 768 i (by omega) hi,
      KeygenPublicFirstFold.highP_coeff original (i-768) (by omega),
      input.2 (i-768) (by omega),input.2 i hi]
    have back : i-768+768=i := by omega
    rw [back]
    rfl

def stageValue (a : Vector) (m h : Nat) (i : Nat) : R :=
  KeygenPublicRadixPolynomial.split (value a) m h (i/(2*h)) (i%(2*h))

def StageCheck (a b : Vector) (k : Nat) : Prop :=
  b.size=1536 ∧ ∀ i : Fin 1536, value b i.val=
    stageValue a (KeygenPublicRadixStages.count k) (KeygenPublicRadixStages.size k/2) i.val

instance stageCheckDecidable (a b : Vector) (k : Nat) : Decidable (StageCheck a b k) := by
  unfold StageCheck
  infer_instance

theorem rows_value (a : Nat → R) (m h i : Nat) (positive : 0<h)
    (extent : m*(2*h)=1536) (inside : i<1536) :
    KeygenPublicRadixRows.image a m h m i=
      KeygenPublicRadixPolynomial.split a m h (i/(2*h)) (i%(2*h)) := by
  have width : 0<2*h := by omega
  have row : i/(2*h)<m := (Nat.div_lt_iff_lt_mul width).2 (by omega)
  have column : i%(2*h)<2*h := Nat.mod_lt i width
  have address : (i/(2*h))*(2*h)+i%(2*h)=i := by
    simpa only [Nat.mul_comm,Nat.add_comm] using Nat.mod_add_div i (2*h)
  have law := KeygenPublicRadixPolynomial.rows_values a m h m (i/(2*h)) (i%(2*h)) column
  simpa only [address,row,ite_true] using law

theorem split_congr (a b : Nat → R) (m h j k : Nat)
    (same : ∀ i, i<1536 → a i=b i) (extent : m*(2*h)=1536)
    (row : j<m) (column : k<2*h) :
    KeygenPublicRadixPolynomial.split a m h j k=KeygenPublicRadixPolynomial.split b m h j k := by
  have limit := Nat.mul_le_mul_right (2*h) (show j+1≤m by omega)
  simp only [Nat.add_mul,Nat.one_mul,extent] at limit
  unfold KeygenPublicRadixPolynomial.split
  split_ifs with low
  · unfold KeygenPublicRadixFold.low
    rw [same (j*(2*h)+k) (by omega),same (j*(2*h)+h+k) (by omega)]
  · unfold KeygenPublicRadixFold.high
    rw [same (j*(2*h)+(k-h)) (by omega),same (j*(2*h)+h+(k-h)) (by omega)]

theorem stage_sound (a b : Vector) (input : Nat → R) (k : Nat) (active : k<8)
    (represented : Represents a (KeygenPublicRadixStages.image input k)) (checked : StageCheck a b k) :
    Represents b (KeygenPublicRadixStages.image input (k+1)) := by
  obtain ⟨positive,_,extent,_,_,_,_⟩ := KeygenPublicRadixStages.dimensions k active
  refine ⟨checked.1,?_⟩
  intro i inside
  rw [checked.2 ⟨i,inside⟩,KeygenPublicRadixStages.image,
    rows_value _ _ _ i positive extent inside]
  apply split_congr _ _ _ _ _ _ represented.2 extent
  · apply (Nat.div_lt_iff_lt_mul (by omega : 0<2*(KeygenPublicRadixStages.size k/2))).2
    omega
  · exact Nat.mod_lt _ (by omega)

def TripleCheck (a b : Vector) : Prop :=
  b.size=1536 ∧ ∀ i : Fin 1536, value b i.val=KeygenPublicTripleFold.value (value a) i.val

instance tripleCheckDecidable (a b : Vector) : Decidable (TripleCheck a b) := by
  unfold TripleCheck
  infer_instance

theorem triple_sound (a b : Vector) (input : Nat → R)
    (represented : Represents a input) (checked : TripleCheck a b) :
    Represents b (KeygenPublicTripleFold.value input) := by
  refine ⟨checked.1,?_⟩
  intro i inside
  rw [checked.2 ⟨i,inside⟩]
  unfold KeygenPublicTripleFold.value
  rw [represented.2 (3*(i/3)) (by omega),represented.2 (3*(i/3)+1) (by omega),
    represented.2 (3*(i/3)+2) (by omega)]

def NonzeroCheck (a : Vector) : Prop := ∀ i : Fin 1536, value a i.val≠0
instance nonzeroCheckDecidable (a : Vector) : Decidable (NonzeroCheck a) := by
  unfold NonzeroCheck
  infer_instance

theorem nonzero_sound (a : Vector) (original : Geometry.Vec)
    (represented : Represents a (KeygenPublicTripleFold.value (KeygenPublicRadixEntry.radixImage original)))
    (checked : NonzeroCheck a) (i : Fin 1536) :
    (FT1536.Run2.CoefficientQuotient.polynomial (Relation.reduceVec original)).eval (KeygenPublicRoots.point i)≠0 := by
  rw [← KeygenPublicEvaluation.original_values original i,← represented.2 i.val i.isLt]
  exact checked i

end FT1536.Source3.PublicTreeEvaluation170
