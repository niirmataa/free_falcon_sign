import Source3.KeygenReadyFast
import Source3.KeygenEntropySource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete source syntax for both set_seed and rng_ready. Automatic tmp32
   scopes are explicit nodes; calls name only their actual fixed destination.
   The specialised entropy condition retains its side effect before !/if. -/
namespace FT1536.Source3.KeygenRngProgram
open C99ArrayReference (Name)
open B20.C (Token)
open KeygenReadyFast (Flag)

inductive Stmt where
  | skip
  | init (capacity : CLogic.Expr)
  | inject (data : Name) (length : CLogic.Expr)
  | extractTmp
  | flip
  | setSeed (data : Name) (length replace : CLogic.Expr)
  | storeFlag (flag : Flag) (value : CLogic.Expr)
  | branchScalar (condition : CLogic.Expr) (yes no : Stmt)
  | branchFlag (flag : Flag) (negated : Bool) (yes no : Stmt)
  | branchEntropy (yes no : Stmt)
  | ret (value : Option Nat)
  | seq (first second : Stmt)
  | scope (body : Stmt)
  | auto32 (body : Stmt)
  deriving DecidableEq, Repr
def chain : List Stmt → Stmt | [] => .skip | first::rest => .seq first (chain rest)
def num (n : Nat) : CLogic.Expr := .literal .i32 n
def len : CLogic.Expr := .var "len".toList
def replacing : Stmt := .scope (chain [
  .init (num 512),.inject "seed".toList len,.storeFlag .seeded (num 1),.storeFlag .flipped (num 0),.ret none])
def remix : Stmt := .scope (.auto32 (chain [
  .extractTmp,.init (num 512),.inject "tmp".toList (num 32),.storeFlag .flipped (num 0)]))
def setSeedCode : Stmt := chain [
  .branchScalar (.var "replace".toList) replacing .skip,
  .branchFlag .flipped false remix .skip,.inject "seed".toList len]
def seedStage : Stmt := .branchFlag .seeded true
  (.scope (.auto32 (chain [
    .branchEntropy (.scope (chain [.ret (some 0)])) .skip,
    .setSeed "tmp".toList (num 32) (num 0),.storeFlag .seeded (num 1)]))) .skip
def flipStage : Stmt := .branchFlag .flipped true
  (.scope (chain [.flip,.storeFlag .flipped (num 1)])) .skip
def readyCode : Stmt := chain [seedStage,flipStage,.ret (some 1)]
def flagToken : Token → Option Flag
  | ['s','e','e','d','e','d'] => some .seeded
  | ['f','l','i','p','p','e','d'] => some .flipped
  | _ => none
def simple : List Token → Option (Stmt × List Token)
  | ['s','h','a','k','e','_','i','n','i','t']::['(']::['&']::['f','k']::['-']::['>']::['r','n','g']::[',']::rest => do
      let (capacity,tail) ← C99ArrayParser.pureExpr rest
      match tail with | [')']::[';']::tail => pure (.init capacity,tail) | _ => none
  | ['s','h','a','k','e','_','i','n','j','e','c','t']::['(']::['&']::['f','k']::['-']::['>']::['r','n','g']::[',']::data::[',']::rest => do
      let (length,tail) ← if rest.take 2=["sizeof".toList,"tmp".toList] then
        some (num 32,rest.drop 2) else C99ArrayParser.pureExpr rest
      match tail with | [')']::[';']::tail => pure (.inject data length,tail) | _ => none
  | ['s','h','a','k','e','_','e','x','t','r','a','c','t']::['(']::['&']::['f','k']::['-']::['>']::['r','n','g']::[',']::['t','m','p']::[',']::['s','i','z','e','o','f']::['t','m','p']::[')']::[';']::rest => pure (.extractTmp,rest)
  | ['s','h','a','k','e','_','f','l','i','p']::['(']::['&']::['f','k']::['-']::['>']::['r','n','g']::[')']::[';']::rest => pure (.flip,rest)
  | ['f','k']::['-']::['>']::flag::['=']::rest => do
      let f ← flagToken flag
      let (value,tail) ← C99ArrayParser.pureExpr rest
      match tail with | [';']::tail => pure (.storeFlag f value,tail) | _ => none
  | ['f','a','l','c','o','n','_','k','e','y','g','e','n','_','s','e','t','_','s','e','e','d']::['(']::['f','k']::[',']::data::[',']::['s','i','z','e','o','f']::['t','m','p']::[',']::rest => do
      let (replace,tail) ← C99ArrayParser.pureExpr rest
      match tail with | [')']::[';']::tail => pure (.setSeed data (num 32) replace,tail) | _ => none
  | ['r','e','t','u','r','n']::[';']::rest => pure (.ret none,rest)
  | ['r','e','t','u','r','n']::number::[';']::rest => do
      let expression ← CLogicParser.number number
      match expression with | .literal .i32 n => pure (.ret (some n),rest) | _ => none
  | _ => none
mutual
  def statement : Nat → List Token → Option (Stmt × List Token)
    | 0,_ => none
    | fuel+1,['{']::rest => do
        let (code,tail) ← body fuel rest
        pure (.scope code,tail)
    | fuel+1,['i','f']::['(']::['!']::['f','k']::['-']::['>']::flag::[')']::rest => do
        let f ← flagToken flag
        let (yes,tail) ← statement fuel rest
        pure (.branchFlag f true yes .skip,tail)
    | fuel+1,['i','f']::['(']::['f','k']::['-']::['>']::flag::[')']::rest => do
        let f ← flagToken flag
        let (yes,tail) ← statement fuel rest
        pure (.branchFlag f false yes .skip,tail)
    | fuel+1,['i','f']::['(']::['!']::['f','a','l','c','o','n','_','g','e','t','_','s','e','e','d']::['(']::['t','m','p']::[',']::['s','i','z','e','o','f']::['t','m','p']::[')']::[')']::rest => do
        let (yes,tail) ← statement fuel rest
        pure (.branchEntropy yes .skip,tail)
    | fuel+1,['i','f']::['(']::rest => do
        let (condition,rest) ← C99ArrayParser.pureExpr rest
        match rest with
        | [')']::rest => do
            let (yes,tail) ← statement fuel rest
            pure (.branchScalar condition yes .skip,tail)
        | _ => none
    | _+1,rest => simple rest
  def body : Nat → List Token → Option (Stmt × List Token)
    | 0,_ => none
    | _+1,['}']::rest => pure (.skip,rest)
    | fuel+1,['u','n','s','i','g','n','e','d']::['c','h','a','r']::['t','m','p']::['[']::['3','2']::[']']::[';']::rest => do
        let (tail,rest) ← body fuel rest
        pure (.auto32 tail,rest)
    | fuel+1,rest => do
        let (head,rest) ← statement fuel rest
        let (tail,rest) ← body fuel rest
        pure (.seq head tail,rest)
end
def parsed (first count : Nat) : Option Stmt := do
  let tokens ← C99ProcedureParser.tokens (((Pinned.keygenLines.drop (first-1)).take count).flatMap String.toList)
  let (code,tail) ← body 96 tokens
  if tail.isEmpty then pure code else none
theorem set_seed_source : parsed 5252 17=some setSeedCode := by decide
theorem ready_source : parsed 5273 15=some readyCode := by decide
theorem signatures_source : (Pinned.keygenLines.drop 5247).take 4=[
  "void\n","falcon_keygen_set_seed(falcon_keygen *fk,\n","\tconst void *seed, size_t len, int replace)\n","{\n"] ∧
  (Pinned.keygenLines.drop 5269).take 3=["static int\n","rng_ready(falcon_keygen *fk)\n","{\n"] := by decide
def noEntropy : Stmt → Bool
  | .branchEntropy _ _ => false
  | .seq a b | .branchScalar _ a b | .branchFlag _ _ a b => noEntropy a && noEntropy b
  | .scope body | .auto32 body => noEntropy body
  | _ => true
theorem set_seed_no_entropy : noEntropy setSeedCode=true := by decide

end FT1536.Source3.KeygenRngProgram
