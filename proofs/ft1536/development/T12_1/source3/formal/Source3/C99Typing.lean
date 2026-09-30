import Source3.C99Frontend

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99Typing
open B20.C
abbrev Types := Name → Option Ty

def count32 (t : Ty) : Bool := t==.i32 || t==.u32
def unsigned (t : Ty) : Bool := t==.u64 || t==.u32

/- Static typing only. No range, successful execution or desired value is
   tested. Left shifts have the unsigned lhs form of the pinned source;
   count types are verified here, not posited for all source executions. -/
def infer (calls ctx : Types) : CLogic.Expr → Option Ty
  | .literal t _ => some t
  | .var n => ctx n
  | .cast t e => do let _ ← infer calls ctx e; pure t
  | .neg e | .bitNot e => infer calls ctx e
  | .bin op a b => do
      let ta ← infer calls ctx a
      let tb ← infer calls ctx b
      if op=.shr then if count32 tb then some ta else none
      else if op=.shl then if count32 tb && unsigned ta then some ta else none
      else some (commonTy ta tb)
  | .cmp _ a b | .land a b | .lor a b => do
      let _ ← infer calls ctx a
      let _ ← infer calls ctx b
      pure .i32
  | .lnot e => do let _ ← infer calls ctx e; pure .i32
  | .call1 n a => do let _ ← infer calls ctx a; calls n
  | .call2 n a b => do let _ ← infer calls ctx a; let _ ← infer calls ctx b; calls n
  | .call3 n a b c => do
      let _ ← infer calls ctx a
      let _ ← infer calls ctx b
      let _ ← infer calls ctx c
      calls n

def environment (s : B20.C.Scalar.State) : C99ScalarReference.Env := fun n => do
  let t ← s.types n
  pure (C99ValueBridge.type t,(s.values n).map C99ValueBridge.value)

def WellTyped (s : B20.C.Scalar.State) : Prop :=
  ∀ n v, s.values n=some v → s.types n=some v.ty

theorem converted_type (t : C99IntegerReference.Ty) (z : Int) :
    (C99IntegerReference.convert t z).type=t := by cases t <;> rfl

theorem value_type_injective (a b : Ty) (h : C99ValueBridge.type a=C99ValueBridge.type b) : a=b := by
  cases a <;> cases b <;> simp_all [C99ValueBridge.type]

theorem encoded_type (v : C99IntegerReference.Value) (t : Ty)
    (h : v.type=C99ValueBridge.type t) : (C99ValueBridge.encode v).ty=t := by
  cases v <;> cases t <;> simp_all [C99IntegerReference.Value.type,C99ValueBridge.type,
    C99ValueBridge.encode,Val.ty]

theorem variable_related (s : B20.C.Scalar.State) (n : Name)
    (t : Ty) (rt : C99IntegerReference.Ty) (v : C99IntegerReference.Value)
    (hs : WellTyped s) (ht : s.types n=some t)
    (hv : environment s n=some (rt,some v)) :
    s.values n=some (C99ValueBridge.encode v) ∧ v.type=C99ValueBridge.type t := by
  have hshape : C99ValueBridge.type t=rt ∧
      ∃ word, s.values n=some word ∧ C99ValueBridge.value word=v := by
    simpa [environment,ht] using hv
  obtain ⟨word,hval,heq⟩ := hshape.2
  have hwtype : word.ty=t := Option.some.inj ((hs n word hval).symm.trans ht)
  subst v
  refine ⟨?_,?_⟩
  · rw [C99ValueBridge.encode_value]
    exact hval
  · rw [C99ValueBridge.type_matches,hwtype]

end FT1536.Source3.C99Typing

#print axioms FT1536.Source3.C99Typing.variable_related
