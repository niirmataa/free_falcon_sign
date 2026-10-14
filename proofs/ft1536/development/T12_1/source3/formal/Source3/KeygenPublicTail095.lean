import Source3.C99ModularDeterminism095
import Source3.KeygenPublicNormalizeProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicTail095
open KeygenPublicExec

/-- Calls may have their own local arrays, but restore the caller's
    pointer environment. This predicate describes the current body only. -/
def noArrays : Stmt → Bool
  | .arrayScope _ _ _ => false
  | .seq a b | .branch _ a b | .loop _ a b => noArrays a && noArrays b
  | .scope _ _ body => noArrays body
  | _ => true

/-- An array lifetime encloses the remaining function tail. There is no
    continuation that could observe a dangling local alias after disposal.
    This is checked on actual source syntax, not an assumed lifetime rule. -/
def tailArrays : Stmt → Bool
  | .seq a b => noArrays a && tailArrays b
  | .arrayScope _ _ body | .scope _ _ body => tailArrays body
  | other => noArrays other

theorem generate : tailArrays (KeygenPublicSource.code .generate) = true := by decide
theorem forwardB : tailArrays (KeygenPublicSource.code .forwardB) = true := by decide
theorem inverseB : tailArrays (KeygenPublicSource.code .inverseB) = true := by decide
theorem forwardT : tailArrays (KeygenPublicSource.code .forwardT) = true := by decide
theorem inverseT : tailArrays (KeygenPublicSource.code .inverseT) = true := by
  rw [KeygenPublicInverseProgram.source_complete]
  change tailArrays KeygenPublicInverseProgram.readyBody = true
  unfold KeygenPublicInverseProgram.readyBody
  rw [KeygenPublicInverseProgram.source_tail, KeygenPublicReverseProgram.source_remaining,
    KeygenPublicRootInverseProgram.source_remaining, KeygenPublicNormalizeProgram.source_remaining]
  decide
theorem forward : tailArrays (KeygenPublicSource.code .forward) = true := by decide
theorem inverse : tailArrays (KeygenPublicSource.code .inverse) = true := by decide
theorem compute : tailArrays (KeygenPublicSource.code .compute) = true := by decide

theorem all_checked (kind : KeygenPublicSource.Kind) : tailArrays (KeygenPublicSource.code kind) = true := by
  cases kind
  · exact generate
  · exact forwardB
  · exact inverseB
  · exact forwardT
  · exact inverseT
  · exact forward
  · exact inverse
  · exact compute

theorem noArrays_tail (code : Stmt) (checked : noArrays code = true) : tailArrays code = true := by
  induction code <;> simp_all [noArrays, tailArrays]

end FT1536.Source3.KeygenPublicTail095
