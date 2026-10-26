import Source3.ZintNormWalkFlat208

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintNormWalkBranch208
open C99ArrayReference (State Name bindPointer Pointer)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open CrtState205 (Slot64 set64)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open ZintNormWalkIncrement208 (row)
open ZintNormWalkFixed208 (Fixed)
open ZintNormWalkFlat208 (Data words)
open KeygenZintCall (Exec)

def zero (s : State) := set64 s "u" 0
 def entry (s : State) (root : ArrayPointer) := bindPointer (zero s) "x".toList root

theorem locals (s : State) (root : ArrayPointer) (name : Name) (nu : name≠"u".toList) :
    (entry s root).locals name=s.locals name :=
  SelectedStepAddPrime195.locals_keep s "u".toList .uint64 (.uint64 0) name nu

theorem arrays (s : State) (root : ArrayPointer) (name : Name) (nx : name≠"x".toList) :
    (entry s root).arrays name=s.arrays name := by simp only [entry,bindPointer,nx,ite_false]; rfl

theorem fixed (s : State) (root tmp : ArrayPointer) (n len : Nat) (pv : Nat → BitVec 32)
    (input : Fixed s root tmp n len pv) : Fixed (entry s root) root tmp n len pv := by
  refine ⟨input.nBound,input.lenBound,input.positive,input.width,input.capacity,input.writable,?_,?_,?_,?_,input.pCapacity,input.pRead,input.apart⟩
  · exact (arrays s root "tmp".toList (by decide)).trans input.tmpBinding
  · exact (locals s root "num".toList (by decide)).trans input.numCell
  · exact (locals s root "xlen".toList (by decide)).trans input.lenCell
  · exact (locals s root "xstride".toList (by decide)).trans input.strideCell

theorem init_source (s : State) (root : ArrayPointer) (old : BitVec 64) (uc : Slot64 s "u" old)
    (xx : s.arrays "xx".toList=some root) (capacity : root.index+0 ≤ root.count) :
    Exec ZintNormWalk194.normInit s ⟨entry s root,.normal⟩ := by
  have first : Exec ZintNormWalk194.normUZero s ⟨zero s,.normal⟩ := by
    rw [ZintNormWalk194.norm_uzero]
    exact .word _ _ _ (.assign _ _ _ .uint64 (some (.uint64 old)) (.int32 0) uc (WordAtoms205.literal _ 0))
  have ptr : Pointer (zero s) "xx".toList C99ProcedureParser.zero root :=
    .add _ _ root root (.uint64 0) xx (.literal .uint64 0) (by decide) (.within root 0 capacity)
  have second : Exec ZintNormWalk194.normXInit (zero s) ⟨entry s root,.normal⟩ := by
    rw [ZintNormWalk194.norm_xinit]
    exact .word _ _ _ (.modular _ _ _ (.base _ _ _ (.bindPtr _ _ _ _ _ ptr)))
  rw [ZintNormWalk194.norm_init_split]
  exact .seqNormal _ _ _ _ _ first second

theorem source (s : State) (root tmp : ArrayPointer) (n len : Nat) (W pv : Nat → BitVec 32) (old : BitVec 64)
    (input : Fixed s root tmp n len pv) (uc : Slot64 s "u" old)
    (xx : s.arrays "xx".toList=some root)
    (sign : s.locals "normalize_signed".toList=some (.int32,some (.int32 1))) (data : Data s root (n*len) W) :
    ∃ out, Exec MakeFgCrtShape194.crtNormalize s ⟨out,.normal⟩ ∧ Fixed out root tmp n len pv ∧
      Cell out "u".toList n ∧ out.arrays "x".toList=some (row root len n) ∧ Data out root (n*len) (words len W pv) ∧
      (∀ name : Name, name≠"u".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i, i < n*len → Separate (elem root i) q) → Load32 s.heap q old → Load32 out.heap q old) := by
  have counter : Cell (entry s root) "u".toList 0 := by
    change Cell (zero s) "u".toList 0
    exact CrtState205.cell64 _ _ _
  have pointer : (entry s root).arrays "x".toList=some root := by simp only [entry,bindPointer,ite_true]
  obtain ⟨out,run,outFixed,outU,outX,image,outLocals,outArrays,keep⟩:=
    ZintNormWalkFlat208.source (entry s root) root tmp n len W pv (fixed s root tmp n len pv input) counter pointer data
  have walkPart : Exec ZintNormWalk194.normLoopPart (entry s root) ⟨out,.normal⟩ := by
    rw [ZintNormWalk194.norm_loop]
    exact run
  have p1 : Exec ZintNormWalk194.normP1 s ⟨out,.normal⟩ := by
    rw [ZintNormWalk194.norm_p1_split]
    exact .seqNormal _ _ _ _ _ (init_source s root old uc xx (by have cap:=input.capacity; omega)) walkPart
  have walk : Exec ZintNormWalk194.normWalk s ⟨out,.normal⟩ := by
    rw [ZintNormWalk194.norm_walk_split,ZintNormWalk194.norm_p2_skip]
    exact .seqNormal _ _ _ _ _ p1 (ZintNormWord194.word_skip out)
  have yes : Exec ZintNormWalk194.normYes s ⟨out,.normal⟩ := by
    rw [ZintNormWalk194.norm_scope]
    exact .scope _ _ _ _ _ walk
  have branch : Exec ZintNormWalk194.normBranch s ⟨out,.normal⟩ := by
    rw [ZintNormWalk194.norm_branch,ZintRebuildCrt194.norm_test]
    exact .branchTrue _ _ _ _ _ (.int32 1) (.scalar _ _ (.variable _ _ _ sign)) (by decide) yes
  have whole : Exec MakeFgCrtShape194.crtNormalize s ⟨out,.normal⟩ := by
    change Exec ZintNormWalk194.normWrap s ⟨out,.normal⟩
    rw [ZintNormWalk194.norm_split,ZintRebuildCrt194.norm_tail]
    exact .seqNormal _ _ _ _ _ branch (ZintNormWord194.word_skip out)
  refine ⟨out,whole,outFixed,outU,outX,image,?_,?_,keep⟩
  · intro name different
    exact (outLocals name different).trans (locals s root name different)
  · intro name different
    exact (outArrays name different).trans (arrays s root name different)

end FT1536.Source3.ZintNormWalkBranch208
