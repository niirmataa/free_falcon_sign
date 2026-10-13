import ExprMeter020E

namespace FT1536.S05.ExprCompileBudget020E
open WordRAM020 ExprStack020E

/-- Syntactic constructor/copy budget for the left-associated append compiler:
    two copies of the left list, one of the right, one opcode node. This
    recurrence is not a theorem about a physical allocator or native Lean. -/
def allocations : Expr → Nat
  | .lit _ | .reg _ => 1
  | .bin _ a b => allocations a+allocations b+2*(compile a).length+(compile b).length+1

def callDepth : Expr → Nat
  | .lit _ | .reg _ => 1
  | .bin _ a b => 1+max (callDepth a) (callDepth b)

theorem nodes_positive (e : Expr) : 0<exprNodes e := by
  cases e <;> simp only [exprNodes] <;> omega

theorem allocations_bound (e : Expr) : allocations e≤(exprNodes e)^2 := by
  induction e with
  | lit w => exact le_rfl
  | reg r => exact le_rfl
  | bin o a b ha hb =>
    simp only [allocations,ExprStack020E.length,exprNodes]
    have ap := nodes_positive a
    have bp := nodes_positive b
    nlinarith

theorem call_depth_bound (e : Expr) : callDepth e≤exprNodes e := by
  induction e with
  | lit w => exact le_rfl
  | reg r => exact le_rfl
  | bin o a b ha hb => simp only [callDepth,exprNodes];omega

/-- One control step can hide arbitrarily much expression work. This rules
    out treating the control counter alone as a total primitive cost. -/
def nested : Nat → Expr
  | 0 => .lit 0
  | n+1 => .bin .add (nested n) (.lit 0)

theorem nested_size (n : Nat) : exprNodes (nested n)=2*n+1 := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [nested,exprNodes,ih];omega

theorem unbounded_expression_work (k : Nat) : ∃ e : Expr, k<(compile e).length := by
  refine ⟨nested k,?_⟩
  rw [ExprStack020E.length,nested_size]
  omega

end FT1536.S05.ExprCompileBudget020E
