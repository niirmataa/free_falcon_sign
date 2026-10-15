import Source3.C99ExpressionSound

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ShiftCompute130
open B20.C (Val BinOp)
open C99ValueBridge (value encode)
open C99IntegerReference (ShiftExec convert width signed fits)

def CountSafe (x y : Val) : Prop := 0≤y.integer ∧ y.integer.toNat<width (value x).type
instance countDecidable (x y : Val) : Decidable (CountSafe x y) := by
  unfold CountSafe
  infer_instance

def LeftSafe (x y : Val) : Prop := 0≤(value x).integer ∧
  fits (value x).type ((value x).integer * 2^y.integer.toNat)
instance leftDecidable (x y : Val) : Decidable (LeftSafe x y) := by
  unfold LeftSafe fits
  infer_instance

def left (x y : Val) : Option Val :=
  if CountSafe x y then
    if signed (value x).type then
      if LeftSafe x y then some (encode (convert (value x).type ((value x).integer * 2^y.integer.toNat))) else none
    else some (encode (convert (value x).type ((value x).integer * 2^y.integer.toNat)))
  else none

def right (x y : Val) : Option Val :=
  if CountSafe x y then some (encode (convert (value x).type ((value x).integer / 2^y.integer.toNat)))
  else none

theorem count_exact (x y : Val) (guard : CountSafe x y) : (value y).integer=(y.integer.toNat : Int) := by
  rw [C99ValueBridge.integer_matches]
  have nonnegative := guard.1
  omega

theorem left_sound (x y z : Val) (computed : left x y=some z) : ShiftExec .left (value x) (value y) (value z) := by
  unfold left at computed
  split at computed
  next count =>
    split at computed
    next isSigned =>
      split at computed
      next safe =>
        have same := Option.some.inj computed
        subst z
        rw [C99ValueBridge.value_encode]
        exact .signedLeft (value x) (value y) y.integer.toNat isSigned (count_exact x y count) count.2 safe.1 safe.2
      next rejected => cases computed
    next notSigned =>
      have unsigned : signed (value x).type=false := by
        cases h : signed (value x).type with
        | false => rfl
        | true => exact (notSigned h).elim
      have same := Option.some.inj computed
      subst z
      rw [C99ValueBridge.value_encode]
      exact .unsignedLeft (value x) (value y) y.integer.toNat unsigned (count_exact x y count) count.2
  next outside => cases computed

theorem right_sound (x y z : Val) (computed : right x y=some z) : ShiftExec .right (value x) (value y) (value z) := by
  unfold right at computed
  split at computed
  next count =>
    have same := Option.some.inj computed
    subst z
    rw [C99ValueBridge.value_encode]
    exact .right (value x) (value y) y.integer.toNat (count_exact x y count) count.2
  next outside => cases computed

def bin (op : BinOp) (x y : Val) : Option Val :=
  match op with | .shl => left x y | .shr => right x y | _ => B20.C.bin op x y

theorem bin_sound (op : BinOp) (x y z : Val) (computed : bin op x y=some z) :
    C99OperatorBridge.Binary op (value x) (value y) (value z) := by
  cases op with
  | shl => exact left_sound x y z computed
  | shr => exact right_sound x y z computed
  | add => exact C99ExpressionSound.binary_sound .add x y z computed
  | sub => exact C99ExpressionSound.binary_sound .sub x y z computed
  | mul => exact C99ExpressionSound.binary_sound .mul x y z computed
  | band => exact C99ExpressionSound.binary_sound .band x y z computed
  | bor => exact C99ExpressionSound.binary_sound .bor x y z computed
  | xor => exact C99ExpressionSound.binary_sound .xor x y z computed

/-- The older partial model deliberately omits these defined source cases. -/
theorem old_signed_left_missing : B20.C.bin .shl (.i32 1) (.i32 1)=none := by decide +kernel
theorem signed_left_defined : bin .shl (.i32 1) (.i32 1)=some (.i32 2) := by decide +kernel
theorem old_wide_count_missing : B20.C.bin .shl (.u32 1) (.u64 1)=none := by decide +kernel
theorem wide_count_defined : bin .shl (.u32 1) (.u64 1)=some (.u32 2) := by decide +kernel

theorem undefined_shifts_rejected :
    bin .shl (.u32 1) (.i32 (-1))=none ∧ bin .shl (.u64 1) (.u64 64)=none ∧
    bin .shl (.i32 (-1)) (.i32 1)=none ∧ bin .shl (.i32 0x40000000) (.i32 1)=none := by decide +kernel

end FT1536.Source3.C99ShiftCompute130
