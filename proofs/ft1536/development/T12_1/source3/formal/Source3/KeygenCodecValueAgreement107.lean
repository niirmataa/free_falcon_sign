import Source3.KeygenCodecAgreement107

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecValueAgreement107
open C99MemoryReference
open KeygenCodecSyntax
open KeygenCodecValues
open KeygenCodecAtoms106 (Clean)
open KeygenCodecAgreement107 (Agree noComp)

theorem expression (argsA argsB : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (e : Expr) (beforeA beforeB a b : Locals) (x y : Value)
    (first : Eval argsA heap buf e beforeA x a) (second : Eval argsB heap buf e beforeB y b)
    (start : Clean beforeA) (same : Agree beforeA beforeB)
    (outEqual : argsA.out = argsB.out) (checked : noComp e = true) : Agree a b ∧ x = y := by
  revert start same outEqual checked
  induction first generalizing argsB beforeB b y <;> intro start same outEqual checked <;> cases second
  all_goals have other := KeygenCodecAgreement107.clean _ _ same start
  all_goals have reserveA := start
  all_goals have reserveB := other
  all_goals have pointers := same.1
  all_goals simp only [Clean] at reserveA reserveB
  all_goals try simp only [noComp, Bool.and_eq_true, decide_eq_true_eq] at checked
  all_goals grind (ematch := 10) only [→ KeygenPrivateValues106.clean, → KeygenCodecAgreement107.update,
    KeygenCodecAgreement107.cell, Agree, KeygenCodecAtoms106.load16,
    KeygenCodecAtoms106.unary, KeygenCodecAtoms106.binary,
    → KeygenCodecAtoms106.no_and, → KeygenCodecAtoms106.no_or, → KeygenCodecAtoms106.no_dereference]

end FT1536.Source3.KeygenCodecValueAgreement107
