import ValueBank020E3

namespace FT1536.S05.ValueScan020E3
open WordRAM020 ArenaTypes020E1 ValueBank020E3

structure Report (cap : Nat) where
  values : Values cap
  writes : Nat

/-- Counter for actual advance calls; this does not price arithmetic or reads. -/
def measured {cap : Nat} (a : Arena cap) (s : State) : Nat → Nat → Values cap → Report cap
  | 0,_,v => ⟨v,0⟩
  | fuel+1,j,v => if h : j<cap then
      let r := measured a s fuel (j+1) (advance a s v ⟨j,h⟩)
      ⟨r.values,1+r.writes⟩
    else ⟨v,0⟩

theorem values_eq {cap : Nat} (a : Arena cap) (s : State) (fuel start : Nat) (v : Values cap) :
    (measured a s fuel start v).values=sweep a s fuel start v := by
  induction fuel generalizing start v with
  | zero => rfl
  | succ fuel ih =>
    simp only [measured,sweep]
    split
    · exact ih _ _
    · rfl

theorem writes_eq {cap : Nat} (a : Arena cap) (s : State) (fuel start : Nat) (v : Values cap)
    (room : start+fuel≤cap) : (measured a s fuel start v).writes=fuel := by
  induction fuel generalizing start v with
  | zero => rfl
  | succ fuel ih =>
    have hs : start<cap := by omega
    rw [measured,dite_eq_left hs]
    change 1+(measured a s fuel (start+1) (advance a s v ⟨start,hs⟩)).writes=fuel+1
    rw [ih (start+1) _ (by omega)]
    omega

theorem full_scan {cap : Nat} (a : Arena cap) (s : State) :
    (measured a s cap 0 (fun _ => none)).values=build a s ∧
      (measured a s cap 0 (fun _ => none)).writes=cap :=
  ⟨values_eq a s cap 0 _,writes_eq a s cap 0 _ (by omega)⟩

theorem actual_scan (a : Arena 877) (s : State) :
    (measured a s 877 0 (fun _ => none)).writes=877 := (full_scan a s).2

end FT1536.S05.ValueScan020E3
