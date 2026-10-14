import Source3.ShakeExtractRun120

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeExtractFragments126
open ShakeExtractSource (Stmt Exec chain Layout)

theorem append (ctx : Layout) (a b : List Stmt) (before middle after : C99ArrayReference.State)
    (first : Exec ctx (chain a) before middle) (second : Exec ctx (chain b) middle after) :
    Exec ctx (chain (a++b)) before after := by
  induction a generalizing before with
  | nil => cases first; exact second
  | cons head tail ih =>
      cases first with
      | seq _ _ _ inside _ headRun tailRun =>
          exact .seq head (chain (tail++b)) before inside after headRun (ih inside tailRun)

end FT1536.Source3.ShakeExtractFragments126
