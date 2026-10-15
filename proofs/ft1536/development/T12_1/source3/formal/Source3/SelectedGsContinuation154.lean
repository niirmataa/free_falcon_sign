import Source3.SelectedGsInvNorm154

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGsContinuation154

def remaining : KeygenSearchExec.Stmt :=
  match KeygenAttemptNorm.headCode with
  | .seq (.procedure _) tail => tail
  | _ => KeygenSearchExec.skip

theorem shape : KeygenAttemptNorm.headCode=
    .seq (.procedure (.call "falcon_poly_invnorm2_fft3".toList SelectedGsBinding154.arguments .discard)) remaining := by decide +kernel

theorem source (out : C99ProcedureReference.Result)
    (tail : KeygenSearchExec.Exec KeygenFullData127.env.ctx remaining SelectedGsInvNorm154.after out) :
    KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenAttemptNorm.headCode SelectedRawNorm151.after out := by
  rw [shape]
  exact .seqNormal _ _ _ SelectedGsInvNorm154.after _ (.procedure _ _ _ SelectedGsInvNorm154.source) tail

end FT1536.Source3.SelectedGsContinuation154
