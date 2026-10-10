import Source3.KeygenPublicValueLists

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Literal partition of the actual inverse, including its dynamic table
   branch, all four passes and the live division-based normalization branch. -/
namespace FT1536.Source3.KeygenPublicInverseProgram
open C99ArrayReference (Name)
open KeygenPublicExec (Stmt chain)
open KeygenPublicTableAtoms (var literal mont)
open KeygenPublicValueExpr (add)

def types : KeygenPublicParser.Types :=
  ["igm_square","igm_cubic","gm","igm"].map (fun n => (n.toList,2))++KeygenPublicSource.types .inverseT
def fragment (start count : Nat) : Stmt := ((KeygenPublicParser.body KeygenPublicSource.signatures
  types 512 (KeygenPublicScalar.expand ((KeygenZintTop.tokens
    ((KeygenPublicScalar.lines start count).flatMap String.toList++['}'])).getD []))).map (fun r => r.1)).getD .skip
def dimensionNames : List Name := ["n","hn","u","v","t","m"].map String.toList
def residueNames : List Name := ["r","w","ni"].map String.toList
def pointerNames : List Name := ["igm_square","igm_cubic"].map String.toList
def declareDimensions : Stmt := .scalar (.declare .u64 dimensionNames)
def declareResidues : Stmt := .scalar (.declare .u32 residueNames)
def declarePointers : Stmt := chain (pointerNames.map .declarePointer)
def squareAlias : Stmt := .pointer "igm_square".toList "igm".toList C99ProcedureParser.zero
def cubicAlias : Stmt := .pointer "igm_cubic".toList "igm".toList C99ProcedureParser.zero
def dynamic : Stmt := .scope [] [] (chain [KeygenPublicForwardProgram.generate,squareAlias,cubicAlias])
def static : Stmt := .scope [] [] (chain [
  .pointer "igm_square".toList "iGMt_square".toList C99ProcedureParser.zero,
  .pointer "igm_cubic".toList "iGMt_cubic".toList C99ProcedureParser.zero])
def dispatch : Stmt := .branch KeygenPublicForwardProgram.condition static dynamic
def tail : Stmt := fragment 1089 70
def readyBody : Stmt := .seq declarePointers (.seq KeygenPublicForwardProgram.nSet
  (.seq KeygenPublicForwardProgram.hnSet (.seq dispatch tail)))
def arraysBody : Stmt := .arrayScope "gm".toList 2048 (.arrayScope "igm".toList 2048 readyBody)
def complete : Stmt := .seq declareDimensions (.seq declareResidues arraysBody)

def index (k : Nat) : CLogic.Expr := KeygenPublicTripleProgram.index k
def names1 : List Name := ["f0","f1","f2","x","x2"].map String.toList
def names2 : List Name := ["f11","f12","f21","f22"].map String.toList
def assignments : List Stmt := [
  .assign "f0".toList (.load16 "a".toList (index 0)),
  .assign "f1".toList (.load16 "a".toList (index 1)),
  .assign "f2".toList (.load16 "a".toList (index 2)),
  .assign "x".toList (.load16 "igm_cubic".toList (.var "v".toList)),
  .assign "x2".toList (KeygenPublicTripleProgram.square (var "x")),
  .assign "f11".toList (mont (var "f1") (var "w")),
  .assign "f12".toList (mont (var "f11") (var "w")),
  .assign "f21".toList (mont (var "f2") (var "w")),
  .assign "f22".toList (mont (var "f21") (var "w"))]
def stores : List Stmt := [
  .store "a".toList (index 0) false (add (var "f0") (add (var "f1") (var "f2"))),
  .store "a".toList (index 1) false (mont (var "x") (add (var "f0") (add (var "f11") (var "f22")))),
  .store "a".toList (index 2) false (mont (var "x2") (add (var "f0") (add (var "f12") (var "f21"))))]
def inner : Stmt := .seq (.scalar (.declare .u32 names1))
  (.seq (.scalar (.declare .u32 names2)) (chain (assignments++stores)))
def body : Stmt := .scope (names1++names2) [] inner
def guard : KeygenWordExpr.Expr := KeygenPublicTripleProgram.guard
def step : Stmt := KeygenPublicTripleProgram.step
def loop : Stmt := .loop guard body step
def initU : Stmt := KeygenPublicTripleProgram.initU
def initV : Stmt := KeygenPublicTripleProgram.initV
def seed : Stmt := .assign "w".toList
  (mont (.load16 "igm_square".toList (.literal .i32 1)) (.load16 "igm_square".toList (.literal .i32 1)))
def pass : Stmt := .seq (.seq initU initV) loop
def remaining : Stmt := fragment 1113 46

theorem source_complete : KeygenPublicSource.code .inverseT=complete := by decide
theorem source_inner : fragment 1091 17=inner := by decide
theorem source_tail : tail=.seq seed (.seq pass remaining) := by decide
theorem body_supported : KeygenPublicTableControl.supported body=true := by decide
theorem remaining_normal : KeygenPublicTableRows.noReturn remaining=true := by decide
theorem complete_normal : KeygenPublicTableRows.noReturn complete=true := by decide
theorem dynamic_normal : KeygenPublicTableRows.noReturn dynamic=true := by decide

end FT1536.Source3.KeygenPublicInverseProgram
