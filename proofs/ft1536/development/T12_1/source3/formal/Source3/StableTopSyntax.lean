import Source3.FprOfThree
import Source3.StableBinarySourceSyntax

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableTopSyntax
open B20.C

inductive Op where | add | mul | div
  deriving DecidableEq, Repr
def opName : Op → Name
  | .add => "fpr_add".toList | .mul => "fpr_mul".toList | .div => "fpr_div".toList
def parseOp (n : Name) : Option Op :=
  if n="fpr_add".toList then some .add else if n="fpr_mul".toList then some .mul
  else if n="fpr_div".toList then some .div else none

inductive Expr where
  | var (n : Name)
  | bin (op : Op) (a b : Expr)
  deriving DecidableEq, Repr
def wordExpr : CLogic.Expr → Option Expr
  | .var n => some (.var n)
  | .call2 n a b => do pure (.bin (← parseOp n) (← wordExpr a) (← wordExpr b))
  | _ => none

inductive Stmt where
  | readCheck (destination : Name) (delta : Nat)
  | letCheck (destination : Name) (value : Expr)
  | storeCheck (offset : Nat) (value : Expr)
  deriving DecidableEq, Repr
structure Loop where
  initialU : Nat
  initialV : Nat
  bound : Nat
  stepU : Nat
  stepV : Nat
  deriving DecidableEq, Repr
structure Branch where
  offset : Nat
  size : Nat
  deriving DecidableEq, Repr
structure Code where
  initializer : CLogic.Expr
  loop : Loop
  body : List Stmt
  branches : List Branch
  deriving DecidableEq, Repr

def natural := StableBinarySourceSyntax.natural
def words := StableBinarySourceSyntax.words
def tokens (s : String) : Option (List Token) := LeafScan.tokenize (s.length+1) s.toList

def parseFor : List Token → Option Loop
  | [['f','o','r'],['('],['u'],['='],u0,[','],['v'],['='],v0,[';'],['u'],['<'],bound,[';'],
      ['u'],['+','='],du,[','],['v'],['+','+'],[')'],['{']] =>
      return ⟨← natural u0,← natural v0,← natural bound,← natural du,1⟩
  | _ => none

def checkedRhs (ts : List Token) : Option Expr := do
  let (e,rest) ← CLogicParser.expression 16 ts
  if rest != [[','],['b','a','d'],[')'],[';']] then none else wordExpr e

def parseStmt : List Token → Option Stmt
  | dst::['=']::['f','t','_','s','t','a','b','l','e','_','p','o','s','i','t','i','v','e','_','k','e','y','g','e','n']::['(']::
      ['r','o','o','t','s']::['[']::['u']::['+']::delta::[']']::[',']::['b','a','d']::[')']::[';']::[] =>
      return .readCheck dst (← natural delta)
  | dst::['=']::['f','t','_','s','t','a','b','l','e','_','p','o','s','i','t','i','v','e','_','k','e','y','g','e','n']::['(']::ts =>
      return .letCheck dst (← checkedRhs ts)
  | ['l','e','a','v','e','s']::['[']::['v']::[']']::['=']::
      ['f','t','_','s','t','a','b','l','e','_','p','o','s','i','t','i','v','e','_','k','e','y','g','e','n']::['(']::ts =>
      return .storeCheck 0 (← checkedRhs ts)
  | ['l','e','a','v','e','s']::['[']::off::['+']::['v']::[']']::['=']::
      ['f','t','_','s','t','a','b','l','e','_','p','o','s','i','t','i','v','e','_','k','e','y','g','e','n']::['(']::ts =>
      return .storeCheck (← natural off) (← checkedRhs ts)
  | _ => none

def parseBranch : List Token → Option Branch
  | [['f','t','_','s','t','a','b','l','e','_','b','i','n','a','r','y','_','i','n','p','l','a','c','e','_','k','e','y','g','e','n'],
      ['('],['l','e','a','v','e','s'],['+'],off,[','],n,[','],['s','c','r','a','t','c','h'],[','],['b','a','d'],[')'],[';']] =>
      return ⟨← natural off,← natural n⟩
  | _ => none

def parse (lines : List String) : Option Code := do
  if lines.length != 27 then none else do
  if (← words lines 0 6) != (← tokens "static void ft_stable_top_branch_keygen(const fpr *roots, fpr *leaves, fpr *scratch, uint32_t *bad) { fpr three; size_t u, v;") then none else do
  let (initial,rest) ← CLogicParser.statement (← words lines 6 1)
  let init ← match initial,rest with
    | .assign ['t','h','r','e','e'] e,[] => some e
    | _,_ => none
  let loop ← parseFor (← words lines 7 1)
  if (← words lines 8 1) != (← tokens "fpr a, ab, abc, ac, b, bc, c, e1, e2;") then none else do
  let prefixBody ← (List.range 11).mapM (fun i => do parseStmt (← words lines (9+i) 1))
  let last ← parseStmt (← words lines 20 2)
  if (← words lines 22 1) != [['}']] then none else do
  let branches ← (List.range 3).mapM (fun i => do parseBranch (← words lines (23+i) 1))
  if (← words lines 26 1) != [['}']] then none else
    pure ⟨init,loop,prefixBody++[last],branches⟩

def v (s : String) : Expr := .var s.toList
def expected : Code := ⟨.call1 "fpr_of".toList (.literal .i32 3),⟨0,0,768,3,1⟩,[
  .readCheck ['a'] 0,.readCheck ['b'] 1,.readCheck ['c'] 2,
  .letCheck ['e','1'] (.bin .add (.bin .add (v "a") (v "b")) (v "c")),
  .letCheck ['a','b'] (.bin .mul (v "a") (v "b")),
  .letCheck ['a','c'] (.bin .mul (v "a") (v "c")),
  .letCheck ['b','c'] (.bin .mul (v "b") (v "c")),
  .letCheck ['e','2'] (.bin .add (.bin .add (v "ab") (v "ac")) (v "bc")),
  .letCheck ['a','b','c'] (.bin .mul (v "ab") (v "c")),
  .storeCheck 0 (.bin .div (v "e1") (v "three")),
  .storeCheck 256 (.bin .div (v "e2") (v "e1")),
  .storeCheck 512 (.bin .div (.bin .mul (v "three") (v "abc")) (v "e2"))],
  [⟨0,256⟩,⟨256,256⟩,⟨512,256⟩]⟩
def source := parse ((Pinned.keygenLines.drop 7515).take 27)

theorem pinned_source : source=some expected := by rfl

end FT1536.Source3.StableTopSyntax

#print axioms FT1536.Source3.StableTopSyntax.pinned_source
