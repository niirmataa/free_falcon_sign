import CoreStep020E5

namespace FT1536.S05.CoreMeaning020E5
open WordRAM020 ArenaTypes020E1 NodeFrames020E2 FixedAction020E5 CoreState020E5

/-- Specification only: complete the current cached dispatch and continue. -/
def finish {cap capacity : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (left : Nat) (st : ArrayFrames020E4.Stack (Frame cap) capacity) (s : ArrayState020E4.State)
    (v : ArrayValues020E4.Values cap) : Option ArrayState020E4.State :=
  (ArrayFrames020E4.top st).bind (fun fr =>
    (FixedAction020E5.action (ArrayValues020E4.lookup a v) a i s fr).bind (fun r =>
      (ArrayFrames020E4.pushMany (ArrayFrames020E4.drop st 1) (pendingList r.1)).bind
        (fun st' => ArrayExecute020E4.execute a i (left-1) st' (MemoryEdit020E5.apply s r.2))))

def denote {cap capacity limit : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (q : Core cap capacity limit) : Option ArrayState020E4.State := match q.phase with
  | .check | .clear => ArrayExecute020E4.execute a i q.left.val q.frames q.state
  | .scan => finish a i q.left.val q.frames q.state
      (ArrayValues020E4.sweep a q.state (cap-q.cursor.val) q.cursor.val q.values)
  | .act => finish a i q.left.val q.frames q.state q.values
  | .push => (ArrayFrames020E4.pushMany q.frames (pendingList q.pending)).bind
      (fun st => ArrayExecute020E4.execute a i q.left.val st q.state)
  | .done => some q.state
  | .bad => none

theorem finish_build {cap capacity : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (left : Nat) (st : ArrayFrames020E4.Stack (Frame cap) capacity) (s : ArrayState020E4.State)
    (hl : 0<left) (hs : 0<st.sp.val) :
    finish a i left st s (ArrayValues020E4.build a s)=ArrayExecute020E4.execute a i left st s := by
  cases left with
  | zero => omega
  | succ left =>
    rw [ArrayExecute020E4.execute,ite_eq_right (show st.sp.val≠0 by omega)]
    simp only [finish,ArrayExecute020E4.step,Option.bind_assoc]
    apply congrArg ((ArrayFrames020E4.top st).bind)
    funext fr
    rw [ArrayAction020E4.action,←FixedAction020E5.action_refines,Option.bind_map]
    simp only [Option.bind_map,Nat.add_sub_cancel,Function.comp_def,FixedAction020E5.observe]

theorem scan_step {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State)
    (v : ArrayValues020E4.Values cap) (j : Fin (cap+1)) (h : j.val<cap) :
    ArrayValues020E4.sweep a s (cap-(j.val+1)) (j.val+1) (ArrayValues020E4.advance a s v ⟨j.val,h⟩)=
      ArrayValues020E4.sweep a s (cap-j.val) j.val v := by
  have he : cap-j.val=(cap-(j.val+1))+1 := by omega
  conv_rhs => rw [he,ArrayValues020E4.sweep,dite_eq_left h]

theorem terminal_meaning {cap capacity limit : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (q : Core cap capacity limit) (h : terminal q) : denote a i q=result q := by
  rcases h with h|h
  · simp only [denote,result,h,ite_true]
  · simp [denote,result,h]

end FT1536.S05.CoreMeaning020E5
