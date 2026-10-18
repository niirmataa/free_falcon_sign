import Source3.SelectedTreeStage170_8
import Source3.PublicBlockChecks170

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedTreeNonzero170
open GeneratedPublicTree170 (stage8 output)
open PublicTreeEvaluation170 (value)

def predicate (i : Fin 1536) : Prop := value output i.val=PublicTreeRootValues170.triple stage8 i.val
instance predicateDecidable : DecidablePred predicate := fun _ => ZMod.decidableEq 18433 _ _

theorem block0 : PublicBlockChecks170.block predicate 0=true := by decide +kernel
theorem block1 : PublicBlockChecks170.block predicate 1=true := by decide +kernel
theorem block2 : PublicBlockChecks170.block predicate 2=true := by decide +kernel
theorem block3 : PublicBlockChecks170.block predicate 3=true := by decide +kernel
theorem block4 : PublicBlockChecks170.block predicate 4=true := by decide +kernel
theorem block5 : PublicBlockChecks170.block predicate 5=true := by decide +kernel
theorem block6 : PublicBlockChecks170.block predicate 6=true := by decide +kernel
theorem block7 : PublicBlockChecks170.block predicate 7=true := by decide +kernel
theorem block8 : PublicBlockChecks170.block predicate 8=true := by decide +kernel
theorem block9 : PublicBlockChecks170.block predicate 9=true := by decide +kernel
theorem block10 : PublicBlockChecks170.block predicate 10=true := by decide +kernel
theorem block11 : PublicBlockChecks170.block predicate 11=true := by decide +kernel
theorem block12 : PublicBlockChecks170.block predicate 12=true := by decide +kernel
theorem block13 : PublicBlockChecks170.block predicate 13=true := by decide +kernel
theorem block14 : PublicBlockChecks170.block predicate 14=true := by decide +kernel
theorem block15 : PublicBlockChecks170.block predicate 15=true := by decide +kernel
theorem block16 : PublicBlockChecks170.block predicate 16=true := by decide +kernel
theorem block17 : PublicBlockChecks170.block predicate 17=true := by decide +kernel
theorem block18 : PublicBlockChecks170.block predicate 18=true := by decide +kernel
theorem block19 : PublicBlockChecks170.block predicate 19=true := by decide +kernel
theorem block20 : PublicBlockChecks170.block predicate 20=true := by decide +kernel
theorem block21 : PublicBlockChecks170.block predicate 21=true := by decide +kernel
theorem block22 : PublicBlockChecks170.block predicate 22=true := by decide +kernel
theorem block23 : PublicBlockChecks170.block predicate 23=true := by decide +kernel

theorem blocks (b : Fin 24) : PublicBlockChecks170.block predicate b.val=true :=
  match b with
  | ⟨0,_⟩ => block0
  | ⟨1,_⟩ => block1
  | ⟨2,_⟩ => block2
  | ⟨3,_⟩ => block3
  | ⟨4,_⟩ => block4
  | ⟨5,_⟩ => block5
  | ⟨6,_⟩ => block6
  | ⟨7,_⟩ => block7
  | ⟨8,_⟩ => block8
  | ⟨9,_⟩ => block9
  | ⟨10,_⟩ => block10
  | ⟨11,_⟩ => block11
  | ⟨12,_⟩ => block12
  | ⟨13,_⟩ => block13
  | ⟨14,_⟩ => block14
  | ⟨15,_⟩ => block15
  | ⟨16,_⟩ => block16
  | ⟨17,_⟩ => block17
  | ⟨18,_⟩ => block18
  | ⟨19,_⟩ => block19
  | ⟨20,_⟩ => block20
  | ⟨21,_⟩ => block21
  | ⟨22,_⟩ => block22
  | ⟨23,_⟩ => block23
  | ⟨n+24,h⟩ => False.elim (by omega)

theorem checked : (List.finRange 1536).all (fun i => decide (predicate i))=true := by
  apply List.all_eq_true.mpr
  intro i _
  exact decide_eq_true (PublicBlockChecks170.sound predicate blocks i)

theorem triple_checked : PublicTreeEvaluation170.TripleCheck stage8 output := by
  refine ⟨by decide +kernel,?_⟩
  intro i
  rw [← PublicTreeRootValues170.triple_eq stage8 i.val i.isLt]
  exact of_decide_eq_true (List.all_eq_true.mp checked i (by simp))

theorem output_values : PublicTreeEvaluation170.Represents output
    (KeygenPublicTripleFold.value (KeygenPublicRadixEntry.radixImage SelectedEvaluation169.fVector)) :=
  PublicTreeEvaluation170.triple_sound stage8 output _ SelectedTreeStage170_8.source triple_checked

def nonzeroPredicate (i : Fin 1536) : Prop := value output i.val≠0
instance nonzeroDecidable : DecidablePred nonzeroPredicate := fun i =>
  inferInstanceAs (Decidable (value output i.val≠(0 : KeygenPublicAlgebra.R)))

theorem nonzero_checked : (List.finRange 1536).all (fun i => decide (nonzeroPredicate i))=true := by decide +kernel

theorem evaluations_nonzero (i : Fin 1536) :
    (FT1536.Run2.CoefficientQuotient.polynomial (Relation.reduceVec SelectedEvaluation169.fVector)).eval
      (KeygenPublicRoots.point i)≠0 :=
  PublicTreeEvaluation170.nonzero_sound output SelectedEvaluation169.fVector output_values
    (fun j => of_decide_eq_true (List.all_eq_true.mp nonzero_checked j (by simp))) i

theorem t_nonzero (i : Fin 1536) : ∃ w : BitVec 16,
    C99NarrowReads.Load16 SelectedForwardT168.output.heap (KeygenSmallOutput.element SelectedPublicStart157.t i.val) w ∧
      w.toNat<18433 ∧ w.toNat≠0 := by
  obtain ⟨w,read,bound,equal⟩ := SelectedEvaluation169.source.2.2 i
  refine ⟨w,read,bound,?_⟩
  intro zero
  have nz := evaluations_nonzero i
  rw [← equal,zero,Nat.cast_zero] at nz
  exact nz rfl

end FT1536.Source3.SelectedTreeNonzero170
