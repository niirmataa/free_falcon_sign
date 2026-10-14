import Source3.KeygenBezoutParse098
import Lean.Elab.Tactic.Cbv

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenBezoutCheck098

theorem checked : KeygenZintDeterminism098.checkedCode
    (KeygenBezoutParse098.codeFromTokens KeygenBezoutTokens098.tokens) = true := by decide +kernel

theorem source : KeygenZintDeterminism098.checkedCode (KeygenZintCall.bezoutPart 7) = true :=
  (congrArg KeygenZintDeterminism098.checkedCode KeygenBezoutParse098.source_code).trans checked

end FT1536.Source3.KeygenBezoutCheck098
