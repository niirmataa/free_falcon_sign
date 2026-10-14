import Source3.KeygenTokenizerStep098
import Source3.KeygenBezoutText098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenLexPrefix098
open B20.C (Token)
open KeygenZintCall (tokenize)

def chars : List Char := (KeygenBezoutText098.lines.take 7).flatMap String.toList
def tokens : List Token := (["for", "(", ";", ";", ")", "{", "int", "r", ";"] : List String).map String.toList

attribute [local cbv_opaque] KeygenZintCall.tokenize

/-- A symbolic source-prefix equation: the candidate step count is
    checked for every remaining fuel and every following character list. -/
theorem compose (fuel : Nat) (tail : List Char) :
    tokenize [] (fuel + 22) (chars ++ tail) = (tokenize [] fuel tail).map (fun rest => tokens ++ rest) := by
  cbv
  simp only [← KeygenTokenizerStep098.unfold_all [] fuel tail]
  cases result : tokenize [] fuel tail with
  | none => simp_all
  | some rest => simp_all [tokens]

end FT1536.Source3.KeygenLexPrefix098
