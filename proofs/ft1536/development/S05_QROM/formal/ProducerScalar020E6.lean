import ProducerExpr020E6

namespace FT1536.S05.ProducerScalar020E6
open WordRAM020 ProducerExpr020E6

abbrev E (r : Nat) := ProducerExpr020E6.Expr r

def lit {r : Nat} (n : Nat) : E r := .literal (word n)
def add {r : Nat} (x y : E r) : E r := .binary .add x y
def sub {r : Nat} (x y : E r) : E r := .binary .sub x y
def mul {r : Nat} (x y : E r) : E r := .binary .mul x y
def eq {r : Nat} (x y : E r) : E r := .binary .eq x y
def lt {r : Nat} (x y : E r) : E r := .binary .lt x y
/-- choose c yes no: truth means a nonzero scalar. -/
def choose {r : Nat} (c yes no : E r) : E r := .select c no yes
def not {r : Nat} (c : E r) : E r := eq c (lit 0)
def and {r : Nat} (a b : E r) : E r := choose a b (lit 0)
def or {r : Nat} (a b : E r) : E r := choose a (lit 1) b
def natClamp {r : Nat} (x : E r) : E r := choose (lt x (lit 0)) (lit 0) x
def pred {r : Nat} (x : E r) : E r := choose (eq x (lit 0)) (lit 0) (sub x (lit 1))
def validAddress {r : Nat} (n : Nat) (x : E r) : E r := and (not (lt x (lit 0))) (lt x (lit n))
def cell {r : Nat} (region : Fin r) (index : Nat) : E r := .load region (lit index)

structure Optional (r : Nat) where
  present : E r
  value : E r

def none {r : Nat} : Optional r := ⟨lit 0,lit 0⟩
def some {r : Nat} (x : E r) : Optional r := ⟨lit 1,x⟩
def guarded {r : Nat} (p : E r) (x : E r) : Optional r := ⟨p,choose p x (lit 0)⟩
def optionChoose {r : Nat} (c : E r) (x y : Optional r) : Optional r :=
  ⟨choose c x.present y.present,choose c x.value y.value⟩

end FT1536.S05.ProducerScalar020E6
