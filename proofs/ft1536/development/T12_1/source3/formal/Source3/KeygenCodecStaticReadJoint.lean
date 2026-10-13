import Source3.KeygenCodecStaticReadPrefix
import Source3.KeygenCodecStaticJoint

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticReadJoint
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticWriteStep (Cursor)
open KeygenCodecStaticEmit (Ready)
open KeygenCodecStaticHistory (Progress)

inductive Read (s t : State) (input : BitVec 16) : Prop where
  | intro (ptr next : ArrayPointer) (before : s.locals.x=some ptr)
      (load : Load16 s.heap ptr input) (advance : PointerAdd ptr 1 next)
      (after : t.locals.x=some next) : Read s t input

/-- History, normal state and actual pointer/read chronology belong to
    one coefficient witness on every flow. -/
theorem coefficient (args : Args) (s t : State) (flow : Flow) (u p : Nat) (word : BitVec 32)
    (bound : u+131<2^64) (small : p<8) (ready : Ready args s)
    (cursor : Cursor (BitVec.ofNat 64 u) s) (count : KeygenCodecStaticPending.Cell p s.locals)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (j : KeygenCodecStaticProfile.Cell "j".toList .int32 (.int32 8) s.locals)
    (mask : KeygenCodecStaticProfile.Cell "mask".toList .uint32 (.uint32 255) s.locals)
    (source : Exec args KeygenCodecStaticBinding.node101 s t flow) :
    ∃ input : BitVec 16, Read s t input ∧
      Progress args s t u (KeygenCodecStaticCoefficientHistory.bytes p word input) flow ∧
      (flow=.normal → KeygenCodecStaticJoint.NormalState p word input t) := by
  obtain ⟨input,ptr,next,readBefore,loaded,start,final,_,_,_,load,advance,_,prepared,rest,exit,firstPtr,lastPtr⟩ :=
    KeygenCodecStaticReadPrefix.preparation args s t flow u p word small ready cursor count acc j mask source
  have history := KeygenCodecStaticCoefficientHistory.remainder_history args s start final flow
    u p word input bound small prepared rest
  unfold Progress at history
  rw [prepared.heap] at history
  refine ⟨input,⟨ptr,next,firstPtr,load,advance,lastPtr⟩,?_,?_⟩
  · rw [exit]
    exact KeygenCodecStaticCoefficientHistory.scope_progress args s final u _ flow history
  · intro normal
    subst flow
    rw [exit]
    exact KeygenCodecStaticJoint.scope_state s final p word input
      (KeygenCodecStaticJoint.remainder_state args s start final u p word input small prepared rest)

end FT1536.Source3.KeygenCodecStaticReadJoint
