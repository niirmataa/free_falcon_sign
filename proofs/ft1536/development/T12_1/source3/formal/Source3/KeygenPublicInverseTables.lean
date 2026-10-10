import Source3.KeygenPublicInverseProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- BOTH inverse aliases refer to the SAME generated igm block. Index zero
   is exceptional and is not falsely described as an ordinary inverse root. -/
namespace FT1536.Source3.KeygenPublicInverseTables
open C99ArrayReference (State bindPointer)
open C99MemoryReference (Memory ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec localPointer)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicTableStore (Pointers)
open KeygenPublicUpperFrames (UpperFrame)
open KeygenPublicForwardProgram (generate)
open KeygenPublicInverseProgram (squareAlias cubicAlias dynamic)
open KeygenPublicForwardCall (generate_entry generate_lookup alias_other restore_empty)
open KeygenPublicForwardControl (seq_inv)
open KeygenPublicAlgebra (R radix)

def rootAt (i : Nat) : R := KeygenPublicRoots.root⁻¹^KeygenMkgm3Indices.tableExponent i
def Table (heap : Memory) (igm : ArrayPointer) : Prop :=
  KeygenPublicTableCells.Cell heap igm 0 ((2*KeygenPublicRoots.firstRoot-1)⁻¹) ∧
  ∀ i, 0 < i → i < 1024 → KeygenPublicTableCells.Cell heap igm i (rootAt i)

theorem generate_values (before : State) (out : Result) (gBlock iBlock : Nat)
    (profile : Slot before "logn" 10)
    (pointers : Pointers before (localPointer gBlock 2048) (localPointer iBlock 2048))
    (different : gBlock≠iBlock)
    (source : Exec KeygenPublicSource.program [] generate before out) :
    out.flow=.normal ∧ out.state.locals=before.locals ∧ out.state.arrays=before.arrays ∧
      Table out.state.heap (localPointer iBlock 2048) ∧
      UpperFrame (localPointer gBlock 2048) (localPointer iBlock 2048) before.heap out.state.heap := by
  cases source with
  | call _ _ f _ entry inner lookup binding executed returned =>
      have fEqual := Option.some.inj (lookup.symm.trans generate_lookup)
      subst f
      obtain ⟨heap,pointers',profile'⟩ := generate_entry before entry _ _ profile pointers binding
      obtain ⟨_,images,_,exceptional,_,_,_,_,_,_,frame⟩ := KeygenPublicUpperImages.source_complete_tables
        entry inner _ _ profile' pointers' rfl rfl (Or.inl different) executed
      rw [heap] at frame
      exact ⟨rfl,rfl,rfl,⟨exceptional,fun i positive bound => (images i (by omega) bound).2⟩,frame⟩

theorem alias_result (before : State) (out : Result) (name : String) (igm : ArrayPointer)
    (pointer : before.arrays "igm".toList=some igm)
    (source : Exec KeygenPublicSource.program [] (.pointer name.toList "igm".toList C99ProcedureParser.zero) before out) :
    out=⟨bindPointer before name.toList igm,.normal⟩ := by
  cases source with
  | pointer _ _ _ _ actual address =>
      have equal := KeygenPublicTableIndex.address before "igm" C99ProcedureParser.zero igm actual 0
        pointer (KeygenPublicForwardCall.zero_value before) address
      have zero : KeygenSmallOutput.element igm 0=igm := by simp only [KeygenSmallOutput.element,Nat.add_zero]
      rw [zero] at equal
      subst actual
      rfl

theorem dynamic_values (before : State) (out : Result) (a : ArrayPointer) (gBlock iBlock : Nat)
    (profile : Slot before "logn" 10) (input : before.arrays "a".toList=some a)
    (pointers : Pointers before (localPointer gBlock 2048) (localPointer iBlock 2048))
    (different : gBlock≠iBlock)
    (source : Exec KeygenPublicSource.program [] dynamic before out) :
    out.flow=.normal ∧ out.state.locals=before.locals ∧ out.state.arrays "a".toList=some a ∧
      out.state.arrays "igm_square".toList=some (localPointer iBlock 2048) ∧
      out.state.arrays "igm_cubic".toList=some (localPointer iBlock 2048) ∧
      Table out.state.heap (localPointer iBlock 2048) ∧
      UpperFrame (localPointer gBlock 2048) (localPointer iBlock 2048) before.heap out.state.heap := by
  cases source with
  | scope _ _ _ _ inner executed =>
      rw [restore_empty]
      obtain ⟨s1,generated,rest1⟩ := seq_inv _ generate _ before inner (by decide) executed
      obtain ⟨s2,square,rest2⟩ := seq_inv _ squareAlias _ s1 inner (by decide) rest1
      obtain ⟨s3,cubic,last⟩ := seq_inv _ cubicAlias _ s2 inner (by decide) rest2
      cases last
      obtain ⟨_,locals1,arrays1,table,frame⟩ := generate_values before ⟨s1,.normal⟩ gBlock iBlock
        profile pointers different generated
      have pointer1 : s1.arrays "igm".toList=some (localPointer iBlock 2048) := by rw [arrays1]; exact pointers.2
      have state2 := congrArg Result.state (alias_result s1 ⟨s2,.normal⟩ "igm_square" _ pointer1 square)
      dsimp only at state2
      have pointer2 : s2.arrays "igm".toList=some (localPointer iBlock 2048) := by
        rw [state2,alias_other _ "igm_square" "igm" _ (by decide)]; exact pointer1
      have state3 := congrArg Result.state (alias_result s2 ⟨s3,.normal⟩ "igm_cubic" _ pointer2 cubic)
      dsimp only at state3
      have heap : s3.heap=s1.heap := by rw [state3,state2]; rfl
      refine ⟨rfl,?_,?_,?_,?_,?_,?_⟩
      · rw [state3,state2]; exact locals1
      · rw [state3,alias_other _ "igm_cubic" "a" _ (by decide),state2,
          alias_other _ "igm_square" "a" _ (by decide),arrays1]; exact input
      · rw [state3,alias_other _ "igm_cubic" "igm_square" _ (by decide),state2]
        simp only [bindPointer,ite_true]
      · rw [state3]; simp only [bindPointer,ite_true]
      · rw [heap]; exact table
      · rw [heap]; exact frame

theorem table_after (code : KeygenPublicExec.Stmt) (s : State) (out : Result) (a igm : ArrayPointer)
    (ok : KeygenPublicTableControl.supported code=true) (only : KeygenPublicValueFrames.onlyA code=true)
    (separate : a.block≠igm.block) (pointer : s.arrays "a".toList=some a) (table : Table s.heap igm)
    (source : Exec KeygenPublicSource.program [] code s out) : Table out.state.heap igm := by
  have block := KeygenPublicValueFrames.other_block _ [] code s out ok only a igm.block separate pointer source
  have transport (i : Nat) (z : R) (cell : KeygenPublicTableCells.Cell s.heap igm i z) :
      KeygenPublicTableCells.Cell out.state.heap igm i z := by
    obtain ⟨w,read,range,value⟩ := cell
    exact ⟨w,KeygenPublicForwardMemory.load_block _ _ (KeygenSmallOutput.element igm i) w block read,range,value⟩
  exact ⟨transport 0 _ table.1,fun i hi bound => transport i _ (table.2 i hi bound)⟩

end FT1536.Source3.KeygenPublicInverseTables
