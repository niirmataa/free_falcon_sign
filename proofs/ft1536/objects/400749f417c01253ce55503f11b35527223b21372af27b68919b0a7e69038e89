import B20.Fpr.Spec

namespace B20.Fpr

set_option maxHeartbeats 8000000
set_option maxRecDepth 16384
open B20.C.Scalar
open B20.C (Val Ty BinOp bin shift bitsOp commonTy literalValue update neg)

theorem rint_execution (x : BitVec 64) (hdom : rintDomain x) :
    B20.C.Scalar.execute shiftCalls Parsed.rintProgram [.u64 x] =
      some (.i64 (rintSpec x)) := by
  have hy := rint_y_int x
  have he := rint_e_int x
  have hen : (rint_e x).toNat = (rint_e x).toInt ∧
      13 ≤ (rint_e x).toNat ∧ (rint_e x).toNat ≤ 1085 := rint_e_nat x hdom
  have hy_f : 0 ≤ (rint_y x).toInt ∧ (rint_y x).toInt ≤ 2047 := rint_y_int x
  have he_f : (rint_e x).toInt = 1085 - (rint_y x).toInt ∧
      -962 ≤ (rint_e x).toInt ∧ (rint_e x).toInt ≤ 1085 := rint_e_int x
  have h64 : (64#32 : BitVec 32).toInt = 64 := by decide
  have hS2 := (B20.C.safe_sub32 1085#32 (rint_y x) (by simp only [lit1085_int]; omega)).1
  have hS3 := (B20.C.safe_sub32 (rint_e x) 64#32 (by omega)).1
  have hs := rint_s_range x
  have hs_f : (rint_s x).toNat ≤ 1 := rint_s_range x
  have hs01 : rint_s x = 0#32 ∨ rint_s x = 1#32 := by
    have h01 : (rint_s x).toNat = 0 ∨ (rint_s x).toNat = 1 := by omega
    have hz : (0#32 : BitVec 32).toNat = 0 := by decide
    have ho : (1#32 : BitVec 32).toNat = 1 := by decide
    rcases h01 with h | h
    · left; apply BitVec.eq_of_toNat_eq; omega
    · right; apply BitVec.eq_of_toNat_eq; omega
  have hs64 : (((rint_s x).signExtend 64).toNat ≤ 1) := by
    rcases hs01 with h | h
    · rw [h]; decide
    · rw [h]; decide
  have hnegd : ((rint_s x).signExtend 64) ≠ 0x8000000000000000 := by
    intro hcon
    have hmin : (0x8000000000000000 : BitVec 64).toNat = 2^63 := by decide
    have hcon2 : (((rint_s x).signExtend 64).toNat = 2^63) := by
      rw [hcon]; exact hmin
    omega
  have hneg_eq := B20.C.neg_defined_of_ne _ hnegd
  have hf := rint_f_range (rint_d x) (rint_dd x)
  by_cases hcase : (rint_e x).toNat < 64
  · have hmask := rint_mask_all _ hcase
    have he2eq : (rint_e2 x).toNat = (rint_e x).toNat := by
      have hto : ((rint_e2 x).toNat = (rint_e x).toNat &&& 63) := by
        simp [rint_e2, BitVec.toNat_and]
      have h63 : (63 : Nat) = 2^6 - 1 := by decide
      have hid : (rint_e x).toNat &&& 63 = (rint_e x).toNat := by
        rw [h63]
        exact Nat.and_two_pow_sub_one_of_lt_two_pow (by omega)
      omega
    have he2int : 0 ≤ (rint_e2 x).toInt ∧ (rint_e2 x).toInt ≤ 63 := by
      have hb : 2 * (rint_e2 x).toNat < 2^32 := by omega
      have heq := BitVec.toInt_eq_toNat_of_lt hb
      omega
    have hm2 := rint_m2_small x hdom hcase
    have hcount := rint_sub63_count _ he2int
    have hsafe := rint_sub63_safe _ he2int
    have hcall5 := ulsh_call_of_toNat (rint_m1 x) (63#32 - rint_e2 x) hcount
    have hcall8 := ursh_call_of_toNat (rint_m1 x) (rint_e2 x) (by omega)
    have hcond := B20.C.cond_neg_add64 (rint_m2 x) ((rint_s x).signExtend 64) hs64 hm2
    have hmask_exp : (-((((1085#32 - (((x >>> 52).setWidth 32 &&& 2047#32))) - 64#32).setWidth 32 >>> 31).setWidth 64)) =
        BitVec.allOnes 64 := by
      simpa [rint_mask, rint_e, rint_y] using hmask
    simp [rint_y, rint_e, rint_m0, rint_mask, rint_m1, rint_e2, rint_d, rint_dd, rint_f, rint_m2, rint_s, hmask, hmask_exp] at hS2 hS3 hmask he2eq hsafe hf hneg_eq
    simp [rint_y, rint_e, rint_m0, rint_mask, rint_m1, rint_e2, rint_d, rint_dd, rint_f, rint_m2, rint_s, hmask_exp] at hcall5 hcall8 hcond
    rw [hmask_exp] at hcall5 hcall8 hcond
    simp (config := { maxSteps := 2000000 }) [B20.C.Scalar.execute, Parsed.rintProgram,
      bindArgs, emptyState, declareOne, assign, evalBody, B20.C.Scalar.step, declareMany,
      B20.C.Scalar.evalExpr, rintSpec, rint_y, rint_e, rint_m0, rint_mask, rint_m1, rint_e2,
      rint_d, rint_dd, rint_f, rint_m2, rint_s, bin, shift, bitsOp, commonTy, Val.ty,
      B20.C.cast, literalValue, update, hS2, hS3, signedBits_band32,
      hmask, hcall5, hcall8, hf, hneg_eq, hcond, B20.C.neg_u64, B20.C.neg_u32, hsafe]
  · have hmask := rint_mask_zero (rint_e x) ⟨by omega, by omega⟩
    have he2int : 0 ≤ (rint_e2 x).toInt ∧ (rint_e2 x).toInt ≤ 63 := by
      have hlt : (rint_e2 x).toNat < 64 := by
        have hto : ((rint_e2 x).toNat = (rint_e x).toNat &&& 63) := by
          simp [rint_e2, BitVec.toNat_and]
        have hle := Nat.and_le_right (n := (rint_e x).toNat) (m := 63)
        omega
      have hb : 2 * (rint_e2 x).toNat < 2^32 := by omega
      have heq := BitVec.toInt_eq_toNat_of_lt hb
      omega
    have hm2 := rint_m2_big x hdom hcase
    have hcount := rint_sub63_count _ he2int
    have hsafe := rint_sub63_safe _ he2int
    have hcall5 := ulsh_call_of_toNat (rint_m1 x) (63#32 - rint_e2 x) hcount
    have hcall8 := ursh_call_of_toNat (rint_m1 x) (rint_e2 x) (by
      have hto : ((rint_e2 x).toNat = (rint_e x).toNat &&& 63) := by
        simp [rint_e2, BitVec.toNat_and]
      have hle := Nat.and_le_right (n := (rint_e x).toNat) (m := 63)
      omega)
    have hcond := B20.C.cond_neg_add64 (rint_m2 x) ((rint_s x).signExtend 64) hs64 hm2
    have hmask_exp : (-((((1085#32 - (((x >>> 52).setWidth 32 &&& 2047#32))) - 64#32).setWidth 32 >>> 31).setWidth 64)) =
        0#64 := by
      simpa [rint_mask, rint_e, rint_y] using hmask
    simp [rint_y, rint_e, rint_m0, rint_mask, rint_m1, rint_e2, rint_d, rint_dd, rint_f, rint_m2, rint_s, hmask, hmask_exp] at hS2 hS3 hmask hsafe hf hneg_eq
    simp [rint_y, rint_e, rint_m0, rint_mask, rint_m1, rint_e2, rint_d, rint_dd, rint_f, rint_m2, rint_s, hmask_exp] at hcall5 hcall8 hcond
    rw [hmask_exp] at hcall5 hcall8 hcond
    simp (config := { maxSteps := 2000000 }) [B20.C.Scalar.execute, Parsed.rintProgram,
      bindArgs, emptyState, declareOne, assign, evalBody, B20.C.Scalar.step, declareMany,
      B20.C.Scalar.evalExpr, rintSpec, rint_y, rint_e, rint_m0, rint_mask, rint_m1, rint_e2,
      rint_d, rint_dd, rint_f, rint_m2, rint_s, bin, shift, bitsOp, commonTy, Val.ty,
      B20.C.cast, literalValue, update, hS2, hS3, signedBits_band32,
      hmask, hcall5, hcall8, hf, hneg_eq, hcond, B20.C.neg_u64, B20.C.neg_u32, hsafe]


end B20.Fpr
