import Source3.KeygenDecodeStaticUnaryDecision

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticUnarySelect
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified KeygenDecodeStaticWire
open KeygenCodecStaticBitBuffer KeygenCodecStaticBits

def rhs : Expr := .binary .band (.binary .shr (.variable "db".toList) (.variable "db_len".toList)) (.number .i32 1)
def code : Stmt := .seq KeygenDecodeStaticBinding.node056
  (.seq KeygenDecodeStaticBinding.node057 (.seq KeygenDecodeStaticBinding.node062 .skip))
def setBit (s : State) (bit : Bool) : State :=
  withLocals s (localSet s.locals "bit".toList .uint32 (some (.uint32 (BitVec.ofNat 32 bit.toNat))))

theorem skip_tail (args : Args) (code : Stmt) (s t : State) (flow : Flow)
    (source : Checked args code s t flow) : Checked args (.seq code .skip) s t flow := by
  cases flow with
  | normal => exact seq args code .skip s t t .normal source (skip args t)
  | broken => exact seq_break args code .skip s t source
  | returned value => exact seq_return args code .skip s t value source

theorem select (args : Args) (src dst : ArrayPointer) (v p : Nat) (db : BitVec 32)
    (bytes : List (BitVec 8)) (s : State) (bit : Bool) (tail : List Bool)
    (positive : 1≤p) (small : p≤8) (wire : Wire args src dst v p db bytes s)
    (declaredBit : s.locals.scalars "bit".toList=some (.uint32,none))
    (bits : remaining p db bytes=bit::tail) :
    Checked args code s (setBit (KeygenDecodeStaticScalarTests.afterPop s p) bit) (KeygenDecodeStaticUnaryDecision.flow bit) ∧
      Wire args src dst v (p-1) db bytes (setBit (KeygenDecodeStaticScalarTests.afterPop s p) bit) ∧
      remaining (p-1) db bytes=tail ∧
      (setBit (KeygenDecodeStaticScalarTests.afterPop s p) bit).heap=s.heap := by
  let s1 := KeygenDecodeStaticScalarTests.afterPop s p
  let s2 := setBit s1 bit
  have pop : Checked args KeygenDecodeStaticBinding.node056 s s1 .normal :=
    KeygenDecodeStaticScalarTests.source_pop args s p positive wire.ready.pending
  have context1 := context_frame args src dst s s1 _ .normal pop.run (by unfold KeygenDecodeStaticReady.Checks; decide +kernel) wire.ready.context
  have cursor1 := (KeygenDecodeStaticCellFrame.exec_frame "v".toList args _ s s1 .normal pop.run (by decide +kernel)).trans wire.ready.cursor
  have db1 := (KeygenDecodeStaticCellFrame.exec_frame "db".toList args _ s s1 .normal pop.run (by decide +kernel)).trans wire.ready.accumulator
  have pending1 : Cell "db_len" .uint32 (.uint32 (BitVec.ofNat 32 (p-1))) s1.locals := by
    simp only [Cell,s1,KeygenDecodeStaticScalarTests.afterPop,withLocals,localSet,C99ScalarReference.set,ite_true]
  have bit1 := (KeygenDecodeStaticCellFrame.exec_frame "bit".toList args _ s s1 .normal pop.run (by decide +kernel)).trans declaredBit
  obtain ⟨rest,shape,size,lastBits⟩ := KeygenDecodeStaticPrefixBits.split p db bytes [bit] tail (by simpa only [List.length_cons,List.length_nil] using positive)
    (by simpa only [List.singleton_append] using bits)
  have size' : rest.length=p-1 := by simpa only [List.length_cons,List.length_nil] using size
  have shaped : buffer (rest.length+1) db=bit::rest := by
    rw [size',show p-1+1=p by omega]
    exact shape
  have actualBit := KeygenDecodeStaticPrefixValues.sign_bit rest bit db shaped
  rw [size'] at actualBit
  have calculation : KeygenDecodeCalculation.Computes args s1.heap s1.buf s1.locals rhs (.uint32 (BitVec.ofNat 32 bit.toNat)) := by
    have canonical : KeygenDecodeCalculation.Computes args s1.heap s1.buf s1.locals rhs (.uint32 ((db >>> (p-1)) &&& 1)) :=
      .binary _ _ _ _ _ _
        (.binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) db1)
          (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) pending1)
          (.shr _ _ _ (KeygenDecodeStaticWordOps.right_uint32 db (p-1) (by omega))))
        (.number _ _ _ (by decide +kernel))
        (.band _ _ _ (KeygenDecodeStaticWordOps.and_int32 _ 1 (by decide +kernel)))
    rw [actualBit] at canonical
    exact canonical
  have write : Checked args KeygenDecodeStaticBinding.node057 s1 s2 .normal := by
    have source := assign args s1 "bit".toList .uint32 none rhs _ s1.locals
      (by decide +kernel) (by decide +kernel) bit1 (.pure _ _ _ calculation)
    simpa only [KeygenDecodeWordOps.self32,KeygenDecodeStaticBinding.node057,rhs,setBit,s2] using source
  have ready1 : Ready args src dst v (p-1) db s1 := ⟨context1,cursor1,pending1,db1⟩
  have ready2 := KeygenDecodeStaticReaderFrame.ready_frame args src dst v (p-1) db s1 s2 _ .normal write.run
    (by unfold KeygenDecodeStaticReaderFrame.Checks KeygenDecodeStaticReady.Checks; decide +kernel) ready1
  have bit2 : Cell "bit" .uint32 (.uint32 (BitVec.ofNat 32 bit.toNat)) s2.locals := by
    simp only [Cell,s2,setBit,withLocals,localSet,C99ScalarReference.set,ite_true]
  have decision := KeygenDecodeStaticUnaryDecision.decision args s2 bit bit2
  have full : Checked args code s s2 (KeygenDecodeStaticUnaryDecision.flow bit) :=
    seq args _ _ s s1 s2 _ pop (seq args _ _ s1 s2 s2 _ write (skip_tail args _ s2 s2 _ decision))
  have finalWire : Wire args src dst v (p-1) db bytes s2 := ⟨ready2,wire.reads,wire.extent⟩
  have suffixBits := KeygenDecodeStaticBitRead.consume_bit rest bit db shaped
  rw [size'] at suffixBits
  refine ⟨full,finalWire,?_,rfl⟩
  unfold remaining
  rw [suffixBits]
  exact lastBits

end FT1536.Source3.KeygenDecodeStaticUnarySelect
