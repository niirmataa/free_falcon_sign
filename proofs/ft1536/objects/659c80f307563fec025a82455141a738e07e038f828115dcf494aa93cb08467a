import B20.Fpr.Spec

namespace B20.Fpr

set_option maxHeartbeats 8000000
set_option maxRecDepth 16384
open B20.C.Scalar
open B20.C (Val Ty BinOp bin shift bitsOp commonTy literalValue update neg)

def floorDomain (x : BitVec 64) : Prop :=
  rintDomain x ∧ x ≠ 0x8000000000000000

theorem floor_t_range (x : BitVec 64) : ((floor_t x).toNat ≤ 1) := by
  show ((x >>> 63).toNat ≤ 1)
  have h1 : ((x >>> 63).toNat = x.toNat >>> 63) := by simp [BitVec.toNat_ushiftRight]
  have hx := x.isLt
  omega

def floor_t (x : BitVec 64) : BitVec 64 := x >>> 63

def floor_mask (cc : BitVec 32) : BitVec 64 :=
  -(((63#32 - cc) >>> 31).setWidth 64)

theorem floor_mask_fold (cc : BitVec 32) :
    -(((63#32 - cc) >>> 31).setWidth 64) = floor_mask cc := rfl

theorem floor_sub63_safe (cc : BitVec 32)
    (hcc : 13 ≤ cc.toInt ∧ cc.toInt ≤ 1085) :
    B20.C.signedBitsOp .sub 63#32 cc = B20.C.bitsOp .sub 63#32 cc ∧
    (63#32 - cc).toInt = 63 - cc.toInt := by
  have h63 : (63#32 : BitVec 32).toInt = 63 := by decide
  have hb : -(2^31 : Int) ≤ (63#32).toInt - cc.toInt ∧
    (63#32).toInt - cc.toInt < 2^31 := by omega
  exact B20.C.safe_sub32 63#32 cc hb

theorem floor_mask_zero (cc : BitVec 32) (hcc : cc.toNat ≤ 63) :
    floor_mask cc = 0#64 := by
  have hsub := BitVec.toNat_sub (63#32) cc
  have h63 : (63#32 : BitVec 32).toNat = 63 := by decide
  have hV : ((((63#32 - cc) >>> 31).setWidth 64).toNat = 0) := by
    have h1 : ((((63#32 - cc) >>> 31)).toNat =
      ((63#32 - cc).toNat >>> 31)) := by
      simp
    have h2 : ((((63#32 - cc) >>> 31).setWidth 64).toNat =
      ((((63#32 - cc) >>> 31)).toNat)) := by
      exact BitVec.toNat_setWidth_of_le (by decide)
    omega
  have h0 : ((0#64 : BitVec 64).toNat = 0) := by decide
  have hX : ((((63#32 - cc) >>> 31).setWidth 64)) = 0#64 := by
    apply BitVec.eq_of_toNat_eq
    rw [hV, h0]
  have hnz : (-(0#64 : BitVec 64)) = 0#64 := by decide
  simp only [floor_mask, hX, hnz]

theorem floor_mask_all (cc : BitVec 32) (hcc : 64 ≤ cc.toNat ∧ cc.toNat < 2^31) :
    floor_mask cc = BitVec.allOnes 64 := by
  have hsub := BitVec.toNat_sub (63#32) cc
  have h63 : (63#32 : BitVec 32).toNat = 63 := by decide
  have hV : ((((63#32 - cc) >>> 31).setWidth 64).toNat = 1) := by
    have h1 : ((((63#32 - cc) >>> 31)).toNat =
      ((63#32 - cc).toNat >>> 31)) := by
      simp
    have h2 : ((((63#32 - cc) >>> 31).setWidth 64).toNat =
      ((((63#32 - cc) >>> 31)).toNat)) := by
      exact BitVec.toNat_setWidth_of_le (by decide)
    omega
  have hall : BitVec.allOnes 64 = -((1#64 : BitVec 64)) := by decide
  have h1 : ((1#64 : BitVec 64).toNat = 1) := by decide
  have hX : ((((63#32 - cc) >>> 31).setWidth 64)) = 1#64 := by
    apply BitVec.eq_of_toNat_eq
    rw [hV, h1]
  simp only [floor_mask, hX, hall]

theorem irsh_call_of_toNat (a : BitVec 64) (c : BitVec 32) (hc : c.toNat < 64) :
    shiftCalls "fpr_irsh".toList [.i64 a, .i32 c] =
      some (.i64 (a.sshiftRight c.toNat)) := by
  have hc32 : c.toNat < 2^32 := by have h := c.isLt; omega
  have heq : c = BitVec.ofNat 32 c.toNat := by
    apply BitVec.eq_of_toNat_eq
    simp
  have hto : (BitVec.ofNat 32 c.toNat).toNat = c.toNat := by
    rw [BitVec.toNat_ofNat]; exact Nat.mod_eq_of_lt hc32
  rw [heq, hto]
  exact irsh_call a ⟨c.toNat, hc⟩

def floor_xi0 (x : BitVec 64) : BitVec 64 :=
  ((rint_m0 x ^^^ -(floor_t x)) + floor_t x)

def floor_xi1 (x : BitVec 64) : BitVec 64 :=
  (floor_xi0 x).sshiftRight (rint_e2 x).toNat

def floorSpec (x : BitVec 64) : BitVec 64 :=
  ((floor_xi1 x &&& ~~~(floor_mask (rint_e x))) |||
    ((-(floor_t x)) &&& floor_mask (rint_e x)))

theorem floor_execution (x : BitVec 64) (hdom : floorDomain x) :
    B20.C.Scalar.execute shiftCalls Parsed.floorProgram [.u64 x] =
      some (.i64 (floorSpec x)) := by
  obtain ⟨hdomR, hne⟩ := hdom
  have hen : (rint_e x).toNat = (rint_e x).toInt ∧
      13 ≤ (rint_e x).toNat ∧ (rint_e x).toNat ≤ 1085 := rint_e_nat x hdomR
  have he_f : (rint_e x).toInt = 1085 - (rint_y x).toInt ∧
      -962 ≤ (rint_e x).toInt ∧ (rint_e x).toInt ≤ 1085 := rint_e_int x
  have hy_f : 0 ≤ (rint_y x).toInt ∧ (rint_y x).toInt ≤ 2047 := rint_y_int x
  have hS_cc := (B20.C.safe_sub32 1085#32 (rint_y x)
    (by simp only [lit1085_int]; omega)).1
  have ht := floor_t_range x
  have ht01 : floor_t x = 0#64 ∨ floor_t x = 1#64 := by
    have h01 : (floor_t x).toNat = 0 ∨ (floor_t x).toNat = 1 := by omega
    have hz : (0#64 : BitVec 64).toNat = 0 := by decide
    have ho : (1#64 : BitVec 64).toNat = 1 := by decide
    rcases h01 with h | h
    · left; apply BitVec.eq_of_toNat_eq; omega
    · right; apply BitVec.eq_of_toNat_eq; omega
  have htmin : floor_t x ≠ 0x8000000000000000 := by
    intro hcon
    have hmin : (0x8000000000000000 : BitVec 64).toNat = 2^63 := by decide
    have hcon2 : ((floor_t x).toNat = 2^63) := by
      rw [hcon]; exact hmin
    omega
  have hneg_t := B20.C.neg_defined_of_ne _ htmin
  have hm0le : (rint_m0 x).toNat ≤ 2^63 - 1 := by
    have hm := m0_lt x
    omega
  have hcond7 := B20.C.cond_neg_add64_le (rint_m0 x) (floor_t x) ht hm0le
  have he2lt : (rint_e2 x).toNat < 64 := (rint_e2_range (rint_e x)).1
  have hcall9 := irsh_call_of_toNat (floor_xi0 x) (rint_e2 x) he2lt
  have hccint : 13 ≤ (rint_e x).toInt ∧ (rint_e x).toInt ≤ 1085 := by omega
  have hsafe := floor_sub63_safe _ hccint
  by_cases hcase : (rint_e x).toNat < 64
  · have hmaskF : floor_mask (rint_e x) = 0#64 := floor_mask_zero _ (by omega)
    simp only [rint_y, rint_e, rint_m0, floor_t, floor_xi0, floor_xi1,
      rint_e2, floorSpec, ←floor_mask_fold, hmaskF] at hS_cc hsafe hneg_t hcall9 hcond7
    simp (config := { maxSteps := 2000000 }) [B20.C.Scalar.execute, Parsed.floorProgram,
      bindArgs, emptyState, declareOne, assign, evalBody, B20.C.Scalar.step, declareMany,
      B20.C.Scalar.evalExpr, floorSpec, floor_t, floor_xi0, floor_xi1,
      rint_m0, rint_e, rint_e2, rint_y, bin, shift, bitsOp, commonTy, Val.ty,
      B20.C.cast, literalValue, update, B20.C.notBits, hS_cc, signedBits_band32,
      ←floor_mask_fold, hmaskF, hcall9, hcond7, hneg_t, B20.C.neg_u64, hsafe]
  · have hmaskF : floor_mask (rint_e x) = BitVec.allOnes 64 :=
      floor_mask_all _ ⟨by omega, by omega⟩
    simp only [rint_y, rint_e, rint_m0, floor_t, floor_xi0, floor_xi1,
      rint_e2, floorSpec, ←floor_mask_fold, hmaskF] at hS_cc hsafe hneg_t hcall9 hcond7
    simp (config := { maxSteps := 2000000 }) [B20.C.Scalar.execute, Parsed.floorProgram,
      bindArgs, emptyState, declareOne, assign, evalBody, B20.C.Scalar.step, declareMany,
      B20.C.Scalar.evalExpr, floorSpec, floor_t, floor_xi0, floor_xi1,
      rint_m0, rint_e, rint_e2, rint_y, bin, shift, bitsOp, commonTy, Val.ty,
      B20.C.cast, literalValue, update, B20.C.notBits, hS_cc, signedBits_band32,
      ←floor_mask_fold, hmaskF, hcall9, hcond7, hneg_t, B20.C.neg_u64, hsafe]

end B20.Fpr
