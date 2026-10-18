import Source3.PublicTailShape159
import Source3.PublicAppendSource157

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicTripleShape165
open KeygenPublicExec (Stmt chain)
open KeygenPublicTableAtoms (var)
open PublicTailShape159 (load cvar caddW sqr mont uStore addQ)
open KeygenPublicInputProgram (append)

def firstNames : List String := ["fA","fB","fC","x","x2"]
def productNames : List String := ["fB0","fB1","fB2","fC0","fC1","fC2"]
def names : List String := firstNames++productNames
def declaration0 : Stmt := .scalar (.declare .u32 (firstNames.map String.toList))
def declaration1 : Stmt := .scalar (.declare .u32 (productNames.map String.toList))
def declarations : Stmt := chain [declaration0,declaration1]
def reads : Stmt := chain [
  .assign "fA".toList (load "a" (caddW "u" 0)),
  .assign "fB".toList (load "a" (caddW "u" 1)),
  .assign "fC".toList (load "a" (caddW "u" 2)),
  .assign "x".toList (load "gm_cubic" (cvar "v"))]
def products : Stmt := chain [
  .assign "x2".toList (sqr (var "x")),
  .assign "fB0".toList (mont (var "fB") (var "x")),
  .assign "fB1".toList (mont (var "fB0") (var "w")),
  .assign "fB2".toList (mont (var "fB1") (var "w")),
  .assign "fC0".toList (mont (var "fC") (var "x2")),
  .assign "fC1".toList (mont (var "fC0") (var "w")),
  .assign "fC2".toList (mont (var "fC1") (var "w"))]
def writes : Stmt := chain [
  uStore (caddW "u" 0) (addQ (var "fA") (addQ (var "fB0") (var "fC0"))),
  uStore (caddW "u" 1) (addQ (var "fA") (addQ (var "fB1") (var "fC2"))),
  uStore (caddW "u" 2) (addQ (var "fA") (addQ (var "fB2") (var "fC1")))]
def loaded : List String := ["x","fC","fB","fA","w"]
def completed : List String := ["fC2","fC1","fC0","fB2","fB1","fB0","x2"]++loaded

theorem source_shape : PublicTailShape159.tripleBody = .scope (names.map String.toList) []
    (append declarations (append reads (append products writes))) := rfl

end FT1536.Source3.PublicTripleShape165
