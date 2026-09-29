import B20.Word.FoundationConverse
import Init.Data.BitVec.Lemmas
import Lean.Elab.Tactic.Omega

namespace B20.Word
open B20.Foundation

theorem byteAt_write (m : Memory) (base : Nat) (v : Word64) (i : Nat) (hi : i < 8) :
    (m.writeU64 base v).byteAt (base + i) = (v.toNat / 2^(8*i)) % 256 := by
  have hge : base + i ≥ base := by omega
  have hsub : base + i - base = i := by omega
  simp [Memory.byteAt, Memory.writeU64, hge, hsub, hi, Nat.shiftRight_eq_div_pow]

theorem write_frame (m : Memory) (base : Nat) (v : Word64) (address : Nat)
    (outside : address < base ∨ base + 8 ≤ address) :
    (m.writeU64 base v).bytes address = m.bytes address := by
  rcases outside with h | h
  · simp [Memory.writeU64, show ¬address ≥ base by omega]
  · simp [Memory.writeU64, show address ≥ base by omega,
      show ¬address - base < 8 by omega]

theorem write_legal (m : Memory) (base : Nat) (v : Word64) :
    (m.writeU64 base v).legalU64 base := by
  intro i hi
  simp [Memory.writeU64, show base + i ≥ base by omega,
    show base + i - base = i by omega, hi]

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

def byteExpansion (n : Nat) : Nat :=
  (List.range 8).foldl (fun acc i => acc + (n / 2^(8*i) % 256) * 2^(8*i)) 0

theorem byteExpansion_eq (n : Nat) : byteExpansion n = n % 18446744073709551616 := by
  unfold byteExpansion
  rw [show List.range 8 = [0, 1, 2, 3, 4, 5, 6, 7] by decide]
  simp only [List.foldl_cons, List.foldl_nil, Nat.reduceMul, Nat.reducePow]
  exact radix_eight n

theorem foldl_equal_on (xs : List Nat) (f g : Nat → Nat → Nat)
    (h : ∀ a i, i ∈ xs → f a i = g a i) (a : Nat) : xs.foldl f a = xs.foldl g a := by
  induction xs generalizing a with
  | nil => rfl
  | cons i xs ih =>
    simp only [List.foldl_cons]
    rw [h a i (by simp)]
    apply ih
    intro b j hj
    exact h b j (by simp [hj])

theorem read_write_formula (m : Memory) (base : Nat) (v : Word64) :
    (m.writeU64 base v).readU64 base = some (BitVec.ofNat 64 (byteExpansion v.toNat)) := by
  unfold Memory.readU64 byteExpansion
  apply congrArg (fun n => some (BitVec.ofNat 64 n))
  apply foldl_equal_on
  intro a i hi
  rw [byteAt_write m base v i (List.mem_range.mp hi)]

theorem read_write_roundtrip (m : Memory) (base : Nat) (v : Word64) :
    (m.writeU64 base v).readU64 base = some v := by
  rw [read_write_formula, byteExpansion_eq, Nat.mod_eq_of_lt v.isLt]
  simp

/-- Abstract P01 memory semantics only. This is not yet a theorem about the
text of shake.c:dec64le/enc64le, pointer provenance, or finite LP64 addresses. -/
theorem model_load_store_roundtrip (s : State) (base : Nat) (v : Word64) :
    CExec (.seq (.storeU64 base (.const v)) (.ret (.loadU64 base))) s
      (.returned (some v) { s with mem := s.mem.writeU64 base v }) := by
  apply (CExec_iff_eval _ _ _).mpr
  simp [evalStmt, evalExpr, read_write_roundtrip]

#print axioms byteAt_write
#print axioms write_frame
#print axioms write_legal
#print axioms radix_step
#print axioms radix_eight
#print axioms byteExpansion_eq
#print axioms foldl_equal_on
#print axioms read_write_formula
#print axioms read_write_roundtrip
#print axioms model_load_store_roundtrip

end B20.Word
