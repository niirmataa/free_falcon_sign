import Source3.C99Frontend
import Source3.C99ArithmeticBridge

namespace FT1536.Source3.C99CompareBridge
open B20.C C99ValueBridge

theorem same_type_integer_eq (x y : Val) (ht : x.ty=y.ty) :
    x.integer=y.integer ↔ x=y := by
  cases x <;> cases y <;>
    simp_all [Val.ty,Val.integer,BitVec.toNat_inj,BitVec.toInt_inj]

theorem cast_type (t : B20.C.Ty) (v : B20.C.Val) : (B20.C.cast t v).ty=t := by
  cases t <;> cases v <;> rfl

theorem comparison_iff (op : C99IntegerReference.Comparison)
    (x y z : C99IntegerReference.Value) :
    C99IntegerReference.CompareExec op x y z ↔
      let t := C99IntegerReference.usual (C99IntegerReference.promote x.type)
        (C99IntegerReference.promote y.type)
      z=.int32 (if C99IntegerReference.compare op
        (C99IntegerReference.convert t x.integer).integer
        (C99IntegerReference.convert t y.integer).integer then 1#32 else 0#32) := by
  constructor
  · intro h
    cases h with
    | step t ht a b ha hb => subst t; subst a; subst b; rfl
  · intro h
    rw [h]
    exact C99IntegerReference.CompareExec.step op x y _ rfl _ _ rfl rfl

theorem source_to_interpreter (op : CLogic.Cmp) (x y z : Val)
    (hs : C99IntegerReference.CompareExec (C99Frontend.comparison op) (value x) (value y) (value z)) :
    CLogic.compare op x y=z := by
  rw [comparison_iff] at hs
  simp only [type_matches,usual_matches] at hs
  rw [← cast_matches,← cast_matches] at hs
  simp only [integer_matches] at hs
  have hz := congrArg encode hs
  rw [encode_value] at hz
  have heq := same_type_integer_eq (B20.C.cast (commonTy x.ty y.ty) x)
    (B20.C.cast (commonTy x.ty y.ty) y) (by rw [cast_type,cast_type])
  rw [hz]
  cases op <;> simp [CLogic.compare,CLogic.boolean,C99Frontend.comparison,
    C99IntegerReference.compare,encode,heq]

end FT1536.Source3.C99CompareBridge

#print axioms FT1536.Source3.C99CompareBridge.source_to_interpreter
