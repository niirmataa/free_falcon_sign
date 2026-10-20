import Source3.KeygenPublicInverseFold

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Derive n/hn, both generated aliases, the inverse-unity seed and counters
   from the SAME inverse prefix. The full remaining source suffix is retained. -/
namespace FT1536.Source3.KeygenPublicInverseEntry
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec Stmt localPointer)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicInputCells (Cells)
open KeygenPublicFirstTables (cells_block)
open KeygenPublicInverseTables (Table rootAt)
open KeygenPublicInverseFold (Inv unity)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicInverseProgram
open KeygenPublicForwardControl (seq_inv)

structure Types (s : State) : Prop where
  n : ∃ old, s.locals "n".toList=some (.uint64,old)
  hn : ∃ old, s.locals "hn".toList=some (.uint64,old)
  u : ∃ old, s.locals "u".toList=some (.uint64,old)
  v : ∃ old, s.locals "v".toList=some (.uint64,old)
  w : ∃ old, s.locals "w".toList=some (.uint32,old)
def pointerReady (s : State) : State := {s with arrays := fun n =>
  if n="igm_cubic".toList then none else if n="igm_square".toList then none else s.arrays n}
theorem pointer_declarations (s : State) (out : Result)
    (source : Exec KeygenPublicSource.program [] declarePointers s out) : out=⟨pointerReady s,.normal⟩ := by
  obtain ⟨s1,first,rest⟩ := seq_inv _ _ _ s out (by decide) source
  cases first
  obtain ⟨s2,second,last⟩ := seq_inv _ _ _ _ out (by decide) rest
  cases second
  cases last
  rfl
theorem dispatch_dynamic (s : State) (out : Result) (profile : Slot s "logn" 10)
    (source : Exec KeygenPublicSource.program [] dispatch s out) : Exec KeygenPublicSource.program [] dynamic s out := by
  cases source with
  | branchTrue _ _ _ _ _ v guard nonzero inner =>
      rw [KeygenPublicForwardRange.condition_value s v profile guard] at nonzero
      exact (nonzero rfl).elim
  | branchFalse _ _ _ _ _ v guard zero inner => exact inner
theorem seed_root : rootAt 1^2=unity := by
  simp only [rootAt,KeygenPublicUpperFinish.te_one,unity,KeygenPublicRoots.unity,
    KeygenPublicRoots.firstRoot,inv_pow]

def Run (a : Nat → KeygenPublicAlgebra.R) (p : ArrayPointer) (out : Result) : Prop :=
  ∃ igm entry after,
    Inv a p igm 0 entry ∧
    USlot entry "hn" 768 ∧ Slot entry "logn" 10 ∧
    entry.arrays "igm_square".toList=some igm ∧
    Exec KeygenPublicSource.program [] loop entry ⟨after,.normal⟩ ∧
    Inv a p igm 512 after ∧
    USlot after "hn" 768 ∧ Slot after "logn" 10 ∧
    after.arrays "igm_square".toList=some igm ∧
    Exec KeygenPublicSource.program [] remaining after out

theorem tail_triples (a : Nat → KeygenPublicAlgebra.R) (p igm : ArrayPointer) (s : State) (out : Result)
    (width : p.elementBytes=2) (separate : p.block≠igm.block) (pointer : s.arrays "a".toList=some p)
    (profile : Slot s "logn" 10) (n : USlot s "n" 1536) (hn : USlot s "hn" 768)
    (wType : ∃ old, s.locals "w".toList=some (.uint32,old))
    (uType : ∃ old, s.locals "u".toList=some (.uint64,old))
    (vType : ∃ old, s.locals "v".toList=some (.uint64,old))
    (square : s.arrays "igm_square".toList=some igm) (cubic : s.arrays "igm_cubic".toList=some igm)
    (table : Table s.heap igm) (input : Cells s.heap p 1536 a)
    (source : Exec KeygenPublicSource.program [] tail s out) : Run a p out := by
  rw [source_tail] at source
  obtain ⟨s1,seedExec,rest⟩ := seq_inv _ seed _ s out (by decide) source
  obtain ⟨after,passExec,suffix⟩ := seq_inv _ pass remaining s1 out (by decide) rest
  obtain ⟨entry,initExec,loopExec⟩ := seq_inv _ (.seq initU initV) loop s1 ⟨after,.normal⟩ (by decide) passExec
  obtain ⟨s2,uExec,vExec⟩ := seq_inv _ initU initV s1 ⟨entry,.normal⟩ (by decide) initExec
  have load : KeygenPublicValueExpr.Evaluates s (.load16 "igm_square".toList (.literal .i32 1))
      (KeygenPublicAlgebra.radix*rootAt 1) :=
    KeygenPublicValueFrames.load_value s "igm_square" igm (.literal .i32 1) 1 _ square
      (fun v ev => by rw [KeygenPublicTableIndex.literal s 1 v ev]; rfl) (table.2 1 (by decide) (by decide))
  have seeded := KeygenPublicValueExpr.assign_value s ⟨s1,.normal⟩ "w" _ _ wType
    (KeygenPublicValueExpr.twiddle_value s _ _ (KeygenPublicAlgebra.radix*rootAt 1) (rootAt 1) load load) seedExec
  have seedEq : (KeygenPublicAlgebra.radix*rootAt 1)*rootAt 1=KeygenPublicAlgebra.radix*unity := by
    rw [mul_assoc,← pow_two,seed_root]
  rw [seedEq] at seeded
  have f1 := KeygenPublicTableControl.frame _ [] seed s ⟨s1,.normal⟩ (by decide) seedExec
  have f2 := KeygenPublicTableControl.frame _ [] initU s1 ⟨s2,.normal⟩ (by decide) uExec
  have f3 := KeygenPublicTableControl.frame _ [] initV s2 ⟨entry,.normal⟩ (by decide) vExec
  have us := congrArg Result.state (KeygenPublicLastEntry.assign64_result s1 ⟨s2,.normal⟩ "u" _
    (C99IntegerReference.convert .int32 0) (by rw [f1.2.2 _ (by decide)]; exact uType)
    (fun v ev => KeygenPublicTableAtoms.literal_value [] s1 0 v ev) uExec)
  have vs := congrArg Result.state (KeygenPublicLastEntry.assign64_result s2 ⟨entry,.normal⟩ "v" _ (u64 512)
    (by rw [f2.2.2 _ (by decide),f1.2.2 _ (by decide)]; exact vType)
    (fun v ev => KeygenPublicLastEntry.b_value s2 v
      (by change s2.locals "logn".toList=some _; rw [f2.2.2 _ (by decide),f1.2.2 _ (by decide)]; exact profile) ev) vExec)
  dsimp only at us vs
  have heap : entry.heap=s.heap := by
    rw [KeygenPublicTableControl.assign_heap _ _ _ _ vExec,KeygenPublicTableControl.assign_heap _ _ _ _ uExec,
      KeygenPublicTableControl.assign_heap _ _ _ _ seedExec]
  have initial : Inv a p igm 0 entry := by
    refine ⟨⟨width,separate,?_,?_,?_,?_,?_⟩,by decide,?_,?_,?_⟩
    · rw [f3.2.1,f2.2.1,f1.2.1]; exact pointer
    · rw [f3.2.1,f2.2.1,f1.2.1]; exact cubic
    · rw [heap]; exact table
    · exact (f3.2.2 _ (by decide)).trans ((f2.2.2 _ (by decide)).trans ((f1.2.2 _ (by decide)).trans n))
    · exact KeygenPublicValueExpr.local_after initV s2 ⟨entry,.normal⟩ "w" _ (by decide) (by decide)
        (KeygenPublicValueExpr.local_after initU s1 ⟨s2,.normal⟩ "w" _ (by decide) (by decide) seeded uExec) vExec
    · change entry.locals "u".toList=some _
      rw [f3.2.2 _ (by decide),us]; rfl
    · rw [vs]; rfl
    · intro i hi
      simp only [KeygenPublicInverseFold.image,Nat.mul_zero,Nat.not_lt_zero,ite_false]
      rw [heap]; exact input i hi
  have result := KeygenPublicInverseFold.loop_result a p igm loop entry ⟨after,.normal⟩ loopExec rfl 0 initial
  have loopFrame := KeygenPublicTableControl.frame _ [] loop entry ⟨after,.normal⟩ (by decide) loopExec
  have hne : USlot entry "hn" 768 :=
    (f3.2.2 _ (by decide)).trans ((f2.2.2 _ (by decide)).trans ((f1.2.2 _ (by decide)).trans hn))
  have le : Slot entry "logn" 10 :=
    (f3.2.2 _ (by decide)).trans ((f2.2.2 _ (by decide)).trans ((f1.2.2 _ (by decide)).trans profile))
  have se : entry.arrays "igm_square".toList=some igm := by rw [f3.2.1,f2.2.1,f1.2.1]; exact square
  exact ⟨igm,entry,after,initial,hne,le,se,loopExec,result.2,
    (loopFrame.2.2 _ (by decide)).trans hne,(loopFrame.2.2 _ (by decide)).trans le,
    by rw [loopFrame.2.1]; exact se,suffix⟩

theorem ready_triples (a : Nat → KeygenPublicAlgebra.R) (s : State) (out : Result) (p : ArrayPointer) (gBlock iBlock : Nat)
    (width : p.elementBytes=2) (profile : Slot s "logn" 10) (input : s.arrays "a".toList=some p)
    (types : Types s)
    (pointers : KeygenPublicTableStore.Pointers s (localPointer gBlock 2048) (localPointer iBlock 2048))
    (different : gBlock≠iBlock) (gOutside : p.block≠gBlock) (iOutside : p.block≠iBlock)
    (cells : Cells s.heap p 1536 a)
    (source : Exec KeygenPublicSource.program [] readyBody s out) : Run a p out := by
  obtain ⟨s1,d,rest1⟩ := seq_inv _ declarePointers _ s out (by decide) source
  have state1 := congrArg Result.state (pointer_declarations s ⟨s1,.normal⟩ d)
  dsimp only at state1
  obtain ⟨s2,nExec,rest2⟩ := seq_inv _ KeygenPublicForwardProgram.nSet _ s1 out (by decide) rest1
  obtain ⟨s3,hnExec,rest3⟩ := seq_inv _ KeygenPublicForwardProgram.hnSet _ s2 out (by decide) rest2
  obtain ⟨s4,dispatchExec,tailExec⟩ := seq_inv _ dispatch tail s3 out (by decide) rest3
  have state2 := congrArg Result.state (KeygenPublicLastEntry.assign64_result s1 ⟨s2,.normal⟩ "n" _ (u64 1536)
    (by rw [state1]; exact types.n) (fun v hv => KeygenPublicFirstEntry.n_value s1 v (by rw [state1]; exact profile) hv) nExec)
  dsimp only at state2
  have n2 : USlot s2 "n" 1536 := by rw [state2]; rfl
  have frame2 := KeygenPublicTableControl.frame _ [] KeygenPublicForwardProgram.nSet s1 ⟨s2,.normal⟩ (by decide) nExec
  have frame3 := KeygenPublicTableControl.frame _ [] KeygenPublicForwardProgram.hnSet s2 ⟨s3,.normal⟩ (by decide) hnExec
  have state3 := congrArg Result.state (KeygenPublicLastEntry.assign64_result s2 ⟨s3,.normal⟩ "hn" _ (u64 768)
    (by rw [frame2.2.2 _ (by decide),state1]; exact types.hn) (fun v hv => KeygenPublicFirstEntry.hn_value s2 v n2 hv) hnExec)
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
  obtain ⟨_,locals4,input4,square4,cubic4,table,frame⟩ := KeygenPublicInverseTables.dynamic_values s3 ⟨s4,.normal⟩ p gBlock iBlock
    logn3 input3 pointers3 different (dispatch_dynamic s3 ⟨s4,.normal⟩ logn3 dispatchExec)
  have block := KeygenPublicForwardMemory.upper_other s3.heap s4.heap _ _ p.block gOutside iOutside frame
  rw [heap] at block
  apply tail_triples a p (localPointer iBlock 2048) s4 out width iOutside input4
    (by unfold Slot; rw [locals4]; exact logn3)
    (by unfold USlot; rw [locals4]; exact (frame3.2.2 _ (by decide)).trans n2)
    (by unfold USlot; rw [locals4]; exact hn3) ?_ ?_ ?_ square4 cubic4 table (cells_block _ _ p _ _ block cells) tailExec
  · rw [locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.w
  · rw [locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.u
  · rw [locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.v

end FT1536.Source3.KeygenPublicInverseEntry
