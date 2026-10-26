import Source3.ZintNormState207

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintNormBranches207
open C99ArrayReference (State)
open KeygenZintCall (Exec)
open KeygenWordExpr (Eval)
open ZintNormWord194

def tail := KeygenZintCall.Stmt.seq normBranch1 (.seq normBranch2 wskip)

theorem less (s : State) (test : Eval s test1 (.int32 1)) : Exec tail s ⟨s,.returned none⟩ := by
  have yes : Exec yes1 s ⟨s,.returned none⟩ :=
    .scope _ _ _ _ _ (.seqExit _ _ _ _ (.retVoid s) (by intro h; cases h))
  exact .seqExit _ _ _ _ (.branchTrue _ _ _ _ _ (.int32 1) test (by decide) yes) (by intro h; cases h)

theorem equal (s : State) (test1False : Eval s test1 (.int32 0)) (test2False : Eval s test2 (.int32 0)) :
    Exec tail s ⟨s,.normal⟩ :=
  .seqNormal _ _ _ _ _ (.branchFalse _ _ _ _ _ (.int32 0) test1False (by decide) (word_skip s))
    (.seqNormal _ _ _ _ _ (.branchFalse _ _ _ _ _ (.int32 0) test2False (by decide) (word_skip s)) (word_skip s))

theorem greater (s out : State) (test1False : Eval s test1 (.int32 0)) (test2True : Eval s test2 (.int32 1))
    (sub : Exec (.call (.leaf .sub) ZintSubWord194.subArgs .discard) s ⟨out,.normal⟩) :
    Exec tail s ⟨out,.returned none⟩ := by
  have yes : Exec yes2 s ⟨out,.returned none⟩ :=
    .scope _ _ _ _ _ (.seqNormal _ _ _ _ _ sub (.seqExit _ _ _ _ (.retVoid out) (by intro h; cases h)))
  exact .seqNormal _ _ _ _ _ (.branchFalse _ _ _ _ _ (.int32 0) test1False (by decide) (word_skip s))
    (.seqExit _ _ _ _ (.branchTrue _ _ _ _ _ (.int32 1) test2True (by decide) yes) (by intro h; cases h))

end FT1536.Source3.ZintNormBranches207
