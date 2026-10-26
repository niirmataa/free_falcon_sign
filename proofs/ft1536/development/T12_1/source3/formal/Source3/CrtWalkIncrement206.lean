import Source3.CrtCoefficientImage205

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtWalkIncrement206
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer)
open C99NatWord141 (word)
open C99LoopScalar141 (Cell)
open CrtState205 (set64)
open KeygenZintCall (Exec)

def cell (root : ArrayPointer) (v : Nat) : ArrayPointer := StepCopyBody190.elem root (2*v)
 def next (s : State) (root : ArrayPointer) (v : Nat) :=
  bindPointer (set64 s "v" (word (v+1))) "x".toList (cell root (v+1))

theorem at_step (root : ArrayPointer) (v : Nat) :
    {cell root v with index:=(cell root v).index+2}=cell root (v+1) := by
  exact congrArg (fun i : Nat => (⟨root.block,root.base,root.count,root.elementBytes,i⟩ : ArrayPointer))
    (show root.index+2*v+2=root.index+2*(v+1) by omega)

theorem source (s : State) (root : ArrayPointer) (v : Nat) (bound : v < 2^64)
    (vc : Cell s "v".toList v) (stride : Cell s "xstride".toList 2)
    (xb : s.arrays "x".toList=some (cell root v)) (cap : root.index+2*v+2 ≤ root.count) :
    Exec CrtRoundShape205.increment s ⟨next s root v,.normal⟩ := by
  have inc : KeygenWordExec.Exec (.modular (.base (.scalar (.update "v".toList .add (.literal .i32 1)))))
      s ⟨set64 s "v" (word (v+1)),.normal⟩ :=
    ZintSubWord194.update_run _ "v".toList .add _ .uint64 (.uint64 (word v)) (.int32 1)
      (.uint64 (word (v+1))) vc (.literal .int32 1) (C99NatWord141.add_one v bound)
  have stepStride : Cell (set64 s "v" (word (v+1))) "xstride".toList 2 :=
    (CrtState205.keep64 s "v" "xstride" (word (v+1)) (by decide)).trans stride
  have ptr : Pointer (set64 s "v" (word (v+1))) "x".toList (.var "xstride".toList) (cell root (v+1)) := by
    refine .add _ _ (cell root v) _ (.uint64 (word 2)) xb (.variable _ _ _ stepStride) (by decide) ?_
    rw [show (C99IntegerReference.Value.uint64 (word 2)).integer.toNat=2 by decide,← at_step]
    exact .within (cell root v) 2 cap
  exact .seqNormal _ _ _ _ _ (.word _ _ _ inc)
    (.word _ _ _ (.modular _ _ _ (.base _ _ _ (.bindPtr _ _ _ _ _ ptr))))

theorem locals (s : State) (root : ArrayPointer) (v : Nat) (name : Name) (different : name≠"v".toList) :
    (next s root v).locals name=s.locals name :=
  SelectedStepAddPrime195.locals_keep s "v".toList .uint64 (.uint64 (word (v+1))) name different

theorem arrays (s : State) (root : ArrayPointer) (v : Nat) (name : Name) (different : name≠"x".toList) :
    (next s root v).arrays name=s.arrays name := by
  simp only [next,bindPointer,different,ite_false]
  rfl

theorem counter (s : State) (root : ArrayPointer) (v : Nat) : Cell (next s root v) "v".toList (v+1) := by
  change Cell (set64 s "v" (word (v+1))) "v".toList (v+1)
  exact CrtState205.cell64 _ _ _

theorem pointer (s : State) (root : ArrayPointer) (v : Nat) :
    (next s root v).arrays "x".toList=some (cell root (v+1)) := by simp only [next,bindPointer,ite_true]

end FT1536.Source3.CrtWalkIncrement206
