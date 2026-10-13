import ArrayAction020E4

set_option exponentiation.threshold 512
namespace FT1536.S05.ArrayPrefix020E4
open WordRAM020 SyntaxTape020E ArenaTypes020E1 NodeFrames020E2 ArrayAction020E4

theorem loop_prefix {cap : Nat} (f : Ptr cap → Option Word) (s : ArrayState020E4.State)
    (pc body guard : Ptr cap) (remaining : Nat) (q : Action cap)
    (h : loopAction f s pc body guard remaining=some q) : q.1.length≤2 := by
  unfold loopAction at h
  split at h
  · cases Option.some.inj h
    simp
  · cases hg : f guard with
    | none => simp only [hg,Option.bind_none] at h;cases h
    | some v =>
      simp only [hg,Option.bind_some] at h
      split at h
      · cases Option.some.inj h
        simp
      · cases hc : count (remaining-1) with
        | none => simp only [hc,Option.map_none] at h;cases h
        | some k =>
          simp only [hc,Option.map_some] at h
          cases Option.some.inj h
          simp

theorem empty_prefix {cap : Nat} (o : Option ArrayState020E4.State) (q : Action cap)
    (h : o.map (fun s => ([],s))=some q) : q.1.length≤2 := by
  cases o with
  | none => cases h
  | some s => cases Option.some.inj h;exact Nat.zero_le 2

theorem dispatch_prefix {cap : Nat} (f : Ptr cap → Option Word) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (pc : Ptr cap) (n : Node cap) (t : Token) (q : Action cap)
    (h : dispatch f i s pc n t=some q) : q.1.length≤2 := by
  cases t
  case seq => cases Option.some.inj h;simp
  case branch =>
    simp only [dispatch] at h
    cases hf : f n.third with
    | none => simp only [hf,Option.map_none] at h;cases h
    | some w => simp only [hf,Option.map_some] at h;cases Option.some.inj h;simp
  case loop k => exact loop_prefix f s pc n.first n.second k q h
  case literal w => cases h
  case register r => cases h
  case binary o => cases h
  all_goals exact empty_prefix _ q h

theorem evaluator_prefix {cap : Nat} (f : Ptr cap → Option Word) (a : ArrayArena020E4.Arena cap)
    (i : ArrayState020E4.Input) (s : ArrayState020E4.State) (fr : Frame cap) (q : Action cap)
    (h : withEvaluator f a i s fr=some q) : q.1.length≤2 := by
  cases fr with
  | run pc =>
    simp only [withEvaluator,start] at h
    cases hi : NodeRead020E2.inspect (ArrayArena020E4.model a) pc with
    | none => simp only [hi,Option.bind_none] at h;cases h
    | some nt =>
      simp only [hi,Option.bind_some] at h
      exact dispatch_prefix f i s pc nt.1 nt.2 q h
  | again pc remaining =>
    simp only [withEvaluator,resume] at h
    cases hi : NodeRead020E2.inspect (ArrayArena020E4.model a) pc with
    | none => simp only [hi,Option.bind_none] at h;cases h
    | some nt =>
      rcases nt with ⟨n,t⟩
      simp only [hi,Option.bind_some] at h
      cases t
      case loop limit =>
        dsimp only at h
        by_cases hn : remaining.val≤limit
        · rw [ite_eq_left hn] at h
          exact loop_prefix f s pc n.first n.second remaining.val q h
        · rw [ite_eq_right hn] at h
          cases h
      all_goals cases h

theorem action_prefix {cap : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (s : ArrayState020E4.State) (fr : Frame cap) (q : Action cap)
    (h : action a i s fr=some q) : q.1.length≤2 := evaluator_prefix _ a i s fr q h

end FT1536.S05.ArrayPrefix020E4
