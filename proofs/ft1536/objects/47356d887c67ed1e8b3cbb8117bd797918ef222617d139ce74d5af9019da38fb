import Source3.StableTopLoop
import Source3.C99HelperShape

namespace FT1536.Source3.StableTopBranchLayout
open StableTopMemory StableBinaryByteView
def LeavesRead (l : Layout) (h : B20.C.Byte.Memory) : Prop :=
  ∀ i<768, (wordRead h (StableBinary.addr l.leaves i)).isSome

theorem branch_legal (l : Layout) (h : B20.C.Byte.Memory) (legal : Legal l h) (read : LeavesRead l h)
    (j : Nat) (hj : j<3) : StableBinaryByteView.Legal (branch l j) h := by
  have addr (i : Nat) : StableBinary.addr (branch l j).values i=StableBinary.addr l.leaves (256*j+i) := by
    simp [branch,StableBinary.addr]; omega
  refine ⟨?_,?_,legal.scratchWritable,legal.badReadable,legal.badWritable⟩
  · intro i hi
    rw [addr]
    apply (HelperMemoryTotal.read_some_iff _ _).mp
    exact read _ (by change i<256 at hi; omega)
  · intro i hi
    rw [addr]
    exact legal.leavesWritable _ (by change i<256 at hi; omega)

theorem allowed_subset (l : Layout) (j : Nat) (hj : j<3) (p : B20.C.Byte.Pointer)
    (h : StableBinaryRefinementGoal.allowedByte (branch l j) p) : Allowed l p := by
  dsimp [StableBinaryRefinementGoal.allowedByte,StableBinary.inBytes,branch,Allowed] at *
  omega

theorem root_outside (l : Layout) (hl : WellFormed l) (i : Nat) (hi : i<768) (byte : Fin 8) :
    ¬Allowed l ((ptr (StableBinary.addr l.roots i)).add byte.val) := by
  have h1:=hl.rootsLeaves; have h2:=hl.rootsScratch; have h3:=hl.rootsBad; have hbyte:=byte.isLt
  dsimp [Separate,Allowed,ptr,B20.C.Byte.Pointer.add,StableBinary.addr] at *
  omega

theorem leaf_outside_branch (l : Layout) (hl : WellFormed l) (j i : Nat) (hi : i<768)
    (hout : ¬(256*j ≤ i ∧ i<256*j+256)) (byte : Fin 8) :
    ¬StableBinaryRefinementGoal.allowedByte (branch l j) ((ptr (StableBinary.addr l.leaves i)).add byte.val) := by
  have h1:=hl.leavesScratch; have h2:=hl.leavesBad; have hbyte:=byte.isLt
  dsimp [Separate,StableBinaryRefinementGoal.allowedByte,StableBinary.inBytes,branch,
    ptr,B20.C.Byte.Pointer.add,StableBinary.addr] at *
  omega

theorem leaves_after_branch (l : Layout) (hl : WellFormed l) (j : Nat)
    (before after : B20.C.Byte.Memory) (read : LeavesRead l before)
    (legal : StableBinaryByteView.Legal (branch l j) after) (shape : after.length=before.length)
    (frame : ∀ p, ¬StableBinaryRefinementGoal.allowedByte (branch l j) p → after.contents p=before.contents p) :
    LeavesRead l after := by
  intro i hi
  by_cases hin : 256*j ≤ i ∧ i<256*j+256
  · have hlocal := legal.valuesReadable (i-256*j) (by change i-256*j<256; omega)
    have haddr : StableBinary.addr (branch l j).values (i-256*j)=StableBinary.addr l.leaves i := by
      dsimp [branch,StableBinary.addr]; omega
    rw [haddr] at hlocal
    exact (HelperMemoryTotal.read_some_iff _ _).mpr hlocal
  · rw [word_read_congr before after (StableBinary.addr l.leaves i) shape
      (fun byte => frame _ (leaf_outside_branch l hl j i hi hin byte))]
    exact read i hi

end FT1536.Source3.StableTopBranchLayout

#print axioms FT1536.Source3.StableTopBranchLayout.branch_legal
#print axioms FT1536.Source3.StableTopBranchLayout.leaves_after_branch
