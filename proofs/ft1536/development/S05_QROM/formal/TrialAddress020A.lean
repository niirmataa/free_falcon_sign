import CoordinateSites020A

set_option exponentiation.threshold 512
namespace FT1536.S05.TrialAddress020A
open WordRAM020 WordArithmetic020 PairProgram020 ReadSemantics020A BitValue020A CdfPrefix020A

def base (n p k : Nat) : Nat := ((n*1536+p)*80+k)*1024

def addressExpr : Expr :=
  mul (add (mul (add (mul (r 0) (lit 1536)) (r 1)) (lit 80)) (r 2)) (lit 1024)

theorem window (n p k : Nat) (hn : n<196) (hp : p<1536) (hk : k<80) :
    base n p k+1024≤196*(1536*80*1024) ∧ base n p k+1024≤tapeSize := by
  simp only [base,tapeSize]
  omega

theorem expression_correct (s : State) (n p k : Nat) (hn : n<196) (hp : p<1536) (hk : k<80)
    (h0 : s.reg 0=nw n) (h1 : s.reg 1=nw p) (h2 : s.reg 2=nw k) :
    eval s addressExpr=nw (base n p k) := by
  have fn : Fits (n : Int) := tiny_fits (by omega)
  have fp : Fits (p : Int) := tiny_fits (by omega)
  have fk : Fits (k : Int) := tiny_fits (by omega)
  have f0 : Fits ((n*1536 : Nat) : Int) := tiny_fits (by omega)
  have f1 : Fits ((n*1536+p : Nat) : Int) := tiny_fits (by omega)
  have f2 : Fits (((n*1536+p)*80 : Nat) : Int) := tiny_fits (by omega)
  have f3 : Fits (((n*1536+p)*80+k : Nat) : Int) := tiny_fits (by omega)
  have e0 : eval s (mul (r 0) (lit 1536))=nw (n*1536) := by
    change op .mul (s.reg 0) (word 1536)=_
    rw [h0]
    exact mul_word _ _ fn (tiny_fits (n:=1536) (by decide))
  have e1 : eval s (add (mul (r 0) (lit 1536)) (r 1))=nw (n*1536+p) := by
    change op .add (eval s (mul (r 0) (lit 1536))) (s.reg 1)=_
    rw [e0,h1]
    exact add_word _ _ f0 fp
  have e2 : eval s (mul (add (mul (r 0) (lit 1536)) (r 1)) (lit 80))=nw ((n*1536+p)*80) := by
    change op .mul (eval s (add (mul (r 0) (lit 1536)) (r 1))) (word 80)=_
    rw [e1]
    exact mul_word _ _ f1 (tiny_fits (n:=80) (by decide))
  have e3 : eval s (add (mul (add (mul (r 0) (lit 1536)) (r 1)) (lit 80)) (r 2))=nw ((n*1536+p)*80+k) := by
    change op .add (eval s (mul (add (mul (r 0) (lit 1536)) (r 1)) (lit 80))) (s.reg 2)=_
    rw [e2,h2]
    exact add_word _ _ f2 fk
  change op .mul (eval s (add (mul (add (mul (r 0) (lit 1536)) (r 1)) (lit 80)) (r 2))) (word 1024)=_
  rw [e3]
  exact mul_word _ _ f3 (tiny_fits (n:=1024) (by decide))

theorem machine_store (i : Input) (s : State) (n p k : Nat) (hn : n<196) (hp : p<1536) (hk : k<80)
    (h0 : s.reg 0=nw n) (h1 : s.reg 1=nw p) (h2 : s.reg 2=nw k) :
    exec i (set 3 addressExpr) s=put s 3 (nw (base n p k)) := by
  rw [exec_set,expression_correct s n p k hn hp hk h0 h1 h2]

end FT1536.S05.TrialAddress020A
