import Source3.C99Typing
import Source3.C99ArithmeticBridge
import Source3.C99BitwiseBridge
import Source3.C99ShiftLeftBridge
import Source3.C99UnaryBridge
import Source3.C99CompareBridge

namespace FT1536.Source3.C99OperatorBridge
open B20.C C99ValueBridge

def Binary (op : BinOp) (x y z : C99IntegerReference.Value) : Prop :=
  match op with
  | .add => C99IntegerReference.ArithmeticExec .plus x y z
  | .sub => C99IntegerReference.ArithmeticExec .minus x y z
  | .mul => C99IntegerReference.ArithmeticExec .times x y z
  | .band => C99IntegerReference.BitwiseExec .and x y z
  | .bor => C99IntegerReference.BitwiseExec .or x y z
  | .xor => C99IntegerReference.BitwiseExec .xor x y z
  | .shr => C99IntegerReference.ShiftExec .right x y z
  | .shl => C99IntegerReference.ShiftExec .left x y z

def resultType (op : BinOp) (a b : Ty) : Ty :=
  if op=.shr ∨ op=.shl then a else commonTy a b

theorem arithmetic_type (op : C99IntegerReference.Arithmetic) (x y z : C99IntegerReference.Value)
    (h : C99IntegerReference.ArithmeticExec op x y z) :
    z.type=C99IntegerReference.usual x.type y.type := by
  cases h with
  | step t ht a b ha hb safe =>
      rw [C99Typing.converted_type,ht]
      rfl

theorem bitwise_type (op : C99IntegerReference.Bitwise) (x y z : C99IntegerReference.Value)
    (h : C99IntegerReference.BitwiseExec op x y z) :
    z.type=C99IntegerReference.usual x.type y.type := by
  cases h with
  | step t ht a b ha hb => rw [C99Typing.converted_type,ht]; rfl

theorem shift_type (op : C99IntegerReference.Shift) (x y z : C99IntegerReference.Value)
    (h : C99IntegerReference.ShiftExec op x y z) : z.type=x.type := by
  cases h <;> exact C99Typing.converted_type _ _

theorem binary_type (op : BinOp) (x y z : C99IntegerReference.Value) (a b : Ty)
    (hx : x.type=type a) (hy : y.type=type b) (h : Binary op x y z) :
    z.type=type (resultType op a b) := by
  cases op with
  | add | sub | mul =>
      have hr := arithmetic_type _ x y z h
      rw [hx,hy] at hr
      simpa [resultType] using hr.trans (usual_matches a b)
  | band | bor | xor =>
      have hr := bitwise_type _ x y z h
      rw [hx,hy] at hr
      simpa [resultType] using hr.trans (usual_matches a b)
  | shr | shl =>
      simpa [resultType,hx] using shift_type _ x y z h

theorem binary_complete (op : BinOp) (x y z : C99IntegerReference.Value)
    (count : op=.shr ∨ op=.shl → (encode y).ty=.i32 ∨ (encode y).ty=.u32)
    (left : op=.shl → (encode x).ty=.u64 ∨ (encode x).ty=.u32)
    (hs : Binary op x y z) : B20.C.bin op (encode x) (encode y)=some (encode z) := by
  cases op with
  | add | sub | mul =>
      exact C99ArithmeticBridge.arithmetic_source_to_interpreter _ (encode x) (encode y) (encode z)
        (by simpa only [value_encode,Binary] using hs)
  | band | bor | xor =>
      exact C99BitwiseBridge.source_to_interpreter _ (encode x) (encode y) (encode z)
        (by simpa only [value_encode,Binary] using hs)
  | shr =>
      exact C99ShiftBridge.right_source_to_interpreter _ _ _ (count (Or.inl rfl))
        (by simpa only [value_encode,Binary] using hs)
  | shl =>
      exact C99ShiftLeftBridge.source_to_interpreter _ _ _ (left rfl) (count (Or.inr rfl))
        (by simpa only [value_encode,Binary] using hs)

theorem neg_type (x z : C99IntegerReference.Value) (h : C99IntegerReference.NegExec x z) : z.type=x.type := by
  cases h; exact C99Typing.converted_type _ _
theorem complement_type (x z : C99IntegerReference.Value) (h : C99IntegerReference.ComplementExec x z) : z.type=x.type := by
  cases h; exact C99Typing.converted_type _ _
theorem compare_type (op : C99IntegerReference.Comparison) (x y z : C99IntegerReference.Value)
    (h : C99IntegerReference.CompareExec op x y z) : z.type=.int32 := by cases h; rfl

end FT1536.Source3.C99OperatorBridge

#print axioms FT1536.Source3.C99OperatorBridge.binary_complete
