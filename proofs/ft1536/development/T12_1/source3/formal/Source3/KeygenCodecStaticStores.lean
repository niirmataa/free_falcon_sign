import Source3.KeygenCodecStaticIteration
import Source3.KeygenCodecStaticByte
import Source3.KeygenCodecByteHistory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual first-drain and padding writes, at the evaluated source cursor.
   Local cells are explicit; no final codec bytes, length or frame is assumed. -/
namespace FT1536.Source3.KeygenCodecStaticStores
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecScalarCalculation KeygenCodecStaticByte

theorem left_word (word : BitVec 32) (n : Nat) :
    C99IntegerReference.convert .uint32 ((word.toNat : Int)*2^n)=.uint32 (word <<< n) := by
  change C99IntegerReference.Value.uint32 (BitVec.ofInt 32 ((word.toNat : Int)*2^n))=_
  rw [show (word.toNat : Int)*2^n=((word.toNat*2^n : Nat) : Int) by simp,BitVec.ofInt_natCast]
  congr 1
  change BitVec.ofNat 32 (word.toNat*2^n)=BitVec.ofNat 32 (word.toNat <<< n)
  rw [Nat.shiftLeft_eq]

theorem right_word (word : BitVec 32) (n : Nat) :
    C99IntegerReference.convert .uint32 ((word.toNat : Int)/2^n)=.uint32 (word >>> n) := by
  change C99IntegerReference.Value.uint32 (BitVec.ofInt 32 ((word.toNat : Int)/2^n))=_
  rw [show (word.toNat : Int)/2^n=((word.toNat/2^n : Nat) : Int) by simp,BitVec.ofInt_natCast]
  rw [←Nat.shiftRight_eq_div_pow,←BitVec.toNat_ushiftRight,BitVec.ofNat_toNat,BitVec.setWidth_eq]

theorem padding_count (l : Locals) (p : Nat) (small : p≤8)
    (cell : KeygenCodecStaticPending.Cell p l) :
    Computes l (.binary .sub (.number .i32 8) (.variable "acc_len".toList))
      (.int32 (BitVec.ofNat 32 (8-p))) := by
  apply Computes.binary _ _ _ (.int32 8) (.int32 (BitVec.ofNat 32 p)) _
  · exact .number _ _ _ (by decide +kernel)
  · exact .scalar _ _ _ (by unfold Ordinary; decide +kernel) cell
  · apply BinaryOp.sub
    have canonical := KeygenCodecStaticDrain.signed_arithmetic .minus 8 (p : Int)
      (by omega) (by omega) (by omega) (by omega)
      (by change -2147483648≤8-(p : Int); omega) (by change 8-(p : Int)<2147483648; omega)
    simpa only [C99IntegerReference.exact,show (8 : Int)-(p : Int)=((8-p : Nat) : Int) by omega,
      BitVec.ofInt_natCast,show BitVec.ofInt 32 (8 : Int)=8 by decide +kernel] using canonical

theorem padding_calculation (l : Locals) (word : BitVec 32) (p : Nat) (small : p≤8)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word l) (count : KeygenCodecStaticPending.Cell p l) :
    Computes l (.cast .byte (.binary .shl (.variable "acc".toList)
      (.binary .sub (.number .i32 8) (.variable "acc_len".toList))))
      (promoted (word <<< (8-p))) := by
  apply Computes.cast _ _ (.uint32 (word <<< (8-p))) _ _ rfl
  apply Computes.binary _ _ _ (.uint32 word) (.int32 (BitVec.ofNat 32 (8-p))) _
  · exact .scalar _ _ _ (by unfold Ordinary; decide +kernel) acc
  · exact padding_count l p small count
  · apply BinaryOp.shl
    have canonical := C99IntegerReference.ShiftExec.unsignedLeft (.uint32 word) (.int32 (BitVec.ofNat 32 (8-p))) (8-p)
      rfl (KeygenCodecNoneCursor.signed_nat32 _ (by omega)) (by change 8-p<32; omega)
    simp only [C99IntegerReference.Value.type,C99IntegerReference.Value.integer] at canonical
    rw [left_word] at canonical
    exact canonical

theorem drain_calculation (l : Locals) (word : BitVec 32) (p : Nat) (small : p≤8)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word l) (count : KeygenCodecStaticPending.Cell p l) :
    Computes l (.cast .byte (.binary .shr (.variable "acc".toList) (.variable "acc_len".toList)))
      (promoted (word >>> p)) := by
  apply Computes.cast _ _ (.uint32 (word >>> p)) _ _ rfl
  apply Computes.binary _ _ _ (.uint32 word) (.int32 (BitVec.ofNat 32 p)) _
  · exact .scalar _ _ _ (by unfold Ordinary; decide +kernel) acc
  · exact .scalar _ _ _ (by unfold Ordinary; decide +kernel) count
  · apply BinaryOp.shr
    have canonical := C99IntegerReference.ShiftExec.right (.uint32 word) (.int32 (BitVec.ofNat 32 p)) p
      (KeygenCodecNoneCursor.signed_nat32 _ (by omega)) (by change p<32; omega)
    simp only [C99IntegerReference.Value.type,C99IntegerReference.Value.integer] at canonical
    rw [right_word] at canonical
    exact canonical

theorem store_calculated (args : Args) (s t : State) (flow : Flow) (rhs : Expr)
    (cursor : BitVec 64) (word : BitVec 32)
    (cell : s.locals.scalars "u".toList=some (.uint64,some (.uint64 cursor)))
    (calculation : Computes s.locals rhs (promoted word))
    (source : Exec args (.write (.index (.variable "buf".toList) (.variable "u".toList)) .set rhs) s t flow) :
    ∃ p : ArrayPointer, s.buf=some (some p) ∧
      StoreByte s.heap (byteOff p cursor.toNat) (byte word) t.heap := by
  cases source with
  | store args s index rhs middle last p offset value after buffer indexValue nonnegative rhsValue write =>
    obtain ⟨index,lastIndex⟩ := KeygenCodecGuardedWrite.u_eval args s.heap s.buf s.locals middle (.integer offset) cursor cell indexValue
    cases index
    subst middle
    obtain ⟨same,last⟩ := computes_eval args s.heap s.buf s.locals rhs _ calculation last (.integer value) rhsValue
    cases same
    refine ⟨p,buffer,?_⟩
    rw [byte_again] at write
    simpa only [C99IntegerReference.Value.integer,Int.toNat_natCast] using write

/-- The actual final store, rather than just the mathematical padding identity. -/
theorem padding_store (args : Args) (s t : State) (flow : Flow)
    (cursor : BitVec 64) (word : BitVec 32) (p : Nat) (small : p≤8)
    (cell : s.locals.scalars "u".toList=some (.uint64,some (.uint64 cursor)))
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (count : KeygenCodecStaticPending.Cell p s.locals)
    (source : Exec args KeygenCodecStaticBinding.node108 s t flow) :
    ∃ dst : ArrayPointer, s.buf=some (some dst) ∧
      StoreByte s.heap (byteOff dst cursor.toNat) (byte (word <<< (8-p))) t.heap ∧
      (byte (word <<< (8-p))).toNat=KeygenCodecStaticSuffix.low word p*2^(8-p) := by
  obtain ⟨dst,buffer,store⟩ := store_calculated args s t flow _ cursor _ cell (padding_calculation s.locals word p small acc count) source
  exact ⟨dst,buffer,store,padded_byte word p small⟩

theorem drain_store (args : Args) (s t : State) (flow : Flow)
    (cursor : BitVec 64) (word : BitVec 32) (p : Nat) (small : p≤8)
    (cell : s.locals.scalars "u".toList=some (.uint64,some (.uint64 cursor)))
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (count : KeygenCodecStaticPending.Cell p s.locals)
    (source : Exec args KeygenCodecStaticBinding.node048 s t flow) :
    ∃ dst : ArrayPointer, s.buf=some (some dst) ∧
      StoreByte s.heap (byteOff dst cursor.toNat) (byte (word >>> p)) t.heap :=
  store_calculated args s t flow _ cursor _ cell (drain_calculation s.locals word p small acc count) source

end FT1536.Source3.KeygenCodecStaticStores
