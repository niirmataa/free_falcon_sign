import Source3.KeygenPublicForwardControl

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Derive forward table inputs in the actual caller: parameter binding,
   complete generator execution and both gm aliases. There is no incoming
   generated-image or canonical-twiddle premise. -/
namespace FT1536.Source3.KeygenPublicForwardCall
open C99ArrayReference (State bindPointer)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec localPointer)
open KeygenPublicWord (Bind)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicTableStore (Pointers)
open KeygenPublicRangeMemory (Domain)
open KeygenPublicUpperFrames (UpperFrame)
open KeygenPublicForwardProgram (generateArgs generate squareAlias cubicAlias dynamic)
open KeygenPublicForwardControl (seq_inv)

theorem generate_lookup : KeygenPublicSource.program (KeygenPublicSource.name .generate)=
    some (KeygenPublicSource.function .generate) := by decide

theorem zero_value (s : State) (v : C99IntegerReference.Value)
    (source : KeygenPublicWord.scalar s C99ProcedureParser.zero v) : v.integer.toNat=0 := by
  cases source
  rfl

theorem generate_entry (before entry : State) (gm igm : ArrayPointer)
    (profile : Slot before "logn" 10) (pointers : Pointers before gm igm)
    (binding : Bind before (KeygenPublicSource.params .generate) generateArgs entry) :
    entry.heap=before.heap ∧ Pointers entry gm igm ∧ Slot entry "logn" 10 := by
  cases binding with
  | pointer _ _ _ actualG _ _ _ gRead rest =>
      cases rest with
      | pointer _ _ _ actualI _ _ _ iRead rest =>
          cases rest with
          | scalar _ _ _ _ _ _ value evaluated rest =>
              cases rest
              have gEqual := KeygenPublicTableIndex.address before "gm" C99ProcedureParser.zero gm actualG 0
                pointers.1 (zero_value before) gRead
              have iEqual := KeygenPublicTableIndex.address before "igm" C99ProcedureParser.zero igm actualI 0
                pointers.2 (zero_value before) iRead
              have valueEqual := KeygenPublicTableAtoms.variable_value [] before "logn" 10 value profile
                (.scalar _ _ evaluated)
              have g0 : KeygenSmallOutput.element gm 0=gm := by simp only [KeygenSmallOutput.element,Nat.add_zero]
              have i0 : KeygenSmallOutput.element igm 0=igm := by simp only [KeygenSmallOutput.element,Nat.add_zero]
              rw [g0] at gEqual
              rw [i0] at iEqual
              subst actualG; subst actualI; subst value
              exact ⟨rfl,⟨rfl,rfl⟩,rfl⟩

theorem generate_result (before : State) (out : Result) (gBlock iBlock : Nat)
    (profile : Slot before "logn" 10)
    (pointers : Pointers before (localPointer gBlock 2048) (localPointer iBlock 2048))
    (different : gBlock≠iBlock) (empty : ∀ offset, before.heap.bytes gBlock offset=none)
    (source : Exec KeygenPublicSource.program [] generate before out) :
    out.flow=.normal ∧ out.state.locals=before.locals ∧ out.state.arrays=before.arrays ∧
      Domain out.state.heap (localPointer gBlock 2048) ∧
      UpperFrame (localPointer gBlock 2048) (localPointer iBlock 2048) before.heap out.state.heap := by
  cases source with
  | call _ _ f _ entry inner lookup binding executed returned =>
      have fEqual := Option.some.inj (lookup.symm.trans generate_lookup)
      subst f
      obtain ⟨heap,pointers',profile'⟩ := generate_entry before entry _ _ profile pointers binding
      have separate : KeygenPublicTableStore.Separate (localPointer gBlock 2048) (localPointer iBlock 2048) :=
        Or.inl different
      obtain ⟨_,images,top,_,_,_,_,_,_,_,frame⟩ := KeygenPublicUpperImages.source_complete_tables
        entry inner _ _ profile' pointers' rfl rfl separate executed
      rw [heap] at frame
      have domain := KeygenPublicForwardMemory.generated_domain before.heap inner.state.heap gBlock iBlock
        different empty images top frame
      exact ⟨rfl,rfl,rfl,domain,frame⟩

theorem alias_result (before : State) (out : Result) (name : String) (gm : ArrayPointer)
    (pointer : before.arrays "gm".toList=some gm)
    (source : Exec KeygenPublicSource.program [] (.pointer name.toList "gm".toList C99ProcedureParser.zero) before out) :
    out=⟨bindPointer before name.toList gm,.normal⟩ := by
  cases source with
  | pointer _ _ _ _ actual address =>
      have equal := KeygenPublicTableIndex.address before "gm" C99ProcedureParser.zero gm actual 0
        pointer (zero_value before) address
      have zero : KeygenSmallOutput.element gm 0=gm := by simp only [KeygenSmallOutput.element,Nat.add_zero]
      rw [zero] at equal
      subst actual
      rfl

theorem alias_other (s : State) (dst other : String) (p : ArrayPointer) (different : other≠dst) :
    (bindPointer s dst.toList p).arrays other.toList=s.arrays other.toList := by
  simp only [bindPointer,show other.toList≠dst.toList from fun equal => different (String.toList_injective equal),ite_false]
theorem restore_empty (before after : State) : C99ArrayReference.restoreScope before after [] []=after := rfl

theorem dynamic_result (before : State) (out : Result) (a : ArrayPointer) (gBlock iBlock : Nat)
    (profile : Slot before "logn" 10) (input : before.arrays "a".toList=some a)
    (pointers : Pointers before (localPointer gBlock 2048) (localPointer iBlock 2048))
    (different : gBlock≠iBlock) (empty : ∀ offset, before.heap.bytes gBlock offset=none)
    (source : Exec KeygenPublicSource.program [] dynamic before out) :
    out.flow=.normal ∧ out.state.locals=before.locals ∧ out.state.arrays "a".toList=some a ∧
      out.state.arrays "gm_square".toList=some (localPointer gBlock 2048) ∧
      out.state.arrays "gm_cubic".toList=some (localPointer gBlock 2048) ∧
      Domain out.state.heap (localPointer gBlock 2048) ∧
      UpperFrame (localPointer gBlock 2048) (localPointer iBlock 2048) before.heap out.state.heap := by
  cases source with
  | scope _ _ _ _ inner executed =>
      rw [restore_empty]
      obtain ⟨s1,generated,rest1⟩ := seq_inv _ generate _ before inner (by decide) executed
      obtain ⟨s2,square,rest2⟩ := seq_inv _ squareAlias _ s1 inner (by decide) rest1
      obtain ⟨s3,cubic,last⟩ := seq_inv _ cubicAlias _ s2 inner (by decide) rest2
      cases last
      obtain ⟨_,locals1,arrays1,domain,frame⟩ := generate_result before ⟨s1,.normal⟩ gBlock iBlock profile pointers different empty generated
      have pointer1 : s1.arrays "gm".toList=some (localPointer gBlock 2048) := by rw [arrays1]; exact pointers.1
      have squareEqual := alias_result s1 ⟨s2,.normal⟩ "gm_square" _ pointer1 square
      have state2 := congrArg Result.state squareEqual
      dsimp only at state2
      have pointer2 : s2.arrays "gm".toList=some (localPointer gBlock 2048) := by
        rw [state2,alias_other _ "gm_square" "gm" _ (by decide)]
        exact pointer1
      have cubicEqual := alias_result s2 ⟨s3,.normal⟩ "gm_cubic" _ pointer2 cubic
      have state3 := congrArg Result.state cubicEqual
      dsimp only at state3
      have heap : s3.heap=s1.heap := by rw [state3,state2]; rfl
      refine ⟨rfl,?_,?_,?_,?_,?_,?_⟩
      · rw [state3,state2]; exact locals1
      · rw [state3,alias_other _ "gm_cubic" "a" _ (by decide),state2,
          alias_other _ "gm_square" "a" _ (by decide),arrays1]
        exact input
      · rw [state3,alias_other _ "gm_cubic" "gm_square" _ (by decide),state2]
        simp only [bindPointer,ite_true]
      · rw [state3]; simp only [bindPointer,ite_true]
      · rw [heap]; exact domain
      · rw [heap]; exact frame

end FT1536.Source3.KeygenPublicForwardCall
