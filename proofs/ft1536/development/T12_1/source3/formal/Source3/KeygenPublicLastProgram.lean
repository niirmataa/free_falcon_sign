import Source3.KeygenPublicTableControl
import Source3.KeygenPublicRevCert
import Source3.KeygenPublicTableCells

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicLastProgram
open KeygenPublicExec (Stmt)
open KeygenPublicTableAtoms (var literal mont)

def scalarVar (n : String) : CLogic.Expr := .var n.toList
def shifted (e : CLogic.Expr) : CLogic.Expr := .cast .u32 (.bin .shl e (scalarVar "k"))
def index (e : CLogic.Expr) : CLogic.Expr :=
  .bin .add (scalarVar "b") (.call1 (KeygenPublicScalar.name .rev) (shifted e))
def u : CLogic.Expr := scalarVar "u"
def nextU : CLogic.Expr := .bin .add u (.literal .i32 1)
def store (name value : String) (e : CLogic.Expr) : Stmt :=
  .store name.toList (index e) true (var value)
def advance (name factor : String) : Stmt := .assign name.toList (mont (var name) (var factor))
def steps : List Stmt := [store "gm" "x" u,store "igm" "ix" u,
  advance "x" "g4",advance "ix" "ig4",store "gm" "x" nextU,store "igm" "ix" nextU,
  advance "x" "g2",advance "ix" "ig2"]
def body : Stmt := KeygenPublicExec.chain steps
def condition : KeygenWordExpr.Expr := .cmp .lt (var "u") (var "b")
def increment : Stmt := .assign "u".toList (.bin .add (var "u") (literal 2))
def loop : Stmt := .loop condition (.scope [] [] body) increment
def initK : Stmt := .assign "k".toList (.bin .sub (literal 11) (var "logn"))
def initB : Stmt := .assign "b".toList (.bin .shl (.cast .uint64 (literal 1))
  (.bin .sub (var "logn") (literal 1)))
def initU : Stmt := .assign "u".toList (literal 0)
def remaining : Stmt := .seq initK (.seq initB (.seq (.seq initU loop) .skip))
theorem source_remaining : KeygenPublicTableRows.remaining=remaining := by decide
theorem source_body : KeygenPublicTableRows.fragment 852 8=body := by decide
theorem body_supported : KeygenPublicTableControl.supported body=true := by decide
theorem loop_supported : KeygenPublicTableControl.supported loop=true := by decide
theorem body_writes : KeygenPublicTableControl.writes body=
    ["x".toList,"ix".toList,"x".toList,"ix".toList] := by decide

end FT1536.Source3.KeygenPublicLastProgram
