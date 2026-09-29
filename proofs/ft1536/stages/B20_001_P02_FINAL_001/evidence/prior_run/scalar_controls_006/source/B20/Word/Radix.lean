import Init.Data.Nat.Mod
import Lean.Elab.Tactic.Basic

namespace B20.Word

theorem radix_step (n a : Nat) :
    n % a + (n / a % 256) * a = n % (a * 256) := by
  rw [Nat.mod_mul, Nat.mul_comm a (n / a % 256)]

theorem radix_eight (n : Nat) :
    (0 + n / 1 % 256 * 1 + n / 256 % 256 * 256 +
    n / 65536 % 256 * 65536 + n / 16777216 % 256 * 16777216 +
    n / 4294967296 % 256 * 4294967296 +
    n / 1099511627776 % 256 * 1099511627776 +
    n / 281474976710656 % 256 * 281474976710656 +
    n / 72057594037927936 % 256 * 72057594037927936) = n % 18446744073709551616 := by
  simp only [Nat.div_one, Nat.mul_one, Nat.zero_add]
  rw [radix_step n 256, radix_step n 65536, radix_step n 16777216,
    radix_step n 4294967296, radix_step n 1099511627776,
    radix_step n 281474976710656, radix_step n 72057594037927936]

#print axioms radix_step
#print axioms radix_eight

end B20.Word
