import Source3.C99ExpressionBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99StateBridge
open B20.C C99Typing C99ValueBridge

theorem assigned_good (s : B20.C.Scalar.State) (n : Name) (v : Val) (t : Ty)
    (hgood : WellTyped s) (ht : s.types n=some t) :
    WellTyped {s with values := update s.values n (B20.C.cast t v)} := by
  intro other w hw
  by_cases heq : other=n
  · subst other
    have hv : w=B20.C.cast t v := by simpa [update] using hw.symm
    subst w
    simpa [C99CompareBridge.cast_type] using ht
  · apply hgood other w
    simpa [update,heq] using hw

theorem assigned_environment (s : B20.C.Scalar.State) (n : Name)
    (v : C99IntegerReference.Value) (t : Ty) (ht : s.types n=some t) :
    environment {s with values := update s.values n (B20.C.cast t (encode v))} =
      C99ScalarReference.set (environment s) n
        (type t,some (C99IntegerReference.convert (type t) v.integer)) := by
  funext other
  by_cases heq : other=n
  · subst other
    simp [environment,update,C99ScalarReference.set,ht,cast_matches,value_encode]
  · simp [environment,update,C99ScalarReference.set,heq]

theorem undeclared_empty (s : B20.C.Scalar.State) (n : Name)
    (hgood : WellTyped s) (ht : s.types n=none) : s.values n=none := by
  cases hv : s.values n with
  | none => rfl
  | some v => have hh := hgood n v hv; rw [ht] at hh; contradiction

theorem declared_good (s : B20.C.Scalar.State) (n : Name) (t : Ty)
    (hgood : WellTyped s) (ht : s.types n=none) :
    WellTyped {s with types := fun name => if name=n then some t else s.types name} := by
  intro name v hv
  by_cases heq : name=n
  · subst name
    have hnone := undeclared_empty s n hgood ht
    rw [hnone] at hv
    contradiction
  · simp only [heq,ite_false]
    exact hgood name v hv

theorem declared_environment (s : B20.C.Scalar.State) (n : Name) (t : Ty)
    (hgood : WellTyped s) (ht : s.types n=none) :
    environment {s with types := fun name => if name=n then some t else s.types name}=
      C99ScalarReference.set (environment s) n (type t,none) := by
  have hnone := undeclared_empty s n hgood ht
  funext other
  by_cases heq : other=n
  · subst other
    simp [environment,C99ScalarReference.set,hnone]
  · simp [environment,C99ScalarReference.set,heq]

def declareTypes : Types → Ty → List Name → Option Types
  | ctx,_,[] => some ctx
  | ctx,t,n::rest =>
      if (ctx n).isSome then none else
        declareTypes (fun name => if name=n then some t else ctx name) t rest

def expressionCheck (sig ctx : Types) (e : CLogic.Expr) : Bool :=
  (C99Typing.infer sig ctx e).isSome && decide (ExpressionFuel.depth e≤32)

def check (sig ctx : Types) : CLogic.Stmt → Option Types
  | .declare t names => declareTypes ctx t names
  | .assign n e =>
      if (ctx n).isSome && expressionCheck sig ctx e then some ctx else none
  | .update n op e =>
      if (ctx n).isSome && expressionCheck sig ctx (.bin op (.var n) e) then some ctx else none
  | .ret e => if expressionCheck sig ctx e then some ctx else none

def checkBody (sig : Types) : Types → List CLogic.Stmt → Option Types
  | ctx,[] => some ctx
  | ctx,stmt::rest => do checkBody sig (← check sig ctx stmt) rest

theorem expression_check (sig ctx : Types) (e : CLogic.Expr)
    (h : expressionCheck sig ctx e=true) :
    ∃ t, C99Typing.infer sig ctx e=some t ∧ ExpressionFuel.depth e≤32 := by
  have hparts := (Bool.and_eq_true _ _).mp h
  obtain ⟨t,ht⟩ := Option.isSome_iff_exists.mp hparts.1
  exact ⟨t,ht,of_decide_eq_true hparts.2⟩

end FT1536.Source3.C99StateBridge

#print axioms FT1536.Source3.C99StateBridge.assigned_environment
#print axioms FT1536.Source3.C99StateBridge.declared_environment
