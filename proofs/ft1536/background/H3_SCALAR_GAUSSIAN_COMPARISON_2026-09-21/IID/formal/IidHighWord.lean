import IidBerExp
namespace ScalarIID
theorem limb_expansion (x0 x1 y0 y1 : Int) :
    (x0+4294967296*x1)*(y0+4294967296*y1)=
    x0*y0+4294967296*(x0*y1+x1*y0)+18446744073709551616*(x1*y1) := by grind
theorem high_carry (lo a b xy c : Nat) (hl : lo<4294967296)
    (he : xy=lo+4294967296*a+4294967296*b+18446744073709551616*c) :
    xy/18446744073709551616=a/4294967296+b/4294967296+
      (a%4294967296+b%4294967296)/4294967296+c := by omega
theorem first_limb_sum_bound (x0 y0 y1 : Nat)
    (hx : x0<4294967296) (hy0 : y0<4294967296) (hy1 : y1<4294967296) :
    x0*y1+x0*y0/4294967296<18446744073709551616 := by
  have h0:=Nat.mul_le_mul (show x0≤4294967295 by omega) (show y0≤4294967295 by omega)
  have h1:=Nat.mul_le_mul (show x0≤4294967295 by omega) (show y1≤4294967295 by omega)
  omega
theorem high_product_range (x y : Nat) (hx : x<18446744073709551616) (hy : y<18446744073709551616) :
    x*y/18446744073709551616<18446744073709551616 := by
  have h:=Nat.mul_le_mul (show x≤18446744073709551615 by omega) (show y≤18446744073709551615 by omega)
  omega
end ScalarIID
