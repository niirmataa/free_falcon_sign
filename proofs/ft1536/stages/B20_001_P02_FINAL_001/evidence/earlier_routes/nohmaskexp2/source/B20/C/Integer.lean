import B20.C.Syntax
import Lean.Elab.Tactic.Omega

namespace B20.C

def Val.integer : Val → Int
  | .u64 x => x.toNat
  | .i64 x => x.toInt
  | .u32 x => x.toNat
  | .i32 x => x.toInt

def notBits : Val → Val
  | .u64 x => .u64 (~~~x)
  | .i64 x => .i64 (~~~x)
  | .u32 x => .u32 (~~~x)
  | .i32 x => .i32 (~~~x)

/-- Integer literals after the C lexical type rules have selected a type. -/
def literalValue : Ty → Nat → Val
  | .u64, n => .u64 (BitVec.ofNat 64 n)
  | .i64, n => .i64 (BitVec.ofNat 64 n)
  | .u32, n => .u32 (BitVec.ofNat 32 n)
  | .i32, n => .i32 (BitVec.ofNat 32 n)

theorem cast_u32_to_u64 (x : BitVec 32) :
    (cast .u64 (.u32 x)).integer = x.toNat := by
  simp [cast, Val.integer]
  have hx := x.isLt
  change x.toNat < 4294967296 at hx
  omega

theorem unsigned_add64 (x y : BitVec 64) :
    bin .add (.u64 x) (.u64 y) = some (.u64 (x + y)) := by rfl

theorem unsigned_add32 (x y : BitVec 32) :
    bin .add (.u32 x) (.u32 y) = some (.u32 (x + y)) := by rfl

theorem signed_add64 (x y : BitVec 64)
    (h : -(2^63 : Int) ≤ x.toInt + y.toInt ∧ x.toInt + y.toInt < 2^63) :
    bin .add (.i64 x) (.i64 y) = some (.i64 (x + y)) := by
  have hs : signedSafe .add x y = true := by simpa [signedSafe] using h
  simp [bin, commonTy, Val.ty, cast, signedBitsOp, hs, bitsOp]

theorem signed_add32 (x y : BitVec 32)
    (h : -(2^31 : Int) ≤ x.toInt + y.toInt ∧ x.toInt + y.toInt < 2^31) :
    bin .add (.i32 x) (.i32 y) = some (.i32 (x + y)) := by
  have hs : signedSafe .add x y = true := by simpa [signedSafe] using h
  simp [bin, commonTy, Val.ty, cast, signedBitsOp, hs, bitsOp]

theorem signed_overflow_rejected :
    bin .add (.i32 0x7fffffff) (.i32 1) = none ∧
    bin .sub (.i64 0x8000000000000000) (.i64 1) = none := by
  constructor <;> decide

end B20.C
