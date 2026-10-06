import Source3.KeygenModpR
import Source3.KeygenNinv31

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option exponentiation.threshold 32768

/- Concrete generator order at logn10 (B1.03 proof obligations, checked —
   not assumptions). The pinned PRIMES3[0] generator g=1907584673 has
   multiplicative order exactly 9216 modulo p=2147355649, and its M0
   squaring g^2 has order exactly 4608. All statements are plain Nat
   computations checked by the kernel; the prime factors of 9216 = 2^10*3^2
   are 2 and 3, so the two non-trivial power checks certify each exact
   order via the standard divisor argument (recorded in
   KeygenMkgm3OrderBridge for the ZMod consumers). -/
namespace FT1536.Source3.KeygenGeneratorOrder

def p : Nat := 2147355649
def g : Nat := 1907584673

theorem modulus_value : p=KeygenNinv31.prime.toNat := by decide

theorem g_squared_value : g^2%p=1019382745 := by decide

theorem order_power : g^9216%p=1 := by decide

theorem order_exact_half : g^4608%p≠1 := by decide

theorem order_exact_third : g^3072%p≠1 := by decide

theorem order_divides : 9216=2^10*3^2 := by decide

theorem square_order_power : (g^2)^4608%p=1 := by decide

theorem square_order_exact_half : (g^2)^2304%p≠1 := by decide

theorem square_order_exact_third : (g^2)^1536%p≠1 := by decide

theorem square_order_divides : 4608=2^9*3^2 := by decide

/- The -1 laws: for the order-9216 generator and for its M0 squaring, the
   half-order power is the residue of -1. -/
theorem g_half_power : g^4608%p=p-1 := by decide

theorem squared_half_power : (g^2)^2304%p=p-1 := by decide

theorem minus_one_residue : p-1=2147355648 := by decide

end FT1536.Source3.KeygenGeneratorOrder
