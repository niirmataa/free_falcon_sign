import IidRejection
namespace GaussianComparison
theorem limb25_expansion (x0 x1 y0 y1 : Int) :
    (x0+33554432*x1)*(y0+33554432*y1)=x0*y0+
      33554432*(x0*y1+x1*y0)+1125899906842624*(x1*y1) := by grind
theorem low_product_reconstruction (p lo mid hi : Nat)
    (hl : lo<33554432) (hm : mid<33554432)
    (hp : p=lo+33554432*mid+1125899906842624*hi) :
    p/1125899906842624=hi ∧ p%1125899906842624=lo+33554432*mid := by omega
theorem limb_product_ranges (x0 x1 y0 y1 : Nat)
    (h0 : x0<33554432 ∧ y0<33554432) (h1 : x1<268435456 ∧ y1<268435456) :
    x0*y0<1125899906842624 ∧ x0*y1<9007199254740992 ∧ x1*y1<72057594037927936 := by
  have a:=Nat.mul_le_mul (show x0≤33554431 by omega) (show y0≤33554431 by omega)
  have b:=Nat.mul_le_mul (show x0≤33554431 by omega) (show y1≤268435455 by omega)
  have c:=Nat.mul_le_mul (show x1≤268435455 by omega) (show y1≤268435455 by omega)
  omega
theorem round_lookup (b : Fin 8) : 200/2^b.val%2=
    if b.val=3 ∨ b.val=6 ∨ b.val=7 then 1 else 0 := by revert b;decide
theorem nearest_non_crossing (x y a b : Int) (hxy : x<y)
    (hx : b<a → a+b≤2*x) (hy : b<a → 2*y≤a+b) : a≤b := by omega
theorem specialized_center_error (unit : Nat) (h : 0<unit) : 13*unit+1<16*unit := by omega
theorem positive_trunc_counts (ex : Nat) (h : 1023≤ex ∧ ex≤1085) :
    1085-ex≤62 ∧ (1085-ex)%64=1085-ex := by omega
theorem source_precision_error_consumer (d p e q : Int)
    (h : -e*p≤q*d-q*p ∧ q*d-q*p≤e*p) :
    (q-e)*p≤q*d ∧ q*d≤(q+e)*p := by
  simp only [Int.neg_mul] at h
  simp only [Int.sub_mul,Int.add_mul];omega
end GaussianComparison
