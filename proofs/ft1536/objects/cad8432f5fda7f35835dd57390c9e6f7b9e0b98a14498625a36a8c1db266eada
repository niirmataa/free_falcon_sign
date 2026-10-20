import Source3.UnsignedSafety

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.UnsignedState
open B20.C
open UnsignedSafety

structure Ctx where
  types : TEnv
  initialized : TEnv

def setType (map : TEnv) (name : Name) (ty : Ty) : TEnv :=
  fun other => if other=name then some ty else map other

def Good (ctx : Ctx) (s : B20.C.Scalar.State) : Prop :=
  s.types=ctx.types ∧ EnvTyped ctx.initialized s.values

def declareOne (ctx : Ctx) (ty : Ty) (name : Name) : Option Ctx :=
  if (ctx.types name).isSome then none else
    some {ctx with types := setType ctx.types name ty}

theorem declare_total (ctx : Ctx) (s : B20.C.Scalar.State) (ty : Ty) (name : Name)
    (next : Ctx) (hg : Good ctx s) (h : declareOne ctx ty name=some next) :
    ∃ out, B20.C.Scalar.declareOne s ty name=some out ∧ Good next out := by
  by_cases he : (ctx.types name).isSome
  · simp [declareOne,he] at h
  · have hn : next={ctx with types := setType ctx.types name ty} :=
      (Option.some.inj (by simpa [declareOne,he] using h)).symm
    subst next
    refine ⟨{s with types := setType s.types name ty},?_,?_,hg.2⟩
    · simp [B20.C.Scalar.declareOne,hg.1,he]
      rfl
    · simp only [hg.1]

def declareMany : Ctx → Ty → List Name → Option Ctx
  | ctx,_,[] => some ctx
  | ctx,ty,name::rest => do declareMany (← declareOne ctx ty name) ty rest

theorem declarations_total (ctx next : Ctx) (s : B20.C.Scalar.State)
    (ty : Ty) (names : List Name) (hg : Good ctx s)
    (h : declareMany ctx ty names=some next) :
    ∃ out, B20.C.Scalar.declareMany s ty names=some out ∧ Good next out := by
  induction names generalizing ctx s with
  | nil =>
      have he : ctx=next := Option.some.inj h
      subst next
      exact ⟨s,rfl,hg⟩
  | cons name rest ih =>
      obtain ⟨mid,hm,ht⟩ := Option.bind_eq_some_iff.mp h
      obtain ⟨sm,hsm,hgm⟩ := declare_total ctx s ty name mid hg hm
      obtain ⟨out,hout,hgo⟩ := ih mid sm hgm ht
      exact ⟨out,by simp [B20.C.Scalar.declareMany,hsm,hout],hgo⟩

def assign (ctx : Ctx) (name : Name) (rhs : CLogic.Expr) : Option Ctx := do
  let ty ← ctx.types name
  let _ ← infer ctx.initialized rhs
  if ExpressionFuel.depth rhs≤32 then
    pure {ctx with initialized := setType ctx.initialized name ty}
  else none

theorem assign_total (calls : B20.C.Scalar.Calls) (ctx next : Ctx) (s : B20.C.Scalar.State)
    (name : Name) (rhs : CLogic.Expr) (hg : Good ctx s)
    (h : assign ctx name rhs=some next) :
    ∃ out, CLogic.step calls s (.assign name rhs)=some out ∧ Good next out := by
  obtain ⟨ty,hdecl,hrest⟩ := Option.bind_eq_some_iff.mp h
  obtain ⟨rty,hty,hrest⟩ := Option.bind_eq_some_iff.mp hrest
  have hdepth : ExpressionFuel.depth rhs≤32 := by
    by_contra hd
    simp [hd] at hrest
  have heq : next={ctx with initialized := setType ctx.initialized name ty} := by
    exact (Option.some.inj (by simpa [hdepth] using hrest)).symm
  subst next
  obtain ⟨v,hv,hvt⟩ := expr_total calls ctx.initialized s.values rhs rty hg.2 hty
  have heval : CLogic.eval calls s.values 32 rhs=some v := by
    rw [ExpressionFuel.fuel_adequate _ _ _ _ hdepth]
    exact hv
  let out : B20.C.Scalar.State := {s with values := update s.values name (B20.C.cast ty v)}
  refine ⟨out,?_,?_,?_⟩
  · simp [CLogic.step,B20.C.Scalar.assign,heval,hg.1,hdecl,out]
  · exact hg.1
  · intro other otherTy hother
    by_cases eq : other=name
    · subst other
      have ht : otherTy=ty := by simpa [setType] using hother.symm
      subst otherTy
      exact ⟨B20.C.cast ty v,by simp [out,update],cast_type ty v⟩
    · have hi : ctx.initialized other=some otherTy := by simpa [setType,eq] using hother
      obtain ⟨value,hvalue,hvaltype⟩ := hg.2 other otherTy hi
      exact ⟨value,by simpa [out,update,eq] using hvalue,hvaltype⟩

def step (ctx : Ctx) : CLogic.Stmt → Option Ctx
  | .declare ty names => declareMany ctx ty names
  | .assign name rhs => assign ctx name rhs
  | .update name op rhs => assign ctx name (.bin op (.var name) rhs)
  | .ret _ => none

theorem step_total (calls : B20.C.Scalar.Calls) (ctx next : Ctx) (s : B20.C.Scalar.State) (stmt : CLogic.Stmt)
    (hg : Good ctx s) (h : step ctx stmt=some next) :
    ∃ out, CLogic.step calls s stmt=some out ∧ Good next out := by
  cases stmt with
  | declare ty ns => exact declarations_total ctx next s ty ns hg h
  | assign name e => exact assign_total calls ctx next s name e hg h
  | update name op e =>
      obtain ⟨out,hout,hgood⟩ := assign_total calls ctx next s name (.bin op (.var name) e) hg h
      refine ⟨out,?_,hgood⟩
      have hd : ExpressionFuel.depth e≤31 := by
        obtain ⟨ty,_,hr⟩ := Option.bind_eq_some_iff.mp h
        obtain ⟨rty,_,hr⟩ := Option.bind_eq_some_iff.mp hr
        by_contra hn
        have hf : ¬ExpressionFuel.depth (.bin op (.var name) e)≤32 := by
          simp only [ExpressionFuel.depth]; omega
        simp [hf] at hr
      have h31 := ExpressionFuel.fuel_adequate calls s.values e 31 hd
      have h32 := ExpressionFuel.fuel_adequate calls s.values e 32 (by omega)
      simpa [CLogic.step,CLogic.eval,h31,h32,Option.bind_assoc] using hout
  | ret _ => simp [step] at h

def run : Ctx → List CLogic.Stmt → Option Ctx
  | ctx,[] => some ctx
  | ctx,stmt::rest => do run (← step ctx stmt) rest

def exec (calls : B20.C.Scalar.Calls) : B20.C.Scalar.State → List CLogic.Stmt → Option B20.C.Scalar.State
  | s,[] => some s
  | s,stmt::rest => do exec calls (← CLogic.step calls s stmt) rest

theorem run_total (calls : B20.C.Scalar.Calls) (ctx next : Ctx) (s : B20.C.Scalar.State) (body : List CLogic.Stmt)
    (hg : Good ctx s) (h : run ctx body=some next) :
    ∃ out, exec calls s body=some out ∧ Good next out := by
  induction body generalizing ctx s with
  | nil =>
      have heq : ctx=next := Option.some.inj h
      subst next
      exact ⟨s,rfl,hg⟩
  | cons stmt rest ih =>
      obtain ⟨mid,hm,hr⟩ := Option.bind_eq_some_iff.mp h
      obtain ⟨sm,hsm,hgm⟩ := step_total calls ctx mid s stmt hg hm
      obtain ⟨out,ho,hgo⟩ := ih mid sm hgm hr
      exact ⟨out,by simp [exec,hsm,ho],hgo⟩

end FT1536.Source3.UnsignedState

#print axioms FT1536.Source3.UnsignedState.run_total
