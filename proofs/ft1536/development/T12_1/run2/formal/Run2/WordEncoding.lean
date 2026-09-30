import Run2.SignedMachine

namespace FT1536.Run2.BitArithmetic

/- Boundary representation, not a runtime conversion primitive: these are
the bits of the mathematical input value supplied to the bit program. -/
def encodeNat (n : ℕ) : ℕ → List Bool
  | 0 => []
  | k+1 => decide (n%2=1)::encodeNat (n/2) k

theorem encodeNat_length (n k : ℕ) : (encodeNat n k).length=k := by
  induction k generalizing n with
  | zero => rfl
  | succ k ih => simp only [encodeNat,List.length_cons,ih]

theorem encodeNat_value (n k : ℕ) (h : n<2^k) : value (encodeNat n k)=n := by
  induction k generalizing n with
  | zero =>
    have hn : n=0 := by simpa using h
    simp only [encodeNat,value,hn]
  | succ k ih =>
    have hd : n/2<2^k := by
      rw [pow_succ] at h
      omega
    have hm:=Nat.mod_lt n (by decide : 0<2)
    have he:=Nat.mod_add_div n 2
    simp only [encodeNat,value,ih (n/2) hd,bit]
    split <;> simp_all only [decide_eq_true_eq]
    all_goals omega

def encodeSigned (n : ℤ) (k : ℕ) : SignedWord :=
  ⟨decide (n<0),encodeNat n.natAbs k⟩

theorem encodeSigned_correct (n : ℤ) (k : ℕ) (h : n.natAbs<2^k) :
    signedValue (encodeSigned n k)=n := by
  simp only [encodeSigned,signedValue,encodeNat_value n.natAbs k h,decide_eq_true_eq]
  split
  next hn => rw [Int.natCast_natAbs,abs_of_neg hn,neg_neg]
  next hn => rw [Int.natCast_natAbs,abs_of_nonneg (by omega)]

theorem encodeSigned_length (n : ℤ) (k : ℕ) : (encodeSigned n k).magnitude.length=k :=
  encodeNat_length _ _

theorem value_injective_at_length (xs ys : List Bool) (hl : xs.length=ys.length)
    (hv : value xs=value ys) : xs=ys := by
  induction xs generalizing ys with
  | nil => exact (List.eq_nil_of_length_eq_zero hl.symm).symm
  | cons a as ih =>
    cases ys with
    | nil => simp at hl
    | cons b bs =>
      have hlen : as.length=bs.length := by simpa only [List.length_cons,Nat.add_right_cancel_iff] using hl
      simp only [value] at hv
      cases a <;> cases b <;> simp only [bit_false,bit_true] at hv
      · exact congrArg (List.cons false) (ih bs hlen (by omega))
      · omega
      · omega
      · exact congrArg (List.cons true) (ih bs hlen (by omega))

theorem encodeNat_roundtrip (xs : List Bool) : encodeNat (value xs) xs.length=xs :=
  value_injective_at_length _ _ (encodeNat_length _ _) (encodeNat_value _ _ (value_lt xs))

def wordEquiv (n : ℕ) : List.Vector Bool n ≃ Fin (2^n) where
  toFun xs := ⟨value xs.val,by simpa only [xs.property] using value_lt xs.val⟩
  invFun v := ⟨encodeNat v.val n,encodeNat_length _ _⟩
  left_inv xs := by
    apply Subtype.ext
    simpa only [xs.property] using encodeNat_roundtrip xs.val
  right_inv v := Fin.ext (encodeNat_value _ _ v.isLt)

end FT1536.Run2.BitArithmetic
