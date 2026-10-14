import Source3.ShakeBlockFixture116

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeBlockChunks116
open ShakeBlock (Stmt Exec chain)

theorem append (a b : List Stmt) (before middle after : C99ArrayReference.State)
    (first : Exec (chain a) before middle) (second : Exec (chain b) middle after) :
    Exec (chain (a++b)) before after := by
  induction a generalizing before with
  | nil => cases first; exact second
  | cons head tail ih =>
      cases first with
      | seq _ _ _ inside _ headRun tailRun =>
          exact .seq head (chain (tail++b)) before inside after headRun (ih inside tailRun)

theorem scope (code : Stmt) (before after : C99ArrayReference.State) (body : Exec code before after) :
    Exec (.scope [] code) before after := by
  have restored : C99ArrayReference.restoreScope before after [] [] = after := rfl
  rw [←restored]
  exact Exec.scope [] code before after body

end FT1536.Source3.ShakeBlockChunks116
