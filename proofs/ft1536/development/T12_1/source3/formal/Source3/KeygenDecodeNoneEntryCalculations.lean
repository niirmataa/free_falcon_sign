import Source3.KeygenDecodeNoneLoop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact expressions of the source NONE prologue and final return.
   n1536/hq9216/tq27650/return3072 are calculated from q18433/logn10,
   never supplied as codec correctness or length assumptions. -/
namespace FT1536.Source3.KeygenDecodeNoneEntryCalculations
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeCalculation KeygenDecodeNoneCore KeygenDecodeWordOps

def nRhs : Expr := .binary .shl (.cast .size (.number .i32 3))
  (.binary .sub (.variable "logn".toList) (.number .i32 1))
def lengthRhs : Expr := .binary .shl (.variable "n".toList) (.number .i32 1)
def hqRhs : Expr := .binary .shr (.variable "q".toList) (.number .i32 1)
def tqRhs : Expr := .binary .add (.binary .add (.variable "hq".toList) (.variable "q".toList)) (.number .i32 1)

theorem q_comparison : C99IntegerReference.CompareExec .eq (.uint32 18433) (.int32 12289) (.int32 0) := by
  have primitive := C99IntegerReference.CompareExec.step .eq (.uint32 18433) (.int32 12289) .uint32 rfl
    (.uint32 18433) (.uint32 12289) rfl rfl
  convert primitive using 1; decide +kernel

theorem q_calculation (args : Args) (s : State) (q : Cell "q" .uint32 (.uint32 18433) s.locals) :
    Computes args s.heap s.buf s.locals KeygenDecodeNoneBinding.guard011 (.int32 0) :=
  .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) q)
    (.number _ _ _ (by decide +kernel)) (.eq _ _ _ q_comparison)

theorem logn_subtraction :
    C99IntegerReference.ArithmeticExec .minus (.uint32 10) (.int32 1) (.uint32 9) := by
  have primitive := C99IntegerReference.ArithmeticExec.step .minus (.uint32 10) (.int32 1) .uint32 rfl
    (.uint32 10) (.uint32 1) rfl rfl (by intro impossible; cases impossible)
  convert primitive using 1; decide +kernel

theorem n_shift : C99IntegerReference.ShiftExec .left (.uint64 3) (.uint32 9) (.uint64 1536) := by
  have primitive := C99IntegerReference.ShiftExec.unsignedLeft (.uint64 3) (.uint32 9) 9 rfl rfl (by decide +kernel)
  convert primitive using 1; decide +kernel

theorem n_calculation (args : Args) (s : State) (logn : Cell "logn" .uint32 (.uint32 10) s.locals) :
    Computes args s.heap s.buf s.locals nRhs (.uint64 1536) :=
  .binary _ _ _ _ _ _
    (.cast _ _ (.int32 3) _ (.number _ _ _ (by decide +kernel)) (by decide +kernel))
    (.binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) logn)
      (.number _ _ _ (by decide +kernel)) (.sub _ _ _ logn_subtraction))
    (.shl _ _ _ n_shift)

theorem length_shift : C99IntegerReference.ShiftExec .left (.uint64 1536) (.int32 1) (.uint64 3072) := by
  have primitive := C99IntegerReference.ShiftExec.unsignedLeft (.uint64 1536) (.int32 1) 1 rfl rfl (by decide +kernel)
  convert primitive using 1; decide +kernel

theorem length_calculation (args : Args) (s : State) (n : Cell "n" .uint64 (.uint64 1536) s.locals) :
    Computes args s.heap s.buf s.locals lengthRhs (.uint64 3072) :=
  .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) n)
    (.number _ _ _ (by decide +kernel)) (.shl _ _ _ length_shift)

theorem length_comparison (len : BitVec 64) (enough : 3072≤len.toNat) :
    C99IntegerReference.CompareExec .lt (.uint64 len) (.uint64 3072) (.int32 0) := by
  have primitive := C99IntegerReference.CompareExec.step .lt (.uint64 len) (.uint64 3072) .uint64 rfl
    (.uint64 len) (.uint64 3072) (KeygenDecodeNoneCounter.self_uint64 len).symm rfl
  have limit : (C99IntegerReference.Value.uint64 3072).integer=(3072 : Int) := rfl
  have leni : (C99IntegerReference.Value.uint64 len).integer=(len.toNat : Int) := rfl
  have no : ¬(len.toNat : Int)<3072 := by omega
  simpa only [C99IntegerReference.compare,leni,limit,no,decide_false,
    Bool.false_eq_true,ite_false,show (0#32 : BitVec 32)=(0 : BitVec 32) by decide +kernel] using primitive

theorem length_test_calculation (args : Args) (s : State) (enough : 3072≤args.len.toNat)
    (length : Cell "len" .uint64 (.uint64 args.len) s.locals)
    (n : Cell "n" .uint64 (.uint64 1536) s.locals) :
    Computes args s.heap s.buf s.locals KeygenDecodeNoneBinding.guard016 (.int32 0) :=
  .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) length)
    (length_calculation args s n) (.lt _ _ _ (length_comparison args.len enough))

theorem hq_shift : C99IntegerReference.ShiftExec .right (.uint32 18433) (.int32 1) (.uint32 9216) := by
  have primitive := right32 18433 1 (by decide +kernel)
  convert primitive using 1; decide +kernel

theorem hq_calculation (args : Args) (s : State) (q : Cell "q" .uint32 (.uint32 18433) s.locals) :
    Computes args s.heap s.buf s.locals hqRhs (.uint32 9216) :=
  .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) q)
    (.number _ _ _ (by decide +kernel)) (.shr _ _ _ hq_shift)

theorem tq_add : C99IntegerReference.ArithmeticExec .plus (.uint32 9216) (.uint32 18433) (.uint32 27649) := by
  have primitive := add32 9216 18433
  convert primitive using 1; decide +kernel

theorem tq_increment : C99IntegerReference.ArithmeticExec .plus (.uint32 27649) (.int32 1) (.uint32 27650) := by
  have primitive := C99IntegerReference.ArithmeticExec.step .plus (.uint32 27649) (.int32 1) .uint32 rfl
    (.uint32 27649) (.uint32 1) rfl rfl (by intro impossible; cases impossible)
  convert primitive using 1; decide +kernel

theorem tq_calculation (args : Args) (s : State)
    (hq : Cell "hq" .uint32 (.uint32 9216) s.locals) (q : Cell "q" .uint32 (.uint32 18433) s.locals) :
    Computes args s.heap s.buf s.locals tqRhs (.uint32 27650) :=
  .binary _ _ _ _ _ _
    (.binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) hq)
      (.scalar _ _ _ (by unfold Ordinary; decide +kernel) q) (.add _ _ _ tq_add))
    (.number _ _ _ (by decide +kernel)) (.add _ _ _ tq_increment)

end FT1536.Source3.KeygenDecodeNoneEntryCalculations
