import Run2.GameInvariants
import Run2.FiberBinding
import Run2.LazySampling

namespace FT1536.Run2
open Finset Games PublicSimulation
open FT1536.Relation

theorem draw_pushforward {α β γ : Type} [Fintype α] [Fintype β] [DecidableEq β]
    (p : Law α) (g : α → β) (f : β → Dist γ) :
    Dist.Same ((Dist.draw (p.map g)).bind f) ((Dist.draw p).bind fun x => f (g x)) := by
  intro h
  simp only [Dist.expect_bind]
  change (∑ b,(p.map g).mass b*(f b).expect h) = ∑ x,p.mass x*(f (g x)).expect h
  simp_rw [FiberBinding.map_mass, sum_mul]
  rw [sum_comm]
  apply sum_congr rfl
  intro x _
  simp [ite_mul]

noncomputable def samplerLaw (S : Sampler) (h : Rq) (st : State) (m : Bytes) (r : Nonce) :
    Law (Rq × Option BoxVec) := Law.uniform.map (S.code h st m r)

theorem sample_law (S : Sampler) (h : Rq) (st : State) (m : Bytes) (r : Nonce) :
    Dist.Same (sample S h st m r) (Dist.draw (samplerLaw S h st m r)) := by
  intro f
  have hh := draw_pushforward (Law.uniform : Law (Fin S.bits → Bool)) (S.code h st m r) Dist.pure f
  simp only [Dist.expect_bind,Dist.expect_pure] at hh
  exact hh.symm

/- All premises are LOCAL kernels at a fresh signing point. They do not
contain any whole-game advantage, lazy-sampling equivalence, or cost of B. -/
structure LocalJointCertificate (S : Sampler) (e : ℝ) : Prop where
  nonnegative : 0 ≤ e
  ac : ∀ h st m r, Divergence.AC (samplerLaw S h st m r) (SigmaMath.freshHonest h)
  moment : ∀ h st m r,
    Divergence.second (samplerLaw S h st m r) (SigmaMath.freshHonest h) ≤ 1+e

theorem stopped_fresh_kernel (h : Rq) (st : State) (m : Bytes) :
    signHonest h st m true =
      (Dist.draw (Law.uniform : Law Nonce)).bind (fun r =>
        match ROM.lookup (some r,m) (submitted m st).table with
        | some _ => Dist.pure none
        | none => (Dist.draw (SigmaMath.freshHonest h)).map (programmedReply (submitted m st) m r)) := by
  simp only [signHonest,parse_frame,ite_true]
  rfl

theorem simulated_fresh_kernel (S : Sampler) (h : Rq) (st : State) (m : Bytes) :
    Dist.Same (signSim S h st m)
      ((Dist.draw (Law.uniform : Law Nonce)).bind (fun r =>
        match ROM.lookup (some r,m) (submitted m st).table with
        | some _ => Dist.pure none
        | none => (Dist.draw (samplerLaw S h (submitted m st) m r)).map
            (programmedReply (submitted m st) m r))) := by
  intro f
  simp only [signSim,parse_frame,Dist.expect_bind]
  apply Dist.expect_congr
  intro r
  cases he : ROM.lookup (some r,m) (submitted m st).table with
  | some e => rfl
  | none =>
    exact sample_law S h (submitted m st) m r (fun x => f (programmedReply (submitted m st) m r x))

theorem honest_joint_body (h : Rq) (c : Rq) (o : Option BoxVec) :
    (SigmaMath.freshHonest h).mass (c,o) =
      (1/(Fintype.card Rq : ℝ)) * (signBody (SigmaMath.syndrome h) c).mass o := rfl

theorem one_key_public_marginal {SK : Type} [Fintype SK] (beta : Budget)
    (muKey : Law (SK × Rq)) (A : ClassicalAdversary beta) (stop : Bool) :
    Dist.Same (runEUF beta muKey A stop)
      ((Dist.draw (SigmaMath.muH muKey)).bind fun h =>
        (Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
          (honest h initial stop (A.code h coins)).bind (finishHonest h)) := by
  intro f
  have hh := draw_pushforward muKey Prod.snd (fun h =>
        (Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
          (honest h initial stop (A.code h coins)).bind (finishHonest h)) f
  exact hh.symm

theorem exact_message_freshness_gate (h : Rq) (cs : List Rq) (f : Finished)
    (hm : f.forgery.message ∈ f.state.table.seen) : finishSim h cs (some f) = none := by
  simp [finishSim,hm]

end FT1536.Run2
