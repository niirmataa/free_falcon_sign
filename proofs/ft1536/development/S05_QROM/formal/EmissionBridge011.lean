import SourceMaterial011
import KeySupport011

/- Q-KEY/Q-SAMPLER proof-obligation assembly. The fields below are explicit
   obligations at the emitted/codec boundary, NOT cryptographic assumptions
   and NOT a proved instance of falcon_keygen_make. -/
namespace FT1536.S05.EmissionBridge011
open FT1536.Relation FT1536.Run2
open SourceMaterial011 KeySupport011
open FT1536.Source3
open C99MemoryReference (Memory ArrayPointer)

structure EmissionView (X : Type) [Fintype X] where
  sourceLaw : Law X
  emits : X → Bool
  positive : 0<sourceLaw.event (fun x => emits x=true)
  publicValue : X → Rq
  publicBytes : X → Bytes
  decodePublic : Bytes → Option Rq
  snapshot : X → Memory
  input : X → Fin 4 → ArrayPointer
  pubArray : X → ArrayPointer
  material : ∀ x, sourceLaw.mass x≠0 → emits x=true →
    KeygenMakeMaterialWitness.EncodingInputs (snapshot x) (input x) (pubArray x)
  publicRead : ∀ x, sourceLaw.mass x≠0 → emits x=true →
    KeygenPublicNormalizePolynomial.Represents (snapshot x) (pubArray x) (publicValue x)
  publicDecode : ∀ x, sourceLaw.mass x≠0 → emits x=true →
    decodePublic (publicBytes x)=some (publicValue x)

/-- The domain is the actual supplied emission image, not a good-key test
    defined by the moment conclusion. Identification with C is a separate
    instance obligation for EmissionView. -/
def Domain {X : Type} [Fintype X] (v : EmissionView X) (h : Rq) : Prop :=
  ∃ x, v.sourceLaw.mass x≠0 ∧ v.emits x=true ∧ v.publicValue x=h

noncomputable def publicLaw {X : Type} [Fintype X] (v : EmissionView X) : Law Rq :=
  emittedPublic v.sourceLaw (fun x => v.emits x=true) v.positive v.publicValue

theorem public_support {X : Type} [Fintype X] (v : EmissionView X) :
    Covered (publicLaw v) (Domain v) :=
  emitted_support v.sourceLaw _ v.positive v.publicValue (Domain v)
    (fun x hx he => ⟨x,hx,he,rfl⟩)

/-- Every key with nonzero public probability has ONE material record:
    same source outcome, same public array, same decoded public bytes. -/
theorem supported_material {X : Type} [Fintype X] (v : EmissionView X)
    (h : Rq) (hh : (publicLaw v).mass h≠0) :
    ∃ x, ∃ k : CoefficientKey h,
      v.sourceLaw.mass x≠0 ∧ v.emits x=true ∧
      RepresentsKey (v.snapshot x) (v.input x) (v.pubArray x) k ∧
      v.decodePublic (v.publicBytes x)=some h := by
  obtain ⟨x,hx,he,equal⟩ := public_support v h hh
  subst h
  obtain ⟨k,repr⟩ := key_at_same_public_array (v.snapshot x) (v.input x) (v.pubArray x)
    (v.publicValue x) (v.material x hx he) (v.publicRead x hx he)
  exact ⟨x,k,hx,he,repr,v.publicDecode x hx he⟩

theorem keypair_public_law {X SK : Type} [Fintype X] [Fintype SK] [DecidableEq SK]
    (v : EmissionView X) (secretValue : X → SK) :
    SigmaMath.muH ((conditioned v.sourceLaw (fun x => v.emits x=true) v.positive).map
      (fun x => (secretValue x,v.publicValue x)))=publicLaw v :=
  public_marginal_of_conditioned_keypair v.sourceLaw _ v.positive _

/-- Closed kernel assembly conditional on the local sampler proof and on
    the explicit emission view. All states are handled by public initial. -/
theorem emitted_sampler_certificate {X : Type} [Fintype X] (v : EmissionView X)
    (S : Sampler) (e : ℝ) (localCert : OnKeys (Domain v) S e)
    (st : Rq → State) (m : Rq → Bytes) (r : Rq → Nonce) :
    Divergence.AC (jointSim (publicLaw v) (resetInitial S) st m r)
      (jointHonest (publicLaw v)) ∧
    Divergence.second (jointSim (publicLaw v) (resetInitial S) st m r)
      (jointHonest (publicLaw v))≤1+e := by
  have cert := resetInitial_certificate (Domain v) S e localCert
  exact ⟨key_joint_ac _ _ _ _ (public_support v) cert st m r,
    key_joint_moment _ _ _ _ (public_support v) cert st m r⟩

#print axioms public_support
#print axioms supported_material
#print axioms keypair_public_law
#print axioms emitted_sampler_certificate
end FT1536.S05.EmissionBridge011
