import Source3.PublicNormalizeBody174

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicNormalizeLoop174
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenPublicWord (Eval)
open KeygenNttLoopSupport (USlot u64)
open PublicNormalizeBody174 (Fixed)

theorem fixed_next (s : State) (a : ArrayPointer) (fixed : Fixed s a) (u : Nat) :
    Fixed (bindValue s "u".toList .uint64 (u64 (u+1))) a :=
  ⟨fixed.data,fixed.binding,fixed.length,fixed.factor⟩

theorem guard (s : State) (u : Nat) (bound : u≤1536) (counter : USlot s "u" u) (n : USlot s "n" 1536) :
    Eval [] s KeygenPublicNormalizeProgram.guard (C99ScalarReference.boolean (decide (u<1536))) :=
  .cmp .lt _ _ _ _ _ (.scalar _ _ (PublicGenerateIndex159.var_u64 s "u" u counter))
    (.scalar _ _ (PublicGenerateIndex159.var_u64 s "n" 1536 n)) (C99NatWord141.less u 1536 (by omega) (by decide))

theorem remaining (count u : Nat) (s : State) (a : ArrayPointer) (fixed : Fixed s a)
    (counter : USlot s "u" u) (finish : u+count=1536) :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicNormalizeProgram.loop s ⟨after,.normal⟩ ∧
      Fixed after a ∧ USlot after "u" 1536 ∧ PublicInitializedFrame164.Frame s.heap after.heap := by
  induction count generalizing u s with
  | zero =>
    have equal : u=1536 := by omega
    subst u
    exact ⟨s,.loopFalse _ _ _ _ _ (guard s 1536 (by decide) counter fixed.length) (by decide),
      fixed,counter,PublicInitializedFrame164.refl s.heap⟩
  | succ count ih =>
    have inside : u<1536 := by omega
    obtain ⟨middle,run,midFixed,midCounter,memory⟩ := PublicNormalizeBody174.source s a u inside fixed counter
    let next := bindValue middle "u".toList .uint64 (u64 (u+1))
    have step := PublicRootLoop174.increment middle u (by omega) midCounter
    obtain ⟨after,rest,last,lastCounter,restMemory⟩ := ih (u+1) next (fixed_next middle a midFixed u)
      (PublicGenerateRow159.u64_slot_after middle "u" (u+1) (by omega)) (by omega)
    have yes : Eval [] s KeygenPublicNormalizeProgram.guard (C99ScalarReference.boolean true) := by
      simpa only [inside,decide_true] using guard s u (by omega) counter fixed.length
    exact ⟨after,.loopNormal _ _ _ s middle next ⟨after,.normal⟩ (C99ScalarReference.boolean true)
      yes (by decide) run step rest,last,lastCounter,PublicInitializedFrame164.trans _ _ _ memory restMemory⟩

end FT1536.Source3.PublicNormalizeLoop174
