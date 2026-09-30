import Init.Data.BitVec.Lemmas
import Lean.Elab.Tactic.Omega

/- Author-defined *reference* integer semantics of the selected C99 subset.
   Normative origin: ISO/IEC 9899:1999 6.2.5, 6.2.6.2, 6.3.1.1/3/8,
   6.5.3.3, 6.5.6, 6.5.7, 6.5.10--12; GCC LP64 choices: int32/long64,
   two's complement, low-bit signed conversion, arithmetic signed >>.
   No evaluator, fuel, Option-returning execution, or B20.C operation is
   imported here. Rules are finite inductive derivations over bit vectors.
   This file alone does not assert a source/frontend/completeness theorem. -/
namespace FT1536.Source3.C99IntegerReference

inductive Ty where
  | uint64 | int64 | uint32 | int32
  deriving DecidableEq, Repr

def width : Ty → Nat
  | .uint64 | .int64 => 64
  | .uint32 | .int32 => 32

def signed : Ty → Bool
  | .int64 | .int32 => true
  | .uint64 | .uint32 => false

inductive Value where
  | uint64 (bits : BitVec 64)
  | int64 (bits : BitVec 64)
  | uint32 (bits : BitVec 32)
  | int32 (bits : BitVec 32)
  deriving DecidableEq, Repr

def Value.type : Value → Ty
  | .uint64 _ => .uint64
  | .int64 _ => .int64
  | .uint32 _ => .uint32
  | .int32 _ => .int32

def Value.integer : Value → Int
  | .uint64 x => x.toNat
  | .int64 x => x.toInt
  | .uint32 x => x.toNat
  | .int32 x => x.toInt

/- Mathematical conversion by residue class. Signed-to-unsigned conversion
   is reduction modulo 2^w; signed out-of-range conversions choose the GCC
   representative of that same residue class. This is not an overflow rule
   for signed arithmetic: the arithmetic rules below separately require
   representability of the exact mathematical result. -/
def convert (t : Ty) (z : Int) : Value :=
  match t with
  | .uint64 => .uint64 (BitVec.ofInt 64 z)
  | .int64 => .int64 (BitVec.ofInt 64 z)
  | .uint32 => .uint32 (BitVec.ofInt 32 z)
  | .int32 => .int32 (BitVec.ofInt 32 z)

def fits (t : Ty) (z : Int) : Prop :=
  if signed t then -(2^(width t-1) : Int)≤z ∧ z<2^(width t-1)
  else 0≤z ∧ z<2^(width t)

/- No narrow integer type occurs in these scalar expressions, so integer
   promotion is the identity. Rank is determined by the explicit width. -/
def promote (t : Ty) : Ty := t
def unsignedVersion : Ty → Ty
  | .int64 | .uint64 => .uint64
  | .int32 | .uint32 => .uint32

def usual (a b : Ty) : Ty :=
  if a=b then a
  else if signed a = signed b then (if width a < width b then b else a)
  else
    let u := if signed a then b else a
    let s := if signed a then a else b
    if width u ≥ width s then u else s

inductive Arithmetic where
  | plus | minus | times
  deriving DecidableEq, Repr
def exact (op : Arithmetic) (a b : Int) : Int :=
  match op with | .plus => a+b | .minus => a-b | .times => a*b

inductive ArithmeticExec : Arithmetic → Value → Value → Value → Prop where
  | step (op : Arithmetic) (x y : Value)
      (t : Ty) (ht : t=usual (promote x.type) (promote y.type))
      (a b : Value) (ha : a=convert t x.integer) (hb : b=convert t y.integer)
      (safe : signed t=true → fits t (exact op a.integer b.integer)) :
      ArithmeticExec op x y (convert t (exact op a.integer b.integer))

inductive Shift where | left | right
  deriving DecidableEq, Repr

/- 6.5.7: operands are promoted individually, not converted by `usual`.
   A negative or out-of-width count has no derivation. For signed << we
   require nonnegative lhs and representable product, as C99 specifies. -/
inductive ShiftExec : Shift → Value → Value → Value → Prop where
  | unsignedLeft (x : Value) (y : Value) (n : Nat)
      (unsigned : signed x.type=false) (count : y.integer=(n : Int))
      (bound : n<width x.type) :
      ShiftExec .left x y (convert x.type (x.integer * 2^n))
  | signedLeft (x : Value) (y : Value) (n : Nat)
      (isSigned : signed x.type=true) (count : y.integer=(n : Int))
      (bound : n<width x.type) (positive : 0≤x.integer)
      (safe : fits x.type (x.integer * 2^n)) :
      ShiftExec .left x y (convert x.type (x.integer * 2^n))
  | right (x : Value) (y : Value) (n : Nat)
      (count : y.integer=(n : Int)) (bound : n<width x.type) :
      ShiftExec .right x y (convert x.type (x.integer / 2^n))

inductive NegExec : Value → Value → Prop where
  | step (x : Value) (safe : signed x.type=true → fits x.type (-x.integer)) :
      NegExec x (convert x.type (-x.integer))

def Value.bits : Value → Nat
  | .uint64 x | .int64 x => x.toNat
  | .uint32 x | .int32 x => x.toNat

inductive Bitwise where | and | or | xor
  deriving DecidableEq, Repr
def bitResult : Bitwise → Nat → Nat → Nat
  | .and,a,b => a &&& b
  | .or,a,b => a ||| b
  | .xor,a,b => a ^^^ b

inductive BitwiseExec : Bitwise → Value → Value → Value → Prop where
  | step (op : Bitwise) (x y : Value)
      (t : Ty) (ht : t=usual (promote x.type) (promote y.type))
      (a b : Value) (ha : a=convert t x.integer) (hb : b=convert t y.integer) :
      BitwiseExec op x y (convert t (bitResult op a.bits b.bits))

inductive ComplementExec : Value → Value → Prop where
  | step (x : Value) :
      ComplementExec x (convert x.type ((2^(width x.type)-1-x.bits : Nat) : Int))

inductive Comparison where | eq | ne | lt | le | gt | ge
  deriving DecidableEq, Repr
def compare : Comparison → Int → Int → Bool
  | .eq,a,b => decide (a=b)
  | .ne,a,b => decide (a≠b)
  | .lt,a,b => decide (a<b)
  | .le,a,b => decide (a≤b)
  | .gt,a,b => decide (b<a)
  | .ge,a,b => decide (b≤a)

inductive CompareExec : Comparison → Value → Value → Value → Prop where
  | step (op : Comparison) (x y : Value)
      (t : Ty) (ht : t=usual (promote x.type) (promote y.type))
      (a b : Value) (ha : a=convert t x.integer) (hb : b=convert t y.integer) :
      CompareExec op x y (.int32 (if compare op a.integer b.integer then 1#32 else 0#32))

theorem arithmetic_deterministic (op : Arithmetic) (x y a b : Value)
    (ha : ArithmeticExec op x y a) (hb : ArithmeticExec op x y b) : a=b := by
  cases ha with
  | step t ht v w hv hw _ =>
      cases hb with
      | step t' ht' v' w' hv' hw' _ => simp_all

theorem arithmetic_iff (op : Arithmetic) (x y z : Value) :
    ArithmeticExec op x y z ↔
      let t := usual (promote x.type) (promote y.type)
      let a := convert t x.integer
      let b := convert t y.integer
      (signed t=true → fits t (exact op a.integer b.integer)) ∧
      z=convert t (exact op a.integer b.integer) := by
  constructor
  · intro h
    cases h with
    | step t ht a b ha hb safe => subst t; subst a; subst b; exact ⟨safe,rfl⟩
  · rintro ⟨safe,rfl⟩
    exact ArithmeticExec.step op x y _ rfl _ _ rfl rfl safe

theorem shift_deterministic (op : Shift) (x y a b : Value)
    (ha : ShiftExec op x y a) (hb : ShiftExec op x y b) : a=b := by
  cases ha <;> cases hb <;> simp_all [Int.natCast_inj]

theorem neg_deterministic (x a b : Value) (ha : NegExec x a) (hb : NegExec x b) : a=b := by
  cases ha; cases hb; rfl

theorem neg_iff (x z : Value) :
    NegExec x z ↔ (signed x.type=true → fits x.type (-x.integer)) ∧ z=convert x.type (-x.integer) := by
  constructor
  · intro h; cases h with | step safe => exact ⟨safe,rfl⟩
  · rintro ⟨safe,rfl⟩; exact NegExec.step x safe

theorem complement_iff (x z : Value) :
    ComplementExec x z ↔ z=convert x.type ((2^(width x.type)-1-x.bits : Nat) : Int) := by
  constructor
  · intro h; cases h; rfl
  · intro h; rw [h]; exact ComplementExec.step x

theorem bitwise_iff (op : Bitwise) (x y z : Value) :
    BitwiseExec op x y z ↔
      let t := usual (promote x.type) (promote y.type)
      z=convert t (bitResult op (convert t x.integer).bits (convert t y.integer).bits) := by
  constructor
  · intro h
    cases h with
    | step t ht a b ha hb => subst t; subst a; subst b; rfl
  · intro h
    rw [h]
    exact BitwiseExec.step op x y _ rfl _ _ rfl rfl

theorem bitwise_deterministic (op : Bitwise) (x y a b : Value)
    (ha : BitwiseExec op x y a) (hb : BitwiseExec op x y b) : a=b :=
  (bitwise_iff op x y a |>.mp ha).trans (bitwise_iff op x y b |>.mp hb).symm

theorem shift_right_iff (x y z : Value) :
    ShiftExec .right x y z ↔ ∃ n : Nat,
      y.integer=(n : Int) ∧ n<width x.type ∧ z=convert x.type (x.integer / 2^n) := by
  constructor
  · intro h
    cases h
    rename_i n hc hb
    exact ⟨n,hb,hc,rfl⟩
  · rintro ⟨n,hc,hb,rfl⟩
    exact ShiftExec.right x y n hc hb

end FT1536.Source3.C99IntegerReference

#print axioms FT1536.Source3.C99IntegerReference.arithmetic_deterministic
#print axioms FT1536.Source3.C99IntegerReference.shift_deterministic
