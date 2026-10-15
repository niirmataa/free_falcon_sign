import CoreCountTypes020E13

namespace FT1536.S05.CountedLoop020E13
open CoreCountTypes020E13

/-- Generic loop isolates recursive composition from large concrete code
    images. The counted step itself still executes and supplies each result. -/
def run {α : Type} (terminal : α → Bool) (step : α → Report (Option α)) : Nat → α → Report (Option α)
  | 0,m => ⟨some m,zero⟩
  | fuel+1,m => if terminal m then ⟨some m,test zero⟩ else
      let s := step m
      match s.value with
      | none => ⟨none,test s.counts⟩
      | some next =>
        let r := run terminal step fuel next
        ⟨r.value,test (add s.counts r.counts)⟩

def plain {α : Type} (terminal : α → Bool) (step : α → Option α) : Nat → α → Option α
  | 0,m => some m
  | fuel+1,m => if terminal m then some m else (step m).bind (plain terminal step fuel)

theorem value {α : Type} (terminal : α → Bool) (step : α → Report (Option α)) (fuel : Nat) (m : α) :
    (run terminal step fuel m).value=plain terminal (fun x => (step x).value) fuel m := by
  induction fuel generalizing m with
  | zero => rfl
  | succ fuel ih =>
    simp only [run,plain]
    split
    · rfl
    · cases hs : (step m).value with
      | none => rfl
      | some next => exact ih next

theorem valid {α : Type} (terminal : α → Bool) (step : α → Report (Option α))
    (hs : ∀ m,(step m).counts.cycles=14733 ∧ (step m).counts.slots=32 ∧
      (step m).counts.scans≤32 ∧ (step m).counts.writes≤(step m).counts.scans ∧
      (step m).counts.rounds=1 ∧ (step m).counts.tests=0)
    (fuel : Nat) (m : α) : Valid (run terminal step fuel m).counts fuel := by
  induction fuel generalizing m with
  | zero => exact zero_valid 0
  | succ fuel ih =>
    simp only [run]
    split
    · exact stop_valid fuel
    · split
      · have h := round_valid (step m).counts zero fuel (hs m) (zero_valid fuel)
        simpa only [add,zero,Nat.add_zero] using h
      · exact round_valid _ _ fuel (hs m) (ih _)

end FT1536.S05.CountedLoop020E13
