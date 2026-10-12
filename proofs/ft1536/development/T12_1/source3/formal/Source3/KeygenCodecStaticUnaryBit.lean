import Source3.KeygenCodecScalarCalculation
import Source3.KeygenCodecStaticCountdown

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticUnaryBit
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecScalarCalculation

def expression : Expr := .binary .band
  (.binary .shr (.cast .u32 (.variable "ne".toList)) (.number .i32 15)) (.number .i32 1)
def bit (n : Int) : BitVec 32 := if n=(-1 : Int) then 1 else 0

theorem cast_counter (n : Int) : castInteger .u32 (.int32 (BitVec.ofInt 32 n))=
    some (.uint32 (BitVec.ofInt 32 n)) := by
  simp only [castInteger,scalarTy,Option.map_some,C99IntegerReference.convert,
    C99IntegerReference.Value.integer,BitVec.ofInt_toInt]

theorem shifted_counter (n : Int) (lower : -1≤n) (upper : n≤127) :
    BinaryOp .shr (.integer (.uint32 (BitVec.ofInt 32 n))) (.integer (.int32 15))
      (.integer (.uint32 (if n=(-1 : Int) then 131071 else 0))) := by
  have canonical := C99IntegerReference.ShiftExec.right (.uint32 (BitVec.ofInt 32 n)) (.int32 15)
    15 (by decide +kernel) (by change (15 : Nat)<32; decide +kernel)
  change C99IntegerReference.ShiftExec .right (.uint32 (BitVec.ofInt 32 n)) (.int32 15)
    (C99IntegerReference.convert .uint32 ((C99IntegerReference.Value.uint32 (BitVec.ofInt 32 n)).integer/2^15)) at canonical
  have result : C99IntegerReference.convert .uint32
      ((C99IntegerReference.Value.uint32 (BitVec.ofInt 32 n)).integer/2^15)=
      .uint32 (if n=(-1 : Int) then 131071 else 0) := by
    cases n with
    | ofNat m =>
      change (m : Int)≤127 at upper
      change C99IntegerReference.convert .uint32 ((BitVec.ofNat 32 m).toNat/32768)=
        .uint32 (if (m : Int)=(-1 : Int) then 131071 else 0)
      have small : m<2^32 := by omega
      have less : (m : Int)<32768 := by omega
      simp only [BitVec.toNat_ofNat,Nat.mod_eq_of_lt small]
      rw [Int.ediv_eq_zero_of_lt (by omega) less]
      have different : (m : Int)≠(-1 : Int) := by omega
      simp only [different,ite_false]
      rfl
    | negSucc m =>
      have same : m=0 := by omega
      subst m
      decide +kernel
  rw [result] at canonical
  exact .shr _ _ _ canonical

theorem masked_counter (n : Int) :
    BinaryOp .band (.integer (.uint32 (if n=(-1 : Int) then 131071 else 0)))
      (.integer (.int32 1)) (.integer (.uint32 (bit n))) := by
  by_cases same : n=(-1 : Int)
  · simp only [same,ite_true,bit]
    exact .band _ _ _ ((C99IntegerReference.bitwise_iff _ _ _ _).mpr (by decide +kernel))
  · simp only [same,ite_false,bit]
    exact .band _ _ _ ((C99IntegerReference.bitwise_iff _ _ _ _).mpr (by decide +kernel))

theorem calculation (l : Locals) (n : Int) (lower : -1≤n) (upper : n≤127)
    (cell : KeygenCodecStaticCountdown.Cell n l) : Computes l expression (.uint32 (bit n)) :=
  .binary _ _ _ _ _ _
    (.binary _ _ _ _ _ _
      (.cast _ _ _ _ (.scalar _ .int32 _ (by unfold Ordinary; decide +kernel) cell) (cast_counter n))
      (.number _ _ _ (by decide +kernel)) (shifted_counter n lower upper))
    (.number _ _ _ (by decide +kernel)) (masked_counter n)

/-- Actual RHS at node062: zero for every nonterminal iteration, one
    precisely after the last admitted postdecrement changes ne from0 to-1. -/
theorem rhs_eval (args : Args) (s : State) (l : Locals) (value : Value) (n : Int)
    (lower : -1≤n) (upper : n≤127) (cell : KeygenCodecStaticCountdown.Cell n s.locals)
    (source : Eval args s.heap s.buf expression s.locals value l) :
    value=.integer (.uint32 (bit n)) ∧ l=s.locals :=
  computes_eval args s.heap s.buf s.locals expression _ (calculation s.locals n lower upper cell) l value source

theorem source_rhs : KeygenCodecStaticBinding.node062=
    .write (.variable "acc".toList) .add expression := rfl

end FT1536.Source3.KeygenCodecStaticUnaryBit
