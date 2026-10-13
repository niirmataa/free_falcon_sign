import ControlMeter020E
import ExprCompileBudget020E
import PairProgram020

set_option maxRecDepth 16384
set_option maxHeartbeats 2000000
namespace FT1536.S05.ReachableExpr020E
open WordRAM020 ControlStack020E

def atomExpr (a : Atom) : List Expr := match a with
  | .set _ e | .loadROM _ e | .loadRAM _ e | .loadBit _ e => [e]
  | .store a v | .emit a v => [a,v]

def atomMax (a : Atom) : Nat := match a with
  | .set _ e | .loadROM _ e | .loadRAM _ e | .loadBit _ e => exprNodes e
  | .store a v | .emit a v => max (exprNodes a) (exprNodes v)

def maxExpr : Code → Nat
  | .atom a => atomMax a
  | .seq a b => max (maxExpr a) (maxExpr b)
  | .branch e a b => max (exprNodes e) (max (maxExpr a) (maxExpr b))
  | .loop _ g b => max (exprNodes g) (maxExpr b)

def localExpr : Code → List Expr
  | .atom a => atomExpr a
  | .seq _ _ => []
  | .branch e _ _ | .loop _ e _ => [e]

def Bounded (cs : Jobs) (n : Nat) : Prop := ∀ c∈cs,maxExpr c≤n

theorem local_bound (c : Code) (e : Expr) (he : e∈localExpr c) : exprNodes e≤maxExpr c := by
  cases c with
  | atom a =>
    cases a <;> simp only [localExpr,atomExpr,List.mem_cons,List.not_mem_nil,or_false] at he
    all_goals rcases he with rfl|rfl <;> simp only [maxExpr,atomMax] <;> omega
  | seq a b => cases he
  | branch g a b => have h : e=g := List.mem_singleton.mp he;subst e;exact le_max_left _ _
  | loop n g b => have h : e=g := List.mem_singleton.mp he;subst e;exact le_max_left _ _

theorem next_bound (i : Input) (c : Code) (cs : Jobs) (s : State) (n : Nat) (h : Bounded (c::cs) n) :
    Bounded (next i c cs s).1 n := by
  have hc : maxExpr c≤n := h c (by simp)
  have ht : Bounded cs n := fun x hx => h x (by simp [hx])
  cases c with
  | atom a => exact ht
  | seq a b =>
    simp only [next,Bounded,List.mem_cons,forall_eq_or_imp]
    simp only [maxExpr] at hc
    exact ⟨by omega,by omega,ht⟩
  | branch e a b =>
    simp only [next]
    simp only [maxExpr] at hc
    split <;> simp only [Bounded,List.mem_cons,forall_eq_or_imp] <;> exact ⟨by omega,ht⟩
  | loop k g b =>
    cases k with
    | zero => exact ht
    | succ k =>
      simp only [next]
      split
      · exact ht
      · simp only [Bounded,List.mem_cons,forall_eq_or_imp]
        simp only [maxExpr] at hc ⊢
        exact ⟨by omega,hc,ht⟩

theorem program_bound : maxExpr PairProgram020.program≤32 := by decide +kernel

theorem reachable (i : Input) (s0 s : State) (cs : Jobs)
    (h : ControlMeter020E.Reach i [PairProgram020.program] s0 cs s) : Bounded cs 32 := by
  induction h with
  | start => simpa only [Bounded,List.mem_singleton,forall_eq] using program_bound
  | step prev ih => exact next_bound _ _ _ _ _ ih

theorem expression_resources (i : Input) (s0 s : State) (cs : Jobs)
    (h : ControlMeter020E.Reach i [PairProgram020.program] s0 cs s)
    (c : Code) (hc : c∈cs) (e : Expr) (he : e∈localExpr c) :
    (ExprMeter020E.measured s (ExprStack020E.compile e) []).executed≤32 ∧
      (ExprMeter020E.measured s (ExprStack020E.compile e) []).peak≤32 ∧
      ExprCompileBudget020E.allocations e≤1024 ∧ ExprCompileBudget020E.callDepth e≤32 := by
  have hn := (local_bound c e he).trans (reachable i s0 s cs h c hc)
  have b := ExprMeter020E.compiled s e
  have a := ExprCompileBudget020E.allocations_bound e
  exact ⟨b.2.1.trans hn,b.2.2.trans hn,by nlinarith,(ExprCompileBudget020E.call_depth_bound e).trans hn⟩

end FT1536.S05.ReachableExpr020E
