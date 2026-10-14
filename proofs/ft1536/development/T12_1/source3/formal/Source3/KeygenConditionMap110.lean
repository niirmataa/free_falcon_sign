import Source3.KeygenLawAlgebra110

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenConditionMap110
open Finset
open KeygenLawBoundary087 (successMass conditionSuccess)

variable {A B : Type} [Fintype A] [Fintype B]

theorem success_event (p : Law (Option A)) : p.event (fun x => x.isSome = true) = successMass p := by
  simp [Law.event, successMass, Fintype.sum_option]

theorem success_map [DecidableEq B] (p : Law (Option A)) (f : A → B) :
    successMass (p.map (Option.map f)) = successMass p := by
  rw [← success_event, KeygenLawAlgebra110.map_event]
  simp [Law.event, successMass, Fintype.sum_option]

theorem some_mass [DecidableEq B] (p : Law (Option A)) (f : A → B) (b : B) :
    (p.map (Option.map f)).mass (some b) = ∑ a, if f a = b then p.mass (some a) else 0 := by
  classical
  simp [KeygenLawAlgebra110.map_mass, Fintype.sum_option]

theorem condition_map [DecidableEq B] (p : Law (Option A)) (f : A → B) (q : Law A)
    (constructed : conditionSuccess p = some q) :
    conditionSuccess (p.map (Option.map f)) = some (q.map f) := by
  classical
  have positive : 0 < successMass (p.map (Option.map f)) := by
    rw [success_map]
    exact KeygenLawBoundary087.condition_positive p q constructed
  unfold conditionSuccess
  rw [dite_eq_left positive]
  apply congrArg some
  apply KeygenLawAlgebra110.ext
  intro b
  change (p.map (Option.map f)).mass (some b) / successMass (p.map (Option.map f)) = (q.map f).mass b
  rw [some_mass, success_map, KeygenLawAlgebra110.map_mass, sum_div]
  apply sum_congr rfl
  intro a _
  by_cases same : f a = b <;> simp [same, KeygenLawBoundary087.condition_mass p q constructed]

end FT1536.Source3.KeygenConditionMap110
