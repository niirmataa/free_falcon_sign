import CoreMeaning020E5

namespace FT1536.S05.CorePreservation020E5
open WordRAM020 ArenaTypes020E1 NodeFrames020E2 FixedAction020E5 CoreState020E5 CoreMeaning020E5

theorem preserves {cap capacity limit : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (q : Core cap capacity limit) (h : Inv q) : denote a i (CoreStep020E5.step a i q)=denote a i q := by
  cases hp : q.phase <;> simp only [CoreState020E5.Inv,hp] at h
  case check =>
    simp only [CoreStep020E5.step,hp]
    by_cases hs : q.frames.sp.val=0
    · simp only [hs,ite_true,denote,hp]
      cases hl : q.left.val <;> simp only [ArrayExecute020E4.execute,hs,ite_true]
    · simp only [hs,ite_false]
      by_cases hl : q.left.val=0
      · simp only [hl,ite_true,denote,hp,ArrayExecute020E4.execute,hs,ite_false]
      · simp only [hl,ite_false,denote,hp]
  case clear =>
    simp only [CoreStep020E5.step,hp]
    split
    · simp only [denote,hp]
    · rename_i hj
      have he : q.cursor.val=cap := by have := q.cursor.isLt;omega
      have hz := cleared_all q h.2 he
      change finish a i q.left.val q.frames q.state (ArrayValues020E4.sweep a q.state (cap-0) 0 q.values)=_
      rw [Nat.sub_zero,hz]
      simpa only [denote,hp,ArrayValues020E4.build] using finish_build a i q.left.val q.frames q.state h.1.1 h.1.2
  case scan =>
    simp only [CoreStep020E5.step,hp]
    split
    · rename_i hj
      simp only [denote,hp]
      exact congrArg (finish a i q.left.val q.frames q.state) (scan_step a q.state q.values q.cursor hj)
    · rename_i hj
      have he : cap-q.cursor.val=0 := by have := q.cursor.isLt;omega
      simp only [denote,hp,he,ArrayValues020E4.sweep]
  case act =>
    simp only [CoreStep020E5.step,hp]
    cases ht : ArrayFrames020E4.top q.frames with
    | none => simp only [denote,hp,finish,ht,Option.bind_none]
    | some fr =>
      cases ha : FixedAction020E5.action (ArrayValues020E4.lookup a q.values) a i q.state fr with
      | none => simp only [denote,hp,finish,ht,Option.bind_some,ha,Option.bind_none]
      | some r => simp only [denote,hp,finish,ht,Option.bind_some,ha]
  case push =>
    simp only [CoreStep020E5.step,hp]
    cases hq : q.pending with
    | none => simp only [denote,hp,hq,pendingList,ArrayFrames020E4.pushMany,Option.bind_some]
    | one f =>
      dsimp only
      cases hs : ArrayFrames020E4.push q.frames f <;>
        simp only [denote,hp,hq,pendingList,ArrayFrames020E4.pushMany,Option.bind_some,hs,Option.bind_none]
    | two f g =>
      dsimp only
      cases hs : ArrayFrames020E4.push q.frames g <;>
        simp only [denote,hp,hq,pendingList,ArrayFrames020E4.pushMany,Option.bind_some,hs,Option.bind_none]
  case done => simp only [CoreStep020E5.step,hp]
  case bad => simp only [CoreStep020E5.step,hp]

end FT1536.S05.CorePreservation020E5
