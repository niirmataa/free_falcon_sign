import Run2.TargetLaw

/- Q-SAMPLER proof obligation: exact finite pushforwards, no approximation. -/
namespace FT1536.S05.FiniteLaw016
open Finset FT1536.Run2 FT1536.Run2.FiberBinding
variable {A B C : Type} [Fintype A] [Fintype B] [Fintype C]

theorem map_const [DecidableEq B] (p : Law A) (b : B) : p.map (fun _ => b)=Law.pure b := by
  apply law_ext
  intro x
  rw [map_mass]
  by_cases hx : b=x
  · subst x; simp [p.total,Law.pure]
  · simp [hx,Ne.symm hx,Law.pure]

theorem bind_pure [DecidableEq A] (p : Law A) : p.bind Law.pure=p := by
  apply law_ext
  intro x
  simp [Law.bind,Law.pure]

theorem map_bind [DecidableEq B] (p : Law A) (f : A → B) (k : B → Law C) :
    (p.map f).bind k=p.bind (fun x => k (f x)) := by
  apply law_ext
  intro z
  simp only [Law.bind,map_mass]
  simp_rw [sum_mul]
  rw [sum_comm]
  apply sum_congr rfl
  intro x _
  simp [ite_mul]

theorem map_map [DecidableEq B] [DecidableEq C] (p : Law A) (f : A → B) (g : B → C) :
    (p.map f).map g=p.map (g ∘ f) :=
  map_bind p f (fun x => Law.pure (g x))

theorem joint_map [DecidableEq C] (p : Law A) (q : Law B) (f : A×B → C) :
    (Divergence.joint p (fun _ => q)).map f=p.bind (fun a => q.map (fun b => f (a,b))) := by
  apply law_ext
  intro c
  simp only [Law.map,Law.bind,Divergence.joint,Fintype.sum_prod_type]
  simp_rw [mul_sum,mul_assoc]

theorem uniform_product_map [Nonempty A] [Nonempty B] [DecidableEq C] (f : A×B → C) :
    (Law.uniform : Law (A×B)).map f=(Law.uniform : Law A).bind
      (fun a => (Law.uniform : Law B).map (fun b => f (a,b))) := by
  rw [←uniform_joint]
  exact joint_map _ _ _

theorem map_domination [DecidableEq B] (p q : Law A) (K : ℝ)
    (h : ∀ a,p.mass a≤K*q.mass a) (f : A → B) :
    ∀ b,(p.map f).mass b≤K*(q.map f).mass b := by
  intro b
  rw [map_mass,map_mass,mul_sum]
  apply sum_le_sum
  intro a _
  by_cases ha : f a=b
  · simpa only [ha,ite_true] using h a
  · simp [ha]

#print axioms map_const
#print axioms bind_pure
#print axioms map_bind
#print axioms map_map
#print axioms joint_map
#print axioms uniform_product_map
#print axioms map_domination
end FT1536.S05.FiniteLaw016
