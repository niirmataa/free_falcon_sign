import Source3.SelectedSmallGComplete136

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedSmallCalls136
open C99CompactState115 (reference)

theorem first : KeygenSearchLeaves.SmallCall (reference SelectedBound135.after)
    (KeygenSmallShape136.args "rt1" "f") (reference SelectedSmallFComplete136.after) := SelectedSmallFComplete136.source

theorem second : KeygenSearchLeaves.SmallCall (reference SelectedSmallFComplete136.after)
    (KeygenSmallShape136.args "rt2" "g") (reference SelectedSmallGComplete136.after) := SelectedSmallGComplete136.source

/-- A source continuation rule, not a completed norm or KeyGen witness. -/
theorem continue_raw (out : C99ProcedureReference.Result)
    (continuation : KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenSmallShape136.remaining
      (reference SelectedSmallGComplete136.after) out) :
    KeygenSearchExec.Exec KeygenFullData127.env.ctx KeygenNormFrame.code (reference SelectedBound135.after) out := by
  rw [KeygenSmallShape136.norm_prefix]
  exact .seqNormal _ _ _ _ _ (.small _ _ _ first)
    (.seqNormal _ _ _ _ _ (.small _ _ _ second) continuation)

end FT1536.Source3.SelectedSmallCalls136
