import Source3.KeygenPublicRangeExec

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete source partition of mq_NTT_ternary, with the actual dynamic
   generator branch, automatic-array sizes and all three forward passes.
   The range checker validates the complete suffix, not a replacement NTT. -/
namespace FT1536.Source3.KeygenPublicForwardProgram
open C99ArrayReference (Name)
open KeygenPublicExec (Stmt chain)
open KeygenPublicTableAtoms (var literal)

def residueNames : List Name := ["r","w","a0","a1","b","s","fA","fB","fC","x","x2",
  "fB0","fB1","fB2","fC0","fC1","fC2"].map String.toList
def arrayNames : List Name := ["a","gm_square","gm_cubic"].map String.toList
def dimensionNames : List Name := ["n","hn","u","v","t","m"].map String.toList
def pointerNames : List Name := ["gm_square","gm_cubic"].map String.toList
def types : KeygenPublicParser.Types :=
  ["gm_square","gm_cubic","gm","igm"].map (fun n => (n.toList,2))++KeygenPublicSource.types .forwardT
def fragment (start count : Nat) : Stmt := ((KeygenPublicParser.body KeygenPublicSource.signatures
  types 512 (KeygenPublicScalar.expand ((KeygenZintTop.tokens
    ((KeygenPublicScalar.lines start count).flatMap String.toList++['}'])).getD []))).map (fun r => r.1)).getD .skip
def tail : Stmt := fragment 1001 61
def declareDimensions : Stmt := .scalar (.declare .u64 dimensionNames)
def declareResidues : Stmt := .scalar (.declare .u32 ["r".toList,"w".toList])
def declarePointers : Stmt := chain (pointerNames.map .declarePointer)
def nSet : Stmt := .assign "n".toList (.bin .shl (.cast .uint64 (literal 3)) (.bin .sub (var "logn") (literal 1)))
def hnSet : Stmt := .assign "hn".toList (.bin .shr (var "n") (literal 1))
def generateArgs : List C99ArrayReference.Arg := [.pointer "gm".toList C99ProcedureParser.zero,
  .pointer "igm".toList C99ProcedureParser.zero,.scalar (.var "logn".toList)]
def generate : Stmt := .call (KeygenPublicSource.name .generate) generateArgs
def squareAlias : Stmt := .pointer "gm_square".toList "gm".toList C99ProcedureParser.zero
def cubicAlias : Stmt := .pointer "gm_cubic".toList "gm".toList C99ProcedureParser.zero
def dynamic : Stmt := .scope [] [] (chain [generate,squareAlias,cubicAlias])
def static : Stmt := .scope [] [] (chain [
  .pointer "gm_square".toList "GMt_square".toList C99ProcedureParser.zero,
  .pointer "gm_cubic".toList "GMt_cubic".toList C99ProcedureParser.zero])
def condition : KeygenWordExpr.Expr := .cmp .le (var "logn") (literal 9)
def dispatch : Stmt := .branch condition static dynamic
def readyBody : Stmt := .seq declarePointers (.seq nSet (.seq hnSet (.seq dispatch tail)))
def arraysBody : Stmt := .arrayScope "gm".toList 2048 (.arrayScope "igm".toList 2048 readyBody)
def complete : Stmt := .seq declareDimensions (.seq declareResidues arraysBody)

theorem source_complete : KeygenPublicSource.code .forwardT=complete := by decide
theorem tail_range_checked : KeygenPublicRangeExec.checked residueNames arrayNames tail=true := by decide
theorem tail_supported : KeygenPublicTableControl.supported tail=true := by decide
theorem full_normal : KeygenPublicTableRows.noReturn complete=true := by decide
theorem prefix_normal : KeygenPublicTableRows.noReturn readyBody=true := by decide
theorem dynamic_normal : KeygenPublicTableRows.noReturn dynamic=true := by decide
theorem tail_writes : "a".toList∉KeygenPublicTableControl.writes tail ∧
    "logn".toList∉KeygenPublicTableControl.writes tail := by decide
theorem no_dimension_residue : ∀ name∈dimensionNames, name∉residueNames := by decide
theorem n_untracked : "n".toList∉residueNames := by decide
theorem hn_untracked : "hn".toList∉residueNames := by decide

end FT1536.Source3.KeygenPublicForwardProgram
