import Source3.KeygenDecodeStaticUnaryLoop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source ne>255 rejection and lo+=(ne<<j), with ne and low8 derived from
   the actual source bit stream. No successful decoder is an assumption. -/
namespace FT1536.Source3.KeygenDecodeStaticMagnitude
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified KeygenDecodeWordOps

theorem quotient_shift (m : Nat) (bound : m≤32768) :
    ((BitVec.ofNat 32 (m/256)) <<< 8).toNat=(m/256)*256 := by
  have quotient : m/256≤128 := by omega
  rw [BitVec.toNat_shiftLeft,BitVec.toNat_ofNat,Nat.mod_eq_of_lt (show m/256<2^32 by omega),Nat.shiftLeft_eq]
  change ((m/256)*256)%2^32=(m/256)*256
  exact Nat.mod_eq_of_lt (by omega)

theorem joined_magnitude (m : Nat) (bound : m≤32768) :
    BitVec.ofNat 32 (m%256)+((BitVec.ofNat 32 (m/256)) <<< 8)=BitVec.ofNat 32 m := by
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_add,BitVec.toNat_ofNat,quotient_shift m bound]
  have lowBound : m%256<2^32 := by have h:=Nat.mod_lt m (by decide +kernel : 0<256); omega
  rw [Nat.mod_eq_of_lt lowBound]
  have joined : m%256+(m/256)*256=m := by simpa only [Nat.mul_comm] using Nat.mod_add_div m 256
  rw [joined]
  rfl

theorem guard_calculation (args : Args) (s : State) (q : Nat) (bound : q≤128)
    (counter : Cell "ne" .uint32 (.uint32 (BitVec.ofNat 32 q)) s.locals) :
    KeygenDecodeCalculation.Computes args s.heap s.buf s.locals KeygenDecodeStaticBinding.guard075 (.int32 0) := by
  apply KeygenDecodeCalculation.Computes.binary _ _ _ _ _ _
    (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) counter)
    (.number .i32 255 (.int32 255) (by decide +kernel))
  apply BinaryOp.gt
  have comparison := KeygenDecodeStaticScalarTests.mixed_comparison .gt q 255 (by omega) (by decide +kernel)
  have no : ¬(255 : Nat)<q := by omega
  simpa only [C99IntegerReference.compare,Int.ofNat_lt,no,decide_false,C99ScalarReference.boolean,Bool.false_eq_true,ite_false,
    show (255#32 : BitVec 32)=255 by decide +kernel,show (0#32 : BitVec 32)=0 by decide +kernel] using comparison

theorem source_guard (args : Args) (s : State) (q : Nat) (bound : q≤128)
    (counter : Cell "ne" .uint32 (.uint32 (BitVec.ofNat 32 q)) s.locals) :
    Checked args KeygenDecodeStaticBinding.node075 s s .normal := by
  have same : withLocals s s.locals=s := by cases s; rfl
  exact branch_false args KeygenDecodeStaticBinding.guard075 KeygenDecodeStaticBinding.node074 .skip
    s s .normal (.int32 0) s.locals (.pure _ _ _ (guard_calculation args s q bound counter)) (by decide +kernel)
    (by rw [same]; exact skip args s)

def after (s : State) (m : Nat) : State :=
  withLocals s (localSet s.locals "lo".toList .uint32 (some (.uint32 (BitVec.ofNat 32 m))))

theorem source_join (args : Args) (s : State) (m : Nat) (bound : m≤32768)
    (low : Cell "lo" .uint32 (.uint32 (BitVec.ofNat 32 (m%256))) s.locals)
    (counter : Cell "ne" .uint32 (.uint32 (BitVec.ofNat 32 (m/256))) s.locals)
    (j : Cell "j" .uint32 (.uint32 8) s.locals) :
    Checked args KeygenDecodeStaticBinding.node076 s (after s m) .normal := by
  have shifted : KeygenDecodeCalculation.Computes args s.heap s.buf s.locals
      (.binary .shl (.variable "ne".toList) (.variable "j".toList))
      (.uint32 ((BitVec.ofNat 32 (m/256)) <<< 8)) := by
    apply KeygenDecodeCalculation.Computes.binary _ _ _ _ _ _
      (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) counter)
      (.scalar _ _ _ (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) j)
    apply BinaryOp.shl
    simpa only [show (8#32 : BitVec 32)=8 by decide +kernel] using
      KeygenDecodeStaticWordOps.left_uint32 (BitVec.ofNat 32 (m/256)) 8 (by decide +kernel)
  have add := add32 (BitVec.ofNat 32 (m%256)) ((BitVec.ofNat 32 (m/256)) <<< 8)
  rw [joined_magnitude m bound] at add
  have source := compound args s "lo".toList .uint32 (.uint32 (BitVec.ofNat 32 (m%256))) .add .add
    (.binary .shl (.variable "ne".toList) (.variable "j".toList))
    (.uint32 ((BitVec.ofNat 32 (m/256)) <<< 8)) (.uint32 (BitVec.ofNat 32 m)) s.locals
    (by decide +kernel) (by decide +kernel) low rfl (.pure _ _ _ shifted) (.add _ _ _ add)
  simpa only [self32,KeygenDecodeStaticBinding.node076,after] using source

end FT1536.Source3.KeygenDecodeStaticMagnitude
