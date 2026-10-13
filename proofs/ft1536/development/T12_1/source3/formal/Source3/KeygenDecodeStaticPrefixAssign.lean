import Source3.KeygenDecodeStaticPrefixBits
import Source3.KeygenDecodeStaticReaderFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete actual sign/db_len/low assignment block. Bit shape is an
   internal wire seam, to be derived from the same source encoder stream. -/
namespace FT1536.Source3.KeygenDecodeStaticPrefixAssign
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified KeygenCodecStaticBitBuffer KeygenCodecStaticBits

def code : Stmt := .seq KeygenDecodeStaticBinding.node039
  (.seq KeygenDecodeStaticBinding.node040 (.seq KeygenDecodeStaticBinding.node041 .skip))
def setSign (s : State) (bit : Bool) : State :=
  withLocals s (localSet s.locals "sign".toList .uint32 (some (.uint32 (BitVec.ofNat 32 bit.toNat))))
def setPending (s : State) (p : Nat) : State :=
  withLocals s (localSet s.locals "db_len".toList .uint32 (some (.uint32 (BitVec.ofNat 32 p))))
def setLow (s : State) (m : Nat) : State :=
  withLocals s (localSet s.locals "lo".toList .uint32 (some (.uint32 (BitVec.ofNat 32 (m%256)))))
def after (s : State) (p m : Nat) (bit : Bool) : State := setLow (setPending (setSign s bit) (p-9)) m

theorem assignments (args : Args) (s : State) (src dst : ArrayPointer) (v p m : Nat)
    (db : BitVec 32) (bit : Bool) (rest : List Bool) (lower : 9≤p) (upper : p≤16)
    (ready : Ready args src dst v p db s)
    (declaredSign : s.locals.scalars "sign".toList=some (.uint32,none))
    (declaredLo : s.locals.scalars "lo".toList=some (.uint32,none))
    (shape : buffer p db=bit::(digits 8 m++rest)) (size : rest.length=p-9) :
    Checked args code s (after s p m bit) .normal ∧
      Ready args src dst v (p-9) db (after s p m bit) ∧
      Cell "sign" .uint32 (.uint32 (BitVec.ofNat 32 bit.toNat)) (after s p m bit).locals ∧
      Cell "lo" .uint32 (.uint32 (BitVec.ofNat 32 (m%256))) (after s p m bit).locals ∧
      (after s p m bit).heap=s.heap := by
  let s1 := setSign s bit
  let s2 := setPending s1 (p-9)
  let s3 := after s p m bit
  have tailLength : (digits 8 m++rest).length=p-1 := by
    rw [List.length_append,digits_length,size]
    omega
  have shaped : buffer ((digits 8 m++rest).length+1) db=bit::(digits 8 m++rest) := by
    rw [tailLength,show p-1+1=p by omega]
    exact shape
  have signWord : ((db >>> (p-1)) &&& 1)=BitVec.ofNat 32 bit.toNat := by
    rw [←tailLength]
    exact KeygenDecodeStaticPrefixValues.sign_bit _ _ _ shaped
  have signCalc := KeygenDecodeStaticPrefixValues.sign_calculation args s p db (by omega) upper ready.pending ready.accumulator
  rw [signWord] at signCalc
  have signSource : Checked args KeygenDecodeStaticBinding.node039 s s1 .normal := by
    have source := assign args s "sign".toList .uint32 none KeygenDecodeStaticPrefixValues.signRhs _ s.locals
      (by decide +kernel) (by decide +kernel) declaredSign (.pure _ _ _ signCalc)
    simpa only [KeygenDecodeWordOps.self32,KeygenDecodeStaticPrefixValues.source_sign,setSign,s1] using source
  have ready1 := KeygenDecodeStaticReaderFrame.ready_frame args src dst v p db s s1 _ .normal signSource.run
    (by unfold KeygenDecodeStaticReaderFrame.Checks KeygenDecodeStaticReady.Checks; decide +kernel) ready
  have amount : KeygenDecodeCalculation.Computes args s1.heap s1.buf s1.locals
      (.binary .add (.variable "j".toList) (.number .i32 1)) (.uint32 9) := by
    apply KeygenDecodeCalculation.Computes.binary _ _ _ _ _ _
      (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) ready1.context.j)
      (.number .i32 1 (.int32 1) (by decide +kernel))
    apply BinaryOp.add
    simpa only [show (8#32 : BitVec 32)=8 by decide +kernel,show (9#32 : BitVec 32)=9 by decide +kernel,
      show (1#32 : BitVec 32)=1 by decide +kernel] using
      KeygenDecodeStaticCounterOps.plus_nat32 8 1 (by decide +kernel)
  have subtraction : C99IntegerReference.ArithmeticExec .minus (.uint32 (BitVec.ofNat 32 p)) (.uint32 9)
      (.uint32 (BitVec.ofNat 32 (p-9))) := by
    have source := KeygenDecodeWordOps.sub32 (BitVec.ofNat 32 p) 9
    rw [show (9 : BitVec 32)=BitVec.ofNat 32 9 by decide +kernel,
      BitVec.ofNat_sub_ofNat_of_le p 9 (by decide +kernel) lower] at source
    exact source
  have countSource : Checked args KeygenDecodeStaticBinding.node040 s1 s2 .normal := by
    have source := compound args s1 "db_len".toList .uint32 (.uint32 (BitVec.ofNat 32 p))
      .sub .sub (.binary .add (.variable "j".toList) (.number .i32 1)) (.uint32 9)
      (.uint32 (BitVec.ofNat 32 (p-9))) s1.locals (by decide +kernel) (by decide +kernel) ready1.pending rfl
      (.pure _ _ _ amount) (.sub _ _ _ subtraction)
    simpa only [KeygenDecodeWordOps.self32,KeygenDecodeStaticBinding.node040,setPending,s2] using source
  have context2 := context_frame args src dst s1 s2 _ .normal countSource.run (by unfold KeygenDecodeStaticReady.Checks; decide +kernel) ready1.context
  have acc2 := (KeygenDecodeStaticCellFrame.exec_frame "db".toList args _ s1 s2 .normal countSource.run (by decide +kernel)).trans ready1.accumulator
  have pending2 : Cell "db_len" .uint32 (.uint32 (BitVec.ofNat 32 (p-9))) s2.locals := by
    simp only [Cell,s2,setPending,withLocals,localSet,C99ScalarReference.set,ite_true]
  have lo2 := (KeygenDecodeStaticCellFrame.exec_frame "lo".toList args _ s1 s2 .normal countSource.run (by decide +kernel)).trans
    ((KeygenDecodeStaticCellFrame.exec_frame "lo".toList args _ s s1 .normal signSource.run (by decide +kernel)).trans declaredLo)
  have unsignedTail := KeygenDecodeStaticBitRead.consume_bit _ _ _ shaped
  have unsignedShape : buffer ((digits 8 m).length+rest.length) db=digits 8 m++rest := by
    simpa only [List.length_append] using unsignedTail
  have lowWord := KeygenDecodeStaticPrefixValues.low_bits (digits 8 m) rest db (digits_length _ _) unsignedShape
  rw [digits_value] at lowWord
  have lowWord' : ((db >>> (p-9)) &&& 255)=BitVec.ofNat 32 (m%256) := by
    simpa only [size,show (2 : Nat)^8=256 from rfl] using lowWord
  have lowCalc := KeygenDecodeStaticPrefixValues.low_calculation args s2 (p-9) db (by omega) pending2 acc2 context2.mask
  rw [lowWord'] at lowCalc
  have lowSource : Checked args KeygenDecodeStaticBinding.node041 s2 s3 .normal := by
    have source := assign args s2 "lo".toList .uint32 none KeygenDecodeStaticPrefixValues.lowRhs _ s2.locals
      (by decide +kernel) (by decide +kernel) lo2 (.pure _ _ _ lowCalc)
    simpa only [KeygenDecodeWordOps.self32,KeygenDecodeStaticPrefixValues.source_low,setLow,after,s3,s2,s1] using source
  have full : Checked args code s s3 .normal := seq args _ _ s s1 s3 .normal signSource
    (seq args _ _ s1 s2 s3 .normal countSource (seq args _ _ s2 s3 s3 .normal lowSource (skip args s3)))
  have finalContext := context_frame args src dst s s3 code .normal full.run (by unfold KeygenDecodeStaticReady.Checks; decide +kernel) ready.context
  have finalV := (KeygenDecodeStaticCellFrame.exec_frame "v".toList args code s s3 .normal full.run (by decide +kernel)).trans ready.cursor
  have finalDb := (KeygenDecodeStaticCellFrame.exec_frame "db".toList args code s s3 .normal full.run (by decide +kernel)).trans ready.accumulator
  have finalPending := (KeygenDecodeStaticCellFrame.exec_frame "db_len".toList args _ s2 s3 .normal lowSource.run (by decide +kernel)).trans pending2
  refine ⟨full,⟨finalContext,finalV,finalPending,finalDb⟩,?_,?_,rfl⟩
  · simp only [Cell,after,setLow,setPending,setSign,withLocals,localSet,C99ScalarReference.set]
    rfl
  · simp only [Cell,after,setLow,withLocals,localSet,C99ScalarReference.set,ite_true]

end FT1536.Source3.KeygenDecodeStaticPrefixAssign
