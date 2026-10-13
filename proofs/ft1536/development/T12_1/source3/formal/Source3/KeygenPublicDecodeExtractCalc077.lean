import Source3.KeygenPublicDecodeRefill077
import Source3.KeygenDecodeStaticPaddingBits

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicDecodeExtractCalc077
open KeygenDecodeSyntax KeygenDecodeValues KeygenPublicDecodeExecution077 C99MemoryReference
open KeygenPublicDecodeReady077

def shiftRhs : Expr := .binary .shr (.variable "acc".toList) (.variable "acc_len".toList)
def maskRhs : Expr := .binary .sub (.binary .shl (.number .u32 1) (.variable "acc_len".toList)) (.number .u32 1)
def promoted (input : BitVec 16) : C99IntegerReference.Value := .int32 (BitVec.ofNat 32 input.toNat)
theorem promoted_integer (input : BitVec 16) : (promoted input).integer=(input.toNat : Int) :=
  KeygenCodecNoneCursor.signed_nat32 input.toNat (by have bound:=input.isLt; omega)
theorem narrowed (input : BitVec 16) : BitVec.ofInt 16 (promoted input).integer=input := by
  rw [promoted_integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]
theorem cast_input (input : BitVec 16) : castInteger .u16 (.uint32 (input.setWidth 32))=some (promoted input) := by
  have wide : (input.setWidth 32).toNat=input.toNat := by
    rw [BitVec.toNat_setWidth,Nat.mod_eq_of_lt (show input.toNat<2^32 by have bound:=input.isLt; omega)]
  simp only [castInteger,C99IntegerReference.Value.integer,wide,BitVec.ofInt_natCast,BitVec.ofNat_toNat,
    BitVec.setWidth_eq,promoted]

theorem pending_calculation (args : Args) (s : State) (p : Nat) (small : p<32)
    (pending : Cell "acc_len" .int32 (.int32 (BitVec.ofNat 32 p)) s.locals) :
    KeygenDecodeCalculation.Computes args s.heap s.buf s.locals KeygenPublicDecodeBinding077.guard036
      (C99ScalarReference.boolean (decide (15≤p))) := by
  have primitive := KeygenPublicInteger077.compare_i32 .ge p 15 (by omega) (by decide +kernel)
  have same : C99IntegerReference.compare .ge (p : Int) ((15 : Nat) : Int)=decide (15≤p) := by
    simp only [C99IntegerReference.compare,Int.ofNat_le]
  rw [same] at primitive
  exact .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) pending)
    (.number _ _ _ (by decide +kernel)) (.ge _ _ _ primitive)

theorem shift_calculation (args : Args) (s : State) (p : Nat) (acc : BitVec 32) (small : p<32)
    (pending : Cell "acc_len" .int32 (.int32 (BitVec.ofNat 32 p)) s.locals)
    (word : Cell "acc" .uint32 (.uint32 acc) s.locals) :
    KeygenDecodeCalculation.Computes args s.heap s.buf s.locals shiftRhs (.uint32 (acc >>> p)) :=
  .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) word)
    (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) pending)
    (.shr _ _ _ (KeygenDecodeWordOps.right32 acc p small))

theorem mask_calculation (args : Args) (s : State) (p : Nat) (small : p<32)
    (pending : Cell "acc_len" .int32 (.int32 (BitVec.ofNat 32 p)) s.locals) :
    KeygenDecodeCalculation.Computes args s.heap s.buf s.locals maskRhs (.uint32 (BitVec.ofNat 32 (2^p-1))) := by
  have source : KeygenDecodeCalculation.Computes args s.heap s.buf s.locals maskRhs (.uint32 (((1 : BitVec 32) <<< p)-1)) :=
    .binary _ _ _ _ _ _
      (.binary _ _ _ _ _ _ (.number _ _ _ (by decide +kernel))
        (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) pending)
        (.shl _ _ _ (KeygenDecodeWordOps.left32 1 p small)))
      (.number _ _ _ (by decide +kernel)) (.sub _ _ _ (KeygenDecodeWordOps.sub32 _ _))
  rw [show (((1 : BitVec 32) <<< p)-1)=BitVec.ofNat 32 (2^p-1) from KeygenDecodeStaticPaddingBits.mask_word p] at source
  exact source

theorem word_calculation (args : Args) (s : State) (input : BitVec 16) (canonical : input.toNat<18433)
    (word : Cell "w" .uint32 (.uint32 (input.setWidth 32)) s.locals) :
    KeygenDecodeCalculation.Computes args s.heap s.buf s.locals KeygenPublicDecodeBinding077.guard023 (.int32 0) := by
  have primitive := C99IntegerReference.CompareExec.step .ge (.uint32 (input.setWidth 32)) (.int32 18433)
    .uint32 rfl (.uint32 (input.setWidth 32)) (.uint32 18433) (KeygenDecodeWordOps.self32 _).symm rfl
  have value : (C99IntegerReference.Value.uint32 (input.setWidth 32)).integer=(input.toNat : Int) := by
    change ((input.setWidth 32).toNat : Int)=(input.toNat : Int)
    rw [BitVec.toNat_setWidth,Nat.mod_eq_of_lt (show input.toNat<2^32 by omega)]
  have limit : (C99IntegerReference.Value.uint32 18433).integer=(18433 : Int) := rfl
  have no : ¬((18433 : Int) ≤ (input.toNat : Int)) := by omega
  have compare : C99IntegerReference.CompareExec .ge (.uint32 (input.setWidth 32)) (.int32 18433) (.int32 0) := by
    simpa only [C99IntegerReference.compare,value,limit,no,decide_false,Bool.false_eq_true,ite_false,
      show (0#32 : BitVec 32)=0 by decide +kernel] using primitive
  exact .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) word)
    (.number _ _ _ (by decide +kernel)) (.ge _ _ _ compare)

end FT1536.Source3.KeygenPublicDecodeExtractCalc077
