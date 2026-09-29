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

theorem neg_defined_of_ne_min (x : BitVec 64) (h : x ≠ BitVec.intMin 64) :
    neg (.i64 x) = some (.i64 (-x)) := by
  simp [neg, BitVec.toInt_neg_of_ne_intMin h]

end B20.C
