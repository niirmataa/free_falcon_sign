import Source3.KeygenPublicDecodeExtractCalc077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicDecodeExtract077
open KeygenDecodeSyntax KeygenDecodeValues KeygenPublicDecodeExecution077 C99MemoryReference
open KeygenDecodeDynamicCalculation KeygenPublicDecodeCertified077 KeygenPublicDecodeReady077
open KeygenPublicDecodeExtractCalc077

def freshW (s : State) : State := withLocals s (localSet s.locals "w".toList .uint32 none)
def afterStore (s : State) (ptr next : ArrayPointer) (input : BitVec 16) : State :=
  ⟨KeygenDecodeWrite16.overwrite s.heap ptr input,{s.locals with x := some next},s.buf⟩

theorem extract (args : Args) (s : State) (src ptr next : ArrayPointer) (n u p : Nat)
    (acc : BitVec 32) (input : BitVec 16) (positive : 1≤n) (fits : 15≤p) (small : p<23)
    (canonical : input.toNat<18433) (recovered : acc >>> (p-15)=input.setWidth 32)
    (ready : Ready args src ptr n u p acc s) (advance : PointerAdd ptr 1 next)
    (allocated : Allocated s.heap ptr) (width : ptr.elementBytes=2) (writable : s.heap.writable ptr.block=true) :
    ∃ t, Checked args KeygenPublicDecodeBinding077.node035 s t .normal ∧
      Ready args src next (n-1) u (p-15) (KeygenPublicBits077.masked (p-15) acc) t ∧
      Store16 s.heap ptr input t.heap := by
  let s0 := freshW s
  let s1 := setPending s0 (p-15)
  let s2 := set32 s1 "w" (input.setWidth 32)
  let s3 := afterStore s2 ptr next input
  let s4 := set64 s3 "n" (BitVec.ofNat 64 (n-1))
  let s5 := set32 s4 "acc" (KeygenPublicBits077.masked (p-15) acc)
  let t := scopeExit KeygenPublicDecodeBinding077.node034 s s5
  have declareW : Checked args KeygenPublicDecodeBinding077.node016 s s0 .normal :=
    KeygenPublicDecodeCertified077.declare args s [⟨"w".toList,.u32,none⟩] s0.locals rfl
  have pending0 : Cell "acc_len" .int32 (.int32 (BitVec.ofNat 32 p)) s0.locals := ready.pending
  have drop : Checked args KeygenPublicDecodeBinding077.node017 s0 s1 .normal := by
    have source := compound args s0 "acc_len".toList .int32 (.int32 (BitVec.ofNat 32 p)) .sub .sub
      (.number .i32 15) (.int32 15) (.int32 (BitVec.ofNat 32 (p-15))) s0.locals
      (by decide +kernel) (by decide +kernel) pending0 rfl (.pure _ _ _ (.number _ _ _ (by decide +kernel)))
      (.sub _ _ _ (KeygenPublicInteger077.minus_i32 p 15 fits (by omega)))
    simpa only [KeygenPublicInteger077.self_i32,KeygenPublicDecodeBinding077.node017,setPending,s1] using source
  have shifted : Checked args KeygenPublicDecodeBinding077.node018 s1 s2 .normal := by
    have calculation := shift_calculation args s1 (p-15) acc (by omega) (by rfl) ready.accumulator
    rw [recovered] at calculation
    have source := assign args s1 "w".toList .uint32 none shiftRhs (.uint32 (input.setWidth 32)) s1.locals
      (by decide +kernel) (by decide +kernel) rfl (.pure _ _ _ calculation)
    simpa only [KeygenDecodeWordOps.self32,KeygenPublicDecodeBinding077.node018,shiftRhs,set32,s2] using source
  have same2 : withLocals s2 s2.locals=s2 := by cases s2; rfl
  have gate : Checked args KeygenPublicDecodeBinding077.node023 s2 s2 .normal :=
    branch_false args KeygenPublicDecodeBinding077.guard023 KeygenPublicDecodeBinding077.node022 .skip s2 s2 .normal
      (.int32 0) s2.locals (.pure _ _ _ (word_calculation args s2 input canonical rfl)) (by decide +kernel)
      (by rw [same2]; exact skip args s2)
  have stored : Checked args KeygenPublicDecodeBinding077.node024 s2 s3 .normal := by
    have calculation : KeygenDecodeCalculation.Computes args s2.heap s2.buf {s2.locals with x := some next}
        (.cast .u16 (.variable "w".toList)) (promoted input) :=
      .cast _ _ _ _ (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) rfl) (cast_input input)
    have source := KeygenPublicDecodeStore077.store args s2 (.cast .u16 (.variable "w".toList)) ptr next (promoted input)
      ready.pointer advance (.pure _ _ _ calculation) allocated width writable
    rw [narrowed] at source
    exact source
  have remaining3 : Cell "n" .uint64 (.uint64 (BitVec.ofNat 64 n)) s3.locals := ready.remaining
  have decrement := KeygenPublicInteger077.decrement64 (BitVec.ofNat 64 n)
  rw [show (1 : BitVec 64)=BitVec.ofNat 64 1 by decide +kernel,
    BitVec.ofNat_sub_ofNat_of_le n 1 (by decide +kernel) positive] at decrement
  have update : ScalarUpdate "n".toList (-1) s3.locals (.uint64 (BitVec.ofNat 64 n))
      (.uint64 (BitVec.ofNat 64 (n-1))) s4.locals :=
    .scalar (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) .uint64 remaining3 _ decrement
      (KeygenDecodeStaticOuterCounter.self64 _).symm rfl
  have count : Checked args KeygenPublicDecodeBinding077.node025 s3 s4 .normal :=
    evaluate args s3 _ _ _ (.postDec _ _ _ _ _ update)
  have mask : Checked args KeygenPublicDecodeBinding077.node026 s4 s5 .normal := by
    have source := compound args s4 "acc".toList .uint32 (.uint32 acc) .band .band maskRhs
      (.uint32 (BitVec.ofNat 32 (2^(p-15)-1))) (.uint32 (KeygenPublicBits077.masked (p-15) acc)) s4.locals
      (by decide +kernel) (by decide +kernel) ready.accumulator rfl
      (.pure _ _ _ (mask_calculation args s4 (p-15) (by omega) (by rfl))) (.band _ _ _ (KeygenDecodeWordOps.and32 _ _))
    simpa only [KeygenDecodeWordOps.self32,KeygenPublicDecodeBinding077.node026,maskRhs,set32,s5] using source
  have body : Checked args KeygenPublicDecodeBinding077.node034 s s5 .normal :=
    seq args _ _ s s0 s5 .normal declareW (seq args _ _ s0 s1 s5 .normal drop
      (seq args _ _ s1 s2 s5 .normal shifted (seq args _ _ s2 s2 s5 .normal gate
        (seq args _ _ s2 s3 s5 .normal stored (seq args _ _ s3 s4 s5 .normal count
          (seq args _ _ s4 s5 s5 .normal mask (skip args s5)))))))
  have full : Checked args KeygenPublicDecodeBinding077.node035 s t .normal :=
    scope args _ s s5 .normal (by intro impossible; cases impossible) body
  have context := context_frame args src s t _ .normal full.run (by unfold Checks; decide +kernel) ready.context
  have cursor := (KeygenPublicDecodeCellFrame077.exec_frame "u".toList args _ s t .normal full.run (by decide +kernel)).trans ready.cursor
  exact ⟨t,full,⟨context,by rfl,by rfl,cursor,by rfl,by rfl⟩,
    KeygenDecodeWrite16.exists_store s.heap ptr input allocated width writable⟩

end FT1536.Source3.KeygenPublicDecodeExtract077
