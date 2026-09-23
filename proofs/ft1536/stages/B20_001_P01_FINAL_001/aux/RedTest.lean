namespace RedTest

-- String.decEq / literal patterns must kernel-reduce for `decide` proofs
example : ite ("ret" = "reg") (1:Nat) 0 = 0 := by decide
example : ite ("ret" = "ret") (1:Nat) 0 = 1 := by decide

inductive Tok where
  | name (s : String)
  | num (n : Nat)
  deriving DecidableEq, Repr

example : ite ([Tok.name "ret"] = [Tok.name "ret"]) (1:Nat) 0 = 1 := by decide
example : ite ([Tok.name "ret"] = [Tok.name "reg"]) (1:Nat) 0 = 0 := by decide

def dec (ts : List Tok) : Option Nat :=
  match ts with
  | [.name "skip"] => some 0
  | [.name "ret", .num n] => some n
  | _ => none

example : dec [Tok.name "skip"] = some 0 := by decide
example : dec [Tok.name "ret", .num 7] = some 7 := by decide

example : ("abc".toList) = ['a', 'b', 'c'] := by rfl

end RedTest
