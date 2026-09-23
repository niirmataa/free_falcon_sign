import Mathlib
import B20.Foundation.SourceBinding

namespace B20.Foundation

open Classical

abbrev PMFKernel (α β : Type*) := α -> PMF β

/-- An observed kernel: probabilistic step over states, a Boolean observation
of outputs and a designated fallback output. -/
structure ObservedKernel (α β : Type*) where
  step : PMFKernel α β
  observation : β -> Bool
  fallback : β

structure History (α β : Type*) where
  state : α
  observations : List β

/-- Conditional-history kernel: continues from the recorded state of the
history; from any other state it emits the designated fallback. -/
noncomputable def conditionalHistory {α β : Type*} (k : ObservedKernel α β)
    (h : History α β) (a : α) : PMF β :=
  if h.state = a then k.step a else PMF.pure k.fallback

/-- Total variation distance on finite observation spaces over Mathlib `PMF`:
half the ℓ¹ distance of the probability mass functions. -/
noncomputable def totalVariation {α : Type*} [Fintype α] (p q : PMF α) : ℝ :=
  (∑ a, abs (ENNReal.toReal (p a) - ENNReal.toReal (q a))) / 2

/-- Directed chi-square divergence `χ²(p ‖ q)`; `⊤` exactly when `p` assigns
mass outside the support of `q`. -/
noncomputable def directedChi2 {α : Type*} [Fintype α] (p q : PMF α) : WithTop ℝ :=
  if ∃ a, q a = 0 ∧ p a ≠ 0 then ⊤
  else ((((∑ a, (ENNReal.toReal (p a) - ENNReal.toReal (q a))^2
      / ENNReal.toReal (q a)) : ℝ)) : WithTop ℝ)

theorem totalVariation_self_zero {α : Type*} [Fintype α] (p : PMF α) :
    totalVariation p p = 0 := by
  simp [totalVariation]

theorem directedChi2_self_zero {α : Type*} [Fintype α] (p : PMF α) :
    directedChi2 p p = 0 := by
  have hneg : ¬ ∃ a, p a = 0 ∧ p a ≠ 0 := by
    rintro ⟨a, h1, h2⟩
    exact h2 h1
  have hsum : (∑ a : α, (ENNReal.toReal (p a) - ENNReal.toReal (p a)) ^ 2
      / ENNReal.toReal (p a)) = 0 := by
    simp [sub_self, zero_pow, zero_div]
  unfold directedChi2
  rw [ite_eq_right hneg, hsum]
  simp

/-- Trivial concrete instance: a unit-state kernel emitting `true` surely. -/
noncomputable def singletonObserved : ObservedKernel Unit Bool :=
  { step := fun _ => PMF.pure true, observation := id, fallback := false }

theorem singletonObserved_apply (u : Unit) : singletonObserved.step u true = 1 := by
  simp [singletonObserved, PMF.pure_apply]

/-! ## Concrete instantiation on the pinned model

The pinned model of this task is the deterministic execution of the pinned
source17 fragment program `source17ReturnZeroProgram` in `CExec` semantics
(the kernel of `B20.Foundation.CExec`), observed through "returned exactly 0".
This section is a full formal instance of `ObservedKernel`, `totalVariation`,
`directedChi2` and `conditionalHistory` on that pinned model — not only the
generic lemmas above. -/

noncomputable def pinnedKernel : ObservedKernel State Outcome where
  step := fun s => PMF.pure (evalStmt source17ReturnZeroProgram s)
  observation := fun o =>
    match o with
    | .returned (some w) _ => w == 0
    | _ => false
  fallback := .stuck "pinned-fallback"

/-- Observed marginal of the pinned model at state `s`. -/
noncomputable def pinnedObserved (s : State) : PMF Bool :=
  PMF.pure (pinnedKernel.observation (evalStmt source17ReturnZeroProgram s))

theorem pinned_observed_eq (s : State) :
    (pinnedKernel.step s).bind (fun b => PMF.pure (pinnedKernel.observation b))
      = pinnedObserved s := by
  simp [pinnedKernel, pinnedObserved, PMF.pure_bind]

theorem pinned_observation_initState :
    pinnedKernel.observation (evalStmt source17ReturnZeroProgram initState) = true := by
  decide

theorem pinned_observed_initState :
    pinnedObserved initState = PMF.pure true := by
  unfold pinnedObserved
  rw [pinned_observation_initState]

theorem pinned_observed_step_apply (s : State) :
    pinnedKernel.step s (evalStmt source17ReturnZeroProgram s) = 1 := by
  simp [pinnedKernel]

/-- Total variation self-distance of the pinned observed marginal is `0`. -/
theorem pinned_tv_self (s : State) :
    totalVariation (pinnedObserved s) (pinnedObserved s) = 0 :=
  totalVariation_self_zero _

/-- Directed chi-square self-divergence of the pinned observed marginal is
`0` (in particular finite: the pinned observed law does not escape its
support). -/
theorem pinned_chi2_self (s : State) :
    directedChi2 (pinnedObserved s) (pinnedObserved s) = 0 :=
  directedChi2_self_zero _

/-- Conditional history on the pinned kernel resumes from the recorded state. -/
theorem pinned_conditionalHistory_state (s : State)
    (h : History State Outcome) (hh : h.state = s) :
    conditionalHistory pinnedKernel h s = pinnedKernel.step s := by
  simp [conditionalHistory, pinnedKernel, hh]

/-- Conditional history on the pinned kernel from a foreign state emits the
designated fallback output. -/
theorem pinned_conditionalHistory_fresh (s : State)
    (h : History State Outcome) (hh : h.state ≠ s) :
    conditionalHistory pinnedKernel h s = PMF.pure (.stuck "pinned-fallback") := by
  simp [conditionalHistory, pinnedKernel, hh]

end B20.Foundation
