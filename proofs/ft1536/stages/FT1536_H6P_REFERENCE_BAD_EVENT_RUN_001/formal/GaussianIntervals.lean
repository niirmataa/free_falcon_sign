import GaussianMul
namespace GaussianComparison
theorem monotone_bracket (f : Nat→Nat) (mono : ∀a b,a≤b→f a≤f b)
    (lo hi x e : Nat) (hx : lo≤x ∧ x≤hi) (hl : f lo=e) (hh : f hi=e) : f x=e := by
  have h1:=mono lo x hx.1;have h2:=mono x hi hx.2;omega
theorem adjacent_cover (lo cut hi x : Nat) (h : lo≤x ∧ x≤hi) :
    (lo≤x ∧ x<cut) ∨ (cut≤x ∧ x≤hi) := by omega
theorem interval_difference (lo hi c x : Int) (h : lo≤x ∧ x≤hi) : lo-c≤x-c ∧ x-c≤hi-c := by omega
theorem finite_guard_source (e : Nat) (h : e≤393) : e<1048576 ∧ min e 63<64 := by omega
theorem nonwrap_horner (z y c : Nat) (hz : z<18446744073709551616)
    (hy : y≤c) : z*y/18446744073709551616≤c := by
  have hm:=Nat.mul_le_mul_right y (show z≤18446744073709551616 by omega)
  omega
theorem threshold_upper (y : Nat) (hy : y≤9223372036854775808) : y/256≤36028797018963968 := by omega
theorem weighted_bounds (xs : List (Int×Int)) (lo hi : Int)
    (h : ∀p∈xs,0≤p.1 ∧ lo≤p.2 ∧ p.2≤hi) :
    lo*(xs.map Prod.fst).sum≤(xs.map fun p=>p.1*p.2).sum ∧
    (xs.map fun p=>p.1*p.2).sum≤hi*(xs.map Prod.fst).sum := by
  induction xs with
  | nil => simp
  | cons p ps ih =>
    have hp:=h p (by simp)
    have hs : ∀a∈ps,0≤a.1 ∧ lo≤a.2 ∧ a.2≤hi := by intro a ha;exact h a (by simp [ha])
    have hb:=ih hs
    have h1:=Int.mul_le_mul_of_nonneg_left hp.2.1 hp.1
    have h2:=Int.mul_le_mul_of_nonneg_left hp.2.2 hp.1
    simp only [List.map_cons,List.sum_cons,Int.mul_add]
    grind
end GaussianComparison
