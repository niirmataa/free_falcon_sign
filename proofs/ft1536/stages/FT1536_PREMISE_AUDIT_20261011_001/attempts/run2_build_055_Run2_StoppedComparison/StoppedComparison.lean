import Run2.ExecutionComparison
import Run2.ReaderBinding

namespace FT1536.Run2
open Games
open FT1536.Relation

noncomputable def simulateLazy (S : Sampler) (h : Rq) (st : State) :
    {s q : ℕ} → Program s q → Dist (Option Finished)
  | _,_,.done f => Dist.pure (some ⟨f,st⟩)
  | _,_,.hash x k => (hashHonest x st).bind fun co =>
      simulateLazy S h (recordedHash x co.1 co.2) (k co.1)
  | _,_,.sign m k => (signSim S h st m).bind fun o => match o with
    | none => Dist.pure none
    | some os => simulateLazy S h os.2 (k os.1)

noncomputable def signStepComparison (S : Sampler) (e : ℝ) (cert : LocalJointCertificate S e)
    (h : Rq) (st : State) (m : Bytes) :
    Comparison (1+e) (signHonest h st m true) (signSim S h st m) := by
  classical
  let ks := fun r : Nonce =>
    match ROM.lookup (some r,m) (submitted m st).table with
    | some _ => Dist.pure (none : Option (Reply×State))
    | none => (Dist.draw (SigmaMath.freshHonest h)).map (programmedReply (submitted m st) m r)
  let js := fun r : Nonce =>
    match ROM.lookup (some r,m) (submitted m st).table with
    | some _ => Dist.pure (none : Option (Reply×State))
    | none => (Dist.draw (samplerLaw S h (submitted m st) m r)).map (programmedReply (submitted m st) m r)
  have hc (r : Nonce) : Comparison (1+e) (ks r) (js r) := by
    dsimp [ks,js]
    split
    · exact (Comparison.refl _).weaken (by linarith [cert.nonnegative])
    · exact (Comparison.ofLaws _ _ (1+e) (cert.ac h (submitted m st) m r)
        (cert.moment h (submitted m st) m r)).map (programmedReply (submitted m st) m r)
  let cc := Comparison.bind (Comparison.refl (Dist.draw (Law.uniform : Law Nonce))) hc
    (show 0≤1+e by linarith [cert.nonnegative])
  have hp : Dist.Same ((Dist.draw (Law.uniform : Law Nonce)).bind ks) (signHonest h st m true) := by
    rw [stopped_fresh_kernel]
    exact Dist.same_refl _
  have hj : Dist.Same ((Dist.draw (Law.uniform : Law Nonce)).bind js) (signSim S h st m) :=
    Dist.same_symm (simulated_fresh_kernel S h st m)
  simpa only [one_mul] using cc.transport hp hj

noncomputable def programComparison (S : Sampler) (e : ℝ) (cert : LocalJointCertificate S e)
    (h : Rq) {s q : ℕ} (p : Program s q) : ∀ st,
    Comparison ((1+e)^s) (honest h st true p) (simulateLazy S h st p) := by
  have he := cert.nonnegative
  induction p with
  | @done s q f =>
    intro st
    exact (Comparison.refl _).weaken (one_le_pow₀ (by linarith [cert.nonnegative]))
  | @hash s q x k ih =>
    intro st
    let cc := Comparison.bind (Comparison.refl (hashHonest x st))
      (fun co => ih co.1 (recordedHash x co.1 co.2))
      (show 0≤(1+e)^s by positivity)
    simpa only [one_mul,honest,simulateLazy] using cc
  | @sign s q m k ih =>
    intro st
    let kp := fun o : Option (Reply×State) => match o with
      | none => Dist.pure (none : Option Finished)
      | some os => honest h os.2 true (k os.1)
    let kj := fun o : Option (Reply×State) => match o with
      | none => Dist.pure (none : Option Finished)
      | some os => simulateLazy S h os.2 (k os.1)
    have hc (o : Option (Reply×State)) : Comparison ((1+e)^s) (kp o) (kj o) := by
      cases o with
      | none => exact (Comparison.refl _).weaken (one_le_pow₀ (by linarith [cert.nonnegative]))
      | some os => exact ih os.1 os.2
    let cc := Comparison.bind (signStepComparison S e cert h st m) hc
      (show 0≤(1+e)^s by positivity)
    have hp : Dist.Same ((signHonest h st m true).bind kp) (honest h st true (.sign m k)) := by
      intro F
      simp only [honest,Dist.expect_bind]
      apply Dist.expect_congr
      intro o
      cases o <;> rfl
    have hj : Dist.Same ((signSim S h st m).bind kj) (simulateLazy S h st (.sign m k)) := by
      intro F
      simp only [simulateLazy,Dist.expect_bind]
      apply Dist.expect_congr
      intro o
      cases o <;> rfl
    have hh := cc.transport hp hj
    simpa only [pow_succ'] using hh

noncomputable def lazyGame (beta : Budget) (muH : Law Rq)
    (A : ClassicalAdversary beta) (S : Sampler) : Dist Bool :=
  (Dist.draw muH).bind fun h =>
    (Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
      (simulateLazy S h initial (A.code h coins)).bind (finishHonest h)

noncomputable def stoppedGameComparison {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK×Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (e : ℝ) (cert : LocalJointCertificate S e) :
    Comparison ((1+e)^beta.qs) (runEUF beta muKey A true) (lazyGame beta (SigmaMath.muH muKey) A S) := by
  have he := cert.nonnegative
  let mu := SigmaMath.muH muKey
  have hc (h : Rq) (coins : Fin beta.coinBits → Bool) :
      Comparison ((1+e)^beta.qs)
        ((honest h initial true (A.code h coins)).bind (finishHonest h))
        ((simulateLazy S h initial (A.code h coins)).bind (finishHonest h)) := by
    have hh := Comparison.bind (programComparison S e cert h (A.code h coins) initial)
      (fun o => Comparison.refl (finishHonest h o)) (by norm_num)
    simpa only [mul_one] using hh
  let hbits := fun h => Comparison.bind (Comparison.refl
    (Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool)))) (hc h)
    (show 0≤(1+e)^beta.qs by positivity)
  let hkey := Comparison.bind (Comparison.refl (Dist.draw mu)) hbits
    (show 0≤1*((1+e)^beta.qs) by positivity)
  have hp := Dist.same_symm (one_key_public_marginal beta muKey A true)
  have H := hkey.transport hp (Dist.same_refl _)
  simpa only [one_mul,lazyGame,mu] using H

theorem stopped_game_event_bound {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK×Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (e : ℝ) (cert : LocalJointCertificate S e) :
    (runEUF beta muKey A true).event (fun b => b=true) ≤
      EventTransfer.phi ((1+e)^beta.qs-1)
        ((lazyGame beta (SigmaMath.muH muKey) A S).event (fun b => b=true)) :=
  (stoppedGameComparison beta muKey A S e cert).event_bound
    (one_le_pow₀ (by linarith [cert.nonnegative])) _

end FT1536.Run2
