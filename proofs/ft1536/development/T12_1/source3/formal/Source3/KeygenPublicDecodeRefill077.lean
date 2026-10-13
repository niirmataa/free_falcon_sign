import Source3.KeygenPublicDecodeRead077
import Source3.KeygenPublicDecodeSequence077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicDecodeRefill077
open KeygenDecodeSyntax KeygenDecodeValues KeygenPublicDecodeExecution077 C99MemoryReference
open KeygenDecodeDynamicCalculation KeygenPublicDecodeCertified077 KeygenPublicDecodeReady077

def pieces : List Stmt := [KeygenPublicDecodeBinding077.node013,KeygenPublicDecodeBinding077.node014,KeygenPublicDecodeBinding077.node015]
def code : Stmt := KeygenPublicDecodeSequence077.chain pieces .skip
def after (s : State) (u p : Nat) (acc : BitVec 32) (byte : BitVec 8) : State :=
  setPending (KeygenPublicDecodeRead077.after s u acc byte) (p+8)

theorem refill (args : Args) (s : State) (src ptr atByte : ArrayPointer) (n u p : Nat) (acc : BitVec 32) (byte : BitVec 8)
    (small : p<15) (available : u<args.len.toNat) (ready : Ready args src ptr n u p acc s)
    (advance : PointerAdd src u atByte) (load : LoadByte s.heap atByte byte) :
    Checked args code s (after s u p acc byte) .normal ∧
      Ready args src ptr n (u+1) (p+8) (KeygenPublicDecodeBits077.appended acc byte) (after s u p acc byte) ∧
      (after s u p acc byte).heap=s.heap := by
  let s1 := KeygenPublicDecodeRead077.after s u acc byte
  let s2 := after s u p acc byte
  have same : withLocals s s.locals=s := by cases s; rfl
  have gateCalc : KeygenDecodeCalculation.Computes args s.heap s.buf s.locals KeygenPublicDecodeBinding077.guard013 (.int32 0) :=
    .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) ready.cursor)
      (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) ready.context.length)
      (.ge _ _ _ (KeygenDecodeStaticInputGate.comparison u args.len available))
  have gate : Checked args KeygenPublicDecodeBinding077.node013 s s .normal :=
    branch_false args KeygenPublicDecodeBinding077.guard013 KeygenPublicDecodeBinding077.node012 .skip s s .normal
      (.int32 0) s.locals (.pure _ _ _ gateCalc) (by decide +kernel) (by rw [same]; exact skip args s)
  have read := KeygenPublicDecodeRead077.source_append args s u (by have limit:=args.len.isLt; omega)
    src atByte byte acc ready.cursor ready.accumulator ready.context.buffer advance load
  have pending1 := (KeygenPublicDecodeCellFrame077.exec_frame "acc_len".toList args _ s s1 .normal read.run (by decide +kernel)).trans ready.pending
  have count : Checked args KeygenPublicDecodeBinding077.node015 s1 s2 .normal := by
    have source := compound args s1 "acc_len".toList .int32 (.int32 (BitVec.ofNat 32 p)) .add .add
      (.number .i32 8) (.int32 8) (.int32 (BitVec.ofNat 32 (p+8))) s1.locals
      (by decide +kernel) (by decide +kernel) pending1 rfl (.pure _ _ _ (.number _ _ _ (by decide +kernel)))
      (.add _ _ _ (KeygenPublicInteger077.plus_i32 p 8 (by omega)))
    simpa only [KeygenPublicInteger077.self_i32,KeygenPublicDecodeBinding077.node015,setPending,after,s2,s1] using source
  have full : Checked args code s s2 .normal := seq args _ _ s s s2 .normal gate
    (seq args _ _ s s1 s2 .normal read (seq args _ _ s1 s2 s2 .normal count (skip args s2)))
  have context := context_frame args src s s2 code .normal full.run (by unfold Checks; decide +kernel) ready.context
  have remaining := (KeygenPublicDecodeCellFrame077.exec_frame "n".toList args _ s s2 .normal full.run (by decide +kernel)).trans ready.remaining
  exact ⟨full,⟨context,ready.pointer,remaining,by rfl,by rfl,by rfl⟩,rfl⟩

end FT1536.Source3.KeygenPublicDecodeRefill077
