import Source3.PublicSquareSource157
import Source3.KeygenPublicDivisionWords

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicDivisionExpr157
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ModularReference (GenEval)
open KeygenPublicDivisionWords (Operand Instruction operand word expression result target)
open KeygenPublicArguments (Conversion U32)
open KeygenPublicSquare (Slot)
open KeygenPublicMontgomery (modulus inverse)

def Known (s : State) (env : String → BitVec 32) (initialized : List String) : Prop :=
  ∀ n∈initialized, Slot s n (env n)
def available (initialized : List String) : Operand → Bool
  | .slot n => initialized.contains n
  | .number _ => true
def readable (initialized : List String) : Instruction → Bool
  | .mul _ a b => available initialized a && available initialized b
  | .square _ a => available initialized a
def initializedAfter : List Instruction → List String → List String
  | [],known => known
  | step::rest,known => initializedAfter rest (target step::known)
def checked : List Instruction → List String → Bool
  | [],_ => true
  | step::rest,known => readable known step && checked rest (target step::known)

theorem operands (s : State) (env : String → BitVec 32) (initialized : List String) (a : Operand)
    (known : Known s env initialized) (present : available initialized a=true) :
    ∃ v, GenEval KeygenPublicScalar.Square s (operand a) v ∧ U32 v (word env a) := by
  cases a with
  | slot n =>
    exact ⟨.uint32 (env n),.scalar _ _ (.variable n.toList .uint32 (.uint32 (env n))
      (known n (List.contains_iff_mem.mp present))),KeygenPublicArguments.u32_self _⟩
  | number n => exact ⟨C99IntegerReference.convert .int32 n,.scalar _ _ (.literal .int32 n),KeygenPublicArguments.u32_literal n⟩

theorem multiply (x y : BitVec 32) (a b : Value) (hx : U32 a x) (hy : U32 b y) :
    KeygenPublicScalar.Square "mq_montymul".toList [a,b,.int32 18433,.int32 18431]
      (.uint32 (KeygenPublicLeafWords.montgomery x y modulus inverse)) := by
  have conversion : Conversion (KeygenPublicScalar.params .mul)
      [.uint32 x,.uint32 y,.uint32 modulus,.uint32 inverse] [a,b,.int32 18433,.int32 18431] :=
    .cons _ _ _ _ _ _ _ ((KeygenPublicArguments.u32_self x).trans hx.symm)
      (.cons _ _ _ _ _ _ _ ((KeygenPublicArguments.u32_self y).trans hy.symm)
        (.cons _ _ _ _ _ _ _ (by decide) (.cons _ _ _ _ _ _ _ (by decide) .nil)))
  exact .leaf _ _ _ (.run .mul _ _ (by unfold KeygenPublicScalar.IsLeaf; decide)
    (KeygenPublicArguments.body_conversion _ .mul _ _ _ conversion
      (PublicLeafSource157.body .mul (by decide) [.u32 x,.u32 y,.u32 modulus,.u32 inverse] _ rfl
        (KeygenPublicLeafWords.bound_mul x y modulus inverse) (KeygenPublicLeafWords.mul_model x y modulus inverse))))

theorem square (x : BitVec 32) (a : Value) (hx : U32 a x) :
    KeygenPublicScalar.Square "mq_montysqr".toList [a,.int32 18433,.int32 18431]
      (.uint32 (KeygenPublicLeafWords.montgomery x x modulus inverse)) := by
  have conversion : Conversion (KeygenPublicScalar.params .square)
      [.uint32 x,.uint32 modulus,.uint32 inverse] [a,.int32 18433,.int32 18431] :=
    .cons _ _ _ _ _ _ _ ((KeygenPublicArguments.u32_self x).trans hx.symm)
      (.cons _ _ _ _ _ _ _ (by decide) (.cons _ _ _ _ _ _ _ (by decide) .nil))
  exact .square _ _ (KeygenPublicArguments.body_conversion _ .square _ _ _ conversion (PublicSquareSource157.body x modulus inverse))

theorem source (s : State) (env : String → BitVec 32) (initialized : List String) (step : Instruction)
    (known : Known s env initialized) (present : readable initialized step=true) :
    GenEval KeygenPublicScalar.Square s (expression step) (.uint32 (result env step)) := by
  cases step with
  | mul dst a b =>
    obtain ⟨av,ae,ax⟩ := operands s env initialized a known (Bool.and_eq_true_iff.mp present).1
    obtain ⟨bv,be,bx⟩ := operands s env initialized b known (Bool.and_eq_true_iff.mp present).2
    exact .call4 _ _ _ _ _ av bv (.int32 18433) (.int32 18431) _ ae be
      (.scalar _ _ (.literal .int32 18433)) (.scalar _ _ (.literal .int32 18431)) (multiply _ _ av bv ax bx)
  | square dst a =>
    obtain ⟨av,ae,ax⟩ := operands s env initialized a known present
    exact .call3 _ _ _ _ av (.int32 18433) (.int32 18431) _ ae
      (.scalar _ _ (.literal .int32 18433)) (.scalar _ _ (.literal .int32 18431)) (square _ av ax)

theorem steps_checked : checked KeygenPublicDivisionWords.steps ["x","y"]=true := by decide +kernel
theorem final_checked : readable (initializedAfter KeygenPublicDivisionWords.steps ["x","y"])
    KeygenPublicDivisionWords.finalStep=true := by decide +kernel

end FT1536.Source3.PublicDivisionExpr157
