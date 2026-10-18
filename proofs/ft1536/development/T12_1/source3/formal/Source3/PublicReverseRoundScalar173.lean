import Source3.PublicReverseRoundBody173

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicReverseRoundScalar173
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenPublicWord (Eval)
open KeygenNttLoopSupport (USlot u64)
open PublicReverseRoundContext173 (Arrays)

theorem guard (s : State) (t : Nat) (bound : t<2^64) (slot : USlot s "t" t) (n : USlot s "n" 1536) :
    Eval [] s KeygenPublicReverseProgram.stageGuard (C99ScalarReference.boolean (decide (t<1536))) :=
  .cmp .lt _ _ _ _ _
    (.scalar _ _ (PublicGenerateIndex159.var_u64 s "t" t slot))
    (.scalar _ _ (PublicGenerateIndex159.var_u64 s "n" 1536 n))
    (C99NatWord141.less t 1536 bound (by decide))

theorem increment (s : State) (m : Nat) (bound : m<2^64) (slot : USlot s "m" m) :
    Exec KeygenPublicSource.program [] KeygenPublicReverseProgram.stageStep s
      ⟨bindValue s "m".toList .uint64 (u64 (m/2)),.normal⟩ :=
  .assign _ _ _ .uint64 (some (u64 m)) (u64 (m/2)) slot
    (.bin .shr _ _ _ _ _ (.scalar _ _ (PublicGenerateIndex159.var_u64 s "m" m slot))
      (PublicGenerateHead159.eval_lit s 1) (C99OuterScalar144.half_word m bound))

theorem arrays_increment (s : State) (a gm : ArrayPointer) (m : Nat) (ctx : Arrays s a gm) :
    Arrays (bindValue s "m".toList .uint64 (u64 (m/2))) a gm :=
  PublicReverseRoundContext173.transfer s _ a gm ctx rfl (PublicGroupBody162.same_heap_frame s _ a rfl)

end FT1536.Source3.PublicReverseRoundScalar173
