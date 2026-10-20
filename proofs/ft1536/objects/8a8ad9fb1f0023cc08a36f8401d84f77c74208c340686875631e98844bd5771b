import Source3.KeygenPublicCommonMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact successful-suffix syntax: every failure test precedes its ternary
   division store; the inverse call occurs only after the complete loop. -/
namespace FT1536.Source3.KeygenPublicSuffixProgram
open KeygenPublicExec (Stmt chain)
open KeygenPublicTableAtoms (var literal)
open KeygenPublicInputProgram (index condition increment initial)

def zeroTest : KeygenWordExpr.Expr := .cmp .eq (.load16 "t".toList index) (literal 0)
def fail : Stmt := .scope [] [] (.seq (.ret (some (literal 0))) .skip)
def test : Stmt := .branch zeroTest fail .skip
def quotient (kind : KeygenPublicScalar.Kind) : KeygenWordExpr.Expr :=
  .call2 (KeygenPublicScalar.name kind) (.load16 "h".toList index) (.load16 "t".toList index)
def ternaryStore : Stmt := .store "h".toList index false (quotient .divT)
def binaryStore : Stmt := .store "h".toList index false (quotient .divB)
def divide : Stmt := .branch (var "ternary") ternaryStore binaryStore
def body : Stmt := .scope [] [] (chain [test,divide])
def loop : Stmt := .loop condition body increment
def pass : Stmt := .seq initial loop
def inverse : Stmt := .call (KeygenPublicSource.name .inverse) KeygenPublicInputProgram.hArgs
def success : Stmt := .ret (some (literal 1))
def complete : Stmt := .seq pass (chain [inverse,success])

theorem source_complete : KeygenPublicInputProgram.suffix=complete := by decide
theorem divide_supported : KeygenPublicTableControl.supported divide=true := by decide
theorem division_writes : KeygenPublicTableControl.writes divide=[] := by decide
theorem loop_footprint : KeygenPublicFrame.only KeygenPublicSource.signatures KeygenPublicSource.permissions ["h".toList] loop=true := by decide

end FT1536.Source3.KeygenPublicSuffixProgram
