import PairStores020B

namespace FT1536.S05.StoreExpressions020C
open WordRAM020 PairProgram020 ReadSemantics020A PairStores020B

def storesBy (x y : Expr) : Code := seqs [store (mul (r 1) (lit 2)) x,
  store (add (mul (r 1) (lit 2)) (lit 1)) y]

theorem eval_ram (s : State) (mem : Fin ramSize → Word) (e : Expr) :
    eval {s with ram := mem} e=eval s e :=
  eval_of_agree _ _ e (fun _ _ => rfl)

theorem stores_correct (i : Input) (s : State) (p : Fin 1536) (x y : Expr)
    (h1 : s.reg 1=word (p.val:Int)) :
    exec i (storesBy x y) s=writePair s p (eval s x) (eval s y) := by
  simp only [storesBy,exec_seqs_cons,exec_seqs_nil,exec_store,address0 s p h1]
  rw [address1 {s with ram := Function.update s.ram (slot0 p) (eval s x)} p h1]
  simp only [eval_ram]
  rfl

end FT1536.S05.StoreExpressions020C
