import CoreControl020E5

namespace FT1536.S05.CoreDataPatch020E5
open WordRAM020 ArenaTypes020E1 NodeFrames020E2 FixedAction020E5 CoreState020E5 CoreFieldPatch020E5 VerifiedPatch020E5

abbrev BoundedProgram {n : Nat} (a b : ArrayBank020E4.Bank Word n) := {p : Program a b // p.code.length≤3}

section
variable {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)

def edit (q : Core cap capacity limit) (e : MemoryEdit020E5.Edit) :
    BoundedProgram (image hc hf hl q) (image hc hf hl (CoreData020E5.edit q e)) := by
  cases e
  case keep => exact ⟨identity _,by simp [identity]⟩
  case fault => exact ⟨identity _,by simp [identity]⟩
  case reg r w => exact ⟨reg hc hf hl q r w,by rw [reg_length];omega⟩
  case ram r w => exact ⟨ram hc hf hl q r w,by rw [ram_length];omega⟩
  case out r w => exact ⟨out hc hf hl q r w,by rw [out_length];omega⟩

def push (q : Core cap capacity limit) (f : Frame cap) :
    BoundedProgram (image hc hf hl q) (image hc hf hl (CoreData020E5.pushData q f)) := by
  unfold CoreData020E5.pushData
  split
  · rename_i h
    exact ⟨frames hc hf hl q ⟨q.frames.sp.val,h⟩ f,(frames_length hc hf hl q _ f).le⟩
  · exact ⟨identity _,by simp [identity]⟩

def program (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input) (q : Core cap capacity limit) :
    BoundedProgram (image hc hf hl q) (image hc hf hl (CoreData020E5.next a i q)) := by
  unfold CoreData020E5.next
  cases hp : q.phase
  case clear =>
    dsimp only
    split
    · rename_i h
      exact ⟨values hc hf hl q ⟨q.cursor.val,h⟩ none,by rw [values_length];omega⟩
    · exact ⟨identity _,by simp [identity]⟩
  case scan =>
    dsimp only
    split
    · rename_i h
      exact ⟨values hc hf hl q ⟨q.cursor.val,h⟩ (ArrayValues020E4.entry a q.state q.values ⟨q.cursor.val,h⟩),by rw [values_length];omega⟩
    · exact ⟨identity _,by simp [identity]⟩
  case act =>
    dsimp only
    cases ht : ArrayFrames020E4.top q.frames with
    | none => exact ⟨identity _,by simp [identity]⟩
    | some f =>
      dsimp only
      cases ha : FixedAction020E5.action (ArrayValues020E4.lookup a q.values) a i q.state f with
      | none => exact ⟨identity _,by simp [identity]⟩
      | some r => exact edit hc hf hl q r.2
  case push =>
    cases hq : q.pending
    · exact ⟨identity _,by simp [identity]⟩
    · exact push hc hf hl q _
    · exact push hc hf hl q _
  all_goals exact ⟨identity _,by simp [identity]⟩

end
end FT1536.S05.CoreDataPatch020E5
