import CostValueCell020E4

namespace FT1536.S05.CostValues020E4
open WordRAM020 CostRun020E4 CostFlow020E4

abbrev Values := ArrayValues020E4.Values

def advance {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State)
    (v : Values cap) (k : Fin cap) : Run (Values cap) :=
  CostRun020E4.bind (CostValueCell020E4.entry a s v k) (fun w => CostBank020E4.write 2 v k w)

def sweep {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State) :
    Nat → Nat → Values cap → Run (Values cap)
  | 0,_,v => charge 2 2 v
  | fuel+1,j,v => if h : j<cap then overhead 4
      (CostRun020E4.bind (advance a s v ⟨j,h⟩) (fun q => sweep a s fuel (j+1) q))
    else charge 2 2 v

def build {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State) : Run (Values cap) :=
  CostRun020E4.bind (CostBank020E4.zero cap 2 none) (sweep a s cap 0)

def stepPrice (cap : Nat) : Nat := 81+CostBank020E4.writePrice cap 2
def buildPrice (cap : Nat) : Nat := 6+cap*(6+stepPrice cap)

theorem advance_value {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State)
    (v : Values cap) (k : Fin cap) : (advance a s v k).value=ArrayValues020E4.advance a s v k := by
  rw [advance,bind_value,CostValueCell020E4.entry_value,CostBank020E4.write_value]
  rfl

theorem advance_bound {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State)
    (v : Values cap) (k : Fin cap) :
    Bounded (advance a s v k) (77+CostBank020E4.writePrice cap 2) (77+CostBank020E4.writePrice cap 2) :=
  bind_bound _ _ _ _ _ _ (CostValueCell020E4.entry_bound a s v k) (fun _ => ⟨le_rfl,le_rfl⟩)

theorem sweep_value {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State)
    (fuel start : Nat) (v : Values cap) : (sweep a s fuel start v).value=ArrayValues020E4.sweep a s fuel start v := by
  induction fuel generalizing start v with
  | zero => rfl
  | succ fuel ih =>
    by_cases hs : start<cap
    · simp only [sweep,ArrayValues020E4.sweep,dite_eq_left hs,overhead,bind_value,advance_value,ih]
    · simp only [sweep,ArrayValues020E4.sweep,dite_eq_right hs,charge]

theorem sweep_bound {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State)
    (fuel start : Nat) (v : Values cap) : Bounded (sweep a s fuel start v)
      (2+fuel*stepPrice cap) (2+fuel*stepPrice cap) := by
  induction fuel generalizing start v with
  | zero => simp [Bounded,sweep,charge]
  | succ fuel ih =>
    by_cases hs : start<cap
    · rw [sweep,dite_eq_left hs]
      have hb := bind_bound (advance a s v ⟨start,hs⟩) (sweep a s fuel (start+1))
        _ _ _ _ (advance_bound a s v ⟨start,hs⟩) (ih (start+1))
      have h := overhead_bound 4 _ _ _ hb
      rcases h with ⟨ht,hm⟩
      simp only [Bounded,stepPrice] at *
      constructor <;> nlinarith
    · rw [sweep,dite_eq_right hs]
      constructor <;> change 2≤2+(fuel+1)*stepPrice cap <;> omega

theorem build_value {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State) :
    (build a s).value=ArrayValues020E4.build a s := by
  rw [build,bind_value,CostBank020E4.zero_value,sweep_value]
  rfl

theorem build_bound {cap : Nat} (a : ArrayArena020E4.Arena cap) (s : ArrayState020E4.State) :
    Bounded (build a s) (buildPrice cap) (buildPrice cap) := by
  have hz := CostBank020E4.zero_budget cap 2 (none : Option Word)
  have hb : Bounded (CostBank020E4.zero cap 2 (none : Option Word)) (4+cap*6) (4+cap*6) := by
    exact ⟨le_of_eq hz.1,le_of_eq hz.2⟩
  have h := bind_bound _ (sweep a s cap 0) _ _ _ _ hb (sweep_bound a s cap 0)
  rcases h with ⟨ht,hm⟩
  change (build a s).ticks≤_ ∧ (build a s).allocated≤_
  unfold buildPrice
  change (CostRun020E4.bind _ (sweep a s cap 0)).ticks≤_ ∧ (CostRun020E4.bind _ (sweep a s cap 0)).allocated≤_
  constructor <;> nlinarith

end FT1536.S05.CostValues020E4
