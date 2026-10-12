import Source3.KeygenCodecStaticUnaryInvariant

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticByte
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecScalarCalculation

def byte (word : BitVec 32) : BitVec 8 := BitVec.ofNat 8 word.toNat
def promoted (word : BitVec 32) : C99IntegerReference.Value :=
  .int32 (BitVec.ofNat 32 (byte word).toNat)

theorem byte_again (word : BitVec 32) : BitVec.ofInt 8 (promoted word).integer=byte word := by
  have small : (byte word).toNat<2^31 := Nat.lt_of_lt_of_le (byte word).isLt (by decide +kernel)
  change BitVec.ofInt 8 (BitVec.ofNat 32 (byte word).toNat).toInt=byte word
  rw [KeygenCodecNoneCursor.signed_nat32 _ small,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]

theorem byte_low (word : BitVec 32) : (byte word).toNat=KeygenCodecStaticSuffix.low word 8 := by
  simp only [byte,BitVec.toNat_ofNat,KeygenCodecStaticSuffix.low]

theorem cast_calculation (l : Locals) (word : BitVec 32)
    (cell : KeygenCodecStaticUnaryInvariant.Acc word l) :
    Computes l (.cast .byte (.variable "acc".toList)) (promoted word) := by
  apply Computes.cast _ _ _ _ (.scalar _ .uint32 _ (by unfold Ordinary; decide +kernel) cell)
  rfl

/-- Actual unary byte store. The location is the evaluated source index;
    byte content comes from the real RHS, with no requested output premise. -/
theorem store_byte (args : Args) (s t : State) (flow : Flow) (word : BitVec 32)
    (cell : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (source : Exec args KeygenCodecStaticBinding.node068 s t flow) :
    ∃ p : ArrayPointer, ∃ offset : C99IntegerReference.Value,
      s.buf=some (some p) ∧ 0≤offset.integer ∧
      StoreByte s.heap (byteOff p offset.integer.toNat) (byte word) t.heap := by
  cases source with
  | store args s index rhs middle last p offset value after buffer indexValue nonnegative rhsValue write =>
    have kept := (KeygenCodecCellFrame.eval_frame "acc".toList args s.heap s.buf _ s.locals middle (.integer offset) indexValue (by decide +kernel)).trans cell
    obtain ⟨same,locals⟩ := computes_eval args s.heap s.buf middle _ (promoted word) (cast_calculation middle word kept) last (.integer value) rhsValue
    cases same
    exact ⟨p,offset,buffer,nonnegative,by simpa only [byte_again] using write⟩

theorem full_unary_byte (word bit : BitVec 32) (small : bit.toNat<2) :
    (byte ((word <<< 1)+bit)).toNat=KeygenCodecStaticSuffix.low word 7*2+bit.toNat := by
  rw [byte_low]
  exact KeygenCodecStaticUnaryAppend.low_append word bit 7 (by decide +kernel) small

/-- Mathematical padding-byte identity for arbitrary old high bits.
    Binding this identity to node108 and the whole outer loop is still open. -/
theorem padded_byte (word : BitVec 32) (pending : Nat) (small : pending≤8) :
    (byte (word <<< (8-pending))).toNat=
      KeygenCodecStaticSuffix.low word pending*2^(8-pending) := by
  rw [byte_low]
  have count : pending+(8-pending)=8 := by omega
  have shifted := KeygenCodecStaticSuffix.low_shl word pending (8-pending) (by omega)
  simpa only [count] using shifted

end FT1536.Source3.KeygenCodecStaticByte
