import Source3.KeygenDecodeStaticScalarTests

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenDecodeStaticUnaryDecision
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified

def flow (bit : Bool) : Flow := if bit then .broken else .normal

theorem decision (args : Args) (s : State) (bit : Bool)
    (cell : Cell "bit" .uint32 (.uint32 (BitVec.ofNat 32 bit.toNat)) s.locals) :
    Checked args KeygenDecodeStaticBinding.node062 s s (flow bit) := by
  have calculation : KeygenDecodeCalculation.Computes args s.heap s.buf s.locals
      KeygenDecodeStaticBinding.guard062 (.uint32 (BitVec.ofNat 32 bit.toNat)) :=
    .scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) cell
  have same : withLocals s s.locals=s := by cases s; rfl
  cases bit
  · have source := branch_false args KeygenDecodeStaticBinding.guard062 KeygenDecodeStaticBinding.node061 .skip
      s s .normal _ s.locals (.pure _ _ _ calculation) (by decide +kernel)
      (by rw [same]; exact skip args s)
    exact source
  · have broken : Checked args KeygenDecodeStaticBinding.node060 s s .broken :=
      seq_break args KeygenDecodeStaticBinding.node058 KeygenDecodeStaticBinding.node059 s s (breakLoop args s)
    have wrapped : Checked args KeygenDecodeStaticBinding.node061 s s .broken := by
      have source := scope args KeygenDecodeStaticBinding.node060 s s .broken (by intro impossible; cases impossible) broken
      rw [empty_scope _ _ _ rfl] at source
      exact source
    have source := branch_true args KeygenDecodeStaticBinding.guard062 KeygenDecodeStaticBinding.node061 .skip
      s s .broken _ s.locals (.pure _ _ _ calculation) (by decide +kernel) (by rw [same]; exact wrapped)
    exact source

end FT1536.Source3.KeygenDecodeStaticUnaryDecision
