import Source3.ZintNormTwo207

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintNormWalkIncrement208
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open CrtState205 (set64)
open C99NatWord141 (word)
open KeygenZintCall (Exec)

def row (root : ArrayPointer) (len v : Nat) := StepCopyBody190.elem root (v*len)
 def point (root : ArrayPointer) (len v j : Nat) := StepCopyBody190.elem root (v*len+j)
 def next (s : State) (root : ArrayPointer) (len v : Nat) :=
  bindPointer (set64 s "u" (word (v+1))) "x".toList (row root len (v+1))

theorem row_element (root : ArrayPointer) (len v j : Nat) : StepCopyBody190.elem (row root len v) j=point root len v j := by
  exact congrArg (fun k : Nat => (⟨root.block,root.base,root.count,root.elementBytes,k⟩ : ArrayPointer))
    (show root.index+v*len+j=root.index+(v*len+j) by omega)

theorem row_step (root : ArrayPointer) (len v : Nat) :
    {row root len v with index:=(row root len v).index+len}=row root len (v+1) := by
  exact congrArg (fun k : Nat => (⟨root.block,root.base,root.count,root.elementBytes,k⟩ : ArrayPointer))
    (show root.index+v*len+len=root.index+(v+1)*len by rw [Nat.add_mul,Nat.one_mul]; omega)

theorem source (s : State) (root : ArrayPointer) (len v : Nat) (vb : v < 2^64) (lb : len < 2^64)
    (uc : Cell s "u".toList v) (stride : Cell s "xstride".toList len)
    (xb : s.arrays "x".toList=some (row root len v)) (cap : root.index+v*len+len ≤ root.count) :
    Exec ZintNormWalk194.walkInc s ⟨next s root len v,.normal⟩ := by
  have inc : Exec ZintNormWalk194.walkIncU s ⟨set64 s "u" (word (v+1)),.normal⟩ :=
    ZintNormWord194.word_update s "u".toList .add (.literal .i32 1) .uint64 (.uint64 (word v)) (.int32 1)
      (.uint64 (word (v+1))) uc (.literal .int32 1) (C99NatWord141.add_one v vb)
  have strideNext : Cell (set64 s "u" (word (v+1))) "xstride".toList len :=
    (CrtState205.keep64 s "u" "xstride" (word (v+1)) (by decide)).trans stride
  have ptr : Pointer (set64 s "u" (word (v+1))) "x".toList (.var "xstride".toList) (row root len (v+1)) := by
    refine .add _ _ (row root len v) _ (.uint64 (word len)) xb (.variable _ _ _ strideNext) ?_ ?_
    · rw [C99NatWord141.integer len lb]; omega
    · rw [C99NatWord141.integer len lb,← row_step]
      exact .within (row root len v) len cap
  exact .seqNormal _ _ _ _ _ inc (.word _ _ _ (.modular _ _ _ (.base _ _ _ (.bindPtr _ _ _ _ _ ptr))))

theorem locals (s : State) (root : ArrayPointer) (len v : Nat) (name : Name) (different : name≠"u".toList) :
    (next s root len v).locals name=s.locals name :=
  SelectedStepAddPrime195.locals_keep s "u".toList .uint64 (.uint64 (word (v+1))) name different

theorem arrays (s : State) (root : ArrayPointer) (len v : Nat) (name : Name) (different : name≠"x".toList) :
    (next s root len v).arrays name=s.arrays name := by
  simp only [next,bindPointer,different,ite_false]
  rfl

theorem counter (s : State) (root : ArrayPointer) (len v : Nat) : Cell (next s root len v) "u".toList (v+1) := by
  change Cell (set64 s "u" (word (v+1))) "u".toList (v+1)
  exact CrtState205.cell64 _ _ _

theorem pointer (s : State) (root : ArrayPointer) (len v : Nat) :
    (next s root len v).arrays "x".toList=some (row root len (v+1)) := by simp only [next,bindPointer,ite_true]

end FT1536.Source3.ZintNormWalkIncrement208
