import Source3.KeygenPublicRadixStages

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Carry actual generated table/header facts through the first fold and
   all radix stages to the SAME remaining triple execution. -/
namespace FT1536.Source3.KeygenPublicRadixEntry
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt localPointer)
open KeygenNttLoopSupport (USlot)
open KeygenPublicSizeOps (Declared)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicFirstTables (Table cells_block)
open KeygenPublicInputCells (Cells)
open KeygenPublicInputMaterial (reduced)
open KeygenPublicTableControl (frame)
open KeygenPublicForwardControl (seq_inv)
open KeygenPublicForwardProgram
open KeygenPublicFirstValues (seed pass firstLoop remaining)

structure Header (a gm : ArrayPointer) (s : State) : Prop where
  fixed : KeygenPublicRadixStages.Fixed a gm s
  cubic : s.arrays "gm_cubic".toList=some gm
  profile : Slot s "logn" 10
  n : USlot s "n" 1536
  hn : USlot s "hn" 768
  wType : ∃ old, s.locals "w".toList=some (.uint32,old)
def headerNames : List Name := ["logn".toList,"n".toList,"hn".toList,"w".toList]
theorem header_after (code : Stmt) (s : State) (out : Result) (a gm : ArrayPointer)
    (ok : KeygenPublicTableControl.supported code=true) (only : KeygenPublicValueFrames.onlyA code=true)
    (keep : ∀ name∈headerNames, name∉KeygenPublicTableControl.writes code)
    (header : Header a gm s) (source : Exec KeygenPublicSource.program [] code s out) : Header a gm out.state := by
  have f := frame _ [] code s out ok source
  refine ⟨KeygenPublicRadixStages.fixed_after code s out a gm ok only header.fixed source,
    ?_,?_,?_,?_,?_⟩
  · rw [f.2.1]; exact header.cubic
  · exact (f.2.2 _ (keep _ (by simp [headerNames]))).trans header.profile
  · exact (f.2.2 _ (keep _ (by simp [headerNames]))).trans header.n
  · exact (f.2.2 _ (keep _ (by simp [headerNames]))).trans header.hn
  · rw [f.2.2 _ (keep _ (by simp [headerNames]))]; exact header.wType

noncomputable def radixImage (original : Geometry.Vec) : Nat → KeygenPublicAlgebra.R :=
  KeygenPublicRadixStages.image (KeygenPublicFirstFold.image original 768) 8
def ThroughRadix (original : Geometry.Vec) (a : ArrayPointer) (out : Result) : Prop :=
  ∃ gm after,
    Header a gm after ∧ USlot after "m" 512 ∧ USlot after "t" 3 ∧
    USlot after "u" 768 ∧ Declared after "v" ∧
    Cells after.heap a 1536 (radixImage original) ∧
    Exec KeygenPublicSource.program [] KeygenPublicRadixProgram.triple after out

theorem tail_stages (original : Geometry.Vec) (a gm : ArrayPointer) (s : State) (out : Result)
    (header : Header a gm s) (rType : ∃ old, s.locals "r".toList=some (.uint32,old))
    (uType : Declared s "u") (vType : Declared s "v") (tType : Declared s "t") (mType : Declared s "m")
    (input : Cells s.heap a 1536 (reduced original))
    (source : Exec KeygenPublicSource.program [] tail s out) : ThroughRadix original a out := by
  rw [KeygenPublicFirstValues.source_first_pass] at source
  obtain ⟨s1,seedExec,rest⟩ := seq_inv _ seed _ s out (by decide) source
  obtain ⟨after,passExec,suffixExec⟩ := seq_inv _ pass remaining s1 out (by decide) rest
  obtain ⟨entry,initExec,loopExec⟩ := seq_inv _ KeygenPublicFirstEntry.initU firstLoop s1 ⟨after,.normal⟩ (by decide) passExec
  have r := KeygenPublicValueExpr.assign_value s ⟨s1,.normal⟩ "r" _ _ rType
    (KeygenPublicFirstEntry.table_load s "gm_square" gm header.fixed.square header.fixed.table) seedExec
  have frame1 := frame _ [] seed s ⟨s1,.normal⟩ (by decide) seedExec
  have frame2 := frame _ [] KeygenPublicFirstEntry.initU s1 ⟨entry,.normal⟩ (by decide) initExec
  have uType1 : Declared s1 "u" := by rw [Declared,frame1.2.2 _ (by decide)]; exact uType
  obtain ⟨counter,heap2⟩ := KeygenPublicSizeOps.init s1 ⟨entry,.normal⟩ "u" 0 (by decide) uType1 initExec
  have heap1 := KeygenPublicTableControl.assign_heap _ _ _ _ seedExec
  have inv : KeygenPublicFirstFold.Inv original a 0 entry := by
    refine ⟨⟨by decide,?_,?_,header.fixed.width,?_,?_⟩,counter⟩
    · rw [frame2.2.1,frame1.2.1]; exact header.fixed.pointer
    · exact (frame2.2.2 _ (by decide)).trans ((frame1.2.2 _ (by decide)).trans header.hn)
    · exact KeygenPublicValueExpr.local_after KeygenPublicFirstEntry.initU s1 ⟨entry,.normal⟩ "r" _ (by decide) (by decide) r initExec
    · intro j hj; rw [heap2,heap1,KeygenPublicFirstFold.image_zero]; exact input j hj
  have folded := (KeygenPublicFirstFold.loop_result original a firstLoop entry ⟨after,.normal⟩ loopExec rfl 0 inv).2
  have firstExec : Exec KeygenPublicSource.program [] (.seq seed pass) s ⟨after,.normal⟩ := .seqNormal _ _ _ _ _ seedExec passExec
  have firstFrame := frame _ [] (.seq seed pass) s ⟨after,.normal⟩ (by decide) firstExec
  have firstHeader := header_after (.seq seed pass) s ⟨after,.normal⟩ a gm (by decide) (by decide) (by decide) header firstExec
  rw [KeygenPublicRadixProgram.source_remaining] at suffixExec
  obtain ⟨start,initSize,restStages⟩ := seq_inv _ KeygenPublicRadixProgram.start _ after out (by decide) suffixExec
  obtain ⟨final,stagesExec,tripleExec⟩ := seq_inv _ KeygenPublicRadixProgram.stages _ start out (by decide) restStages
  have tType1 : Declared after "t" := by rw [Declared,firstFrame.2.2 _ (by decide)]; exact tType
  have size := (KeygenPublicSizeOps.assign after ⟨start,.normal⟩ "t" _ 768 (by decide) tType1
    (KeygenPublicSizeOps.variable_slot after "hn" 768 firstHeader.hn) initSize).2
  have startFrame := frame _ [] KeygenPublicRadixProgram.start after ⟨start,.normal⟩ (by decide) initSize
  have startHeader := header_after KeygenPublicRadixProgram.start after ⟨start,.normal⟩ a gm
    (by decide) (by decide) (by decide) firstHeader initSize
  have mType1 : Declared start "m" := by rw [Declared,startFrame.2.2 _ (by decide),firstFrame.2.2 _ (by decide)]; exact mType
  have vType1 : Declared start "v" := by rw [Declared,startFrame.2.2 _ (by decide),firstFrame.2.2 _ (by decide)]; exact vType
  have input1 : Cells start.heap a 1536 (KeygenPublicFirstFold.image original 768) := by
    rw [KeygenPublicTableControl.assign_heap _ _ _ _ initSize]; exact folded.cells
  have stages := (KeygenPublicRadixStages.source_stages (KeygenPublicFirstFold.image original 768) a gm start ⟨final,.normal⟩
    startHeader.fixed size mType1 vType1 input1 stagesExec).2
  have finalHeader := header_after KeygenPublicRadixProgram.stages start ⟨final,.normal⟩ a gm
    (by decide) (by decide) (by decide) startHeader stagesExec
  have u : USlot final "u" 768 :=
    (frame _ [] KeygenPublicRadixProgram.stages _ _ (by decide) stagesExec).2.2 _ (by decide) |>.trans
      ((startFrame.2.2 _ (by decide)).trans folded.counter)
  exact ⟨gm,final,finalHeader,stages.counter,stages.currentSize,u,stages.vType,stages.cells,tripleExec⟩

structure Types (s : State) : Prop where
  first : KeygenPublicFirstEntry.Types s
  v : Declared s "v"
  t : Declared s "t"
  m : Declared s "m"
  w : ∃ old, s.locals "w".toList=some (.uint32,old)

theorem ready_stages (original : Geometry.Vec) (s : State) (out : Result) (a : ArrayPointer) (gBlock iBlock : Nat)
    (width : a.elementBytes=2) (profile : Slot s "logn" 10) (input : s.arrays "a".toList=some a)
    (types : Types s)
    (pointers : KeygenPublicTableStore.Pointers s (localPointer gBlock 2048) (localPointer iBlock 2048))
    (different : gBlock≠iBlock) (gOutside : a.block≠gBlock) (iOutside : a.block≠iBlock)
    (cells : Cells s.heap a 1536 (reduced original))
    (source : Exec KeygenPublicSource.program [] readyBody s out) : ThroughRadix original a out := by
  obtain ⟨s1,d,rest1⟩ := seq_inv _ declarePointers _ s out (by decide) source
  have state1 := congrArg Result.state (KeygenPublicForwardRange.pointer_declarations s ⟨s1,.normal⟩ d)
  dsimp only at state1
  obtain ⟨s2,nExec,rest2⟩ := seq_inv _ nSet _ s1 out (by decide) rest1
  obtain ⟨s3,hnExec,rest3⟩ := seq_inv _ hnSet _ s2 out (by decide) rest2
  obtain ⟨s4,dispatchExec,tailExec⟩ := seq_inv _ dispatch tail s3 out (by decide) rest3
  have state2 := congrArg Result.state (KeygenPublicLastEntry.assign64_result s1 ⟨s2,.normal⟩ "n" _ (KeygenNttLoopSupport.u64 1536)
    (by rw [state1]; exact types.first.n) (fun v hv => KeygenPublicFirstEntry.n_value s1 v (by rw [state1]; exact profile) hv) nExec)
  dsimp only at state2
  have n2 : USlot s2 "n" 1536 := by rw [state2]; rfl
  have frame2 := frame _ [] nSet s1 ⟨s2,.normal⟩ (by decide) nExec
  have frame3 := frame _ [] hnSet s2 ⟨s3,.normal⟩ (by decide) hnExec
  have state3 := congrArg Result.state (KeygenPublicLastEntry.assign64_result s2 ⟨s3,.normal⟩ "hn" _ (KeygenNttLoopSupport.u64 768)
    (by rw [frame2.2.2 _ (by decide),state1]; exact types.first.hn)
    (fun v hv => KeygenPublicFirstEntry.hn_value s2 v n2 hv) hnExec)
  dsimp only at state3
  have hn3 : USlot s3 "hn" 768 := by rw [state3]; rfl
  have heap : s3.heap=s.heap := by rw [state3,state2,state1]; rfl
  have logn3 : Slot s3 "logn" 10 := by
    change s3.locals "logn".toList=some _
    rw [frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact profile
  have input3 : s3.arrays "a".toList=some a := by rw [frame3.2.1,frame2.2.1,state1]; exact input
  have pointers3 : KeygenPublicTableStore.Pointers s3 (localPointer gBlock 2048) (localPointer iBlock 2048) := by
    change s3.arrays "gm".toList=some _ ∧ s3.arrays "igm".toList=some _
    rw [frame3.2.1,frame2.2.1,state1]; exact pointers
  obtain ⟨_,locals4,input4,square4,cubic4,table,frame4⟩ := KeygenPublicFirstTables.dynamic_values s3 ⟨s4,.normal⟩ a gBlock iBlock
    logn3 input3 pointers3 different (KeygenPublicForwardRange.dispatch_dynamic s3 ⟨s4,.normal⟩ logn3 dispatchExec)
  have block := KeygenPublicForwardMemory.upper_other s3.heap s4.heap _ _ a.block gOutside iOutside frame4
  rw [heap] at block
  have header : Header a (localPointer gBlock 2048) s4 := by
    refine ⟨⟨width,gOutside,input4,square4,table⟩,cubic4,?_,?_,?_,?_⟩
    · unfold Slot; rw [locals4]; exact logn3
    · unfold USlot; rw [locals4]; exact (frame3.2.2 _ (by decide)).trans n2
    · unfold USlot; rw [locals4]; exact hn3
    · rw [locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.w
  apply tail_stages original a (localPointer gBlock 2048) s4 out header
    ?_ ?_ ?_ ?_ ?_ (cells_block _ _ a _ _ block cells) tailExec
  · rw [locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.first.r
  · rw [Declared,locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.first.u
  · rw [Declared,locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.v
  · rw [Declared,locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.t
  · rw [Declared,locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.m

end FT1536.Source3.KeygenPublicRadixEntry
