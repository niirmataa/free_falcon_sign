import Run2.TargetLaw

namespace FT1536.Run2
open Finset Divergence

theorem second_self {α : Type} [Fintype α] (p : Law α) : second p p=1 := by
  unfold second
  calc
    _ = ∑ x,p.mass x := by
      apply sum_congr rfl
      intro x _
      by_cases hx:p.mass x=0
      · simp [hx]
      · field_simp
    _ = 1 := p.total

/- A proved comparison witness, not a sampler certificate or an assumed
advantage bound. Its latent space retains all random observations. -/
structure Comparison {α : Type} (C : ℝ) (P J : Dist α) where
  Ω : Type
  finite : Fintype Ω
  p : @Law Ω finite
  j : @Law Ω finite
  out : Ω → α
  real_semantics : Dist.Same ((Dist.draw p).map out) P
  sim_semantics : Dist.Same ((Dist.draw j).map out) J
  ac : AC j p
  moment : second j p≤C

attribute [instance] Comparison.finite

namespace Comparison
noncomputable def refl {α : Type} (P : Dist α) : Comparison 1 P P where
  Ω := P.Sample
  finite := P.finite
  p := P.law
  j := P.law
  out := P.out
  real_semantics := fun _ => rfl
  sim_semantics := fun _ => rfl
  ac := fun _ h => h
  moment := (second_self _).le

noncomputable def ofLaws {α : Type} [Fintype α] (p j : Law α) (C : ℝ)
    (ha : AC j p) (hm : second j p≤C) : Comparison C (Dist.draw p) (Dist.draw j) where
  Ω := α
  finite := inferInstance
  p := p
  j := j
  out := id
  real_semantics := fun _ => rfl
  sim_semantics := fun _ => rfl
  ac := ha
  moment := hm

noncomputable def weaken {α : Type} {C D : ℝ} {P J : Dist α}
    (c : Comparison C P J) (h : C≤D) : Comparison D P J :=
  {c with moment := c.moment.trans h}

noncomputable def transport {α : Type} {C : ℝ} {P J P' J' : Dist α}
    (c : Comparison C P J) (hp : Dist.Same P P') (hj : Dist.Same J J') : Comparison C P' J' :=
  {c with real_semantics := Dist.same_trans c.real_semantics hp,
          sim_semantics := Dist.same_trans c.sim_semantics hj}

noncomputable def map {α β : Type} {C : ℝ} {P J : Dist α}
    (c : Comparison C P J) (f : α → β) : Comparison C (P.map f) (J.map f) where
  Ω := c.Ω
  finite := c.finite
  p := c.p
  j := c.j
  out := f ∘ c.out
  real_semantics := c.real_semantics |> fun h => Dist.same_map h f
  sim_semantics := c.sim_semantics |> fun h => Dist.same_map h f
  ac := c.ac
  moment := c.moment

noncomputable def dependentJoint {α : Type} [Fintype α] {β : α → Type}
    [∀ a,Fintype (β a)] (p : Law α) (k : (a : α) → Law (β a)) : Law (Sigma β) where
  mass z := p.mass z.1*(k z.1).mass z.2
  nonneg z := mul_nonneg (p.nonneg _) ((k _).nonneg _)
  total := by
    rw [Fintype.sum_sigma]
    simp_rw [←mul_sum]
    have hh (a : α) : (∑ b,(k a).mass b)=1 := (k a).total
    simp_rw [hh,mul_one]
    exact p.total

theorem dependent_ac {α : Type} [Fintype α] {β : α → Type} [∀ a,Fintype (β a)]
    (p j : Law α) (kp kj : (a : α) → Law (β a))
    (h : AC j p) (hk : ∀ a,AC (kj a) (kp a)) :
    AC (dependentJoint j kj) (dependentJoint p kp) := by
  intro z hz
  rcases mul_eq_zero.mp hz with ha | hb
  · simp [dependentJoint,h _ ha]
  · simp [dependentJoint,hk _ _ hb]

theorem dependent_moment {α : Type} [Fintype α] {β : α → Type} [∀ a,Fintype (β a)]
    (p j : Law α) (kp kj : (a : α) → Law (β a)) (D : ℝ)
    (hk : ∀ a,second (kj a) (kp a)≤D) :
    second (dependentJoint j kj) (dependentJoint p kp)≤second j p*D := by
  unfold second
  rw [Fintype.sum_sigma,sum_mul]
  apply sum_le_sum
  intro a _
  have he : (∑ b,(dependentJoint j kj).mass ⟨a,b⟩^2/(dependentJoint p kp).mass ⟨a,b⟩) =
      (j.mass a^2/p.mass a)*second (kj a) (kp a) := by
    rw [second,mul_sum]
    apply sum_congr rfl
    intro b _
    simp only [dependentJoint,mul_pow,mul_div_mul_comm]
  rw [he]
  exact mul_le_mul_of_nonneg_left (hk a) (div_nonneg (sq_nonneg _) (p.nonneg a))

noncomputable def bind {α β : Type} {C D : ℝ} {P J : Dist α}
    {f g : α → Dist β} (c : Comparison C P J) (k : ∀ a,Comparison D (f a) (g a))
    (hD : 0≤D) : Comparison (C*D) (P.bind f) (J.bind g) where
  Ω := (a : c.Ω) × (k (c.out a)).Ω
  finite := inferInstance
  p := dependentJoint c.p (fun a => (k (c.out a)).p)
  j := dependentJoint c.j (fun a => (k (c.out a)).j)
  out z := (k (c.out z.1)).out z.2
  real_semantics := by
    intro F
    change (∑ z : (a : c.Ω) × (k (c.out a)).Ω,
      c.p.mass z.1*(k (c.out z.1)).p.mass z.2*F ((k (c.out z.1)).out z.2)) = _
    rw [Fintype.sum_sigma]
    have he (a : c.Ω) : (∑ b,c.p.mass a*(k (c.out a)).p.mass b*F ((k (c.out a)).out b)) =
        c.p.mass a*(f (c.out a)).expect F := by
      have hh := (k (c.out a)).real_semantics F
      change (∑ b,(k (c.out a)).p.mass b*F ((k (c.out a)).out b)) = _ at hh
      simp_rw [mul_assoc,←mul_sum]
      rw [hh]
    simp_rw [he]
    rw [Dist.expect_bind]
    exact c.real_semantics (fun a => (f a).expect F)
  sim_semantics := by
    intro F
    change (∑ z : (a : c.Ω) × (k (c.out a)).Ω,
      c.j.mass z.1*(k (c.out z.1)).j.mass z.2*F ((k (c.out z.1)).out z.2)) = _
    rw [Fintype.sum_sigma]
    have he (a : c.Ω) : (∑ b,c.j.mass a*(k (c.out a)).j.mass b*F ((k (c.out a)).out b)) =
        c.j.mass a*(g (c.out a)).expect F := by
      have hh := (k (c.out a)).sim_semantics F
      change (∑ b,(k (c.out a)).j.mass b*F ((k (c.out a)).out b)) = _ at hh
      simp_rw [mul_assoc,←mul_sum]
      rw [hh]
    simp_rw [he]
    rw [Dist.expect_bind]
    exact c.sim_semantics (fun a => (g a).expect F)
  ac := dependent_ac _ _ _ _ c.ac (fun a => (k (c.out a)).ac)
  moment := (dependent_moment _ _ _ _ D (fun a => (k (c.out a)).moment)).trans
    (mul_le_mul_of_nonneg_right c.moment hD)

theorem event_bound {α : Type} {C : ℝ} {P J : Dist α} (c : Comparison C P J)
    (hC : 1≤C) (E : α → Prop) : P.event E≤EventTransfer.phi (C-1) (J.event E) := by
  classical
  let d := densityOfAC c.j c.p c.ac
  have hm : energy c.p d.ratio-1≤C-1 := by
    rw [energy_eq_second]
    linarith [c.moment]
  have hh := EventTransfer.phi_bound (show 0≤C-1 by linarith)
    (c.j.event_nonneg (fun x => E (c.out x))) (c.j.event_le_one (fun x => E (c.out x)))
    (EventTransfer.event_quadratic c.j c.p d (fun x => E (c.out x)) (C-1) hm)
  have hp := Dist.same_event _ _ c.real_semantics E
  have hj := Dist.same_event _ _ c.sim_semantics E
  change c.p.event (fun x => E (c.out x)) = P.event E at hp
  change c.j.event (fun x => E (c.out x)) = J.event E at hj
  rwa [hp,hj] at hh

end Comparison
end FT1536.Run2
