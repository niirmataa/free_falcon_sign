import Source3.KeygenDecodeStaticLoop
import Source3.KeygenDecodeNoneEntryCalculations

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact actual M0 prologue expressions. Constants n1536/j8/mask255 are
   derived from q18433/logn10 and the pinned source expressions. -/
namespace FT1536.Source3.KeygenDecodeStaticPrologueCalculations
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeCalculation KeygenDecodeWordOps

def nRhs : Expr := KeygenDecodeNoneEntryCalculations.nRhs
def maskRhs : Expr := .binary .sub (.binary .shl (.number .u32 1) (.variable "j".toList)) (.number .u32 1)

theorem q_calculation (args : Args) (s : State) (q : Cell "q" .uint32 (.uint32 18433) s.locals) :
    Computes args s.heap s.buf s.locals KeygenDecodeStaticBinding.guard016 (.int32 0) := by
  simpa only [KeygenDecodeStaticBinding.guard016,KeygenDecodeNoneBinding.guard011] using
    KeygenDecodeNoneEntryCalculations.q_calculation args s q

theorem n_calculation (args : Args) (s : State) (logn : Cell "logn" .uint32 (.uint32 10) s.locals) :
    Computes args s.heap s.buf s.locals nRhs (.uint64 1536) :=
  KeygenDecodeNoneEntryCalculations.n_calculation args s logn

theorem shift_j : C99IntegerReference.ShiftExec .left (.uint32 1) (.uint32 8) (.uint32 256) := by
  have source := KeygenDecodeStaticWordOps.left_uint32 1 8 (by decide +kernel)
  convert source using 1; decide +kernel

theorem subtract_one : C99IntegerReference.ArithmeticExec .minus (.uint32 256) (.uint32 1) (.uint32 255) := by
  have source := sub32 256 1
  convert source using 1; decide +kernel

theorem mask_calculation (args : Args) (s : State) (j : Cell "j" .uint32 (.uint32 8) s.locals) :
    Computes args s.heap s.buf s.locals maskRhs (.uint32 255) :=
  .binary _ _ _ _ _ _
    (.binary _ _ _ _ _ _ (.number .u32 1 (.uint32 1) (by decide +kernel))
      (.scalar _ _ _ (by unfold Ordinary; decide +kernel) j) (.shl _ _ _ shift_j))
    (.number .u32 1 (.uint32 1) (by decide +kernel)) (.sub _ _ _ subtract_one)

theorem source_n : KeygenDecodeStaticBinding.node010=.write (.variable "n".toList) .set nRhs := rfl
theorem source_mask : KeygenDecodeStaticBinding.node017=.write (.variable "mask".toList) .set maskRhs := rfl

end FT1536.Source3.KeygenDecodeStaticPrologueCalculations
