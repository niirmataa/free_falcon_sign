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

/-- The sampler's per-challenge reply law (F04 repair, variant A): the
noise-only tape map at the ROM challenge `c`. The challenge itself is not
drawn here — it is the ROM hash answer `H(r‖m)`, supplied as an input of the
noise map and sampled outside the tape in `samplerLaw`/`sample`. -/
noncomputable def replyLaw (S : Sampler) (h : Rq) (st : State) (m : Bytes) (r : Nonce)
    (c : Rq) : Law (Option BoxVec) := Law.uniform.map (S.code h st m r c)

/-- THE challenge-from-ROM joint signing law (F04 repair, variant A): at a
fresh signing point the challenge `c` is the ROM hash answer `H(r‖m)` — the
lazy ROM draw `Law.uniform` on `Rq`, OUTSIDE the sampler's fair-bit tape —
and the conditional reply law at `c` is the noise-only `replyLaw`. Formally
`Divergence.joint Law.uniform (replyLaw S h st m r)`, so the challenge
marginal IS `Law.uniform` (`JointDecomp.marginal_joint`) and the conditional
at `c` IS `replyLaw ... c` (`JointDecomp.condOf_joint`) — kernel facts of the
construction, not premises. This factorization replaces the impossible
`UniformChallengeAt` bridge of the pre-audit model (F04): no
uniform-preserving map out of a finite tape is used or needed. -/
noncomputable def samplerLaw (S : Sampler) (h : Rq) (st : State) (m : Bytes) (r : Nonce) :
    Law (Rq × Option BoxVec) := Divergence.joint (Law.uniform : Law Rq) (replyLaw S h st m r)

/-- Joint mass of the ROM-sourced signing law: the ROM challenge mass times
the noise-only reply mass at that challenge. -/
theorem samplerLaw_mass (S : Sampler) (h : Rq) (st : State) (m : Bytes) (r : Nonce)
    (c : Rq) (o : Option BoxVec) :
    (samplerLaw S h st m r).mass (c, o)
      = (Law.uniform : Law Rq).mass c * (replyLaw S h st m r c).mass o := rfl

/-- Pushforward of a law at the mass level: a `map`ped law integrates any
downstream function exactly like the preimage sum (the `Law`-level form of
`draw_pushforward`). -/
theorem map_expect {α β : Type} [Fintype α] [Fintype β] [DecidableEq β]
    (p : Law α) (g : α → β) (F : β → ℝ) :
    ∑ b, (p.map g).mass b * F b = ∑ a, p.mass a * F (g a) := by
  simp_rw [FiberBinding.map_mass]
  calc ∑ b : β, (∑ a : α, if g a = b then p.mass a else 0) * F b
      = ∑ b : β, ∑ a : α, (if g a = b then p.mass a else 0) * F b := by
        apply sum_congr rfl
        intro b _
        rw [sum_mul]
    _ = ∑ a : α, ∑ b : β, (if g a = b then p.mass a else 0) * F b := by
        rw [Finset.sum_comm]
    _ = ∑ a : α, ∑ b : β, if g a = b then p.mass a * F b else 0 := by
        apply sum_congr rfl
        intro a _
        apply sum_congr rfl
        intro b _
        rw [ite_mul, zero_mul]
    _ = ∑ a : α, p.mass a * F (g a) := by
        apply sum_congr rfl
        intro a _
        have hflip : ∀ b : β, (if g a = b then p.mass a * F b else 0)
            = if b = g a then p.mass a * F b else 0 := by
          intro b
          by_cases h : b = g a
          · simp [h]
          · have h' : g a ≠ b := fun he => h he.symm
            simp [h, h']
        simp_rw [hflip]
        exact Finset.sum_ite_eq_of_mem' univ (g a) (fun b => p.mass a * F b)
          (Finset.mem_univ _)

/-- Integration against a joint law factorizes (Fubini for
`Divergence.joint`): the joint sum is the challenge-weighted sum of the
per-challenge sums. -/
theorem joint_expect {α β : Type} [Fintype α] [Fintype β]
    (p : Law α) (k : α → Law β) (F : α × β → ℝ) :
    ∑ z : α × β, (Divergence.joint p k).mass z * F z
      = ∑ a : α, p.mass a * ∑ b : β, (k a).mass b * F (a, b) := by
  rw [Fintype.sum_prod_type]
  calc ∑ a : α, ∑ b : β, (Divergence.joint p k).mass (a, b) * F (a, b)
      = ∑ a : α, ∑ b : β, p.mass a * ((k a).mass b * F (a, b)) := by
        apply sum_congr rfl
        intro a _
        apply sum_congr rfl
        intro b _
        show (p.mass a * (k a).mass b) * F (a, b)
          = p.mass a * ((k a).mass b * F (a, b))
        rw [mul_assoc]
    _ = ∑ a : α, p.mass a * ∑ b : β, (k a).mass b * F (a, b) := by
        apply sum_congr rfl
        intro a _
        rw [← Finset.mul_sum]

theorem sample_law (S : Sampler) (h : Rq) (st : State) (m : Bytes) (r : Nonce) :
    Dist.Same (sample S h st m r) (Dist.draw (samplerLaw S h st m r)) := by
  classical
  intro f
  simp only [sample, Dist.expect_bind, Dist.expect_map]
  show (∑ c : Rq, (Law.uniform : Law Rq).mass c *
          ∑ w : Fin S.bits → Bool,
            (Law.uniform : Law (Fin S.bits → Bool)).mass w * f (c, S.code h st m r c w))
      = ∑ z : Rq × Option BoxVec, (samplerLaw S h st m r).mass z * f z
  have hJ : (∑ z : Rq × Option BoxVec, (samplerLaw S h st m r).mass z * f z)
      = ∑ z : Rq × Option BoxVec,
          (Divergence.joint (Law.uniform : Law Rq) (replyLaw S h st m r)).mass z * f z := rfl
  rw [hJ, joint_expect (Law.uniform : Law Rq) (replyLaw S h st m r) f]
  apply sum_congr rfl
  intro c _
  apply congrArg ((Law.uniform : Law Rq).mass c * ·)
  show (∑ w : Fin S.bits → Bool,
        (Law.uniform : Law (Fin S.bits → Bool)).mass w * f (c, S.code h st m r c w))
      = ∑ o : Option BoxVec, (replyLaw S h st m r c).mass o * f (c, o)
  exact (map_expect (Law.uniform : Law (Fin S.bits → Bool)) (S.code h st m r c)
    (fun o => f (c, o))).symm

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
