import Source3.KeygenPublicEncodePrepare077
import Source3.KeygenDecodeStaticInputGate

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEncodeByteCalc077
open KeygenCodecSyntax KeygenPublicEncodeValues077 KeygenPublicEncodeExecution077 C99MemoryReference
open KeygenPublicEncodeReady077

def drainRhs : Expr := .cast .byte (.binary .shr (.variable "acc".toList) (.variable "acc_len".toList))
def maskRhs : Expr := .binary .sub (.binary .shl (.number .u32 1) (.variable "acc_len".toList)) (.number .u32 1)

theorem drain_calculation (s : State) (p : Nat) (acc : BitVec 32) (small : p<32)
    (pending : Cell "acc_len" .int32 (.int32 (BitVec.ofNat 32 p)) s.locals)
    (word : Cell "acc" .uint32 (.uint32 acc) s.locals) :
    KeygenPublicEncodePure077.Computes s.locals drainRhs (KeygenCodecStaticByte.promoted (acc >>> p)) :=
  .cast _ _ _ _
    (.binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold KeygenCodecScalarCalculation.Ordinary; decide +kernel) word)
      (.scalar _ _ _ (by unfold KeygenCodecScalarCalculation.Ordinary; decide +kernel) pending)
      (.shr _ _ _ (KeygenDecodeWordOps.right32 acc p small))) rfl

theorem mask_calculation (s : State) (p : Nat) (small : p<32)
    (pending : Cell "acc_len" .int32 (.int32 (BitVec.ofNat 32 p)) s.locals) :
    KeygenPublicEncodePure077.Computes s.locals maskRhs (.uint32 (((1 : BitVec 32) <<< p)-1)) :=
  .binary _ _ _ _ _ _
    (.binary _ _ _ _ _ _ (.number .u32 1 (.uint32 1) (by decide +kernel))
      (.scalar _ _ _ (by unfold KeygenCodecScalarCalculation.Ordinary; decide +kernel) pending)
      (.shl _ _ _ (KeygenDecodeWordOps.left32 1 p small)))
    (.number .u32 1 (.uint32 1) (by decide +kernel)) (.sub _ _ _ (KeygenDecodeWordOps.sub32 _ _))

theorem capacity_calculation (s : State) (args : Args) (u : Nat)
    (available : u<args.capacity.toNat)
    (cursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) s.locals)
    (capacity : Cell "max_out_len" .uint64 (.uint64 args.capacity) s.locals) :
    KeygenPublicEncodePure077.Computes s.locals KeygenPublicEncodeBinding077.guard017 (.int32 0) :=
  .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold KeygenCodecScalarCalculation.Ordinary; decide +kernel) cursor)
    (.scalar _ _ _ (by unfold KeygenCodecScalarCalculation.Ordinary; decide +kernel) capacity)
    (.ge _ _ _ (KeygenDecodeStaticInputGate.comparison u args.capacity available))

theorem source_mask : KeygenPublicEncodeBinding077.node025=
    .write (.variable "acc".toList) .band maskRhs := rfl
theorem source_drain : KeygenPublicEncodeBinding077.node018=
    .write (.index (.variable "buf".toList) (.variable "u".toList)) .set drainRhs := rfl

end FT1536.Source3.KeygenPublicEncodeByteCalc077
