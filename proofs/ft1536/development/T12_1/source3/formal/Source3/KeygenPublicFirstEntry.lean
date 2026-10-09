import Source3.KeygenPublicFirstTables

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Derive the first-loop domains from the actual dimension assignments,
   generator dispatch, seed load and counter initialization. -/
namespace FT1536.Source3.KeygenPublicFirstEntry
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec Stmt localPointer)
open KeygenPublicWord (Eval)
open KeygenPublicTableAtoms (Slot var literal)
open KeygenPublicForwardProgram
open KeygenPublicForwardControl (seq_inv)
open KeygenPublicFirstTables (Table cells_block)
open KeygenPublicInputCells (Cells)
open KeygenPublicInputMaterial (reduced)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicFirstValues (seed pass firstLoop remaining)

structure Types (s : State) : Prop where
  n : ∃ old, s.locals "n".toList=some (.uint64,old)
  hn : ∃ old, s.locals "hn".toList=some (.uint64,old)
  u : ∃ old, s.locals "u".toList=some (.uint64,old)
  r : ∃ old, s.locals "r".toList=some (.uint32,old)

def initU : Stmt := .assign "u".toList (literal 0)

theorem n_value (s : State) (v : Value) (profile : Slot s "logn" 10)
    (source : Eval [] s (.bin .shl (.cast .uint64 (literal 3)) (.bin .sub (var "logn") (literal 1))) v) :
    v=u64 1536 := by
  cases source with
  | bin _ _ _ a b _ left right op =>
      have ae : a=u64 3 := by
        cases left with
        | cast _ _ value evaluated =>
            rw [KeygenPublicTableAtoms.literal_value [] s 3 value evaluated]; rfl
      have be := KeygenPublicLastEntry.logn_minus_one s b profile right
      subst a; subst b
      obtain ⟨k,hk,_,equal⟩ := KeygenNttForwardExec.shift_left_value _ _ v op
      have nine : k=9 := by change (9 : Int)=(k : Int) at hk; omega
      subst k
      exact equal

theorem hn_value (s : State) (v : Value) (n : USlot s "n" 1536)
    (source : Eval [] s (.bin .shr (var "n") (literal 1)) v) : v=u64 768 := by
  cases source with
  | bin _ _ _ a b _ left right op =>
      have ae := KeygenPublicInputAtoms.word64 [] s "n" 1536 a n left
      have be := KeygenPublicTableAtoms.literal_value [] s 1 b right
      subst a; subst b
      exact KeygenNttLoopSupport.shr_one_u64 1536 (by decide) v op

theorem table_load (s : State) (name : String) (gm : ArrayPointer)
    (binding : s.arrays name.toList=some gm) (table : Table s.heap gm) :
    KeygenPublicValueExpr.Evaluates s (.load16 name.toList (.literal .i32 1))
      (KeygenPublicAlgebra.radix*KeygenPublicFirstFold.root) := by
  intro v source
  cases source with
  | load16 _ _ actual w address read =>
      have index : ∀ z, KeygenPublicWord.scalar s (.literal .i32 1) z → z.integer.toNat=1 := by
        intro z hz; cases hz; rfl
      rw [KeygenPublicTableIndex.address s name (.literal .i32 1) gm actual 1 binding index address] at read
      obtain ⟨old,loaded,range,eq⟩ := KeygenPublicFirstTables.first_cell s.heap gm table
      have we := C99NarrowReads.load16_deterministic _ _ _ _ read loaded
      subst w
      refine ⟨?_,?_⟩
      · change KeygenPublicRangeExpr.Ranged (C99NarrowReads.unsignedPromotion old)
        unfold KeygenPublicRangeExpr.Ranged
        rw [C99NarrowReads.unsigned_promotion_exact]
        exact ⟨Int.natCast_nonneg _,by exact_mod_cast range⟩
      · change ((C99NarrowReads.unsignedPromotion old).integer : KeygenPublicAlgebra.R)=_
        rw [C99NarrowReads.unsigned_promotion_exact,Int.cast_natCast]; exact eq

/- Both interior states are selected from this SAME source derivation. -/
def FirstRun (original : Geometry.Vec) (a : ArrayPointer) (out : Result) : Prop :=
  ∃ entry after,
    KeygenPublicFirstFold.Inv original a 0 entry ∧
    Exec KeygenPublicSource.program [] firstLoop entry ⟨after,.normal⟩ ∧
    KeygenPublicFirstFold.Inv original a 768 after ∧
    Exec KeygenPublicSource.program [] remaining after out

theorem tail_first (original : Geometry.Vec) (a gm : ArrayPointer) (s : State) (out : Result)
    (width : a.elementBytes=2) (pointer : s.arrays "a".toList=some a)
    (hn : USlot s "hn" 768) (rType : ∃ old, s.locals "r".toList=some (.uint32,old))
    (uType : ∃ old, s.locals "u".toList=some (.uint64,old))
    (square : s.arrays "gm_square".toList=some gm) (table : Table s.heap gm)
    (input : Cells s.heap a 1536 (reduced original))
    (source : Exec KeygenPublicSource.program [] tail s out) : FirstRun original a out := by
  rw [KeygenPublicFirstValues.source_first_pass] at source
  obtain ⟨s1,seedExec,rest⟩ := seq_inv _ seed _ s out (by decide) source
  obtain ⟨after,passExec,suffixExec⟩ := seq_inv _ pass remaining s1 out (by decide) rest
  obtain ⟨entry,initExec,loopExec⟩ := seq_inv _ initU firstLoop s1 ⟨after,.normal⟩ (by decide) passExec
  have r := KeygenPublicValueExpr.assign_value s ⟨s1,.normal⟩ "r" _ _ rType
    (table_load s "gm_square" gm square table) seedExec
  have frame1 := KeygenPublicTableControl.frame _ [] seed s ⟨s1,.normal⟩ (by decide) seedExec
  have uType1 : ∃ old, s1.locals "u".toList=some (.uint64,old) := by
    rw [frame1.2.2 _ (by decide)]; exact uType
  have equal := congrArg Result.state (KeygenPublicLastEntry.assign64_result s1 ⟨entry,.normal⟩ "u" _
    (C99IntegerReference.convert .int32 0) uType1
    (fun v hv => KeygenPublicTableAtoms.literal_value [] s1 0 v hv) initExec)
  dsimp only at equal
  have frame2 := KeygenPublicTableControl.frame _ [] initU s1 ⟨entry,.normal⟩ (by decide) initExec
  have heap1 := KeygenPublicTableControl.assign_heap _ _ _ _ seedExec
  have heap2 := KeygenPublicTableControl.assign_heap _ _ _ _ initExec
  have inv : KeygenPublicFirstFold.Inv original a 0 entry := by
    refine ⟨⟨by decide,?_,?_,width,?_,?_⟩,?_⟩
    · rw [frame2.2.1,frame1.2.1]; exact pointer
    · exact (frame2.2.2 _ (by decide)).trans ((frame1.2.2 _ (by decide)).trans hn)
    · exact KeygenPublicValueExpr.local_after initU s1 ⟨entry,.normal⟩ "r" _ (by decide) (by decide) r initExec
    · intro j hj; rw [heap2,heap1,KeygenPublicFirstFold.image_zero]; exact input j hj
    · rw [equal]; rfl
  have folded := KeygenPublicFirstFold.loop_result original a firstLoop entry ⟨after,.normal⟩ loopExec rfl 0 inv
  exact ⟨entry,after,inv,loopExec,folded.2,suffixExec⟩

theorem ready_first (original : Geometry.Vec) (s : State) (out : Result) (a : ArrayPointer) (gBlock iBlock : Nat)
    (width : a.elementBytes=2) (profile : Slot s "logn" 10) (input : s.arrays "a".toList=some a)
    (types : Types s)
    (pointers : KeygenPublicTableStore.Pointers s (localPointer gBlock 2048) (localPointer iBlock 2048))
    (different : gBlock≠iBlock) (gOutside : a.block≠gBlock) (iOutside : a.block≠iBlock)
    (cells : Cells s.heap a 1536 (reduced original))
    (source : Exec KeygenPublicSource.program [] readyBody s out) : FirstRun original a out := by
  obtain ⟨s1,d,rest1⟩ := seq_inv _ declarePointers _ s out (by decide) source
  have state1 := congrArg Result.state (KeygenPublicForwardRange.pointer_declarations s ⟨s1,.normal⟩ d)
  dsimp only at state1
  obtain ⟨s2,nExec,rest2⟩ := seq_inv _ nSet _ s1 out (by decide) rest1
  obtain ⟨s3,hnExec,rest3⟩ := seq_inv _ hnSet _ s2 out (by decide) rest2
  obtain ⟨s4,dispatchExec,tailExec⟩ := seq_inv _ dispatch tail s3 out (by decide) rest3
  have state2 := congrArg Result.state (KeygenPublicLastEntry.assign64_result s1 ⟨s2,.normal⟩ "n" _ (u64 1536)
    (by rw [state1]; exact types.n) (fun v hv => n_value s1 v (by rw [state1]; exact profile) hv) nExec)
  dsimp only at state2
  have n2 : USlot s2 "n" 1536 := by rw [state2]; rfl
  have frame2 := KeygenPublicTableControl.frame _ [] nSet s1 ⟨s2,.normal⟩ (by decide) nExec
  have frame3 := KeygenPublicTableControl.frame _ [] hnSet s2 ⟨s3,.normal⟩ (by decide) hnExec
  have state3 := congrArg Result.state (KeygenPublicLastEntry.assign64_result s2 ⟨s3,.normal⟩ "hn" _ (u64 768)
    (by rw [frame2.2.2 _ (by decide),state1]; exact types.hn) (fun v hv => hn_value s2 v n2 hv) hnExec)
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
  obtain ⟨_,locals4,input4,square4,_,table,frame⟩ := KeygenPublicFirstTables.dynamic_values s3 ⟨s4,.normal⟩ a gBlock iBlock
    logn3 input3 pointers3 different (KeygenPublicForwardRange.dispatch_dynamic s3 ⟨s4,.normal⟩ logn3 dispatchExec)
  have block := KeygenPublicForwardMemory.upper_other s3.heap s4.heap _ _ a.block gOutside iOutside frame
  rw [heap] at block
  apply tail_first original a (localPointer gBlock 2048) s4 out width input4
    (by unfold USlot; rw [locals4]; exact hn3) ?_ ?_ square4 table (cells_block _ _ a _ _ block cells) tailExec
  · rw [locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.r
  · rw [locals4,frame3.2.2 _ (by decide),frame2.2.2 _ (by decide),state1]; exact types.u

end FT1536.Source3.KeygenPublicFirstEntry
