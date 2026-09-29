import B20.C.ScalarCalls
import B20.Fpr.ParsedPrograms

namespace B20.Fpr
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
  rw [if_neg]
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
  exact decide_eq_true h

def packSpec (s e : BitVec 32) (m : BitVec 64) : BitVec 64 :=
  let e1 := e + 1076#32
  let t := e1 >>> 31
  let m1 := m &&& (t.setWidth 64 - 1)
  let t2 := (m1 >>> 54).setWidth 32
  let e2 := e1 &&& (-t2)
  let x := (((s.setWidth 64) <<< 63) ||| (m1 >>> 2)) + ((e2.setWidth 64) <<< 52)
  let f := m1.setWidth 32 &&& 7#32
  x + (((200#32 >>> f.toNat) &&& 1#32).setWidth 64)

theorem pack_execution (s e : BitVec 32) (m : BitVec 64) (hdom : packDomain s e) :
    B20.C.Scalar.execute shiftCalls Parsed.packProgram
      [.i32 s, .i32 e, .u64 m] = some (.u64 (packSpec s e m)) := by
  simp only [packDomain] at hdom
  simp [B20.C.Scalar.execute, Parsed.packProgram, bindArgs, emptyState, declareOne,
    assign, evalBody, B20.C.Scalar.step, declareMany, B20.C.Scalar.evalExpr, packSpec,
    bin, shift, bitsOp, commonTy, Val.ty, B20.C.cast, literalValue, update,
    pack_neg_defined, pack_add_safe _ hdom]

end B20.Fpr
