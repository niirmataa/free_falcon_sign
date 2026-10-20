import Source3.KeygenPublicFirstFold

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Retain the actual generator's VALUES through Call/Bind and both aliases.
   These are Montgomery-scaled table cells, not ordinary input coefficients. -/
namespace FT1536.Source3.KeygenPublicFirstTables
open C99ArrayReference (State bindPointer)
open C99MemoryReference (Memory ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec localPointer)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicTableStore (Pointers)
open KeygenPublicUpperFrames (UpperFrame)
open KeygenPublicForwardProgram (generate squareAlias cubicAlias dynamic)
open KeygenPublicForwardCall (generate_entry generate_lookup alias_result alias_other restore_empty)
open KeygenPublicForwardControl (seq_inv)

def Table (heap : Memory) (gm : ArrayPointer) : Prop :=
  ∀ i<1024, KeygenPublicTableCells.Cell heap gm i
    (KeygenPublicRoots.root^KeygenMkgm3Indices.tableExponent i)

theorem generate_values (before : State) (out : Result) (gBlock iBlock : Nat)
    (profile : Slot before "logn" 10)
    (pointers : Pointers before (localPointer gBlock 2048) (localPointer iBlock 2048))
    (different : gBlock≠iBlock)
    (source : Exec KeygenPublicSource.program [] generate before out) :
    out.flow=.normal ∧ out.state.locals=before.locals ∧ out.state.arrays=before.arrays ∧
      Table out.state.heap (localPointer gBlock 2048) ∧
      UpperFrame (localPointer gBlock 2048) (localPointer iBlock 2048) before.heap out.state.heap := by
  cases source with
  | call _ _ f _ entry inner lookup binding executed returned =>
      have fEqual := Option.some.inj (lookup.symm.trans generate_lookup)
      subst f
      obtain ⟨heap,pointers',profile'⟩ := generate_entry before entry _ _ profile pointers binding
      obtain ⟨_,images,top,_,_,_,_,_,_,_,frame⟩ := KeygenPublicUpperImages.source_complete_tables
        entry inner _ _ profile' pointers' rfl rfl (Or.inl different) executed
      rw [heap] at frame
      refine ⟨rfl,rfl,rfl,?_,frame⟩
      intro i hi
      by_cases zero : i=0
      · subst i; exact top
      · exact (images i (by omega) hi).1

theorem dynamic_values (before : State) (out : Result) (a : ArrayPointer) (gBlock iBlock : Nat)
    (profile : Slot before "logn" 10) (input : before.arrays "a".toList=some a)
    (pointers : Pointers before (localPointer gBlock 2048) (localPointer iBlock 2048))
    (different : gBlock≠iBlock)
    (source : Exec KeygenPublicSource.program [] dynamic before out) :
    out.flow=.normal ∧ out.state.locals=before.locals ∧ out.state.arrays "a".toList=some a ∧
      out.state.arrays "gm_square".toList=some (localPointer gBlock 2048) ∧
      out.state.arrays "gm_cubic".toList=some (localPointer gBlock 2048) ∧
      Table out.state.heap (localPointer gBlock 2048) ∧
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
      have pointer1 : s1.arrays "gm".toList=some (localPointer gBlock 2048) := by rw [arrays1]; exact pointers.1
      have state2 := congrArg Result.state (alias_result s1 ⟨s2,.normal⟩ "gm_square" _ pointer1 square)
      dsimp only at state2
      have pointer2 : s2.arrays "gm".toList=some (localPointer gBlock 2048) := by
        rw [state2,alias_other _ "gm_square" "gm" _ (by decide)]; exact pointer1
      have state3 := congrArg Result.state (alias_result s2 ⟨s3,.normal⟩ "gm_cubic" _ pointer2 cubic)
      dsimp only at state3
      have heap : s3.heap=s1.heap := by rw [state3,state2]; rfl
      refine ⟨rfl,?_,?_,?_,?_,?_,?_⟩
      · rw [state3,state2]; exact locals1
      · rw [state3,alias_other _ "gm_cubic" "a" _ (by decide),state2,
          alias_other _ "gm_square" "a" _ (by decide),arrays1]; exact input
      · rw [state3,alias_other _ "gm_cubic" "gm_square" _ (by decide),state2]
        simp only [bindPointer,ite_true]
      · rw [state3]; simp only [bindPointer,ite_true]
      · rw [heap]; exact table
      · rw [heap]; exact frame

theorem first_cell (heap : Memory) (gm : ArrayPointer) (table : Table heap gm) :
    KeygenPublicInputCells.Cell heap gm 1 (KeygenPublicAlgebra.radix*KeygenPublicFirstFold.root) := by
  have cell := table 1 (by decide)
  have exponent : KeygenPublicRoots.root^KeygenMkgm3Indices.tableExponent 1=KeygenPublicFirstFold.root := by
    rw [KeygenPublicUpperFinish.te_one]; rfl
  rw [exponent] at cell
  exact cell

theorem cells_block (before after : Memory) (p : ArrayPointer) (n : Nat) (a : Nat → KeygenPublicAlgebra.R)
    (same : KeygenPublicForwardMemory.Block before after p.block)
    (cells : KeygenPublicInputCells.Cells before p n a) : KeygenPublicInputCells.Cells after p n a := by
  intro i hi
  obtain ⟨w,read,range,eq⟩ := cells i hi
  exact ⟨w,KeygenPublicForwardMemory.load_block before after (KeygenSmallOutput.element p i) w same read,range,eq⟩

end FT1536.Source3.KeygenPublicFirstTables
