import Source3.KeygenPublicEncodeByteCalc077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEncodeEmit077
open KeygenCodecSyntax KeygenPublicEncodeValues077 KeygenPublicEncodeExecution077 C99MemoryReference
open KeygenPublicEncodeDynamic077 KeygenPublicEncodeCertified077 KeygenPublicEncodeReady077

def byte (acc : BitVec 32) (p : Nat) : BitVec 8 := KeygenCodecStaticByte.byte (acc >>> p)
def after (s : State) (out : ArrayPointer) (u p : Nat) (acc : BitVec 32) : State :=
  ⟨KeygenPublicEncodeStore077.overwrite s.heap (byteOff out u) (byte acc p),s.locals,s.buf⟩

theorem emit (args : Args) (s : State) (out : ArrayPointer) (u p : Nat) (acc : BitVec 32)
    (small : p<32) (inside : u<2880) (enough : 2880≤args.capacity.toNat)
    (context : Context args out s) (legal : WritableBytes s.heap out 2880)
    (cursor : Cell "u" .uint64 (.uint64 (BitVec.ofNat 64 u)) s.locals)
    (pending : Cell "acc_len" .int32 (.int32 (BitVec.ofNat 32 p)) s.locals)
    (word : Cell "acc" .uint32 (.uint32 acc) s.locals) :
    Checked args KeygenPublicEncodeBinding077.node023 s (after s out u p acc) .normal ∧
      StoreByte s.heap (byteOff out u) (byte acc p) (after s out u p acc).heap := by
  let t := after s out u p acc
  have available : u<args.capacity.toNat := by omega
  have same : withLocals s s.locals=s := by cases s; rfl
  have guard : Checked args KeygenPublicEncodeBinding077.node017 s s .normal :=
    branch_false args KeygenPublicEncodeBinding077.guard017 KeygenPublicEncodeBinding077.node016 .skip s s .normal
      (.int32 0) s.locals (.pure _ _ _ (KeygenPublicEncodeByteCalc077.capacity_calculation s args u available cursor context.capacity))
      (by decide +kernel) (by rw [same]; exact skip args s)
  have indexCalc : KeygenPublicEncodePure077.Computes s.locals (.variable "u".toList) (.uint64 (BitVec.ofNat 64 u)) :=
    .scalar _ _ _ (by unfold KeygenCodecScalarCalculation.Ordinary; decide +kernel) cursor
  have indexValue := KeygenCodecNoneCursor.unsigned_nat64 u (by omega : u<2^64)
  have allocated : Allocated s.heap (byteOff out (C99IntegerReference.Value.uint64 (BitVec.ofNat 64 u)).integer.toNat) := by
    rw [indexValue]
    exact legal.2 u inside
  have stored : Checked args KeygenPublicEncodeBinding077.node018 s t .normal := by
    have source := KeygenPublicEncodeStore077.store args s (.variable "u".toList) KeygenPublicEncodeByteCalc077.drainRhs
      s.locals s.locals out (.uint64 (BitVec.ofNat 64 u)) (KeygenCodecStaticByte.promoted (acc >>> p)) context.buffer
      (.pure _ _ _ indexCalc) (by rw [indexValue]; omega)
      (.pure _ _ _ (KeygenPublicEncodeByteCalc077.drain_calculation s p acc small pending word)) allocated legal.1
    simpa only [KeygenPublicEncodeByteCalc077.source_drain,indexValue,Int.toNat_natCast,
      KeygenCodecStaticByte.byte_again,byte,after,t] using source
  have insideCode : Checked args KeygenPublicEncodeBinding077.node021 s t .normal :=
    seq args _ _ s s t .normal guard (seq args _ _ s t t .normal stored (skip args t))
  have wrapped : Checked args KeygenPublicEncodeBinding077.node022 s t .normal := by
    have source := scope args KeygenPublicEncodeBinding077.node021 s t .normal (by intro impossible; cases impossible) insideCode
    rw [empty_scope _ _ _ rfl] at source
    exact source
  have full : Checked args KeygenPublicEncodeBinding077.node023 s t .normal :=
    branch_true args KeygenPublicEncodeBinding077.guard023 KeygenPublicEncodeBinding077.node022 .skip s t .normal
      (C99ScalarReference.boolean (decide (args.out≠none))) s.locals (.outTest _ context.noOut context.noNull)
      (by simp [context.output,KeygenCodecValues.truth,C99ScalarReference.boolean,C99IntegerReference.Value.integer])
      (by rw [same]; exact wrapped)
  exact ⟨full,KeygenPublicEncodeStore077.exists_store s.heap (byteOff out u) (byte acc p) (legal.2 u inside) rfl legal.1⟩

end FT1536.Source3.KeygenPublicEncodeEmit077
