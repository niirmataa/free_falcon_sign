import Source3.PublicRoundBody163

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicRoundScalar163
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open C99IntegerReference (Value CompareExec)
open KeygenPublicExec (Exec)
open KeygenPublicWord (Eval)
open KeygenPublicTableAtoms (var)
open KeygenNttLoopSupport (USlot u64)
open PublicRoundContext163 (Arrays)

theorem greater_three (t : Nat) (bound : t < 2^64) :
    CompareExec .gt (u64 t) (.int32 3) (C99ScalarReference.boolean (decide (3 < t))) := by
  have raw := CompareExec.step .gt (u64 t) (.int32 3) .uint64 rfl (u64 t) (u64 3)
    (C99CountedWords.convert_self (u64 t)).symm rfl
  change CompareExec .gt (u64 t) (.int32 3)
    (C99ScalarReference.boolean (decide ((u64 3).integer < (u64 t).integer))) at raw
  rw [KeygenNttLoopSupport.u64_integer t bound,KeygenNttLoopSupport.u64_integer 3 (by decide)] at raw
  have same : (((3 : Nat) : Int) < (t : Int)) ↔ (3 : Nat) < t := by omega
  simpa only [same] using raw

theorem guard (s : State) (t : Nat) (bound : t < 2^64) (slot : USlot s "t" t) :
    Eval [] s PublicTailShape159.midGuard (C99ScalarReference.boolean (decide (3 < t))) :=
  .cmp .gt _ _ _ _ _
    (.scalar _ _ (PublicGenerateIndex159.var_u64 s "t" t slot))
    (PublicGenerateHead159.eval_lit s 3) (greater_three t bound)

theorem increment (s : State) (m : Nat) (bound : m < 2^64) (slot : USlot s "m" m) :
    Exec KeygenPublicSource.program [] PublicTailShape159.midInc s
      ⟨bindValue s "m".toList .uint64 (u64 (m*2)),.normal⟩ :=
  .assign _ _ _ .uint64 (some (u64 m)) (u64 (m*2)) slot
    (.bin .shl _ _ _ _ _ (.scalar _ _ (PublicGenerateIndex159.var_u64 s "m" m slot))
      (PublicGenerateHead159.eval_lit s 1) (C99ControlShift142.double_word m bound))

theorem arrays_increment (s : State) (a gm : ArrayPointer) (m : Nat)
    (ctx : Arrays s a gm) : Arrays (bindValue s "m".toList .uint64 (u64 (m*2))) a gm :=
  PublicRoundContext163.transfer s _ a gm ctx rfl (PublicGroupBody162.same_heap_frame s _ a rfl)

end FT1536.Source3.PublicRoundScalar163
