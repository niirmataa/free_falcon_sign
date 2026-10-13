import CoreStep020E5

namespace FT1536.S05.CoreRank020E5
open WordRAM020 ArenaTypes020E1 NodeFrames020E2 FixedAction020E5 CoreState020E5

def cycle (cap : Nat) : Nat := 2*cap+8

def rank {cap capacity limit : Nat} (q : Core cap capacity limit) : Nat := match q.phase with
  | .check => q.left.val*cycle cap+1
  | .clear => (q.left.val-1)*cycle cap+(2*cap-q.cursor.val+7)
  | .scan => (q.left.val-1)*cycle cap+(cap-q.cursor.val+6)
  | .act => (q.left.val-1)*cycle cap+5
  | .push => q.left.val*cycle cap+(pendingList q.pending).length+2
  | .done | .bad => 0

theorem positive {cap capacity limit : Nat} (q : Core cap capacity limit) (h : ¬terminal q) : 0<rank q := by
  cases hp : q.phase <;> simp only [rank,hp]
  all_goals first | omega | (exfalso;apply h;simp [terminal,hp])

theorem decreases {cap capacity limit : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (q : Core cap capacity limit) (h : ¬terminal q) : rank (CoreStep020E5.step a i q)<rank q := by
  have hj := q.cursor.isLt
  cases hp : q.phase
  case check =>
    simp only [CoreStep020E5.step,hp]
    split
    · simp only [rank,hp];omega
    · split
      · simp only [rank,hp];omega
      · rename_i hl
        have hmul : cycle cap≤q.left.val*cycle cap := by
          simpa only [Nat.one_mul] using Nat.mul_le_mul_right (cycle cap) (show 1≤q.left.val by omega)
        simp only [rank,hp,Nat.sub_mul,Nat.one_mul]
        unfold cycle at hmul ⊢
        omega
  case clear =>
    simp only [CoreStep020E5.step,hp]
    split <;> simp only [rank,hp] <;> omega
  case scan =>
    simp only [CoreStep020E5.step,hp]
    split <;> simp only [rank,hp] <;> omega
  case act =>
    simp only [CoreStep020E5.step,hp]
    cases ht : ArrayFrames020E4.top q.frames with
    | none => simp only [rank,hp];omega
    | some fr =>
      dsimp only
      cases ha : FixedAction020E5.action (ArrayValues020E4.lookup a q.values) a i q.state fr with
      | none => simp only [rank,hp];omega
      | some r =>
        have hb := pending_bound r.1
        simp only [rank,hp]
        omega
  case push =>
    simp only [CoreStep020E5.step,hp]
    cases hq : q.pending with
    | none => simp only [rank,hp,hq,pendingList,List.length_nil];omega
    | one f =>
      dsimp only
      cases ArrayFrames020E4.push q.frames f <;>
        simp only [rank,hp,hq,pendingList,List.length_cons,List.length_nil] <;> omega
    | two f g =>
      dsimp only
      cases ArrayFrames020E4.push q.frames g <;>
        simp only [rank,hp,hq,pendingList,List.length_cons,List.length_nil] <;> omega
  case done => exfalso;apply h;simp [terminal,hp]
  case bad => exfalso;apply h;simp [terminal,hp]

end FT1536.S05.CoreRank020E5
