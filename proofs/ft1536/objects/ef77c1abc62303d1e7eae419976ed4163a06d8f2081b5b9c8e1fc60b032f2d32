import Mathlib.Data.Nat.ModEq
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/- Exact integer Montgomery reduction, shared by radix2^31 and radix2^16.
   The word implementation must separately be shown to compute these values.
   In particular, this theorem does not assume that a machine product fits. -/
namespace FT1536.Source3.MontgomeryArithmetic

def multiplier (a b p0i radix : ℕ) : ℕ := (a*b*p0i)%radix
def quotient (a b p p0i radix : ℕ) : ℕ := (a*b+multiplier a b p0i radix*p)/radix
def reduce (t p : ℕ) : ℕ := if t<p then t else t-p

theorem numerator_divisible (a b p p0i radix : ℕ)
    (inverse : radix∣p*p0i+1) : radix∣a*b+multiplier a b p0i radix*p := by
  apply Nat.dvd_of_mod_eq_zero
  calc
    (a*b+multiplier a b p0i radix*p)%radix = (a*b+(a*b*p0i)*p)%radix := by
      simp only [multiplier,Nat.add_mod,Nat.mul_mod,Nat.mod_mod]
    _ = (a*b*(p*p0i+1))%radix := by congr 1; ring
    _ = 0 := Nat.mod_eq_zero_of_dvd (dvd_mul_of_dvd_right inverse (a*b))

theorem numerator_bound (a b p p0i radix : ℕ) (hp : 0<p) (hpr : p<radix)
    (ha : a<p) (hb : b<p) : a*b+multiplier a b p0i radix*p<2*p*radix := by
  have hr : 0<radix := hp.trans hpr
  have hm : multiplier a b p0i radix<radix := Nat.mod_lt _ hr
  have hz : a*b<p*radix :=
    (Nat.mul_le_mul ha.le hb.le).trans_lt (Nat.mul_lt_mul_of_pos_left hpr hp)
  have hw := Nat.mul_lt_mul_of_pos_right hm hp
  nlinarith

theorem quotient_bound (a b p p0i radix : ℕ) (hp : 0<p) (hpr : p<radix)
    (ha : a<p) (hb : b<p) : quotient a b p p0i radix<2*p := by
  have hn := numerator_bound a b p p0i radix hp hpr ha hb
  exact (Nat.div_lt_iff_lt_mul (hp.trans hpr)).mpr (by simpa [Nat.mul_comm,Nat.mul_left_comm,Nat.mul_assoc] using hn)

theorem reduced_range (t p : ℕ) (ht : t<2*p) : reduce t p<p := by
  unfold reduce
  split_ifs <;> omega

theorem reduction_congruence (a b p p0i radix : ℕ)
    (inverse : radix∣p*p0i+1) :
    (reduce (quotient a b p p0i radix) p*radix)%p=(a*b)%p := by
  have hd := numerator_divisible a b p p0i radix inverse
  have he : quotient a b p p0i radix*radix=a*b+multiplier a b p0i radix*p :=
    Nat.div_mul_cancel hd
  unfold reduce
  split_ifs with ht
  · rw [he]
    simp only [Nat.add_mod,Nat.mul_mod,Nat.mod_self,Nat.mul_zero,Nat.zero_mod,Nat.add_zero,Nat.mod_mod]
  · have hpq : p≤quotient a b p p0i radix := by omega
    have hs : (quotient a b p p0i radix-p)*radix+p*radix =
        a*b+multiplier a b p0i radix*p := by
      rw [← Nat.add_mul,Nat.sub_add_cancel hpq,he]
    have hm := congrArg (fun x => x%p) hs
    simpa only [Nat.add_mod,Nat.mul_mod,Nat.mod_self,Nat.zero_mul,Nat.mul_zero,Nat.zero_mod,Nat.add_zero,Nat.mod_mod] using hm

theorem reduction_contract (a b p p0i radix : ℕ) (hp : 0<p) (hpr : p<radix)
    (ha : a<p) (hb : b<p) (inverse : radix∣p*p0i+1) :
    reduce (quotient a b p p0i radix) p<p ∧
      (reduce (quotient a b p p0i radix) p*radix)%p=(a*b)%p :=
  ⟨reduced_range _ p (quotient_bound a b p p0i radix hp hpr ha hb),
    reduction_congruence a b p p0i radix inverse⟩

end FT1536.Source3.MontgomeryArithmetic
