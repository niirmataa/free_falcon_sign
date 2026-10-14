import Source3.KeygenWholeCall088
import Mathlib.Data.Fintype.Vector
import Mathlib.Data.Fintype.Sigma

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenWholeBytes088
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)
open KeygenWholeCall088

/-- Only the already stated legal caller/profile domain. No successful
    execution, output equation, distribution or normalization is a field. -/
structure Domain (env : Env) (caller : State) where
  primes : ArrayPointer
  rev : ArrayPointer
  rootLegal : KeygenMakeAssembly080.LegalEntry env caller primes rev
  buffers : KeygenOutputMemory081.Legal env caller
  comp : env.args.comp = 1
  capacity : BitVec 64
  publicLegal : KeygenPublicEntry082.Legal env caller capacity

abbrev Secret := (length : Fin 10370) × List.Vector (BitVec 8) length.val
abbrev Packet := Secret × List.Vector (BitVec 8) 2881

instance byteFinite : Finite (BitVec 8) :=
  Finite.of_injective BitVec.toFin (by intro a b equal; cases a; cases b; cases equal; rfl)

noncomputable instance secretFintype : Fintype Secret := Fintype.ofFinite Secret
noncomputable instance packetFintype : Fintype Packet := Fintype.ofFinite Packet

def secretBytes (p : Packet) : List (BitVec 8) := p.1.2.val
def publicBytes (p : Packet) : List (BitVec 8) := p.2.val

def pack (sk pk : List (BitVec 8)) (skBound : sk.length ≤ 10369) (pkLength : pk.length = 2881) : Packet :=
  (⟨⟨sk.length, by omega⟩, ⟨sk, rfl⟩⟩, ⟨pk, pkLength⟩)

def Observed (env : Env) (out : Result) (p : Packet) : Prop :=
  KeygenSourceToFiber001.Emitted env out (secretBytes p) (publicBytes p)

theorem packet_ext (p q : Packet) (secret : secretBytes p = secretBytes q)
    (publicEqual : publicBytes p = publicBytes q) : p = q := by
  rcases p with ⟨⟨np, vp⟩, pp⟩
  rcases q with ⟨⟨nq, vq⟩, pq⟩
  have lengths : np = nq := Fin.ext (by
    have equal := congrArg List.length secret
    simpa only [secretBytes, vp.property, vq.property] using equal)
  subst nq
  have vectors : vp = vq := Subtype.ext secret
  have publics : pp = pq := Subtype.ext publicEqual
  cases vectors
  cases publics
  rfl

theorem observed_unique (env : Env) (out : Result) (p q : Packet)
    (hp : Observed env out p) (hq : Observed env out q) : p = q := by
  apply packet_ext
  · exact KeygenSecretObserved081.unique _ _ _ _ _ hp.1 hq.1
  · exact KeygenPublicObserved077.observed_unique _ _ _ _ _ hp.2 hq.2

theorem success_has_packet (domain : Domain env caller) (t : Trace env caller)
    (success : KeygenSourceToFiber001.Success t.out) : ∃ p, Observed env t.out p := by
  obtain ⟨result, contract⟩ := KeygenSourceToFiber001.emitted_to_actual_fiber env caller t.out
    domain.primes domain.rev domain.rootLegal domain.buffers domain.comp
    domain.capacity domain.publicLegal t.source success
  exact ⟨pack (KeygenSourceToFiber001.secretBytes result) (KeygenSourceToFiber001.publicBytes result)
    contract.secretLength.2 contract.publicLength, contract.emitted⟩

/-- Choose only the unique packet already present in a FIXED final heap.
    This does not select an execution or resolve source nondeterminism. -/
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

abbrev Outcome := Failure ⊕ Packet

/-- Failures keep their source phase; no return-0 trace is normalized away. -/
noncomputable def observe (domain : Domain env caller) (t : Trace env caller) : Outcome :=
  if failed : t.failure = none then
    .inr (packetOf domain t (t.failure_none_iff.mp failed))
  else .inl (t.failure.get (by simpa only [Option.isSome_iff_ne_none] using failed))

def keyOnly : Outcome → Option Packet
  | .inl _ => none
  | .inr p => some p

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

theorem keyOnly_none_iff (domain : Domain env caller) (t : Trace env caller) :
    keyOnly (observe domain t) = none ↔ t.out.flow = .returned (some (.int32 0)) := by
  rw [← t.failure_some_iff_zero]
  unfold observe
  split_ifs with h <;> simp [keyOnly, h, Option.isSome_iff_ne_none]

/-- Every successful byte outcome has the SAME decoded material, full
    certificate and fiber supplied by the source theorem, without adding
    them to the input domain. -/
theorem observed_contract (domain : Domain env caller) (t : Trace env caller) (p : Packet)
    (observed : observe domain t = .inr p) :
    ∃ result : KeygenSourceToFiber001.Output env caller t.out,
      KeygenSourceToFiber001.Contract result ∧
      secretBytes p = KeygenSourceToFiber001.secretBytes result ∧
      publicBytes p = KeygenSourceToFiber001.publicBytes result := by
  obtain ⟨success, actual⟩ := (observe_right_iff domain t p).mp observed
  exact KeygenSourceToFiber001.actual_observed_fiber env caller t.out domain.primes domain.rev
    domain.rootLegal domain.buffers domain.comp domain.capacity domain.publicLegal
    t.source success (secretBytes p) (publicBytes p) actual

end FT1536.Source3.KeygenWholeBytes088
