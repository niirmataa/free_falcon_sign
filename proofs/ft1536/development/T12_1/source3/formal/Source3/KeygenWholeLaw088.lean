import Source3.KeygenWholeBytes088
import Source3.KeygenLawBoundary087
import Mathlib.Data.Fintype.Sum

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Probability consumer for source-connected whole calls. Its execution
   family is an EXPLICIT input, not a realized seed-to-source producer.
   It will consume that producer once constructed. No independence or
   per-attempt acceptance probability occurs anywhere in this layer. -/
namespace FT1536.Source3.KeygenWholeLaw088
open Finset
open C99ArrayReference (State)
open KeygenMakeInvocation (Env)
open KeygenWholeCall088
open KeygenWholeBytes088

/-- Absence of a finite defined reference call is not conflated with an
    observed return 0 or asserted to be an infinite, defined C execution. -/
inductive Execution (env : Env) (caller : State) where
  | returned (trace : Trace env caller)
  | noDefinedReturn (absent : ¬ Nonempty (Trace env caller))

abbrev CallOutcome := Option Outcome

noncomputable def observeExecution (domain : Domain env caller) : Execution env caller → CallOutcome
  | .returned trace => some (observe domain trace)
  | .noDefinedReturn _ => none

variable {Ω : Type} [Fintype Ω]

/-- One input draw for the entire invocation. A concrete seed experiment
    must construct executions from the pinned code; supplying an arbitrary
    family here is not the final source-law binding. -/
noncomputable def wholeLaw (input : Law Ω) (caller : Ω → State)
    (domains : ∀ s, Domain env (caller s))
    (executions : ∀ s, Execution env (caller s)) : Law CallOutcome := by
  classical
  exact input.map (fun s => observeExecution (domains s) (executions s))

def forget : CallOutcome → Option Packet
  | none => none
  | some (.inl _) => none
  | some (.inr p) => some p

noncomputable def packetLaw (p : Law CallOutcome) : Law (Option Packet) := by
  classical
  exact p.map forget

noncomputable def noReturnMass (p : Law CallOutcome) : ℝ := p.mass none
noncomputable def failureMass (p : Law CallOutcome) (cause : Failure) : ℝ := p.mass (some (.inl cause))
noncomputable def emittedMass (p : Law CallOutcome) : ℝ := ∑ k, p.mass (some (.inr k))

theorem full_accounting (p : Law CallOutcome) :
    noReturnMass p + (∑ cause, failureMass p cause) + emittedMass p = 1 := by
  have total := p.total
  rw [Fintype.sum_option, Fintype.sum_sum_type] at total
  simpa only [noReturnMass, failureMass, emittedMass, add_assoc] using total

theorem packet_mass (p : Law CallOutcome) (k : Packet) :
    (packetLaw p).mass (some k) = p.mass (some (.inr k)) := by
  classical
  simp [packetLaw, Law.map, Law.bind, Law.pure, Fintype.sum_option,
    Fintype.sum_sum_type, forget, eq_comm]

theorem packet_success_mass (p : Law CallOutcome) :
    KeygenLawBoundary087.successMass (packetLaw p) = emittedMass p := by
  simp only [KeygenLawBoundary087.successMass, emittedMass, packet_mass]

theorem packet_failure_mass (p : Law CallOutcome) :
    (packetLaw p).mass none = noReturnMass p + ∑ cause, failureMass p cause := by
  have total := KeygenLawBoundary087.failure_success (packetLaw p)
  rw [packet_success_mass] at total
  have accounted := full_accounting p
  linarith

/-- Conditioning happens only after full return-1 byte emission. The
    existence of a positive successful mass is not supplied as a premise. -/
noncomputable def successfulLaw (p : Law CallOutcome) : Option (Law Packet) :=
  KeygenLawBoundary087.conditionSuccess (packetLaw p)

theorem successful_none_iff (p : Law CallOutcome) :
    successfulLaw p = none ↔ emittedMass p = 0 := by
  rw [successfulLaw, KeygenLawBoundary087.condition_none_iff, packet_success_mass]

theorem successful_mass (p : Law CallOutcome) (q : Law Packet)
    (constructed : successfulLaw p = some q) (k : Packet) :
    q.mass k = p.mass (some (.inr k)) / emittedMass p := by
  rw [KeygenLawBoundary087.condition_mass (packetLaw p) q constructed,
    packet_mass, packet_success_mass]

theorem successful_positive (p : Law CallOutcome) (q : Law Packet)
    (constructed : successfulLaw p = some q) : 0 < emittedMass p := by
  simpa only [packet_success_mass] using
    KeygenLawBoundary087.condition_positive (packetLaw p) q constructed

theorem map_positive_witness {A B : Type} [Fintype A] [Fintype B] [DecidableEq B]
    (p : Law A) (f : A → B) (b : B) (positive : 0 < (p.map f).mass b) :
    ∃ a, 0 < p.mass a ∧ f a = b := by
  by_contra none
  push Not at none
  have zero : (p.map f).mass b = 0 := by
    change (∑ a, p.mass a * (Law.pure (f a)).mass b) = 0
    apply sum_eq_zero
    intro a _
    by_cases equal : f a = b
    · have massZero : p.mass a = 0 := by
        apply le_antisymm _ (p.nonneg a)
        by_contra positiveA
        exact none a (lt_of_not_ge positiveA) equal
      simp [massZero]
    · simp [Law.pure, Ne.symm equal]
  rw [zero] at positive
  exact (lt_irrefl 0) positive

/-- A positive successful mass of the constructed whole-call law has an
    actual source trace with these exact observed bytes. -/
theorem whole_success_source (input : Law Ω) (caller : Ω → State)
    (domains : ∀ s, Domain env (caller s)) (executions : ∀ s, Execution env (caller s))
    (p : Packet) (positive : 0 < (wholeLaw input caller domains executions).mass (some (.inr p))) :
    ∃ s, ∃ t : Trace env (caller s),
      0 < input.mass s ∧ KeygenSourceToFiber001.Success t.out ∧ Observed env t.out p := by
  classical
  obtain ⟨s, mass, equal⟩ := map_positive_witness input
    (fun s => observeExecution (domains s) (executions s)) (some (.inr p)) positive
  cases selected : executions s with
  | noDefinedReturn absent => simp [selected, observeExecution] at equal
  | returned t =>
      have observed : observe (domains s) t = .inr p := by
        simpa only [selected, observeExecution, Option.some.injEq] using equal
      obtain ⟨success, bytes⟩ := (observe_right_iff (domains s) t p).mp observed
      exact ⟨s, t, mass, success, bytes⟩

/-- Every failure category is a mass of the source-connected full law,
    not a retry probability supplied by a geometric approximation. -/
theorem whole_failure_source (input : Law Ω) (caller : Ω → State)
    (domains : ∀ s, Domain env (caller s)) (executions : ∀ s, Execution env (caller s))
    (cause : Failure)
    (positive : 0 < failureMass (wholeLaw input caller domains executions) cause) :
    ∃ s, ∃ t : Trace env (caller s), 0 < input.mass s ∧ t.failure = some cause := by
  classical
  obtain ⟨s, mass, equal⟩ := map_positive_witness input
    (fun s => observeExecution (domains s) (executions s)) (some (.inl cause)) positive
  cases selected : executions s with
  | noDefinedReturn absent => simp [selected, observeExecution] at equal
  | returned t =>
      have observed : observe (domains s) t = .inl cause := by
        simpa only [selected, observeExecution, Option.some.injEq] using equal
      exact ⟨s, t, mass, (observe_left_iff (domains s) t cause).mp observed⟩

end FT1536.Source3.KeygenWholeLaw088
