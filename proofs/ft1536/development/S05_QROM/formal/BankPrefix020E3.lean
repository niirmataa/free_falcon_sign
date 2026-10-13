import BankStep020E3

set_option exponentiation.threshold 512
namespace FT1536.S05.BankPrefix020E3
open WordRAM020 ArenaTypes020E1 ArenaHeap020E1 NodeFrames020E2

theorem next_length (i : Input) (s : State) (c : Code) : (ControlStack020E.next i c [] s).1.length≤2 := by
  cases c with
  | atom a => exact Nat.zero_le _
  | seq a b => exact le_rfl
  | branch e a b => simp only [ControlStack020E.next];split <;> simp
  | loop n g b =>
    cases n with
    | zero => exact Nat.zero_le _
    | succ n => simp only [ControlStack020E.next];split <;> simp

/-- The temporary action prefix is bounded too; it is never the live stack. -/
theorem action_prefix {cap : Nat} (a : Arena cap) (i : Input) (s : State) (mu : Meaning)
    (hh : HeapValid a mu) (f : Frame cap) (c : Code) (hrel : Rel a mu f c)
    (fs : List (Frame cap)) (t : State) (h : BankAction020E3.action a i s f=some (fs,t)) : fs.length≤2 := by
  rw [BankAction020E3.correct a i s mu hh f] at h
  obtain ⟨gs,hg,hr⟩ := NodeResume020E2.action_correct a i s mu hh f c hrel
  have he := Option.some.inj (hg.symm.trans h)
  have hf : gs=fs := congrArg Prod.fst he
  rw [←hf,hr.length_eq]
  exact next_length i s c

end FT1536.S05.BankPrefix020E3
