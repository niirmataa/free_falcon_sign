import Source3.GeneratedPublicEvaluation170

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicFiniteChecks170

def check {n : Nat} (p : Fin n → Prop) [DecidablePred p] : Bool :=
  (List.finRange n).all (fun i => decide (p i))

theorem sound {n : Nat} (p : Fin n → Prop) [DecidablePred p] (checked : check p=true) (i : Fin n) : p i :=
  of_decide_eq_true (List.all_eq_true.mp checked i (by simp))

end FT1536.Source3.PublicFiniteChecks170
