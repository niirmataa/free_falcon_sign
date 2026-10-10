import Source3.KeygenPublicReverseStages

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The SAME generated-table/triple prefix supplies reverse t/m and every
   caller domain. First-root/normalization execution remains tied to it. -/
namespace FT1536.Source3.KeygenPublicReverseEntry
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt localPointer)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicSizeOps (Declared)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicFirstTables (cells_block)
open KeygenPublicInputCells (Cells)
open KeygenPublicInverseTables (Table rootAt)
open KeygenPublicTableControl (frame)
open KeygenPublicForwardControl (seq_inv)
open KeygenPublicInverseProgram

structure Header (p igm : ArrayPointer) (s : State) : Prop where
  fixed : KeygenPublicReverseStages.Fixed p igm s
  cubic : s.arrays "igm_cubic".toList=some igm
  profile : Slot s "logn" 10
  hn : USlot s "hn" 768
  rType : ∃ old, s.locals "r".toList=some (.uint32,old)
  niType : ∃ old, s.locals "ni".toList=some (.uint32,old)
def headerNames : List Name := ["logn".toList,"hn".toList,"r".toList,"ni".toList]
theorem header_after (code : Stmt) (s : State) (out : Result) (p igm : ArrayPointer)
    (ok : KeygenPublicTableControl.supported code=true) (only : KeygenPublicValueFrames.onlyA code=true)
    (keepN : "n".toList∉KeygenPublicTableControl.writes code)
    (keep : ∀ name∈headerNames, name∉KeygenPublicTableControl.writes code)
    (header : Header p igm s) (source : Exec KeygenPublicSource.program [] code s out) : Header p igm out.state := by
  have f := frame _ [] code s out ok source
  refine ⟨KeygenPublicReverseStages.fixed_after code s out p igm ok only keepN header.fixed source,?_,?_,?_,?_,?_⟩
  · rw [f.2.1]; exact header.cubic
  · exact (f.2.2 _ (keep _ (by simp [headerNames]))).trans header.profile
  · exact (f.2.2 _ (keep _ (by simp [headerNames]))).trans header.hn
  · rw [f.2.2 _ (keep _ (by simp [headerNames]))]; exact header.rType
  · rw [f.2.2 _ (keep _ (by simp [headerNames]))]; exact header.niType

def reverseImage (a : Nat → KeygenPublicAlgebra.R) : Nat → KeygenPublicAlgebra.R :=
  KeygenPublicReverseStages.image (KeygenPublicInverseFold.value a) 8
def ThroughReverse (a : Nat → KeygenPublicAlgebra.R) (p : ArrayPointer) (out : Result) : Prop :=
  ∃ igm after,
    Header p igm after ∧ USlot after "m" 1 ∧ USlot after "t" 1536 ∧
    USlot after "u" 1536 ∧ Declared after "v" ∧
    Cells after.heap p 1536 (reverseImage a) ∧
    Exec KeygenPublicSource.program [] KeygenPublicReverseProgram.remaining after out

theorem remaining_stages (a : Nat → KeygenPublicAlgebra.R) (p igm : ArrayPointer) (s : State) (out : Result)
    (header : Header p igm s) (u : USlot s "u" 1536) (vType : Declared s "v")
    (tType : Declared s "t") (mType : Declared s "m")
    (input : Cells s.heap p 1536 (KeygenPublicInverseFold.value a))
    (source : Exec KeygenPublicSource.program [] remaining s out) : ThroughReverse a p out := by
  rw [KeygenPublicReverseProgram.source_remaining] at source
  obtain ⟨start,initSize,rest⟩ := seq_inv _ KeygenPublicReverseProgram.start _ s out (by decide) source
  obtain ⟨after,stagesExec,suffix⟩ := seq_inv _ KeygenPublicReverseProgram.stages _ start out (by decide) rest
  have sizeState := congrArg Result.state (KeygenPublicLastEntry.assign64_result s ⟨start,.normal⟩ "t" _
    (C99IntegerReference.convert .int32 6) tType (fun v ev => KeygenPublicTableAtoms.literal_value [] s 6 v ev) initSize)
  dsimp only at sizeState
  have t : USlot start "t" 6 := by rw [sizeState]; rfl
  have firstFrame := frame _ [] KeygenPublicReverseProgram.start s ⟨start,.normal⟩ (by decide) initSize
  have startHeader := header_after KeygenPublicReverseProgram.start s ⟨start,.normal⟩ p igm
    (by decide) (by decide) (by decide) (by decide) header initSize
  have mt : Declared start "m" := by rw [Declared,firstFrame.2.2 _ (by decide)]; exact mType
  have vt : Declared start "v" := by rw [Declared,firstFrame.2.2 _ (by decide)]; exact vType
  have cells : Cells start.heap p 1536 (KeygenPublicInverseFold.value a) := by rw [sizeState]; exact input
  have stages := (KeygenPublicReverseStages.source_stages (KeygenPublicInverseFold.value a) p igm start ⟨after,.normal⟩
    startHeader.fixed startHeader.profile t mt vt cells stagesExec).2
  have afterHeader := header_after KeygenPublicReverseProgram.stages start ⟨after,.normal⟩ p igm
    (by decide) (by decide) (by decide) (by decide) startHeader stagesExec
  have lastU : USlot after "u" 1536 :=
    (frame _ [] KeygenPublicReverseProgram.stages _ _ (by decide) stagesExec).2.2 _ (by decide) |>.trans
      ((firstFrame.2.2 _ (by decide)).trans u)
  exact ⟨igm,after,afterHeader,stages.counter,stages.currentSize,lastU,stages.vType,stages.cells,suffix⟩

theorem tail_stages (a : Nat → KeygenPublicAlgebra.R) (p igm : ArrayPointer) (s : State) (out : Result)
    (header : Header p igm s) (wType : ∃ old, s.locals "w".toList=some (.uint32,old))
    (uType : Declared s "u") (vType : Declared s "v") (tType : Declared s "t") (mType : Declared s "m")
    (input : Cells s.heap p 1536 a)
    (source : Exec KeygenPublicSource.program [] tail s out) : ThroughReverse a p out := by
  rw [source_tail] at source
  obtain ⟨s1,seedExec,rest⟩ := seq_inv _ seed _ s out (by decide) source
  obtain ⟨after,passExec,suffix⟩ := seq_inv _ pass remaining s1 out (by decide) rest
  obtain ⟨entry,initExec,loopExec⟩ := seq_inv _ (.seq initU initV) loop s1 ⟨after,.normal⟩ (by decide) passExec
  obtain ⟨s2,uExec,vExec⟩ := seq_inv _ initU initV s1 ⟨entry,.normal⟩ (by decide) initExec
  have load : KeygenPublicValueExpr.Evaluates s (.load16 "igm_square".toList (.literal .i32 1))
      (KeygenPublicAlgebra.radix*rootAt 1) :=
    KeygenPublicValueFrames.load_value s "igm_square" igm (.literal .i32 1) 1 _ header.fixed.square
      (fun v ev => by rw [KeygenPublicTableIndex.literal s 1 v ev]; rfl) (header.fixed.table.2 1 (by decide) (by decide))
  have seeded := KeygenPublicValueExpr.assign_value s ⟨s1,.normal⟩ "w" _ _ wType
    (KeygenPublicValueExpr.twiddle_value s _ _ (KeygenPublicAlgebra.radix*rootAt 1) (rootAt 1) load load) seedExec
  have seedEq : (KeygenPublicAlgebra.radix*rootAt 1)*rootAt 1=KeygenPublicAlgebra.radix*KeygenPublicInverseFold.unity := by
    rw [mul_assoc,← pow_two,KeygenPublicInverseEntry.seed_root]
  rw [seedEq] at seeded
  have f1 := frame _ [] seed s ⟨s1,.normal⟩ (by decide) seedExec
  have f2 := frame _ [] initU s1 ⟨s2,.normal⟩ (by decide) uExec
  have f3 := frame _ [] initV s2 ⟨entry,.normal⟩ (by decide) vExec
  have us := congrArg Result.state (KeygenPublicLastEntry.assign64_result s1 ⟨s2,.normal⟩ "u" _
    (C99IntegerReference.convert .int32 0) (by rw [f1.2.2 _ (by decide)]; exact uType)
    (fun v ev => KeygenPublicTableAtoms.literal_value [] s1 0 v ev) uExec)
  have vs := congrArg Result.state (KeygenPublicLastEntry.assign64_result s2 ⟨entry,.normal⟩ "v" _ (u64 512)
    (by rw [f2.2.2 _ (by decide),f1.2.2 _ (by decide)]; exact vType)
    (fun v ev => KeygenPublicLastEntry.b_value s2 v
      (by change s2.locals "logn".toList=some _; rw [f2.2.2 _ (by decide),f1.2.2 _ (by decide)]; exact header.profile) ev) vExec)
  dsimp only at us vs
  have heap : entry.heap=s.heap := by
    rw [KeygenPublicTableControl.assign_heap _ _ _ _ vExec,KeygenPublicTableControl.assign_heap _ _ _ _ uExec,
      KeygenPublicTableControl.assign_heap _ _ _ _ seedExec]
  have initial : KeygenPublicInverseFold.Inv a p igm 0 entry := by
    refine ⟨⟨header.fixed.width,header.fixed.separate,?_,?_,?_,?_,?_⟩,by decide,?_,?_,?_⟩
    · rw [f3.2.1,f2.2.1,f1.2.1]; exact header.fixed.pointer
    · rw [f3.2.1,f2.2.1,f1.2.1]; exact header.cubic
    · rw [heap]; exact header.fixed.table
    · exact (f3.2.2 _ (by decide)).trans ((f2.2.2 _ (by decide)).trans ((f1.2.2 _ (by decide)).trans header.fixed.n))
    · exact KeygenPublicValueExpr.local_after initV s2 ⟨entry,.normal⟩ "w" _ (by decide) (by decide)
        (KeygenPublicValueExpr.local_after initU s1 ⟨s2,.normal⟩ "w" _ (by decide) (by decide) seeded uExec) vExec
    · change entry.locals "u".toList=some _
      rw [f3.2.2 _ (by decide),us]; rfl
    · rw [vs]; rfl
    · intro i hi
      simp only [KeygenPublicInverseFold.image,Nat.mul_zero,Nat.not_lt_zero,ite_false]
      rw [heap]; exact input i hi
  have triple := (KeygenPublicInverseFold.loop_result a p igm loop entry ⟨after,.normal⟩ loopExec rfl 0 initial).2
  have firstExec : Exec KeygenPublicSource.program [] (.seq seed pass) s ⟨after,.normal⟩ := .seqNormal _ _ _ _ _ seedExec passExec
  have firstFrame := frame _ [] (.seq seed pass) s ⟨after,.normal⟩ (by decide) firstExec
  have afterHeader := header_after (.seq seed pass) s ⟨after,.normal⟩ p igm
    (by decide) (by decide) (by decide) (by decide) header firstExec
  apply remaining_stages a p igm after out afterHeader triple.u ⟨_,triple.v⟩ ?_ ?_
    (KeygenPublicInverseFold.folded a p igm after triple) suffix
  · rw [Declared,firstFrame.2.2 _ (by decide)]; exact tType
  · rw [Declared,firstFrame.2.2 _ (by decide)]; exact mType

structure Types (s : State) : Prop where
  triple : KeygenPublicInverseEntry.Types s
  t : Declared s "t"
  m : Declared s "m"
  r : ∃ old, s.locals "r".toList=some (.uint32,old)
  ni : ∃ old, s.locals "ni".toList=some (.uint32,old)

theorem ready_stages (a : Nat → KeygenPublicAlgebra.R) (s : State) (out : Result) (p : ArrayPointer) (gBlock iBlock : Nat)
    (width : p.elementBytes=2) (profile : Slot s "logn" 10) (input : s.arrays "a".toList=some p)
    (types : Types s)
    (pointers : KeygenPublicTableStore.Pointers s (localPointer gBlock 2048) (localPointer iBlock 2048))
    (different : gBlock≠iBlock) (gOutside : p.block≠gBlock) (iOutside : p.block≠iBlock)
    (cells : Cells s.heap p 1536 a)
    (source : Exec KeygenPublicSource.program [] readyBody s out) : ThroughReverse a p out := by
  obtain ⟨s1,d,rest1⟩ := seq_inv _ declarePointers _ s out (by decide) source
  have state1 := congrArg Result.state (KeygenPublicInverseEntry.pointer_declarations s ⟨s1,.normal⟩ d)
  dsimp only at state1
  obtain ⟨s2,nExec,rest2⟩ := seq_inv _ KeygenPublicForwardProgram.nSet _ s1 out (by decide) rest1
  obtain ⟨s3,hnExec,rest3⟩ := seq_inv _ KeygenPublicForwardProgram.hnSet _ s2 out (by decide) rest2
  obtain ⟨s4,dispatchExec,tailExec⟩ := seq_inv _ dispatch tail s3 out (by decide) rest3
  have state2 := congrArg Result.state (KeygenPublicLastEntry.assign64_result s1 ⟨s2,.normal⟩ "n" _ (u64 1536)
    (by rw [state1]; exact types.triple.n) (fun v hv => KeygenPublicFirstEntry.n_value s1 v (by rw [state1]; exact profile) hv) nExec)
  dsimp only at state2
  have n2 : USlot s2 "n" 1536 := by rw [state2]; rfl
  have frame2 := frame _ [] KeygenPublicForwardProgram.nSet s1 ⟨s2,.normal⟩ (by decide) nExec
  have frame3 := frame _ [] KeygenPublicForwardProgram.hnSet s2 ⟨s3,.normal⟩ (by decide) hnExec
  have state3 := congrArg Result.state (KeygenPublicLastEntry.assign64_result s2 ⟨s3,.normal⟩ "hn" _ (u64 768)
    (by rw [frame2.2.2 _ (by decide),state1]; exact types.triple.hn) (fun v hv => KeygenPublicFirstEntry.hn_value s2 v n2 hv) hnExec)
  dsimp only at state3
  have hn3 : USlot s3 "hn" 768 := by rw [state3]; rfl
  have heap : s3.heap=s.heap := by rw [state3,state2,state1]; rfl
  have logn3 : Slot s3 "logn" 10 := by
    change s3.locals "logn".toList=some _
    rw [frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact profile
  have input3 : s3.arrays "a".toList=some p := by rw [frame3.2.1,frame2.2.1,state1]; exact input
  have pointers3 : KeygenPublicTableStore.Pointers s3 (localPointer gBlock 2048) (localPointer iBlock 2048) := by
    change s3.arrays "gm".toList=some _ ∧ s3.arrays "igm".toList=some _
    rw [frame3.2.1,frame2.2.1,state1]; exact pointers
  obtain ⟨_,locals4,input4,square4,cubic4,table,frame4⟩ := KeygenPublicInverseTables.dynamic_values s3 ⟨s4,.normal⟩ p gBlock iBlock
    logn3 input3 pointers3 different (KeygenPublicInverseEntry.dispatch_dynamic s3 ⟨s4,.normal⟩ logn3 dispatchExec)
  have block := KeygenPublicForwardMemory.upper_other s3.heap s4.heap _ _ p.block gOutside iOutside frame4
  rw [heap] at block
  have header : Header p (localPointer iBlock 2048) s4 := by
    refine ⟨⟨width,iOutside,input4,square4,table,?_⟩,cubic4,?_,?_,?_,?_⟩
    · unfold USlot; rw [locals4]; exact (frame3.2.2 _ (by decide)).trans n2
    · unfold Slot; rw [locals4]; exact logn3
    · unfold USlot; rw [locals4]; exact hn3
    · rw [locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.r
    · rw [locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.ni
  apply tail_stages a p (localPointer iBlock 2048) s4 out header
    ?_ ?_ ?_ ?_ ?_ (cells_block _ _ p _ _ block cells) tailExec
  · rw [locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.triple.w
  · rw [Declared,locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.triple.u
  · rw [Declared,locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.triple.v
  · rw [Declared,locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.t
  · rw [Declared,locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.m

end FT1536.Source3.KeygenPublicReverseEntry
