import NodeExpr020E2

namespace FT1536.S05.ValueSlot020E3
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArenaHeap020E1 ArenaToken020E1

/-- One cell's evaluation reads previously materialized values only. -/
def compute {cap : Nat} (f : Ptr cap → Option Word) (s : State) (n : Node cap) : Token → Option Word
  | .literal w => some w
  | .register r => some (s.reg r)
  | .binary o => (f n.second).bind (fun x => (f n.first).map (fun y => op o x y))
  | _ => none

/-- Specification only; never stored in the value bank. -/
def value (s : State) : Piece → Option Word
  | .expr e => some (eval s e)
  | .code _ => none

theorem correct {cap : Nat} (f : Ptr cap → Option Word) (s : State) (n : Node cap)
    (t : Token) (mu : Meaning) (v : Piece)
    (hs : assemble t ((children t n).map (fun p => mu p.val))=some v)
    (hf : ∀ p∈children t n,f p=value s (mu p.val)) : compute f s n t=value s v := by
  have hk := assemble_kind t _ v hs
  cases v with
  | code c => cases t <;> first | rfl | cases hk
  | expr e =>
    cases t
    case literal w =>
      have he : Expr.lit w=e := by simpa [assemble,children,arity,needs,push] using hs
      subst e;rfl
    case register r =>
      have he : Expr.reg r=e := by simpa [assemble,children,arity,needs,push] using hs
      subst e;rfl
    case binary o =>
      change assemble (.binary o) [mu n.first.val,mu n.second.val]=some (.expr e) at hs
      cases hb : mu n.first.val <;> cases ha : mu n.second.val <;> simp [assemble,push,hb,ha] at hs
      case expr.expr eb ea =>
        have he : Expr.bin o ea eb=e := by simpa using hs
        subst e
        rw [compute,hf n.second (by simp [children,arity,needs]),ha]
        simp only [value,Option.bind_some]
        rw [hf n.first (by simp [children,arity,needs]),hb]
        rfl
    all_goals cases hk

end FT1536.S05.ValueSlot020E3
