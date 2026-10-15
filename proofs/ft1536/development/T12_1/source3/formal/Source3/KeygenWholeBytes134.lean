import Source3.KeygenWholeBytes088
import Source3.KeygenWholeCall088
import Mathlib.Data.Fintype.Vector
import Mathlib.Data.Fintype.Sigma
import Source3.KeygenSourceToFiber134
import Source3.KeygenWholeCall134

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenWholeBytes134
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)
open KeygenWholeCall088 hiding Attempt Trace
open KeygenWholeCall134
open KeygenWholeBytes088
theorem success_has_packet (domain : Domain env caller) (t : Trace env caller)
    (success : KeygenSourceToFiber001.Success t.out) : ∃ p, Observed env t.out p := by
  obtain ⟨result, contract⟩ := KeygenSourceToFiber134.emitted_to_actual_fiber env caller t.out
    domain.primes domain.rev domain.rootLegal domain.buffers domain.comp
    domain.capacity domain.publicLegal t.source success
  exact ⟨pack (KeygenSourceToFiber134.secretBytes result) (KeygenSourceToFiber134.publicBytes result)
    contract.secretLength.2 contract.publicLength, contract.emitted⟩

noncomputable def packetOf (domain : Domain env caller) (t : Trace env caller)
    (success : KeygenSourceToFiber001.Success t.out) : Packet :=
  Classical.choose (success_has_packet domain t success)

theorem packetOf_observed (domain : Domain env caller) (t : Trace env caller)
    (success : KeygenSourceToFiber001.Success t.out) : Observed env t.out (packetOf domain t success) :=
  Classical.choose_spec (success_has_packet domain t success)

theorem packetOf_eq (domain : Domain env caller) (t : Trace env caller)
    (success : KeygenSourceToFiber001.Success t.out) (p : Packet) (observed : Observed env t.out p) :
    packetOf domain t success = p :=
  observed_unique env t.out _ p (packetOf_observed domain t success) observed

noncomputable def observe (domain : Domain env caller) (t : Trace env caller) : Outcome :=
  if failed : t.failure = none then
    .inr (packetOf domain t (t.failure_none_iff.mp failed))
  else .inl (t.failure.get (by simpa only [Option.isSome_iff_ne_none] using failed))

theorem observe_right_iff (domain : Domain env caller) (t : Trace env caller) (p : Packet) :
    observe domain t = .inr p ↔ KeygenSourceToFiber001.Success t.out ∧ Observed env t.out p := by
  unfold observe
  split_ifs with h
  · constructor
    · intro equal
      cases Sum.inr.inj equal
      exact ⟨t.failure_none_iff.mp h, packetOf_observed domain t _⟩
    · rintro ⟨success, observed⟩
      exact congrArg Sum.inr (packetOf_eq domain t _ p observed)
  · constructor
    · intro equal
      cases equal
    · rintro ⟨success, _⟩
      exact (h (t.failure_none_iff.mpr success)).elim

theorem observe_left_iff (domain : Domain env caller) (t : Trace env caller) (cause : Failure) :
    observe domain t = .inl cause ↔ t.failure = some cause := by
  unfold observe
  split_ifs with h
  · simp [h]
  · simp only [Sum.inl.injEq]
    constructor
    · intro equal
      rw [← equal]
      exact (Option.some_get _).symm
    · intro equal
      exact Option.get_of_eq_some _ equal

theorem observed_contract (domain : Domain env caller) (t : Trace env caller) (p : Packet)
    (observed : observe domain t = .inr p) :
    ∃ result : KeygenSourceToFiber134.Output env caller t.out,
      KeygenSourceToFiber134.Contract result ∧
      secretBytes p = KeygenSourceToFiber134.secretBytes result ∧
      publicBytes p = KeygenSourceToFiber134.publicBytes result := by
  obtain ⟨success, actual⟩ := (observe_right_iff domain t p).mp observed
  exact KeygenSourceToFiber134.actual_observed_fiber env caller t.out domain.primes domain.rev
    domain.rootLegal domain.buffers domain.comp domain.capacity domain.publicLegal
    t.source success (secretBytes p) (publicBytes p) actual

end FT1536.Source3.KeygenWholeBytes134
