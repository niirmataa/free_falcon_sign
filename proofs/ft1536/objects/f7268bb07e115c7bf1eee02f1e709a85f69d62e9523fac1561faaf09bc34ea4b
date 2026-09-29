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

theorem read_write_roundtrip (m : Memory) (base : Nat) (v : Word64) :
    (m.writeU64 base v).readU64 base = some v := by
  unfold Memory.readU64
  rw [show List.range 8 = [0, 1, 2, 3, 4, 5, 6, 7] by decide]
  simp only [List.foldl_cons, List.foldl_nil,
    byteAt_write m base v 0 (by decide), byteAt_write m base v 1 (by decide),
    byteAt_write m base v 2 (by decide), byteAt_write m base v 3 (by decide),
    byteAt_write m base v 4 (by decide), byteAt_write m base v 5 (by decide),
    byteAt_write m base v 6 (by decide), byteAt_write m base v 7 (by decide)]
  congr 1
  apply BitVec.eq_of_toNat_eq
  have hv := v.isLt
  change (0 + v.toNat / 1 % 256 * 1 + v.toNat / 256 % 256 * 256 +
    v.toNat / 65536 % 256 * 65536 + v.toNat / 16777216 % 256 * 16777216 +
    v.toNat / 4294967296 % 256 * 4294967296 +
    v.toNat / 1099511627776 % 256 * 1099511627776 +
    v.toNat / 281474976710656 % 256 * 281474976710656 +
    v.toNat / 72057594037927936 % 256 * 72057594037927936) %
      18446744073709551616 = v.toNat
  omega

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
#print axioms read_write_roundtrip
#print axioms model_load_store_roundtrip

end B20.Word
