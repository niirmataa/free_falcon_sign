import Run2.StoppingLoss

namespace FT1536.Run2
open Games StoppingLoss
open FT1536.Relation

/- This theorem is about the actual two interpreters and the actual public
constructor. It contains no arbitrary transcript predicate or game equality
premise. The resource/machine refinement is stated separately. -/
theorem concrete_euf_cma_to_mt_isis {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK×Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (e : ℝ) (cert : LocalJointCertificate S e) :
    AdvEUF beta muKey A ≤ min 1 (epsColl beta+
      EventTransfer.phi ((1+e)^beta.qs-1)
        (AdvMT (beta.qh+1) (SigmaMath.muH muKey) (Reduction.build beta A S))) := by
  apply le_min (Dist.event_le_one _ _)
  have hs := clipped_game_stopping_loss beta muKey A
  have hm := stopped_euf_to_concrete_mt beta muKey A S e cert
  dsimp only [AdvEUF] at hs
  linarith

theorem exists_concrete_reducer {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK×Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (e : ℝ) (cert : LocalJointCertificate S e) :
    ∃ B : MTAdversary (beta.qh+1), B=Reduction.build beta A S ∧
      AdvEUF beta muKey A ≤ min 1 (epsColl beta+
        EventTransfer.phi ((1+e)^beta.qs-1) (AdvMT (beta.qh+1) (SigmaMath.muH muKey) B)) :=
  ⟨Reduction.build beta A S,rfl,concrete_euf_cma_to_mt_isis beta muKey A S e cert⟩

theorem concrete_hardness_substitution {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK×Rq)) (A : ClassicalAdversary beta)
    (S : Sampler) (e epsilon : ℝ) (cert : LocalJointCertificate S e)
    (hepsilon : epsilon≤1)
    (hardness : AdvMT (beta.qh+1) (SigmaMath.muH muKey) (Reduction.build beta A S)≤epsilon) :
    AdvEUF beta muKey A ≤ min 1 (epsColl beta+EventTransfer.phi ((1+e)^beta.qs-1) epsilon) := by
  have he := cert.nonnegative
  have hd : 0≤(1+e)^beta.qs-1 := by
    have hh : 1≤(1+e)^beta.qs := one_le_pow₀ (by linarith)
    linarith
  have hp := EventTransfer.phi_mono hd (Dist.event_nonneg _ _) hardness hepsilon
  apply (concrete_euf_cma_to_mt_isis beta muKey A S e cert).trans
  apply min_le_min_left
  dsimp only [AdvMT] at *
  linarith

theorem exact_collision_parameter (beta : Budget) : epsColl beta =
    min 1 (((beta.qs : ℝ)*beta.qh+(beta.qs : ℝ)*((beta.qs-1 : ℕ) : ℝ)/2)/(2^320 : ℝ)) := by
  rw [epsColl,loss_exact]

end FT1536.Run2
