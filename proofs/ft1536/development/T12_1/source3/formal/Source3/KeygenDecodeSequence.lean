import Source3.KeygenDecodeControl

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Composing a genuinely normally executed statement chain with its
   remaining source suffix; no source-completeness or outcome oracle. -/
namespace FT1536.Source3.KeygenDecodeSequence
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution

def chain : List Stmt → Stmt → Stmt
  | [],tail => tail
  | head::rest,tail => .seq head (chain rest tail)

theorem normal_split (args : Args) (a b : Stmt) (s t : State)
    (source : Exec args (.seq a b) s t .normal) :
    ∃ middle, Exec args a s middle .normal ∧ Exec args b middle t .normal := by
  cases source with
  | seq a b s middle t flow first second => exact ⟨middle,first,second⟩

theorem append_normal (args : Args) (statements : List Stmt) (s middle after : State) (tail : Stmt) (flow : Flow)
    (source : Exec args (chain statements .skip) s middle .normal)
    (selected : Exec args tail middle after flow) : Exec args (chain statements tail) s after flow := by
  induction statements generalizing s with
  | nil => cases source; exact selected
  | cons head rest ih =>
    obtain ⟨next,first,remaining⟩ := normal_split args head (chain rest .skip) s middle source
    exact .seq args _ _ s next after flow first (ih next remaining)

end FT1536.Source3.KeygenDecodeSequence
