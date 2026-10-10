import Run2.LawBinding

/- Q-KEY and Q-SAMPLER proof obligations on the SAME public-key law.
   This module does not provide the source emission map or a sampler007
   implementation theorem. It does not change the legacy all-h certificate. -/
namespace FT1536.S05.KeySupport011
open Finset Run2
open FT1536.Relation

/-- The public domain must be supplied from source/key evidence, not defined
    by the desired moment conclusion. All reply failures remain in the laws. -/
structure OnKeys (K : Rq → Prop) (S : Sampler) (e : ℝ) : Prop where
  nonnegative : 0≤e
  ac : ∀ h, K h → ∀ st m r,
    Divergence.AC (samplerLaw S h st m r) (SigmaMath.freshHonest h)
  moment : ∀ h, K h → ∀ st m r,
    Divergence.second (samplerLaw S h st m r) (SigmaMath.freshHonest h)≤1+e

def Covered (mu : Law Rq) (K : Rq → Prop) : Prop :=
  ∀ h, mu.mass h≠0 → K h

theorem restrict_legacy (S : Sampler) (e : ℝ) (c : LocalJointCertificate S e)
    (K : Rq → Prop) : OnKeys K S e :=
  ⟨c.nonnegative,fun h _ => c.ac h,fun h _ => c.moment h⟩

theorem univ_to_legacy (S : Sampler) (e : ℝ) (c : OnKeys (fun _ => True) S e) :
    LocalJointCertificate S e :=
  ⟨c.nonnegative,fun h => c.ac h trivial,fun h => c.moment h trivial⟩

theorem initial_certificate (K : Rq → Prop) (S : Sampler) (e : ℝ)
    (c : OnKeys K S e) (h : Rq) (hk : K h) (m : Bytes) (r : Nonce) :
    Divergence.AC (samplerLaw S h initial m r) (SigmaMath.freshHonest h) ∧
    Divergence.second (samplerLaw S h initial m r) (SigmaMath.freshHonest h)≤1+e :=
  ⟨c.ac h hk initial m r,c.moment h hk initial m r⟩

def resetInitial (S : Sampler) : Sampler :=
  ⟨S.bits,fun h _ m r coins => S.code h initial m r coins⟩

theorem resetInitial_bits (S : Sampler) : (resetInitial S).bits=S.bits := rfl

theorem resetInitial_law (S : Sampler) (h : Rq) (st : State) (m : Bytes) (r : Nonce) :
    samplerLaw (resetInitial S) h st m r=samplerLaw S h initial m r := rfl

theorem resetInitial_certificate (K : Rq → Prop) (S : Sampler) (e : ℝ)
    (cert : OnKeys K S e) : OnKeys K (resetInitial S) e :=
  ⟨cert.nonnegative,fun h hk _ m r => cert.ac h hk initial m r,
    fun h hk _ m r => cert.moment h hk initial m r⟩

/-- Both experiments draw the key ONCE from exactly mu. Keeping h in the
    joint law rules out silently resampling/reconditioning at Sign. -/
noncomputable def jointSim (mu : Law Rq) (S : Sampler)
    (st : Rq → State) (m : Rq → Bytes) (r : Rq → Nonce) : Law (Rq × (Rq × Option PublicSimulation.BoxVec)) :=
  Divergence.joint mu (fun h => samplerLaw S h (st h) (m h) (r h))

noncomputable def jointHonest (mu : Law Rq) : Law (Rq × (Rq × Option PublicSimulation.BoxVec)) :=
  Divergence.joint mu SigmaMath.freshHonest

theorem key_joint_ac (K : Rq → Prop) (mu : Law Rq) (S : Sampler) (e : ℝ)
    (cover : Covered mu K) (cert : OnKeys K S e)
    (st : Rq → State) (m : Rq → Bytes) (r : Rq → Nonce) :
    Divergence.AC (jointSim mu S st m r) (jointHonest mu) :=
  Divergence.joint_ac mu mu _ _ (fun _ hx => hx)
    (fun h hp => cert.ac h (cover h hp) (st h) (m h) (r h))

theorem second_self {X : Type} [Fintype X] (mu : Law X) : Divergence.second mu mu=1 := by
  unfold Divergence.second
  calc
    _ = ∑ x, mu.mass x := by
      apply sum_congr rfl
      intro x _
      by_cases hx : mu.mass x=0
      · simp [hx]
      · field_simp
    _ = 1 := mu.total

theorem key_joint_moment (K : Rq → Prop) (mu : Law Rq) (S : Sampler) (e : ℝ)
    (cover : Covered mu K) (cert : OnKeys K S e)
    (st : Rq → State) (m : Rq → Bytes) (r : Rq → Nonce) :
    Divergence.second (jointSim mu S st m r) (jointHonest mu)≤1+e := by
  have hb := Divergence.joint_bound mu mu
    (fun h => samplerLaw S h (st h) (m h) (r h)) SigmaMath.freshHonest (1+e)
    (fun h hp => cert.moment h (cover h hp) (st h) (m h) (r h))
  rw [second_self,one_mul] at hb
  exact hb

/-- Conditioning is done on the original source sample space, once. The
    acceptance event must describe emission, never a chosen good-key filter. -/
noncomputable def conditioned {X : Type} [Fintype X] (p : Law X)
    (E : X → Prop) [DecidablePred E] (hp : 0<p.event E) : Law X where
  mass x := (if E x then p.mass x else 0)/p.event E
  nonneg x := div_nonneg (by split_ifs; exact p.nonneg x; exact le_refl 0) hp.le
  total := by
    rw [← Finset.sum_div]
    exact div_self (ne_of_gt hp)

noncomputable def emittedPublic {X : Type} [Fintype X] (p : Law X)
    (E : X → Prop) [DecidablePred E] (hp : 0<p.event E) (pub : X → Rq) : Law Rq :=
  (conditioned p E hp).map pub

theorem map_composition {X Y : Type} [Fintype X] [Fintype Y] [DecidableEq Y]
    (p : Law X) (key : X → Y) (pub : Y → Rq) :
    (p.map key).map pub=p.map (fun x => pub (key x)) := by
  classical
  apply Run2.FiberBinding.law_ext
  intro h
  rw [Run2.FiberBinding.map_mass,Run2.FiberBinding.map_mass]
  simp_rw [Run2.FiberBinding.map_mass]
  simp_rw [Finset.sum_ite_irrel]
  rw [Finset.sum_comm]
  apply sum_congr rfl
  intro x _
  simp

theorem public_marginal_of_conditioned_keypair {X SK : Type} [Fintype X] [Fintype SK]
    [DecidableEq SK] (p : Law X) (E : X → Prop) [DecidablePred E]
    (hp : 0<p.event E) (key : X → SK×Rq) :
    SigmaMath.muH ((conditioned p E hp).map key)=
      emittedPublic p E hp (fun x => (key x).2) :=
  map_composition (conditioned p E hp) key Prod.snd

theorem emittedPublic_congr_on_emission {X : Type} [Fintype X]
    (p : Law X) (E : X → Prop) [DecidablePred E] (hp : 0<p.event E)
    (pub pub' : X → Rq) (same : ∀ x, E x → pub x=pub' x) :
    emittedPublic p E hp pub=emittedPublic p E hp pub' := by
  apply Run2.FiberBinding.law_ext
  intro h
  rw [Run2.FiberBinding.map_mass,Run2.FiberBinding.map_mass]
  apply sum_congr rfl
  intro x _
  by_cases he : E x
  · rw [same x he]
  · simp [conditioned,he]

theorem conditioned_support {X : Type} [Fintype X] (p : Law X)
    (E : X → Prop) [DecidablePred E] (hp : 0<p.event E) (x : X)
    (hx : (conditioned p E hp).mass x≠0) : E x ∧ p.mass x≠0 := by
  constructor
  · by_contra he
    exact hx (by simp [conditioned,he])
  · intro he
    exact hx (by simp [conditioned,he])

theorem mapped_support_witness {X : Type} [Fintype X] (p : Law X)
    (pub : X → Rq) (h : Rq) (hh : (p.map pub).mass h≠0) :
    ∃ x, p.mass x≠0 ∧ pub x=h := by
  classical
  by_contra no
  apply hh
  rw [Run2.FiberBinding.map_mass]
  apply sum_eq_zero
  intro x _
  by_cases he : pub x=h
  · have hz : p.mass x=0 := by
      by_contra hn
      exact no ⟨x,hn,he⟩
    simp [he,hz]
  · simp [he]

theorem emitted_support {X : Type} [Fintype X] (p : Law X)
    (E : X → Prop) [DecidablePred E] (hp : 0<p.event E) (pub : X → Rq)
    (K : Rq → Prop) (source : ∀ x, p.mass x≠0 → E x → K (pub x)) :
    Covered (emittedPublic p E hp pub) K := by
  intro h hh
  obtain ⟨x,hx,he⟩ := mapped_support_witness (conditioned p E hp) pub h hh
  obtain ⟨accepted,mass⟩ := conditioned_support p E hp x hx
  rw [← he]
  exact source x mass accepted

/-- No factor 1/P(emit) appears in the per-key moment: the SAME conditioned
    public-key law is used on both sides. This is not a PRG/conditioning hop. -/
theorem emitted_joint_certificate {X : Type} [Fintype X] (p : Law X)
    (E : X → Prop) [DecidablePred E] (hp : 0<p.event E) (pub : X → Rq)
    (K : Rq → Prop) (source : ∀ x, p.mass x≠0 → E x → K (pub x))
    (S : Sampler) (e : ℝ) (cert : OnKeys K S e)
    (st : Rq → State) (m : Rq → Bytes) (r : Rq → Nonce) :
    Divergence.AC (jointSim (emittedPublic p E hp pub) S st m r)
      (jointHonest (emittedPublic p E hp pub)) ∧
    Divergence.second (jointSim (emittedPublic p E hp pub) S st m r)
      (jointHonest (emittedPublic p E hp pub))≤1+e := by
  have covered := emitted_support p E hp pub K source
  exact ⟨key_joint_ac K _ S e covered cert st m r,
    key_joint_moment K _ S e covered cert st m r⟩

#print axioms restrict_legacy
#print axioms univ_to_legacy
#print axioms initial_certificate
#print axioms resetInitial_bits
#print axioms resetInitial_law
#print axioms resetInitial_certificate
#print axioms key_joint_ac
#print axioms second_self
#print axioms key_joint_moment
#print axioms map_composition
#print axioms public_marginal_of_conditioned_keypair
#print axioms emittedPublic_congr_on_emission
#print axioms conditioned_support
#print axioms mapped_support_witness
#print axioms emitted_support
#print axioms emitted_joint_certificate
end FT1536.S05.KeySupport011
