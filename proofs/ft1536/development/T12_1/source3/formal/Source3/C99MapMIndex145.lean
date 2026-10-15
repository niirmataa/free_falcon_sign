import Source3.FftTableList139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99MapMIndex145

theorem source {α β : Type} (f : α → Option β) (xs : List α) (ys : List β)
    (length : xs.length=ys.length)
    (each : ∀ (i : Nat) (bound : i<xs.length), f xs[i]=some (ys[i]'(by omega))) :
    xs.mapM f=some ys := by
  induction xs generalizing ys with
  | nil =>
    cases ys with
    | nil => rfl
    | cons y ys => cases length
  | cons x xs ih =>
    cases ys with
    | nil => cases length
    | cons y ys =>
      have head : f x=some y := each 0 (by simp)
      have sizes : xs.length=ys.length := Nat.succ.inj length
      have tail : xs.mapM f=some ys := ih ys sizes (fun i bound => each (i+1) (by simpa only [List.length_cons] using Nat.succ_lt_succ bound))
      rw [List.mapM_cons,head,tail]
      rfl

end FT1536.Source3.C99MapMIndex145
