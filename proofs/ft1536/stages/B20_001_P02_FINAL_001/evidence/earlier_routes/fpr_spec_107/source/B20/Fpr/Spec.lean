import B20.C.ScalarCalls
import B20.C.SignedArith
import B20.Fpr.ParsedPrograms

namespace B20.Fpr

set_option maxHeartbeats 8000000
set_option maxRecDepth 16384
open B20.C.Scalar
open B20.C (Val Ty BinOp bin shift bitsOp commonTy literalValue update neg)

theorem cast_i32_1_u64 : B20.C.cast .u64 (.i32 1) = .u64 1 := by decide
theorem cast_i32_63_u64 : B20.C.cast .u64 (.i32 63) = .u64 63 := by decide

def negSpec (x : BitVec 64) : BitVec 64 := x ^^^ ((1 : BitVec 64) <<< 63)

theorem neg_execution (x : BitVec 64) :
    B20.C.Scalar.execute shiftCalls Parsed.negProgram [.u64 x] = some (.u64 (negSpec x)) := by
  simp [B20.C.Scalar.execute, Parsed.negProgram, bindArgs, emptyState, declareOne, assign,
    evalBody, B20.C.Scalar.step, B20.C.Scalar.evalExpr, negSpec, bin, shift, bitsOp,
    commonTy, Val.ty, B20.C.cast, literalValue, update]

def doubleSpec (x : BitVec 64) : BitVec 64 :=
  x + (((((x >>> 52).setWidth 32 &&& 2047#32) + 2047#32) >>> 11).setWidth 64 <<< 52)

theorem double_execution (x : BitVec 64) :
    B20.C.Scalar.execute shiftCalls Parsed.doubleProgram [.u64 x] =
      some (.u64 (doubleSpec x)) := by
  simp [B20.C.Scalar.execute, Parsed.doubleProgram, bindArgs, emptyState, declareOne,
    assign, evalBody, B20.C.Scalar.step, B20.C.Scalar.evalExpr, doubleSpec, bin,
    shift, bitsOp, commonTy, Val.ty, B20.C.cast, literalValue, update]

def halfSpec (x : BitVec 64) : BitVec 64 :=
  let x1 := x - ((1 : BitVec 64) <<< 52)
  let t := ((((x1 >>> 52).setWidth 32 &&& 2047#32) + 1#32) >>> 11)
  x1 &&& (t.setWidth 64 - 1)

theorem half_execution (x : BitVec 64) :
    B20.C.Scalar.execute shiftCalls Parsed.halfProgram [.u64 x] =
      some (.u64 (halfSpec x)) := by
  simp [B20.C.Scalar.execute, Parsed.halfProgram, bindArgs, emptyState, declareOne,
    assign, evalBody, B20.C.Scalar.step, declareMany, B20.C.Scalar.evalExpr, halfSpec, bin,
    shift, bitsOp, commonTy, Val.ty, B20.C.cast, literalValue, update]

theorem sub_execution (calls : B20.C.Scalar.Calls) (x y w : BitVec 64)
    (hadd : calls "fpr_add".toList [.u64 x, .u64 (y ^^^ ((1 : BitVec 64) <<< 63))] =
      some (.u64 w)) :
    B20.C.Scalar.execute calls Parsed.subProgram [.u64 x, .u64 y] = some (.u64 w) := by
  simp [B20.C.Scalar.execute, Parsed.subProgram, bindArgs, emptyState, declareOne,
    assign, evalBody, B20.C.Scalar.step, B20.C.Scalar.evalExpr, bin,
    shift, bitsOp, commonTy, Val.ty, B20.C.cast, literalValue, update]
  exact ⟨.u64 w, hadd, rfl⟩

theorem pack_t_range (m : BitVec 64) : ((m >>> 54).setWidth 32).toNat < 2^31 := by
  have h1 : (m >>> 54).toNat = m.toNat / 2^54 := by
    simp [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have h2 : ((m >>> 54).setWidth 32).toNat = (m >>> 54).toNat % 2^32 := by
    simp [BitVec.toNat_setWidth]
  have hm := m.isLt
  omega

def packDomain (_s e : BitVec 32) : Prop :=
  -(2^31 : Int) ≤ e.toInt + 1076 ∧ e.toInt + 1076 < 2^31

theorem pack_neg_defined (m : BitVec 64) :
    B20.C.neg (.i32 ((m >>> 54).setWidth 32)) =
      some (.i32 (-((m >>> 54).setWidth 32))) := by
  simp only [B20.C.neg]
  rw [ite_eq_right]
  intro hcon
  have hr := pack_t_range m
  have hmin : ((0x80000000 : BitVec 32)).toNat = 2^31 := by decide
  rw [hcon] at hr
  omega

theorem pack_add_safe (e : BitVec 32)
    (h : -(2^31 : Int) ≤ e.toInt + 1076 ∧ e.toInt + 1076 < 2^31) :
    B20.C.signedSafe .add e 1076#32 = true := by
  have hy : (1076#32 : BitVec 32).toInt = 1076 := by decide
  simp [B20.C.signedSafe, hy]
  omega

theorem pack_add_bits (e : BitVec 32)
    (h : -(2^31 : Int) ≤ e.toInt + 1076 ∧ e.toInt + 1076 < 2^31) :
    B20.C.signedBitsOp .add e 1076#32 = B20.C.bitsOp .add e 1076#32 := by
  simp [B20.C.signedBitsOp, pack_add_safe e h]

theorem signedBits_band32 (x y : BitVec 32) :
    B20.C.signedBitsOp .band x y = B20.C.bitsOp .band x y := by
  simp [B20.C.signedBitsOp, B20.C.signedSafe]

theorem signedBits_xor64 (x y : BitVec 64) :
    B20.C.signedBitsOp .xor x y = B20.C.bitsOp .xor x y := by
  simp [B20.C.signedBitsOp, B20.C.signedSafe]

theorem signedBits_band64 (x y : BitVec 64) :
    B20.C.signedBitsOp .band x y = B20.C.bitsOp .band x y := by
  simp [B20.C.signedBitsOp, B20.C.signedSafe]

theorem pack_f_range (x : BitVec 64) : ((x.setWidth 32 &&& 7#32).toNat < 32) := by
  have h : (x.setWidth 32 &&& 7#32).toNat ≤ 7 := by
    have hle := Nat.and_le_right (n := (x.setWidth 32).toNat) (m := (7#32).toNat)
    have h7 : (7#32 : BitVec 32).toNat = 7 := by decide
    simpa [BitVec.toNat_and, h7] using hle
  omega

theorem pack_and7_lt (n : Nat) : n &&& 7 < 32 := by
  have h : n &&& 7 ≤ 7 := Nat.and_le_right
  omega

def packSpec (s e : BitVec 32) (m : BitVec 64) : BitVec 64 :=
  let e1 := e + 1076#32
  let t := e1 >>> 31
  let m1 := m &&& (t.setWidth 64 - 1)
  let t2 := (m1 >>> 54).setWidth 32
  let e2 := e1 &&& (-t2)
  let x := (((s.signExtend 64) <<< 63) ||| (m1 >>> 2)) + ((e2.setWidth 64) <<< 52)
  let f := m1.setWidth 32 &&& 7#32
  x + (((200#32 >>> f.toNat) &&& 1#32).setWidth 64)

theorem pack_execution (s e : BitVec 32) (m : BitVec 64) (hdom : packDomain s e) :
    B20.C.Scalar.execute shiftCalls Parsed.packProgram
      [.i32 s, .i32 e, .u64 m] = some (.u64 (packSpec s e m)) := by
  simp only [packDomain] at hdom
  simp (config := { maxSteps := 200000 }) [B20.C.Scalar.execute, Parsed.packProgram,
    bindArgs, emptyState, declareOne, assign, evalBody, B20.C.Scalar.step, declareMany,
    B20.C.Scalar.evalExpr, packSpec, bin, shift, bitsOp, commonTy, Val.ty, B20.C.cast,
    literalValue, update, pack_neg_defined, pack_add_bits _ hdom, signedBits_band32, pack_and7_lt]

def rintDomain (x : BitVec 64) : Prop :=
  ((((x >>> 52).setWidth 32 &&& 2047#32).toNat ≤ 1072))

theorem rint_y_range (x : BitVec 64) :
    (((x >>> 52).setWidth 32 &&& 2047#32).toNat < 2048) := by
  have hle := Nat.and_le_right (n := (((x >>> 52).setWidth 32).toNat)) (m := (2047#32).toNat)
  have h7 : (2047#32 : BitVec 32).toNat = 2047 := by decide
  have hor : (((x >>> 52).setWidth 32 &&& 2047#32).toNat =
    ((x >>> 52).setWidth 32).toNat &&& (2047#32).toNat) := by
    simp [BitVec.toNat_and]
  omega

theorem rint_y_int (x : BitVec 64) :
    0 ≤ (((x >>> 52).setWidth 32 &&& 2047#32).toInt) ∧
    (((x >>> 52).setWidth 32 &&& 2047#32).toInt) ≤ 2047 := by
  have h := rint_y_range x
  have hb : 2 * ((((x >>> 52).setWidth 32 &&& 2047#32).toNat)) < 2^32 := by omega
  have heq := BitVec.toInt_eq_toNat_of_lt hb
  omega

theorem rint_f_range (d : BitVec 64) (dd : BitVec 32) :
    ((((d >>> 61).setWidth 32) ||| (((dd ||| -dd) >>> 31))).toNat < 32) := by
  have hor : ((((d >>> 61).setWidth 32) ||| (((dd ||| -dd) >>> 31))).toNat =
    ((d >>> 61).setWidth 32).toNat ||| (((dd ||| -dd) >>> 31)).toNat) := by
    simp [BitVec.toNat_or]
  have hA : (((d >>> 61).setWidth 32).toNat < 32) := by
    have h1 : ((d >>> 61).toNat = d.toNat >>> 61) := by simp [BitVec.toNat_ushiftRight]
    have h2 : (((d >>> 61).setWidth 32).toNat = (d >>> 61).toNat % 2^32) := by
      simp [BitVec.toNat_setWidth]
    have hd := d.isLt
    omega
  have hB : (((((dd ||| -dd) >>> 31))).toNat < 32) := by
    have h1 : (((((dd ||| -dd) >>> 31))).toNat = ((dd ||| -dd).toNat >>> 31)) := by
      simp [BitVec.toNat_ushiftRight]
    have h2 := (dd ||| -dd).isLt
    omega
  rw [hor]
  exact Nat.or_lt_two_pow (n := 5) (by omega) (by omega)

theorem rint_s_range (x : BitVec 64) : ((((x >>> 63).setWidth 32)).toNat ≤ 1) := by
  have h1 : ((x >>> 63).toNat = x.toNat >>> 63) := by simp [BitVec.toNat_ushiftRight]
  have h2 : ((((x >>> 63).setWidth 32)).toNat = (x >>> 63).toNat % 2^32) := by
    simp [BitVec.toNat_setWidth]
  have hx := x.isLt
  omega

theorem e_toNat_of_range (e : BitVec 32)
    (he : 13 ≤ e.toInt ∧ e.toInt ≤ 1085) :
    e.toNat = e.toInt ∧ 13 ≤ e.toNat ∧ e.toNat ≤ 1085 := by
  have h31 : e.toNat < 2^31 := by
    by_contra hc
    push Not at hc
    have hmsb : e.msb = true := by
      rw [BitVec.msb_eq_decide]; exact decide_eq_true hc
    have hneg := BitVec.toInt_neg_of_msb_true hmsb
    omega
  have hmsb : e.msb = false := by
    rw [BitVec.msb_eq_decide]; exact decide_eq_false (by omega)
  have heq := BitVec.toInt_eq_toNat_of_msb hmsb
  omega

def rint_m0 (x : BitVec 64) : BitVec 64 :=
  ((x <<< 10) ||| 4611686018427387904#64) &&& 9223372036854775807#64

theorem m0_lt (x : BitVec 64) : (rint_m0 x).toNat < 2^63 := by
  have htop : (9223372036854775807#64 : BitVec 64).toNat = 2^63 - 1 := by
    decide
  have hle : ((rint_m0 x).toNat ≤ (9223372036854775807#64).toNat) := by
    simp only [rint_m0]
    exact Nat.and_le_right
  omega

def rint_mask (e : BitVec 32) : BitVec 64 :=
  -((((e - 64#32).setWidth 32 >>> 31).setWidth 64))

theorem lit1085_int : (1085#32 : BitVec 32).toInt = 1085 := by decide

theorem rint_e_int (x : BitVec 64) :
    (1085#32 - (((x >>> 52).setWidth 32 &&& 2047#32))).toInt =
      1085 - ((((x >>> 52).setWidth 32 &&& 2047#32).toInt)) ∧
    -962 ≤ (1085#32 - (((x >>> 52).setWidth 32 &&& 2047#32))).toInt ∧
    (1085#32 - (((x >>> 52).setWidth 32 &&& 2047#32))).toInt ≤ 1085 := by
  have hy := rint_y_int x
  have hb : -(2^31 : Int) ≤ (1085#32).toInt - ((((x >>> 52).setWidth 32 &&& 2047#32).toInt)) ∧
    (1085#32).toInt - ((((x >>> 52).setWidth 32 &&& 2047#32).toInt)) < 2^31 := by
    simp only [lit1085_int]; omega
  have hs := (B20.C.safe_sub32 1085#32 _ hb).2
  have h1085 := lit1085_int
  refine ⟨hs, by omega, by omega⟩

theorem rint_e_nat (x : BitVec 64) (hdom : rintDomain x) :
    (1085#32 - (((x >>> 52).setWidth 32 &&& 2047#32))).toNat =
      (1085#32 - (((x >>> 52).setWidth 32 &&& 2047#32))).toInt ∧
    13 ≤ (1085#32 - (((x >>> 52).setWidth 32 &&& 2047#32))).toNat ∧
    (1085#32 - (((x >>> 52).setWidth 32 &&& 2047#32))).toNat ≤ 1085 := by
  have he := rint_e_int x
  have hy := rint_y_int x
  simp only [rintDomain] at hdom
  have hyy : ((((x >>> 52).setWidth 32 &&& 2047#32).toInt)) =
      (((((x >>> 52).setWidth 32 &&& 2047#32).toNat : Nat)) : Int) := by
    have hb : 2 * ((((x >>> 52).setWidth 32 &&& 2047#32).toNat)) < 2^32 := by
      have hr := rint_y_range x; omega
    exact BitVec.toInt_eq_toNat_of_lt hb
  have h31 : (1085#32 - (((x >>> 52).setWidth 32 &&& 2047#32))).toNat < 2^31 := by
    by_contra hc
    push Not at hc
    have hmsb : (1085#32 - (((x >>> 52).setWidth 32 &&& 2047#32))).msb = true := by
      rw [BitVec.msb_eq_decide]; exact decide_eq_true hc
    have hneg := BitVec.toInt_neg_of_msb_true hmsb
    omega
  have heq : (1085#32 - (((x >>> 52).setWidth 32 &&& 2047#32))).toInt =
      (((1085#32 - (((x >>> 52).setWidth 32 &&& 2047#32))).toNat : Nat) : Int) := by
    have hb : 2 * (1085#32 - (((x >>> 52).setWidth 32 &&& 2047#32))).toNat < 2^32 := by
      omega
    exact BitVec.toInt_eq_toNat_of_lt hb
  omega

theorem rint_mask_all (e : BitVec 32) (he : e.toNat < 64) :
    rint_mask e = BitVec.allOnes 64 := by
  have hsub := BitVec.toNat_sub e 64#32
  have h64 : (64#32 : BitVec 32).toNat = 64 := by decide
  have hV : ((((e - 64#32).setWidth 32 >>> 31).setWidth 64).toNat = 1) := by
    have h1 : ((((e - 64#32).setWidth 32 >>> 31)).toNat =
      (((e - 64#32).setWidth 32).toNat >>> 31)) := by
      simp
    have h3 : ((((e - 64#32).setWidth 32)).toNat = (e - 64#32).toNat % 2^32) := by
      simp
    have h2 : ((((e - 64#32).setWidth 32 >>> 31).setWidth 64).toNat =
      ((((e - 64#32).setWidth 32 >>> 31)).toNat)) := by
      exact BitVec.toNat_setWidth_of_le (by decide)
    omega
  have hall : BitVec.allOnes 64 = -((1#64 : BitVec 64)) := by decide
  have h1 : ((1#64 : BitVec 64).toNat = 1) := by decide
  have hX : ((((e - 64#32).setWidth 32 >>> 31).setWidth 64)) = 1#64 := by
    apply BitVec.eq_of_toNat_eq
    rw [hV, h1]
  simp only [rint_mask, hX, hall]

theorem rint_mask_zero (e : BitVec 32) (he : 64 ≤ e.toNat ∧ e.toNat < 2^31) :
    rint_mask e = 0#64 := by
  have hsub := BitVec.toNat_sub e 64#32
  have h64 : (64#32 : BitVec 32).toNat = 64 := by decide
  have hV : ((((e - 64#32).setWidth 32 >>> 31).setWidth 64).toNat = 0) := by
    have h1 : ((((e - 64#32).setWidth 32 >>> 31)).toNat =
      (((e - 64#32).setWidth 32).toNat >>> 31)) := by
      simp
    have h3 : ((((e - 64#32).setWidth 32)).toNat = (e - 64#32).toNat % 2^32) := by
      simp
    have h2 : ((((e - 64#32).setWidth 32 >>> 31).setWidth 64).toNat =
      ((((e - 64#32).setWidth 32 >>> 31)).toNat)) := by
      exact BitVec.toNat_setWidth_of_le (by decide)
    omega
  have h0 : ((0#64 : BitVec 64).toNat = 0) := by decide
  have hX : ((((e - 64#32).setWidth 32 >>> 31).setWidth 64)) = 0#64 := by
    apply BitVec.eq_of_toNat_eq
    rw [hV, h0]
  have hnz : (-(0#64 : BitVec 64)) = 0#64 := by decide
  simp only [rint_mask, hX, hnz]

theorem ulsh_call_of_toNat (m1 : BitVec 64) (c : BitVec 32) (hc : c.toNat < 64) :
    shiftCalls "fpr_ulsh".toList [.u64 m1, .i32 c] =
      some (.u64 (m1 <<< c.toNat)) := by
  have hc32 : c.toNat < 2^32 := by have h := c.isLt; omega
  have heq : c = BitVec.ofNat 32 c.toNat := by
    apply BitVec.eq_of_toNat_eq
    simp
  have hto : (BitVec.ofNat 32 c.toNat).toNat = c.toNat := by
    rw [BitVec.toNat_ofNat]; exact Nat.mod_eq_of_lt hc32
  rw [heq, hto]
  exact ulsh_call m1 ⟨c.toNat, hc⟩

theorem ursh_call_of_toNat (m1 : BitVec 64) (c : BitVec 32) (hc : c.toNat < 64) :
    shiftCalls "fpr_ursh".toList [.u64 m1, .i32 c] =
      some (.u64 (m1 >>> c.toNat)) := by
  have hc32 : c.toNat < 2^32 := by have h := c.isLt; omega
  have heq : c = BitVec.ofNat 32 c.toNat := by
    apply BitVec.eq_of_toNat_eq
    simp
  have hto : (BitVec.ofNat 32 c.toNat).toNat = c.toNat := by
    rw [BitVec.toNat_ofNat]; exact Nat.mod_eq_of_lt hc32
  rw [heq, hto]
  exact ursh_call m1 ⟨c.toNat, hc⟩


theorem rint_e2_range (e : BitVec 32) :
    ((e &&& 63#32).toNat < 64) ∧
    (0 ≤ (e &&& 63#32).toInt ∧ (e &&& 63#32).toInt ≤ 63) := by
  have hor : ((e &&& 63#32).toNat = e.toNat &&& 63) := by simp [BitVec.toNat_and]
  have hle := Nat.and_le_right (n := e.toNat) (m := 63)
  have hlt : (e &&& 63#32).toNat < 64 := by omega
  have hb : 2 * ((e &&& 63#32).toNat) < 2^32 := by omega
  have heq := BitVec.toInt_eq_toNat_of_lt hb
  refine ⟨hlt, by omega, by omega⟩

theorem rint_sub63_count (e2 : BitVec 32)
    (he2 : 0 ≤ e2.toInt ∧ e2.toInt ≤ 63) : ((63#32 - e2).toNat < 64) := by
  have h31 : e2.toNat < 2^31 := by
    by_contra hc
    push Not at hc
    have hmsb : e2.msb = true := by
      rw [BitVec.msb_eq_decide]; exact decide_eq_true hc
    have hneg := BitVec.toInt_neg_of_msb_true hmsb
    omega
  have heq : e2.toInt = (e2.toNat : Int) := by
    have hb : 2 * e2.toNat < 2^32 := by omega
    exact BitVec.toInt_eq_toNat_of_lt hb
  have hsub := BitVec.toNat_sub (63#32) e2
  have h63 : (63#32 : BitVec 32).toNat = 63 := by decide
  omega

theorem rint_sub63_safe (e2 : BitVec 32)
    (he2 : 0 ≤ e2.toInt ∧ e2.toInt ≤ 63) :
    B20.C.signedBitsOp .sub 63#32 e2 = B20.C.bitsOp .sub 63#32 e2 ∧
    (63#32 - e2).toInt = 63 - e2.toInt := by
  have h63 : (63#32 : BitVec 32).toInt = 63 := by decide
  have hb : -(2^31 : Int) ≤ (63#32).toInt - e2.toInt ∧
    (63#32).toInt - e2.toInt < 2^31 := by omega
  exact B20.C.safe_sub32 63#32 e2 hb

def rint_y (x : BitVec 64) : BitVec 32 :=
  ((x >>> 52).setWidth 32 &&& 2047#32)

def rint_e (x : BitVec 64) : BitVec 32 :=
  1085#32 - rint_y x

def rint_m1 (x : BitVec 64) : BitVec 64 :=
  rint_m0 x &&& rint_mask (rint_e x)

def rint_e2 (x : BitVec 64) : BitVec 32 :=
  rint_e x &&& 63#32

def rint_d (x : BitVec 64) : BitVec 64 :=
  rint_m1 x <<< (63#32 - rint_e2 x).toNat

def rint_dd (x : BitVec 64) : BitVec 32 :=
  ((rint_d x).setWidth 32) ||| (((((rint_d x) >>> 32).setWidth 32) &&& 536870911#32))

def rint_f (x : BitVec 64) : BitVec 32 :=
  (((rint_d x) >>> 61).setWidth 32) ||| ((((rint_dd x ||| -(rint_dd x)) >>> 31)))

def rint_m2 (x : BitVec 64) : BitVec 64 :=
  ((rint_m1 x) >>> (rint_e2 x).toNat) +
    ((((200#32 >>> (rint_f x).toNat) &&& 1#32).setWidth 64))

def rint_s (x : BitVec 64) : BitVec 32 :=
  ((x >>> 63).setWidth 32)

def rintSpec (x : BitVec 64) : BitVec 64 :=
  let s64 := (rint_s x).signExtend 64
  (((rint_m2 x) ^^^ -s64) + s64)

theorem rint_m2_small (x : BitVec 64) (hdom : rintDomain x)
    (hcase : (rint_e x).toNat < 64) : (rint_m2 x).toNat < 2^63 - 1 := by
  have hen : (rint_e x).toNat = (rint_e x).toInt ∧
      13 ≤ (rint_e x).toNat ∧ (rint_e x).toNat ≤ 1085 := rint_e_nat x hdom
  have hm0b : (rint_m0 x).toNat < 2^63 := m0_lt x
  have hmask := rint_mask_all _ hcase
  have hm1 : rint_m1 x = rint_m0 x := by
    simp only [rint_m1, hmask, BitVec.and_allOnes]
  have he2eq : (rint_e2 x).toNat = (rint_e x).toNat := by
    have hto : ((rint_e2 x).toNat = (rint_e x).toNat &&& 63) := by
      simp [rint_e2, BitVec.toNat_and]
    have h63 : (63 : Nat) = 2^6 - 1 := by decide
    have hid : (rint_e x).toNat &&& 63 = (rint_e x).toNat := by
      rw [h63]
      exact Nat.and_two_pow_sub_one_of_lt_two_pow (by omega)
    omega
  have he2eq : (rint_e2 x).toNat = (rint_e x).toNat := by
    have hto : ((rint_e2 x).toNat = (rint_e x).toNat &&& 63) := by
      simp [rint_e2, BitVec.toNat_and]
    have hid : (rint_e x).toNat &&& 63 = (rint_e x).toNat := by
      have h63 : (63 : Nat) = 2^6 - 1 := by decide
      rw [h63]
      exact Nat.and_two_pow_sub_one_of_lt_two_pow (by omega)
    omega
  have hinc : (((((200#32 >>> (rint_f x).toNat) &&& 1#32).setWidth 64)).toNat ≤ 1) := by
    have hle := Nat.and_le_right
      (n := ((200#32 >>> (rint_f x).toNat).toNat)) (m := (1#32).toNat)
    have h1 : (1#32 : BitVec 32).toNat = 1 := by decide
    have hto : (((((200#32 >>> (rint_f x).toNat) &&& 1#32).setWidth 64)).toNat =
      (((200#32 >>> (rint_f x).toNat) &&& 1#32).toNat)) := by
      exact BitVec.toNat_setWidth_of_le (by decide)
    have hor : ((((200#32 >>> (rint_f x).toNat) &&& 1#32).toNat) =
      ((200#32 >>> (rint_f x).toNat).toNat &&& (1#32).toNat)) := by
      simp [BitVec.toNat_and]
    omega
  have hpow : 2^13 ≤ 2^(rint_e2 x).toNat := by
    apply Nat.pow_le_pow_right (by decide)
    omega
  have hdiv : (rint_m1 x).toNat / 2^(rint_e2 x).toNat < 2^50 := by
    have hlt : (rint_m1 x).toNat < 2^50 * 2^(rint_e2 x).toNat := by
      have h2 : ((rint_m1 x).toNat = (rint_m0 x).toNat) := by
        rw [hm1]
      have hm0b := m0_lt x
      have h50 : (2^63 : Nat) = 2^50 * 2^13 := by decide
      omega
    exact (Nat.div_lt_iff_lt_mul (Nat.two_pow_pos _)).mpr hlt
  have hsh : (((rint_m1 x) >>> (rint_e2 x).toNat).toNat < 2^50) := by
    have h1 : ((((rint_m1 x) >>> (rint_e2 x).toNat)).toNat =
      (rint_m1 x).toNat >>> (rint_e2 x).toNat) := by
      simp [BitVec.toNat_ushiftRight]
    rw [h1, Nat.shiftRight_eq_div_pow]
    exact hdiv
  have hadd : ((rint_m2 x).toNat =
      (((rint_m1 x) >>> (rint_e2 x).toNat).toNat +
        ((((200#32 >>> (rint_f x).toNat) &&& 1#32).setWidth 64)).toNat) % 2^64) := by
    simp [rint_m2, BitVec.toNat_add]
  omega

theorem rint_m2_big (x : BitVec 64) (hdom : rintDomain x)
    (hcase : ¬ (rint_e x).toNat < 64) : (rint_m2 x).toNat < 2^63 - 1 := by
  have hen : (rint_e x).toNat = (rint_e x).toInt ∧
      13 ≤ (rint_e x).toNat ∧ (rint_e x).toNat ≤ 1085 := rint_e_nat x hdom
  have hmask := rint_mask_zero (rint_e x) ⟨by omega, by omega⟩
  have hm1 : rint_m1 x = 0#64 := by
    simp [rint_m1, hmask]
  have hinc : (((((200#32 >>> (rint_f x).toNat) &&& 1#32).setWidth 64)).toNat ≤ 1) := by
    have hle := Nat.and_le_right
      (n := ((200#32 >>> (rint_f x).toNat).toNat)) (m := (1#32).toNat)
    have h1 : (1#32 : BitVec 32).toNat = 1 := by decide
    have hto : (((((200#32 >>> (rint_f x).toNat) &&& 1#32).setWidth 64)).toNat =
      (((200#32 >>> (rint_f x).toNat) &&& 1#32).toNat)) := by
      exact BitVec.toNat_setWidth_of_le (by decide)
    have hor : (((((200#32 >>> (rint_f x).toNat) &&& 1#32).toNat) =
      ((200#32 >>> (rint_f x).toNat).toNat &&& (1#32).toNat))) := by
      simp [BitVec.toNat_and]
    omega
  have hadd : ((rint_m2 x).toNat =
      (((rint_m1 x) >>> (rint_e2 x).toNat).toNat +
        ((((200#32 >>> (rint_f x).toNat) &&& 1#32).setWidth 64)).toNat) % 2^64) := by
    simp [rint_m2, BitVec.toNat_add]
  have hz : (((rint_m1 x) >>> (rint_e2 x).toNat).toNat = 0) := by
    rw [hm1]
    simp
  omega

end B20.Fpr
