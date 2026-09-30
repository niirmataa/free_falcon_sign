import FT1536.Basic
import Mathlib.Algebra.Ring.Prod

namespace FT1536.Run2.NTRUBasis

variable {R S : Type*} [CommRing R] [CommRing S]

/- Algebraic data of an NTRU key. This is not a redefinition of successful
   KeyGen outputs. Source refinement must supply these exact equations. -/
structure Key (reduce : R →+* S) (q : R) where
  f : R
  g : R
  bigF : R
  bigG : R
  h : S
  fInv : S
  ntru : f*bigG-g*bigF=q
  public_eq : reduce g=h*reduce f
  inverse_eq : fInv*reduce f=1

def graph (reduce : R →+* S) (h : S) (z : R×R) : S :=
  reduce z.1+h*reduce z.2

def basis {reduce : R →+* S} {q : R} (k : Key reduce q) (u : R×R) : R×R :=
  (k.g*u.1+k.bigG*u.2, -k.f*u.1-k.bigF*u.2)

theorem second_column {reduce : R →+* S} {q : R} (k : Key reduce q)
    (hq : reduce q=0) : reduce k.bigG=k.h*reduce k.bigF := by
  have hn := congrArg reduce k.ntru
  simp only [map_sub, map_mul, hq, k.public_eq] at hn
  have hm : reduce k.f*(reduce k.bigG-k.h*reduce k.bigF)=0 := by
    calc
      _ = reduce k.f*reduce k.bigG-(k.h*reduce k.f)*reduce k.bigF := by ring
      _ = 0 := hn
  have hh := congrArg (fun x : S => k.fInv*x) hm
  have he : k.fInv*(reduce k.f*(reduce k.bigG-k.h*reduce k.bigF)) =
      reduce k.bigG-k.h*reduce k.bigF := by rw [← mul_assoc, k.inverse_eq, one_mul]
  rw [he, mul_zero] at hh
  exact sub_eq_zero.mp hh

theorem basis_in_kernel {reduce : R →+* S} {q : R} (k : Key reduce q)
    (hq : reduce q=0) (u : R×R) : graph reduce k.h (basis k u)=0 := by
  have hc := second_column k hq
  simp only [graph, basis, map_add, map_mul, map_sub, map_neg, k.public_eq, hc]
  ring

theorem recover_first {reduce : R →+* S} {q : R} (k : Key reduce q) (u : R×R) :
    -k.bigF*(basis k u).1-k.bigG*(basis k u).2=q*u.1 := by
  calc
    _ = (k.f*k.bigG-k.g*k.bigF)*u.1 := by unfold basis; ring
    _ = _ := by rw [k.ntru]

theorem recover_second {reduce : R →+* S} {q : R} (k : Key reduce q) (u : R×R) :
    k.f*(basis k u).1+k.g*(basis k u).2=q*u.2 := by
  calc
    _ = (k.f*k.bigG-k.g*k.bigF)*u.2 := by unfold basis; ring
    _ = _ := by rw [k.ntru]

theorem basis_injective {reduce : R →+* S} {q : R} (k : Key reduce q)
    (hq : Function.Injective (fun x : R => q*x)) : Function.Injective (basis k) := by
  intro u v huv
  apply Prod.ext
  · apply hq
    dsimp only
    rw [← recover_first k u, ← recover_first k v, huv]
  · apply hq
    dsimp only
    rw [← recover_second k u, ← recover_second k v, huv]

theorem kernel_surjectivity {reduce : R →+* S} {q : R} (k : Key reduce q)
    (hq0 : reduce q=0) (hq : Function.Injective (fun x : R => q*x))
    (kernel_q : ∀ x : R, reduce x=0 ↔ ∃ u : R, q*u=x)
    (z : R×R) (hz : graph reduce k.h z=0) : ∃ u : R×R, basis k u=z := by
  have hs := second_column k hq0
  have hfirst : reduce (-k.bigF*z.1-k.bigG*z.2)=0 := by
    calc
      _ = -reduce k.bigF*(graph reduce k.h z) := by
        simp only [map_sub, map_mul, map_neg, graph, hs]
        ring
      _ = 0 := by rw [hz, mul_zero]
  have hsecond : reduce (k.f*z.1+k.g*z.2)=0 := by
    calc
      _ = reduce k.f*(graph reduce k.h z) := by
        simp only [map_add, map_mul, graph, k.public_eq]
        ring
      _ = 0 := by rw [hz, mul_zero]
  obtain ⟨u,hu⟩ := (kernel_q _).mp hfirst
  obtain ⟨v,hv⟩ := (kernel_q _).mp hsecond
  refine ⟨(u,v), Prod.ext (hq ?_) (hq ?_)⟩
  · calc
      q*(basis k (u,v)).1 = k.g*(q*u)+k.bigG*(q*v) := by unfold basis; ring
      _ = k.g*(-k.bigF*z.1-k.bigG*z.2)+k.bigG*(k.f*z.1+k.g*z.2) := by rw [hu,hv]
      _ = (k.f*k.bigG-k.g*k.bigF)*z.1 := by ring
      _ = q*z.1 := by rw [k.ntru]
  · calc
      q*(basis k (u,v)).2 = -k.f*(q*u)-k.bigF*(q*v) := by unfold basis; ring
      _ = -k.f*(-k.bigF*z.1-k.bigG*z.2)-k.bigF*(k.f*z.1+k.g*z.2) := by rw [hu,hv]
      _ = (k.f*k.bigG-k.g*k.bigF)*z.2 := by ring
      _ = q*z.2 := by rw [k.ntru]

noncomputable def kernelEquiv {reduce : R →+* S} {q : R} (k : Key reduce q)
    (hq0 : reduce q=0) (hq : Function.Injective (fun x : R => q*x))
    (kernel_q : ∀ x : R, reduce x=0 ↔ ∃ u : R, q*u=x) :
    (R×R) ≃ {z : R×R // graph reduce k.h z=0} :=
  Equiv.ofBijective (fun u => ⟨basis k u, basis_in_kernel k hq0 u⟩)
    ⟨fun _ _ h => basis_injective k hq (congrArg Subtype.val h), by
      intro z
      obtain ⟨u,hu⟩ := kernel_surjectivity k hq0 hq kernel_q z.val z.property
      exact ⟨u, Subtype.ext hu⟩⟩

theorem kernelEquiv_apply {reduce : R →+* S} {q : R} (k : Key reduce q)
    (hq0 : reduce q=0) (hq : Function.Injective (fun x : R => q*x))
    (kernel_q : ∀ x : R, reduce x=0 ↔ ∃ u : R, q*u=x) (u : R×R) :
    (kernelEquiv k hq0 hq kernel_q u).val=basis k u := rfl

def translateFiber (reduce : R →+* S) (h c : S) (t : R×R) (ht : graph reduce h t=c) :
    {z : R×R // graph reduce h z=0} ≃ {z : R×R // graph reduce h z=c} where
  toFun z := ⟨t+z.val, by
    have he : graph reduce h (t+z.val)=graph reduce h t+graph reduce h z.val := by
      simp only [graph, Prod.fst_add, Prod.snd_add, map_add]
      ring
    rw [he, ht, z.property, add_zero]⟩
  invFun z := ⟨z.val-t, by
    have he : graph reduce h (z.val-t)=graph reduce h z.val-graph reduce h t := by
      simp only [graph, Prod.fst_sub, Prod.snd_sub, map_sub]
      ring
    rw [he, ht, z.property, sub_self]⟩
  left_inv z := by apply Subtype.ext; simp
  right_inv z := by apply Subtype.ext; simp

noncomputable def affineEquiv {reduce : R →+* S} {q : R} (k : Key reduce q)
    (hq0 : reduce q=0) (hq : Function.Injective (fun x : R => q*x))
    (kernel_q : ∀ x : R, reduce x=0 ↔ ∃ u : R, q*u=x)
    (c : S) (t : R×R) (ht : graph reduce k.h t=c) :
    (R×R) ≃ {z : R×R // graph reduce k.h z=c} :=
  (kernelEquiv k hq0 hq kernel_q).trans (translateFiber reduce k.h c t ht)

theorem affineEquiv_apply {reduce : R →+* S} {q : R} (k : Key reduce q)
    (hq0 : reduce q=0) (hq : Function.Injective (fun x : R => q*x))
    (kernel_q : ∀ x : R, reduce x=0 ↔ ∃ u : R, q*u=x)
    (c : S) (t : R×R) (ht : graph reduce k.h t=c) (u : R×R) :
    (affineEquiv k hq0 hq kernel_q c t ht u).val=t+basis k u := rfl

end FT1536.Run2.NTRUBasis
