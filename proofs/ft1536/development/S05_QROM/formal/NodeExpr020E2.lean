import NodeRead020E2

namespace FT1536.S05.NodeExpr020E2
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArenaHeap020E1 ArenaToken020E1 NodeRead020E2

/-- Evaluate stored expression nodes directly. Left operand is second child,
    right operand first child. This function never reconstructs Expr/Code. -/
def evaluate {cap : Nat} : Nat → Arena cap → State → Ptr cap → Option Word
  | 0,_,_,_ => none
  | fuel+1,a,s,p => (inspect a p).bind (fun (n,t) => match t with
    | .literal w => some w
    | .register r => some (s.reg r)
    | .binary o => (evaluate fuel a s n.second).bind (fun x =>
        (evaluate fuel a s n.first).map (fun y => op o x y))
    | _ => none)

theorem correct {cap : Nat} (fuel : Nat) (a : Arena cap) (mu : Meaning) (s : State)
    (hh : HeapValid a mu) (p : Ptr cap) (e : Expr)
    (hp : p.val<a.used.val) (hf : p.val<fuel) (he : mu p.val=.expr e) :
    evaluate fuel a s p=some (eval s e) := by
  induction fuel generalizing p e with
  | zero => omega
  | succ fuel ih =>
    obtain ⟨n,t,ht,hkids,hasm⟩ := inspect_exists a mu hh p hp
    rw [he] at hasm
    have hk := assemble_kind t _ (.expr e) hasm
    rw [evaluate,ht]
    simp only [Option.bind_some]
    cases t
    case literal w =>
      have hE : Expr.lit w=e := by simpa [assemble,children,arity,needs,push] using hasm
      subst e
      rfl
    case register r =>
      have hE : Expr.reg r=e := by simpa [assemble,children,arity,needs,push] using hasm
      subst e
      rfl
    case binary o =>
      have hfirst : n.first.val<p.val := hkids n.first (by simp [children,arity,needs])
      have hsecond : n.second.val<p.val := hkids n.second (by simp [children,arity,needs])
      change assemble (.binary o) [mu n.first.val,mu n.second.val]=some (.expr e) at hasm
      cases hb : mu n.first.val <;> cases ha : mu n.second.val <;>
        simp [assemble,push,hb,ha] at hasm
      case expr.expr eb ea =>
        have hE : Expr.bin o ea eb=e := by simpa using hasm
        subst e
        rw [ih n.second ea (hsecond.trans hp) (by omega) ha]
        simp only [Option.bind_some]
        rw [ih n.first eb (hfirst.trans hp) (by omega) hb]
        rfl
    all_goals cases hk

end FT1536.S05.NodeExpr020E2
