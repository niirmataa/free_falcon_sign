import B20.C.Integer

namespace B20.C

theorem safe_add32 (a b : BitVec 32)
    (h : -(2^31 : Int) ≤ a.toInt + b.toInt ∧ a.toInt + b.toInt < 2^31) :
    signedBitsOp .add a b = bitsOp .add a b ∧
    (a + b).toInt = a.toInt + b.toInt := by
  have hn : ¬ BitVec.saddOverflow a b := by
    intro hc
    simp only [BitVec.saddOverflow, Bool.or_eq_true, decide_eq_true_eq] at hc
    omega
  constructor
  · simp [signedBitsOp, signedSafe]
    omega
  · exact BitVec.toInt_add_of_not_saddOverflow hn

theorem safe_sub32 (a b : BitVec 32)
    (h : -(2^31 : Int) ≤ a.toInt - b.toInt ∧ a.toInt - b.toInt < 2^31) :
    signedBitsOp .sub a b = bitsOp .sub a b ∧
    (a - b).toInt = a.toInt - b.toInt := by
  have hn : ¬ BitVec.ssubOverflow a b := by
    intro hc
    simp only [BitVec.ssubOverflow, Bool.or_eq_true, decide_eq_true_eq] at hc
    omega
  constructor
  · simp [signedBitsOp, signedSafe]
    omega
  · exact BitVec.toInt_sub_of_not_ssubOverflow hn

theorem safe_add64 (a b : BitVec 64)
    (h : -(2^63 : Int) ≤ a.toInt + b.toInt ∧ a.toInt + b.toInt < 2^63) :
    signedBitsOp .add a b = bitsOp .add a b ∧
    (a + b).toInt = a.toInt + b.toInt := by
  have hn : ¬ BitVec.saddOverflow a b := by
    intro hc
    simp only [BitVec.saddOverflow, Bool.or_eq_true, decide_eq_true_eq] at hc
    omega
  constructor
  · simp [signedBitsOp, signedSafe]
    omega
  · exact BitVec.toInt_add_of_not_saddOverflow hn

theorem safe_sub64 (a b : BitVec 64)
    (h : -(2^63 : Int) ≤ a.toInt - b.toInt ∧ a.toInt - b.toInt < 2^63) :
    signedBitsOp .sub a b = bitsOp .sub a b ∧
    (a - b).toInt = a.toInt - b.toInt := by
  have hn : ¬ BitVec.ssubOverflow a b := by
    intro hc
    simp only [BitVec.ssubOverflow, Bool.or_eq_true, decide_eq_true_eq] at hc
    omega
  constructor
  · simp [signedBitsOp, signedSafe]
    omega
  · exact BitVec.toInt_sub_of_not_ssubOverflow hn

theorem neg_defined_of_ne (x : BitVec 64) (h : x ≠ 0x8000000000000000) :
    neg (.i64 x) = some (.i64 (-x)) := by
  simp only [neg, ite_eq_right h]

theorem cond_neg_add64 (a s : BitVec 64) (hs : s.toNat ≤ 1)
    (ha : a.toNat < 2^63 - 1) :
    signedBitsOp .xor a (-s) = bitsOp .xor a (-s) ∧
    (∃ r, signedBitsOp .add (a ^^^ -s) s = bitsOp .add (a ^^^ -s) s ∧
      r = (a ^^^ -s) + s ∧ r.toInt = if s.toNat = 0 then a.toInt else -(a.toInt)) := by
  have hs01 : s = 0#64 ∨ s = 1#64 := by
    have h01 : s.toNat = 0 ∨ s.toNat = 1 := by omega
    rcases h01 with h | h
    · left; apply BitVec.eq_of_toNat_eq; simp [h]
    · right; apply BitVec.eq_of_toNat_eq; simp [h]
  have ha63 : a.toNat < 2^63 := by omega
  have hane : a ≠ 0x8000000000000000 := by
    intro hcon; rw [hcon] at ha63
    simp at ha63
  refine ⟨by simp [signedBitsOp, signedSafe], ?_⟩
  rcases hs01 with rfl | rfl
  · simp [BitVec.xor_zero]
    have hz : ((a ^^^ 0#64) + 0#64).toInt = a.toInt := by simp
    have hs0 : signedSafe .add (a ^^^ 0#64) 0#64 = true := by
      simp [signedSafe, BitVec.xor_zero]
      have hlo := a.toInt_le; have hhi := a.toInt_lt
      omega
    exact ⟨_, by simp [signedBitsOp, hs0], by simp [hz], by simp⟩
  · have hneg1 : (-(1#64 : BitVec 64)) = 0xffffffffffffffff#64 := by decide
    have hxor : (a ^^^ -(1#64)) = ~~~a := by simp [hneg1, BitVec.xor_allOnes]
    have htoa : a.toInt = (a.toNat : Int) := by
      have hb : 2 * a.toNat < 2^64 := by
        have hlt := a.isLt; omega
      exact BitVec.toInt_eq_toNat_of_lt hb
    have hsafe : signedSafe .add (a ^^^ -(1#64)) 1#64 = true := by
      have h1 : ((1#64 : BitVec 64).toInt = 1) := by decide
      have hnot : (~~~a).toNat = 2^64 - 1 - a.toNat := by simp [BitVec.toNat_not]
      have hnt : (~~~a).toInt = -1 - (a.toNat : Int) := by
        have hb2 : 2 * (~~~a).toNat < 2^64 := by omega
        have he := BitVec.toInt_eq_toNat_of_lt hb2
        omega
      simp [signedSafe, hxor, h1, hnt, htoa]
      omega
    refine ⟨_, by simp [signedBitsOp, hsafe], ?_, ?_⟩
    · have : ((a ^^^ -(1#64)) + 1#64) = -a := by
        simp [hxor, BitVec.neg_eq_not_add]
      rw [this]
      exact (BitVec.toInt_neg_of_ne_intMin (by
        intro hcon; rw [hcon] at ha63
        simp [BitVec.intMin] at ha63)).symm ▸ rfl
    · simp [hneg1]

end B20.C
