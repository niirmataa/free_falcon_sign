import Mathlib.Data.BitVec

namespace B20.Word

/-- Literal split-shift expressions; `n < 64` is required by the helper API. -/
def ursh (x : BitVec 64) (n : Nat) : BitVec 64 :=
  (x ^^^ ((x ^^^ (x >>> 32)) &&& -(BitVec.ofNat 64 (n / 32)))) >>> (n % 32)

def ulsh (x : BitVec 64) (n : Nat) : BitVec 64 :=
  (x ^^^ ((x ^^^ (x <<< 32)) &&& -(BitVec.ofNat 64 (n / 32)))) <<< (n % 32)

theorem split_count (n : Nat) (hn : n < 64) :
    n / 32 < 2 ∧ n % 32 < 32 ∧ n = 32 * (n / 32) + n % 32 := by omega

theorem ursh_refines (x : BitVec 64) (n : Nat) (hn : n < 64) :
    ursh x n = x >>> n := by
  have h : n / 32 = 0 ∨ n / 32 = 1 := by omega
  rcases h with h | h
  · have he : n % 32 = n := by omega
    simp [ursh, h, he]
  · have he : 32 + n % 32 = n := by omega
    simp only [ursh, h, show -(BitVec.ofNat 64 1) = BitVec.allOnes 64 by decide,
      BitVec.and_allOnes, ← BitVec.xor_assoc, BitVec.xor_self, BitVec.zero_xor,
      ← BitVec.shiftRight_add, he]

theorem ulsh_refines (x : BitVec 64) (n : Nat) (hn : n < 64) :
    ulsh x n = x <<< n := by
  have h : n / 32 = 0 ∨ n / 32 = 1 := by omega
  rcases h with h | h
  · have he : n % 32 = n := by omega
    simp [ulsh, h, he]
  · have he : 32 + n % 32 = n := by omega
    simp only [ulsh, h, show -(BitVec.ofNat 64 1) = BitVec.allOnes 64 by decide,
      BitVec.and_allOnes, ← BitVec.xor_assoc, BitVec.xor_self, BitVec.zero_xor,
      ← BitVec.shiftLeft_add, he]

/-- Two's-complement signed shifts for the declared GCC/LP64 C model. -/
def irsh (x : BitVec 64) (n : Nat) : BitVec 64 :=
  (x ^^^ ((x ^^^ x.sshiftRight 32) &&& -(BitVec.ofNat 64 (n / 32)))).sshiftRight (n % 32)

theorem irsh_refines (x : BitVec 64) (n : Nat) (hn : n < 64) :
    irsh x n = x.sshiftRight n := by
  have h : n / 32 = 0 ∨ n / 32 = 1 := by omega
  rcases h with h | h
  · have he : n % 32 = n := by omega
    simp [irsh, h, he]
  · have he : 32 + n % 32 = n := by omega
    simp only [irsh, h, show -(BitVec.ofNat 64 1) = BitVec.allOnes 64 by decide,
      BitVec.and_allOnes, ← BitVec.xor_assoc, BitVec.xor_self, BitVec.zero_xor,
      ← BitVec.sshiftRight_add, he]

#print axioms ursh_refines
#print axioms ulsh_refines
#print axioms irsh_refines

end B20.Word
