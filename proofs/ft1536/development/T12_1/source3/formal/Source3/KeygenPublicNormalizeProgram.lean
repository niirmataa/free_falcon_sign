import Source3.KeygenPublicRootInverseMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Literal LIVE logn10 division branch and all normalization stores. -/
namespace FT1536.Source3.KeygenPublicNormalizeProgram
open KeygenPublicExec (Stmt)
open KeygenPublicTableAtoms (var literal mont)

def live : KeygenWordExpr.Expr := .call2 (KeygenPublicScalar.name .divT) (literal 10237) (.cast .uint32 (var "n"))
def static : Stmt := .assign "ni".toList (.load16 "INVNQt".toList (.var "logn".toList))
def dynamic : Stmt := .assign "ni".toList live
def niSet : Stmt := .branch KeygenPublicForwardProgram.condition static dynamic
def index : CLogic.Expr := .var "u".toList
def store : Stmt := .store "a".toList index false (mont (.load16 "a".toList index) (var "ni"))
def body : Stmt := .scope [] [] (.seq store .skip)
def guard : KeygenWordExpr.Expr := .cmp .lt (var "u") (var "n")
def increment : Stmt := KeygenPublicRootInverseProgram.increment
def loop : Stmt := .loop guard body increment
def initU : Stmt := KeygenPublicRootInverseProgram.initU
def pass : Stmt := .seq initU loop
def complete : Stmt := .seq niSet (.seq pass .skip)

theorem source_remaining : KeygenPublicRootInverseProgram.remaining=complete := by decide
theorem body_supported : KeygenPublicTableControl.supported body=true := by decide
theorem complete_supported : KeygenPublicTableControl.supported complete=true := by decide

end FT1536.Source3.KeygenPublicNormalizeProgram
