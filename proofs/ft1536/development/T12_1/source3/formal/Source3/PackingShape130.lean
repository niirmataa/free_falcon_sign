import Source3.GeneratedResultantSyntax130
import Source3.KeygenWordNormalize130

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PackingShape130
open KeygenWordExec (Stmt Exec)
open KeygenWordExpr (Expr)

def initial : Stmt := .assign "u".toList (.scalar (.literal .i32 0))
def condition : Expr := .cmp .lt (.scalar (.var "u".toList)) (.scalar (.var "n".toList))
def body : Stmt := match GeneratedResultantSyntax130.packing with
  | .seq (.seq _ (.loop _ body _)) _ => body
  | _ => KeygenWordExec.skip

def increment : Stmt := .modular (.base (.scalar (.update "u".toList .add (.literal .i32 1))))
def loop : Stmt := .loop condition body increment

theorem source_shape : KeygenResultantSource.packing=.seq (.seq initial loop) KeygenWordExec.skip := by
  rw [GeneratedResultantSyntax130.packing_eq]
  decide +kernel

theorem body_writes : KeygenWordExec.only ["b".toList] body=true := by decide +kernel
theorem increment_writes : KeygenWordExec.only ["b".toList] increment=true := by decide +kernel
theorem body_arrays : KeygenWordFrame130.keepsArrays body=true := by decide +kernel
theorem increment_arrays : KeygenWordFrame130.keepsArrays increment=true := by decide +kernel

theorem assemble (before ready after : C99ArrayReference.State)
    (start : Exec initial before ⟨ready,.normal⟩) (iterations : Exec loop ready ⟨after,.normal⟩) :
    Exec KeygenResultantSource.packing before ⟨after,.normal⟩ := by
  rw [source_shape]
  exact .seqNormal (.seq initial loop) KeygenWordExec.skip before after ⟨after,.normal⟩
    (.seqNormal initial loop before ready ⟨after,.normal⟩ start iterations)
    (.modular (.base .skip) after ⟨after,.normal⟩ (.base .skip after after (.skip after)))

end FT1536.Source3.PackingShape130
