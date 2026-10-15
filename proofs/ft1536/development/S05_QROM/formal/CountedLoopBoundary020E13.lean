import CountedLoop020E13

namespace FT1536.S05.CountedLoopBoundary020E13
open CoreCountTypes020E13

theorem stopped {α : Type} (terminal : α → Bool) (step : α → Report (Option α))
    (fuel : Nat) (m : α) (ht : terminal m=true) :
    CountedLoop020E13.run terminal step (fuel+1) m=⟨some m,test zero⟩ := by
  simp only [CountedLoop020E13.run,ht,ite_true]

theorem malformed {α : Type} (terminal : α → Bool) (step : α → Report (Option α))
    (fuel : Nat) (m : α) (ht : terminal m=false) (he : (step m).value=none) :
    CountedLoop020E13.run terminal step (fuel+1) m=⟨none,test (step m).counts⟩ := by
  simp only [CountedLoop020E13.run,ht,Bool.false_eq_true,ite_false,he]

end FT1536.S05.CountedLoopBoundary020E13
