import Source3.KeygenPublicForwardCall

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Canonical unsigned16 output of the SAME complete mq_NTT_ternary
   execution at logn10. Input range/initialization and residue-local domains
   are explicit caller obligations. Table inputs, all store ranges and both
   automatic-array lifetimes are derived. Polynomial evaluations of the
   original f/g and the enclosing conversion/public call remain separate. -/
namespace FT1536.Source3.KeygenPublicForwardRange
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec localPointer localEntry localExit)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicTableStore (Pointers)
open KeygenPublicRangeExpr (Locals Arrays)
open KeygenPublicRangeMemory (Domain Initialized Image)
open KeygenPublicForwardMemory (Block)
open KeygenPublicForwardProgram
open KeygenPublicForwardControl (seq_inv)

def pointerReady (s : State) : State := {s with arrays := fun n =>
  if n="gm_cubic".toList then none else if n="gm_square".toList then none else s.arrays n}
theorem pointer_declarations (s : State) (out : Result)
    (source : Exec KeygenPublicSource.program [] declarePointers s out) :
    out=⟨pointerReady s,.normal⟩ := by
  obtain ⟨s1,first,rest⟩ := seq_inv _ _ _ s out (by decide) source
  cases first
  obtain ⟨s2,second,last⟩ := seq_inv _ _ _ _ out (by decide) rest
  cases second
  cases last
  rfl

theorem condition_value (s : State) (v : Value) (profile : Slot s "logn" 10)
    (source : KeygenPublicWord.Eval [] s condition v) : v=C99ScalarReference.boolean false := by
  cases source with
  | cmp _ _ _ a b _ first second comparison =>
      have ae := KeygenPublicTableAtoms.variable_value [] s "logn" 10 a profile first
      have be := KeygenPublicTableAtoms.literal_value [] s 9 b second
      subst a; subst b
      exact C99CountedWords.comparison_result _ _ _ v comparison

theorem dispatch_dynamic (s : State) (out : Result) (profile : Slot s "logn" 10)
    (source : Exec KeygenPublicSource.program [] dispatch s out) :
    Exec KeygenPublicSource.program [] dynamic s out := by
  cases source with
  | branchTrue _ _ _ _ _ v guard nonzero inner =>
      rw [condition_value s v profile guard] at nonzero
      exact (nonzero rfl).elim
  | branchFalse _ _ _ _ _ v guard zero inner => exact inner

theorem ready_result (s : State) (out : Result) (a : ArrayPointer) (gBlock iBlock : Nat)
    (profile : Slot s "logn" 10) (input : s.arrays "a".toList=some a)
    (pointers : Pointers s (localPointer gBlock 2048) (localPointer iBlock 2048))
    (different : gBlock≠iBlock) (gOutside : a.block≠gBlock) (iOutside : a.block≠iBlock)
    (empty : ∀ offset, s.heap.bytes gBlock offset=none)
    (localRange : Locals residueNames s.locals) (range : Domain s.heap a)
    (initialized : Initialized s.heap a 1536)
    (source : Exec KeygenPublicSource.program [] readyBody s out) :
    out.flow=.normal ∧ Domain out.state.heap a ∧ Initialized out.state.heap a 1536 := by
  obtain ⟨s1,d,rest1⟩ := seq_inv _ declarePointers _ s out (by decide) source
  have state1 := congrArg Result.state (pointer_declarations s ⟨s1,.normal⟩ d)
  dsimp only at state1
  obtain ⟨s2,nExec,rest2⟩ := seq_inv _ nSet _ s1 out (by decide) rest1
  obtain ⟨s3,hnExec,rest3⟩ := seq_inv _ hnSet _ s2 out (by decide) rest2
  obtain ⟨s4,dispatchExec,tailExec⟩ := seq_inv _ dispatch tail s3 out (by decide) rest3
  have local1 : Locals residueNames s1.locals := by rw [state1]; exact localRange
  obtain ⟨_,heap2,local2,keep2⟩ := KeygenPublicForwardControl.pure_result _ [] residueNames nSet s1 ⟨s2,.normal⟩ (by decide) local1 nExec
  obtain ⟨_,heap3,local3,keep3⟩ := KeygenPublicForwardControl.pure_result _ [] residueNames hnSet s2 ⟨s3,.normal⟩ (by decide) local2 hnExec
  have arrays2 := (KeygenPublicTableControl.frame _ [] nSet s1 ⟨s2,.normal⟩ (by decide) nExec).2.1
  have arrays3 := (KeygenPublicTableControl.frame _ [] hnSet s2 ⟨s3,.normal⟩ (by decide) hnExec).2.1
  have heap : s3.heap=s.heap := by rw [heap3,heap2,state1]; rfl
  have logn3 : Slot s3 "logn" 10 := by
    change s3.locals "logn".toList=some (.uint32,some (.uint32 10))
    rw [keep3 _ (by decide),keep2 _ (by decide),state1]
    exact profile
  have input3 : s3.arrays "a".toList=some a := by rw [arrays3,arrays2,state1]; exact input
  have pointers3 : Pointers s3 (localPointer gBlock 2048) (localPointer iBlock 2048) := by
    change s3.arrays "gm".toList=some _ ∧ s3.arrays "igm".toList=some _
    rw [arrays3,arrays2,state1]
    exact pointers
  obtain ⟨_,locals4,input4,square4,cubic4,tableRange,frame4⟩ := KeygenPublicForwardCall.dynamic_result
    s3 ⟨s4,.normal⟩ a gBlock iBlock logn3 input3 pointers3 different
    (fun offset => by rw [heap]; exact empty offset) (dispatch_dynamic s3 ⟨s4,.normal⟩ logn3 dispatchExec)
  have frame : Block s.heap s4.heap a.block := by
    have result := KeygenPublicForwardMemory.upper_other s3.heap s4.heap _ _ a.block gOutside iOutside frame4
    rw [heap] at result
    exact result
  have inputRange := KeygenPublicForwardMemory.domain_block s.heap s4.heap a frame range
  have inputInitialized := KeygenPublicForwardMemory.initialized_block s.heap s4.heap a 1536 frame initialized
  have arrays : Arrays arrayNames s4 := by
    intro name member p binding
    have options : name="a".toList ∨ name="gm_square".toList ∨ name="gm_cubic".toList := by
      simpa [arrayNames] using member
    rcases options with equal | equal | equal
    · subst name
      have pe := Option.some.inj (binding.symm.trans input4)
      subst p; exact inputRange
    · subst name
      have pe := Option.some.inj (binding.symm.trans square4)
      subst p; exact tableRange
    · subst name
      have pe := Option.some.inj (binding.symm.trans cubic4)
      subst p; exact tableRange
  have locals : Locals residueNames s4.locals := by rw [locals4]; exact local3
  obtain ⟨flow,result⟩ := KeygenPublicRangeExec.body _ [] residueNames arrayNames a 1536 tail s4 out
    tail_range_checked ⟨locals,arrays,inputInitialized⟩ tailExec rfl
  have outPointers := (KeygenPublicTableControl.frame _ [] tail s4 out tail_supported tailExec).2.1
  have outInput : out.state.arrays "a".toList=some a := by rw [outPointers]; exact input4
  exact ⟨flow,result.arrayRange "a".toList (by decide) a outInput,result.initialized⟩

theorem source_canonical (s : State) (out : Result) (a : ArrayPointer)
    (profile : Slot s "logn" 10) (input : s.arrays "a".toList=some a)
    (localRange : Locals residueNames s.locals) (range : Domain s.heap a)
    (initialized : Initialized s.heap a 1536)
    (source : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .forwardT) s out) :
    out.flow=.normal ∧ Domain out.state.heap a ∧ Image out.state.heap a 1536 := by
  rw [source_complete] at source
  obtain ⟨s1,d1,rest1⟩ := seq_inv _ declareDimensions _ s out (by decide) source
  obtain ⟨s2,d2,arraysExec⟩ := seq_inv _ declareResidues arraysBody s1 out (by decide) rest1
  obtain ⟨_,heap1,locals1,keep1⟩ := KeygenPublicForwardControl.pure_result _ [] residueNames declareDimensions
    s ⟨s1,.normal⟩ (by decide) localRange d1
  obtain ⟨_,heap2,locals2,keep2⟩ := KeygenPublicForwardControl.pure_result _ [] residueNames declareResidues
    s1 ⟨s2,.normal⟩ (by decide) locals1 d2
  have arrays1 := (KeygenPublicTableControl.frame _ [] declareDimensions s ⟨s1,.normal⟩ (by decide) d1).2.1
  have arrays2 := (KeygenPublicTableControl.frame _ [] declareResidues s1 ⟨s2,.normal⟩ (by decide) d2).2.1
  have beforeHeap : s2.heap=s.heap := heap2.trans heap1
  have beforeProfile : Slot s2 "logn" 10 := by
    change s2.locals "logn".toList=some (.uint32,some (.uint32 10))
    rw [keep2 _ (by decide),keep1 _ (by decide)]
    exact profile
  have beforeInput : s2.arrays "a".toList=some a := by rw [arrays2,arrays1]; exact input
  have beforeRange : Domain s2.heap a := by rw [beforeHeap]; exact range
  have beforeInitialized : Initialized s2.heap a 1536 := by rw [beforeHeap]; exact initialized
  have live := KeygenPublicForwardMemory.initialized_live s2.heap a beforeInitialized
  cases arraysExec with
  | arrayScope _ _ _ _ innerG gBlock positiveG sizeG freshG executedG =>
      have gOutside : a.block≠gBlock := by intro equal; rw [equal,freshG.1] at live; omega
      have blockG := KeygenPublicForwardMemory.allocated_other s2.heap gBlock 2048 a.block gOutside
      cases executedG with
      | arrayScope _ _ _ _ innerI iBlock positiveI sizeI freshI executedI =>
          have different : gBlock≠iBlock := by
            intro equal
            have zero := freshI.1
            rw [← equal] at zero
            change (if gBlock=gBlock then 4096 else s2.heap.size gBlock)=0 at zero
            simp only [ite_true] at zero
            omega
          have iOutside : a.block≠iBlock := by
            intro equal
            have zero := freshI.1
            rw [← equal] at zero
            have currentLive : 0<(localEntry s2 "gm".toList gBlock 2048).heap.size a.block := by
              change 0<(KeygenPublicExec.allocated s2.heap gBlock 2048).size a.block
              rw [blockG.1]; exact live
            rw [zero] at currentLive
            omega
          have blockI := KeygenPublicForwardMemory.allocated_other
            (localEntry s2 "gm".toList gBlock 2048).heap iBlock 2048 a.block iOutside
          have blockBoth := KeygenPublicForwardMemory.block_trans _ _ _ a.block blockG blockI
          have inputReady : (localEntry (localEntry s2 "gm".toList gBlock 2048) "igm".toList iBlock 2048).arrays "a".toList=some a := by
            simpa only [localEntry,C99ArrayReference.bindPointer,show "a".toList≠"igm".toList from by decide,
              show "a".toList≠"gm".toList from by decide,ite_false] using beforeInput
          have pointersReady : Pointers (localEntry (localEntry s2 "gm".toList gBlock 2048) "igm".toList iBlock 2048)
              (localPointer gBlock 2048) (localPointer iBlock 2048) := by
            exact ⟨rfl,rfl⟩
          have empty : ∀ offset, (localEntry (localEntry s2 "gm".toList gBlock 2048) "igm".toList iBlock 2048).heap.bytes gBlock offset=none := by
            intro offset
            simp only [localEntry,C99ArrayReference.bindPointer,KeygenPublicExec.allocated,different,ite_false,ite_true]
          obtain ⟨flow,outputRange,outputInitialized⟩ := ready_result
            (localEntry (localEntry s2 "gm".toList gBlock 2048) "igm".toList iBlock 2048) innerI a gBlock iBlock beforeProfile
            inputReady pointersReady different gOutside iOutside empty locals2
            (KeygenPublicForwardMemory.domain_block s2.heap _ a blockBoth beforeRange)
            (KeygenPublicForwardMemory.initialized_block s2.heap _ a 1536 blockBoth beforeInitialized) executedI
          have leaveI := KeygenPublicForwardMemory.disposed_other
            (localEntry s2 "gm".toList gBlock 2048).heap innerI.state.heap iBlock a.block iOutside
          have leaveG := KeygenPublicForwardMemory.disposed_other s2.heap
            (localExit (localEntry s2 "gm".toList gBlock 2048) innerI.state "igm".toList iBlock).heap gBlock a.block gOutside
          have leaves := KeygenPublicForwardMemory.block_trans _ _ _ a.block leaveI leaveG
          have finalRange := KeygenPublicForwardMemory.domain_block innerI.state.heap _ a leaves outputRange
          have finalInitialized := KeygenPublicForwardMemory.initialized_block innerI.state.heap _ a 1536 leaves outputInitialized
          exact ⟨flow,finalRange,KeygenPublicRangeMemory.image _ a 1536 finalRange finalInitialized⟩

end FT1536.Source3.KeygenPublicForwardRange
