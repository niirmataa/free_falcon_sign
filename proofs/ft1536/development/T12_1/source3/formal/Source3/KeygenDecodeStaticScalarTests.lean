import Source3.KeygenDecodeStaticPrefixComplete

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticScalarTests
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeWordOps KeygenDecodeStaticWordOps

/-- Exact mixed uint32/int32 comparison used by source zero and bound tests. -/
theorem mixed_comparison (op : C99IntegerReference.Comparison) (m n : Nat)
    (left : m<2^32) (right : n<2^31) :
    C99IntegerReference.CompareExec op (.uint32 (BitVec.ofNat 32 m)) (.int32 (BitVec.ofNat 32 n))
      (C99ScalarReference.boolean (C99IntegerReference.compare op (m : Int) (n : Int))) := by
  have source := C99IntegerReference.CompareExec.step op
    (.uint32 (BitVec.ofNat 32 m)) (.int32 (BitVec.ofNat 32 n)) .uint32 rfl
    (.uint32 (BitVec.ofNat 32 m)) (.uint32 (BitVec.ofNat 32 n))
    (self32 _).symm (convert_int32 n right).symm
  rw [unsigned_nat32 m left,unsigned_nat32 n (by omega)] at source
  exact source

theorem zero_calculation (args : Args) (s : State) (p : Nat) (bound : p≤16)
    (pending : Cell "db_len" .uint32 (.uint32 (BitVec.ofNat 32 p)) s.locals) :
    KeygenDecodeCalculation.Computes args s.heap s.buf s.locals KeygenDecodeStaticBinding.guard055
      (C99ScalarReference.boolean (decide (p=0))) := by
  apply KeygenDecodeCalculation.Computes.binary _ _ _ _ _ _
    (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) pending)
    (.number .i32 0 (.int32 0) (by decide +kernel))
  apply BinaryOp.eq
  simpa only [C99IntegerReference.compare,Int.ofNat_inj,
    show (0#32 : BitVec 32)=0 by decide +kernel] using
    mixed_comparison .eq p 0 (by omega) (by decide +kernel)

def afterPop (s : State) (p : Nat) : State :=
  withLocals s (localSet s.locals "db_len".toList .uint32 (some (.uint32 (BitVec.ofNat 32 (p-1)))))

theorem pop_calculation (args : Args) (s : State) (p : Nat) (positive : 1≤p)
    (pending : Cell "db_len" .uint32 (.uint32 (BitVec.ofNat 32 p)) s.locals) :
    KeygenDecodeDynamicCalculation.Computes args s.heap s.buf (.postDec (.variable "db_len".toList))
      s.locals (.uint32 (BitVec.ofNat 32 p)) (afterPop s p).locals := by
  have decrement := KeygenDecodeStaticCounterOps.decrement32 (BitVec.ofNat 32 p)
  rw [show (1 : BitVec 32)=BitVec.ofNat 32 1 by decide +kernel,
    BitVec.ofNat_sub_ofNat_of_le p 1 (by decide +kernel) positive] at decrement
  apply KeygenDecodeDynamicCalculation.Computes.postDec
  exact .scalar (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) .uint32 pending _ decrement
    (self32 _).symm rfl

theorem source_pop (args : Args) (s : State) (p : Nat) (positive : 1≤p)
    (pending : Cell "db_len" .uint32 (.uint32 (BitVec.ofNat 32 p)) s.locals) :
    KeygenDecodeStaticCertified.Checked args KeygenDecodeStaticBinding.node056 s (afterPop s p) .normal := by
  exact KeygenDecodeStaticCertified.evaluate args s _ _ _ (pop_calculation args s p positive pending)

end FT1536.Source3.KeygenDecodeStaticScalarTests
