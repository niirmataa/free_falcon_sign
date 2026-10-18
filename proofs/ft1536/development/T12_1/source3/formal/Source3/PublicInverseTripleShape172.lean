import Source3.PublicInverseDomains172
import Source3.PublicTripleIndex165

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicInverseTripleShape172
open KeygenPublicExec (Stmt chain)
open KeygenPublicTableAtoms (var)
open PublicTailShape159 (load cvar caddW sqr mont uStore addQ)
open KeygenPublicInputProgram (append)

def firstNames : List String := ["f0","f1","f2","x","x2"]
def productNames : List String := ["f11","f12","f21","f22"]
def names : List String := firstNames++productNames
def declaration0 : Stmt := .scalar (.declare .u32 (firstNames.map String.toList))
def declaration1 : Stmt := .scalar (.declare .u32 (productNames.map String.toList))
def declarations : Stmt := chain [declaration0,declaration1]
def reads : Stmt := chain [
  .assign "f0".toList (load "a" (caddW "u" 0)),
  .assign "f1".toList (load "a" (caddW "u" 1)),
  .assign "f2".toList (load "a" (caddW "u" 2)),
  .assign "x".toList (load "igm_cubic" (cvar "v"))]
def products : Stmt := chain [
  .assign "x2".toList (sqr (var "x")),
  .assign "f11".toList (mont (var "f1") (var "w")),
  .assign "f12".toList (mont (var "f11") (var "w")),
  .assign "f21".toList (mont (var "f2") (var "w")),
  .assign "f22".toList (mont (var "f21") (var "w"))]
def sum (left right : String) := addQ (var "f0") (addQ (var left) (var right))
def output (scaled : Bool) (factor left right : String) :=
  if scaled then mont (var factor) (sum left right) else sum left right
def writes : Stmt := chain [
  uStore (caddW "u" 0) (output false "x" "f1" "f2"),
  uStore (caddW "u" 1) (output true "x" "f11" "f22"),
  uStore (caddW "u" 2) (output true "x2" "f12" "f21")]
def loaded : List String := ["x","f2","f1","f0","w"]
def completed : List String := ["f22","f21","f12","f11","x2"]++loaded

theorem source_shape : KeygenPublicInverseProgram.body=.scope (names.map String.toList) []
    (append declarations (append reads (append products writes))) := by decide

end FT1536.Source3.PublicInverseTripleShape172
