import Source3.C99ShiftSound
import Source3.C99ExpressionBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99ExpressionSound
open B20.C C99ValueBridge C99Typing

def CallsSound (rc : C99ScalarReference.CallRelation) (mc : B20.C.Scalar.Calls) : Prop :=
  ∀ name args v, mc name args=some v → rc name (args.map value) (value v)

theorem literal_value (t : Ty) (n : Nat) :
    value (literalValue t n)=C99IntegerReference.convert (type t) n := by
  cases t <;> simp [literalValue,value,type,C99IntegerReference.convert]
theorem boolean_value (b : Bool) : value (CLogic.boolean b)=C99ScalarReference.boolean b := rfl
theorem truth_value (v : Val) : CLogic.truth v=decide ((value v).integer≠0) := by cases v <;> rfl

theorem binary_sound (op : BinOp) (x y z : Val) (h : B20.C.bin op x y=some z) :
    C99OperatorBridge.Binary op (value x) (value y) (value z) := by
  cases op with
  | add | sub | mul => exact C99IntegerSound.arithmetic_sound _ _ _ _ h
  | band | bor | xor => exact C99IntegerSound.bitwise_sound _ _ _ _ h
  | shr => exact C99ShiftSound.right_sound _ _ _ h
  | shl => exact C99ShiftSound.left_sound _ _ _ h

theorem binary_reference (rc : C99ScalarReference.CallRelation) (env : C99ScalarReference.Env)
    (op : BinOp) (a b : C99ScalarReference.Expr) (x y z : C99IntegerReference.Value)
    (ha : C99ScalarReference.Eval rc env a x) (hb : C99ScalarReference.Eval rc env b y)
    (hop : C99OperatorBridge.Binary op x y z) :
    C99ScalarReference.Eval rc env (C99Frontend.binary op a b) z := by
  cases op with
  | add | sub | mul => exact C99ScalarReference.Eval.arithmetic _ _ _ _ _ _ ha hb hop
  | band | bor | xor => exact C99ScalarReference.Eval.bitwise _ _ _ _ _ _ ha hb hop
  | shr | shl => exact C99ScalarReference.Eval.shift _ _ _ _ _ _ ha hb hop

theorem expression_sound (rc : C99ScalarReference.CallRelation) (mc : B20.C.Scalar.Calls)
    (hcall : CallsSound rc mc) (s : B20.C.Scalar.State) (hg : WellTyped s)
    (e : CLogic.Expr) (v : Val)
    (h : ExpressionFuel.unbounded mc s.values e=some v) :
    C99ScalarReference.Eval rc (environment s) (C99Frontend.expression e) (value v) := by
  induction e generalizing v with
  | literal t n =>
      have hv : literalValue t n=v := Option.some.inj h
      subst v
      rw [literal_value]
      exact C99ScalarReference.Eval.literal _ _
  | var n =>
      have hv : s.values n=some v := h
      exact C99ScalarReference.Eval.variable n (type v.ty) (value v)
        (by simp [environment,hg n v hv,hv])
  | cast t e ih =>
      obtain ⟨x,hx,hv⟩ := Option.map_eq_some_iff.mp h
      subst v
      rw [cast_matches]
      exact C99ScalarReference.Eval.cast _ _ _ (ih x hx)
  | neg e ih =>
      obtain ⟨x,hx,hop⟩ := Option.bind_eq_some_iff.mp h
      exact C99ScalarReference.Eval.neg _ _ _ (ih x hx) (C99UnarySound.neg_sound x v hop)
  | bitNot e ih =>
      obtain ⟨x,hx,hv⟩ := Option.map_eq_some_iff.mp h
      subst v
      exact C99ScalarReference.Eval.complement _ _ _ (ih x hx) (C99UnarySound.complement_sound x)
  | bin op a b iha ihb =>
      obtain ⟨x,hx,hr⟩ := Option.bind_eq_some_iff.mp h
      obtain ⟨y,hy,hop⟩ := Option.bind_eq_some_iff.mp hr
      exact binary_reference rc (environment s) op _ _ _ _ _ (iha x hx) (ihb y hy) (binary_sound op x y v hop)
  | cmp op a b iha ihb =>
      obtain ⟨x,hx,hr⟩ := Option.bind_eq_some_iff.mp h
      obtain ⟨y,hy,hop⟩ := Option.bind_eq_some_iff.mp hr
      have hv : CLogic.compare op x y=v := Option.some.inj hop
      subst v
      exact C99ScalarReference.Eval.compare _ _ _ _ _ _ (iha x hx) (ihb y hy)
        (C99IntegerSound.compare_sound op x y)
  | lnot e ih =>
      obtain ⟨x,hx,hv⟩ := Option.map_eq_some_iff.mp h
      subst v
      have he := C99ScalarReference.Eval.logicalNot _ _ (ih x hx)
      simpa [boolean_value,truth_value,C99Frontend.expression] using he
  | land a b iha ihb =>
      obtain ⟨x,hx,hr⟩ := Option.bind_eq_some_iff.mp h
      by_cases ht : CLogic.truth x=true
      · have hnn : (value x).integer≠0 := by simpa [truth_value] using ht
        have hmap : (ExpressionFuel.unbounded mc s.values b).map (CLogic.boolean ∘ CLogic.truth)=some v := by
          simpa [ht] using hr
        obtain ⟨y,hy,hv⟩ := Option.map_eq_some_iff.mp hmap
        subst v
        have he := C99ScalarReference.Eval.andTrue _ _ _ _ (iha x hx) hnn (ihb y hy)
        simpa [Function.comp_def,boolean_value,truth_value,C99Frontend.expression] using he
      · have hzero : (value x).integer=0 := by simpa [truth_value] using ht
        have hv : CLogic.boolean false=v := Option.some.inj (by simpa [ht] using hr)
        subst v
        exact C99ScalarReference.Eval.andFalse _ _ _ (iha x hx) hzero
  | lor a b iha ihb =>
      obtain ⟨x,hx,hr⟩ := Option.bind_eq_some_iff.mp h
      by_cases ht : CLogic.truth x=true
      · have hnn : (value x).integer≠0 := by simpa [truth_value] using ht
        have hv : CLogic.boolean true=v := Option.some.inj (by simpa [ht] using hr)
        subst v
        exact C99ScalarReference.Eval.orTrue _ _ _ (iha x hx) hnn
      · have hzero : (value x).integer=0 := by simpa [truth_value] using ht
        have hmap : (ExpressionFuel.unbounded mc s.values b).map (CLogic.boolean ∘ CLogic.truth)=some v := by
          simpa [ht] using hr
        obtain ⟨y,hy,hv⟩ := Option.map_eq_some_iff.mp hmap
        subst v
        have he := C99ScalarReference.Eval.orFalse _ _ _ _ (iha x hx) hzero (ihb y hy)
        simpa [Function.comp_def,boolean_value,truth_value,C99Frontend.expression] using he
  | call1 name e ih =>
      obtain ⟨x,hx,hc⟩ := Option.bind_eq_some_iff.mp h
      exact C99ScalarReference.Eval.call1 _ _ _ _ (ih x hx) (hcall name [x] v hc)
  | call2 name a b iha ihb =>
      obtain ⟨x,hx,hr⟩ := Option.bind_eq_some_iff.mp h
      obtain ⟨y,hy,hc⟩ := Option.bind_eq_some_iff.mp hr
      exact C99ScalarReference.Eval.call2 _ _ _ _ _ _ (iha x hx) (ihb y hy) (hcall name [x,y] v hc)
  | call3 name a b c iha ihb ihc =>
      obtain ⟨x,hx,hr⟩ := Option.bind_eq_some_iff.mp h
      obtain ⟨y,hy,hr⟩ := Option.bind_eq_some_iff.mp hr
      obtain ⟨z,hz,hcall'⟩ := Option.bind_eq_some_iff.mp hr
      exact C99ScalarReference.Eval.call3 _ _ _ _ _ _ _ _ (iha x hx) (ihb y hy) (ihc z hz)
        (hcall name [x,y,z] v hcall')

end FT1536.Source3.C99ExpressionSound

#print axioms FT1536.Source3.C99ExpressionSound.expression_sound
