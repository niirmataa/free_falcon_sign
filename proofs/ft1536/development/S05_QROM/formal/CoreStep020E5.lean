import CoreState020E5

namespace FT1536.S05.CoreStep020E5
open WordRAM020 ArenaTypes020E1 NodeFrames020E2 FixedAction020E5 CoreState020E5

def step {cap capacity limit : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (q : Core cap capacity limit) : Core cap capacity limit := match q.phase with
  | .check => if q.frames.sp.val=0 then {q with phase := .done} else
      if q.left.val=0 then {q with phase := .bad} else {q with phase := .clear,cursor := 0}
  | .clear => if h : q.cursor.val<cap then
      {q with values := ArrayBank020E4.write q.values ⟨q.cursor.val,h⟩ none, cursor := ⟨q.cursor.val+1,by omega⟩}
      else {q with phase := .scan,cursor := 0}
  | .scan => if h : q.cursor.val<cap then
      {q with values := ArrayValues020E4.advance a q.state q.values ⟨q.cursor.val,h⟩, cursor := ⟨q.cursor.val+1,by omega⟩}
      else {q with phase := .act}
  | .act => match ArrayFrames020E4.top q.frames with
      | none => {q with phase := .bad}
      | some fr => match FixedAction020E5.action (ArrayValues020E4.lookup a q.values) a i q.state fr with
          | none => {q with phase := .bad}
          | some r => {q with state := MemoryEdit020E5.apply q.state r.2, frames := ArrayFrames020E4.drop q.frames 1, phase := .push,pending := r.1, left := ⟨q.left.val-1,by have := q.left.isLt;omega⟩}
  | .push => match q.pending with
      | .none => {q with phase := .check}
      | .one f => match ArrayFrames020E4.push q.frames f with
          | none => {q with phase := .bad}
          | some st => {q with frames := st,pending := .none}
      | .two f g => match ArrayFrames020E4.push q.frames g with
          | none => {q with phase := .bad}
          | some st => {q with frames := st,pending := .one f}
  | .done | .bad => q

theorem terminal_fixed {cap capacity limit : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (q : Core cap capacity limit) (h : terminal q) : step a i q=q := by
  rcases h with h|h <;> simp only [step,h]

theorem clear_prefix {cap capacity limit : Nat} (q : Core cap capacity limit)
    (hc : Cleared q) (hj : q.cursor.val<cap) :
    ∀ k : Fin cap,k.val<q.cursor.val+1 →
      ArrayBank020E4.read (ArrayBank020E4.write q.values ⟨q.cursor.val,hj⟩ none) k=none := by
  intro k hk
  rw [ArrayBank020E4.read_write]
  by_cases he : k.val=q.cursor.val
  · have he' : k=(⟨q.cursor.val,hj⟩ : Fin cap) := Fin.ext he
    simp [he']
  · rw [Function.update_of_ne (by intro e;exact he (congrArg Fin.val e))]
    exact hc k (by omega)

theorem inv {cap capacity limit : Nat} (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)
    (q : Core cap capacity limit) (h : Inv q) : Inv (step a i q) := by
  cases hp : q.phase <;> simp only [CoreState020E5.Inv,hp] at h
  case check =>
    simp only [step,hp]
    split
    · trivial
    · rename_i hs
      split
      · trivial
      · rename_i hl
        change Ready _ ∧ Cleared _
        refine ⟨⟨by dsimp;omega,by dsimp;omega⟩,?_⟩
        intro k hk
        change k.val<0 at hk
        omega
  case clear =>
    simp only [step,hp]
    split
    · rename_i hj
      simp only [CoreState020E5.Inv]
      exact ⟨h.1,clear_prefix q h.2 hj⟩
    · exact h.1
  case scan =>
    simp only [step,hp]
    split <;> simpa only [CoreState020E5.Inv,Ready] using h
  case act =>
    simp only [step,hp]
    split
    · trivial
    · split <;> trivial
  case push =>
    simp only [step,hp]
    cases hq : q.pending <;> dsimp only
    · trivial
    · split <;> simp only [CoreState020E5.Inv]
    · split <;> simp only [CoreState020E5.Inv]
  case done => simp only [step,CoreState020E5.Inv,hp]
  case bad => simp only [step,CoreState020E5.Inv,hp]

end FT1536.S05.CoreStep020E5
