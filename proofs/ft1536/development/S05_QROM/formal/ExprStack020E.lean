import WordRAM020

namespace FT1536.S05.ExprStack020E
open WordRAM020

inductive Instr where
  | literal (w : Word)
  | register (r : Reg)
  | binary (o : Op)
  deriving Repr

def compile : Expr → List Instr
  | .lit w => [.literal w]
  | .reg r => [.register r]
  | .bin o a b => compile a ++ compile b ++ [.binary o]

def step (s : State) : Instr → List Word → Option (List Word)
  | .literal w,vs => some (w::vs)
  | .register r,vs => some (s.reg r::vs)
  | .binary o,b::a::vs => some (op o a b::vs)
  | .binary _,_ => none

def execute (s : State) : List Instr → List Word → Option (List Word)
  | [],vs => some vs
  | x::xs,vs => (step s x vs).bind (execute s xs)

theorem append (s : State) (xs ys : List Instr) (vs : List Word) :
    execute s (xs++ys) vs=(execute s xs vs).bind (execute s ys) := by
  induction xs generalizing vs with
  | nil => rfl
  | cons x xs ih =>
    simp only [List.cons_append,execute]
    cases h : step s x vs with
    | none => rfl
    | some ws => exact ih ws

theorem correct (s : State) (e : Expr) (vs : List Word) :
    execute s (compile e) vs=some (eval s e::vs) := by
  induction e generalizing vs with
  | lit w => rfl
  | reg r => rfl
  | bin o a b ha hb =>
    simp only [compile,append,ha,hb,Option.bind_some,execute,step,eval]

theorem length (e : Expr) : (compile e).length=exprNodes e := by
  induction e with
  | lit w => rfl
  | reg r => rfl
  | bin o a b ha hb => simp only [compile,List.length_append,List.length_singleton,exprNodes,ha,hb];omega

theorem nodes_cost (e : Expr) : exprNodes e=exprCost e := by
  induction e with
  | lit w => rfl
  | reg r => rfl
  | bin o a b ha hb => simp only [exprNodes,exprCost,ha,hb];omega

end FT1536.S05.ExprStack020E
