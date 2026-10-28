import Source3.BezoutEarlyReturn217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- If bezout returns0, the actual deepest guard returns0 as well. -/
namespace FT1536.Source3.DeepestBezoutReject217
open C99ArrayReference (State)
open KeygenZintCall (Stmt Exec)
open KeygenFullData127 (env)

def guard : Stmt := match DeepestCrtSource217.rest with
  | .seq (.base (.zint g)) _ => g
  | _ => KeygenZintCall.skip
def yes : Stmt := match guard with | .callBranch _ _ _ _ y _ => y | _ => KeygenZintCall.skip
def no : Stmt := match guard with | .callBranch _ _ _ _ _ n => n | _ => KeygenZintCall.skip

theorem rest_shape : DeepestCrtSource217.rest=.seq (.base (.zint guard)) KeygenDeepestSource.skip := by decide
theorem guard_shape : guard=.callBranch .bezout DeepestBezoutEntry217.args .eq (.literal .i32 0) yes no := by decide
theorem yes_shape : yes=.scope [] [] (.seq (.word (.ret (.scalar (.literal .i32 0)))) ZintNormWord194.wskip) := by decide

theorem source (s r : State)
    (binding : C99ArrayReference.Bind s (KeygenZintCall.params .bezout) DeepestBezoutEntry217.args (DeepestBezoutEntry217.entry s))
    (callee : Exec (KeygenZintCall.calleeBody .bezout) (DeepestBezoutEntry217.entry s) ⟨r,.returned (some (.int32 0))⟩)
    (heap : r.heap=s.heap) :
    KeygenDeepestSource.Exec env.ctx DeepestCrtSource217.rest s ⟨s,.returned (some (.int32 0))⟩ := by
  have yesRun : Exec yes s ⟨s,.returned (some (.int32 0))⟩ := by
    rw [yes_shape]
    have ret : Exec (.word (.ret (.scalar (.literal .i32 0)))) s ⟨s,.returned (some (.int32 0))⟩ :=
      .word _ _ _ (.ret _ _ _ (.scalar _ _ (.literal .int32 0)))
    simpa only [ZintNormWord194.restore_empty] using
      (Exec.scope [] [] _ s _ (.seqExit _ _ _ _ ret (by intro impossible; cases impossible)))
  have same : {s with heap:=r.heap}=s := by rw [heap]
  have branch : Exec guard s ⟨s,.returned (some (.int32 0))⟩ := by
    rw [guard_shape]
    have run := Exec.callTrue s .bezout DeepestBezoutEntry217.args .eq (.literal .i32 0) yes no
      (DeepestBezoutEntry217.entry s) ⟨r,.returned (some (.int32 0))⟩ (.int32 0) (.int32 0) (.int32 1)
      ⟨s,.returned (some (.int32 0))⟩ binding callee (.value .int32 _) (.literal .int32 0)
      (.step .eq (.int32 0) (.int32 0) .int32 rfl (.int32 0) (.int32 0) rfl rfl) (by decide)
      (by simpa only [same] using yesRun)
    exact run
  rw [rest_shape]
  exact .seqExit _ _ _ _ (.base _ _ _ (.zint _ _ _ branch)) (by intro impossible; cases impossible)

end FT1536.Source3.DeepestBezoutReject217
